//
//  BigParserSockJS.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation
import WebKit

class BigParserSockJS: NSObject, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {

    let serverUrl: String
    let authId: String

    let topic: String
    let subscribeHeaders: [String: String]

    init(serverUrl: String, authId: String, topic: String, subscribeHeaders: [String: String]) {
        self.serverUrl = serverUrl
        self.authId = authId
        self.topic = topic
        self.subscribeHeaders = subscribeHeaders

        super.init()

        initSockJS()
    }

    private var webView: WKWebView!
    private var webViewLoaded = false

    private func initSockJS() {
        if let url = Bundle.module.url(forResource: "websocket", withExtension: "html", subdirectory: "web") {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                self.webView = WKWebView()
                self.webView.uiDelegate = self
                self.webView.navigationDelegate = self
                self.webView.load(URLRequest(url: url))
                self.injectLogHandler()
            }
        }
    }

    private func injectLogHandler() {
        // inject JS to capture console.log output and send to iOS
        let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(script)
        // register the bridge script that listens for the output
        webView.configuration.userContentController.add(self, name: "logHandler")
    }

    func handleIncoming(data: Data) {
        do {
            let object = try JSONSerialization.jsonObject(with: data)
            print(object)
        } catch {
            print(error)
        }
    }

    // MARK: - WKScriptMessageHandler

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            print("LOG:\n\(message.body)")
            if let messageBody = message.body as? String,
               messageBody.hasPrefix("message: MESSAGE") {
                let parts = messageBody.components(separatedBy: "\n{")
                if parts.count == 2 {
                    let jsonString = "{" + parts[1]

                    if let data = jsonString.data(using: .utf8) {
                        handleIncoming(data: data)
                    }
                }
            }
        }
    }

    private func connect() throws {
        let headersString = try jsObjectString(dictionary: subscribeHeaders)
        let javascriptString = "connect('\(serverUrl)','\(authId)','\(topic)',\(headersString))"
        runJavascript(javascriptString)
    }

    func send(topic: String, headers: [String: String]? = nil, body: String) throws {
        let headersString = try jsObjectString(dictionary: headers)
        let javascriptString = "send('\(topic)',\(headersString),'\(body)')"
        runJavascript(javascriptString)
    }

    private func jsObjectString(dictionary: [String: String]?) throws -> String {
        let dictionaryData = try JSONSerialization.data(withJSONObject: dictionary ?? [:])
        guard let dictionaryString = String(data: dictionaryData, encoding: .utf8) else {
            // TODO: custom error
            throw NSError()
        }
        return dictionaryString
    }

    private func runJavascript(_ javascriptString: String) {
        DispatchQueue.main.async {
            self.webView.evaluateJavaScript(javascriptString, completionHandler: { (result, error) in
                if let error = error {
                    print(error)
                }
                if let result = result {
                    print(result)
                }
            })
        }
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webViewLoaded == false {

            Task {
                try connect()
            }
            webViewLoaded = true
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.cancel)
        } else {
            if navigationAction.request.url?.scheme == "sockjs" {
                DispatchQueue.main.async {
                        let urlComponents = NSURLComponents(string: (navigationAction.request.url?.absoluteString)!)
                        let queryItems = urlComponents?.queryItems
                        let param1 = queryItems?.filter({$0.name == "msg"}).first
                        let temp = String(param1!.value!)
                        if let data = temp.data(using: String.Encoding.utf8) {
                            //let json = JSON(data: data)
                            print("Live Data: \(data.debugDescription)")
                        }
                }
            }
            decisionHandler(.allow)
        }
    }

    // MARK: - WKUIDelegate

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

