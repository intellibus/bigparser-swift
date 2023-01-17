//
//  WebSocketStream.swift
//  
//
//  Created by Miroslav Kutak on 01/12/2023.
//

import Foundation

enum WebSocketError: Error {
    case unknownMessageFormat
}

final class WebSocketStream: AsyncSequence {

    typealias Element = WebsocketMessage
    typealias AsyncIterator = AsyncThrowingStream<WebsocketMessage, Error>.Iterator

    private var stream: AsyncThrowingStream<Element, Error>?
    private var continuation: AsyncThrowingStream<Element, Error>.Continuation?
    private let socket: URLSessionWebSocketTask

    init(url: URL, headers: [String: String], session: URLSession = URLSession.shared) {
        var request = URLRequest(url: url)
        headers.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        socket = session.webSocketTask(with: request)
        // Request
        // Sec-WebSocket-Key: Z806tr6pbH2UTgPsiq17wg==

        // Response:
        // Sec-WebSocket-Accept: WOELs8G4IyxG58LnnnYV8WuAMrI=

        stream = AsyncThrowingStream { continuation in
            self.continuation = continuation
            self.continuation?.onTermination = { @Sendable [socket] _ in
                socket.cancel()
            }
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        guard let stream = stream else {
            fatalError("WebSocket stream was not initialized")
        }
        socket.resume()
        listenForMessages()
        return stream.makeAsyncIterator()
    }

    private func listenForMessages() {
        socket.receive { [unowned self] result in
            guard let continuation = continuation else {
                return
            }

            switch result {
            case .success(let message):
                if let websocketMessage = message.websocketMessage {
                    continuation.yield(websocketMessage)
                } else {
                    continuation.finish(throwing: WebSocketError.unknownMessageFormat)
                }

                listenForMessages()
            case .failure(let error):
                continuation.finish(throwing: error)
            }
        }
    }

}

extension URLSessionWebSocketTask.Message {
    var websocketMessage: WebsocketMessage? {
        guard let data = data else {
            return nil
        }

        // Decode known types
        let decoder = JSONDecoder()
        if let message = try? decoder.decode(GridWebsocketMessage.self, from: data) {
            return .grid(message)
        }

        // Return just string
        if let string = string {
            return .string(string)
        }

        return nil
    }

    var string: String? {
        switch self {
        case .data(let data):
            let stringMessage = String(data: data, encoding: .utf8)
            return stringMessage
        case .string(let stringMessage):
            return stringMessage
        @unknown default:
            return nil
        }
    }

    var data: Data? {
        switch self {
        case .data(let data):
            return data
        case .string(let string):
            return string.data(using: .utf8)
        @unknown default:
            return nil
        }
    }
}
