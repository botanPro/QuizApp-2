//
//  Socket.swift
//  QuizApp
//
//  Created by Botan Amedi on 23/09/2024.
//

import Starscream

class QuizWebSocket: WebSocketDelegate {

    
    var socket: WebSocket!

    init() {
        var request = URLRequest(url: URL(string: "wss://pdkone.com/reverb-websocket")!) // Reverb WebSocket URL
        request.timeoutInterval = 5

        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }

    // MARK: - WebSocketDelegate Methods

    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("WebSocket connected with headers: \(headers)")
            // Subscribe to the quiz channel after connecting
            subscribeToQuizChannel()

        case .disconnected(let reason, let code):
            print("WebSocket disconnected: \(reason) with code: \(code)")

        case .text(let message):
            print("Received text message: \(message)")
            // Handle quiz channel events
            handleQuizMessage(message)

        case .binary(let data):
            print("Received binary data: \(data)")

        case .error(let error):
            print("WebSocket encountered an error: \(error?.localizedDescription ?? "Unknown error")")

        default:
            break
        }
    }

    // MARK: - Subscribe to Quiz Channel

    private func subscribeToQuizChannel() {
        let subscribeMessage: [String: Any] = [
            "event": "pusher:subscribe",
            "data": [
                "channel": "quiz-channel"
            ]
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: subscribeMessage, options: []) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            socket.write(string: jsonString ?? "")
        }
    }

    // MARK: - Handle Received Messages

    private func handleQuizMessage(_ message: String) {
        // Parse the message and handle accordingly (e.g., update UI with new question)
        print("Quiz Channel Message: \(message)")
    }
}
