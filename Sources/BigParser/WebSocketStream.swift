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

final public class WebSocketStompStream: AsyncSequence {

    public typealias Element = WebsocketMessage
    public typealias AsyncIterator = AsyncThrowingStream<WebsocketMessage, Error>.Iterator

    private var stream: AsyncThrowingStream<Element, Error>?
    private var continuation: AsyncThrowingStream<Element, Error>.Continuation?

    private var sockJS: StompSockJS

    init(url: String, authId: String, topic: String, subscribeHeaders: [String: String]) {

        sockJS = StompSockJS(serverUrl: url, authId: authId, topic: topic, subscribeHeaders: subscribeHeaders)

        stream = AsyncThrowingStream { continuation in
            self.continuation = continuation
//            self.continuation?.onTermination = { @Sendable [socket] _ in
//                socket.cancel()
//            }
        }
    }

    public func makeAsyncIterator() -> AsyncIterator {
        guard let stream = stream else {
            fatalError("WebSocket stream was not initialized")
        }

        sockJS.onMessage = listenForMessages

        return stream.makeAsyncIterator()
    }

    private func listenForMessages(_ data: Data) {
        guard let continuation = continuation else {
            return
        }
        do {
            let websocketMessage = try WebsocketMessage(data: data)
            continuation.yield(websocketMessage)
        } catch {
            Console.log(error)
        }
    }
}
