//
//  GPT3ViewModel.swift
//  ChatGPT-DALLE
//
//  Created by Caleb Hrenchir on 6/12/23.
//

import Foundation
import ChatGPTSwift

class GPT3ViewModel: ObservableObject {
    let api = ChatGPTAPI(apiKey: "INSERT_API_KEY")
    @Published var messages = [Message]()
    
    func getResponse(text: String) async {
        self.addMessage(text, type: .text, isUserMessage: true)
        self.addMessage("", type: .indicator, isUserMessage: false)
        
        do {
            let stream = try await api.sendMessageStream(text: text)
            
            for try await line in stream {
                DispatchQueue.main.async {
                    self.messages[self.messages.count - 1].content = self.messages[self.messages.count - 1].content as! String + line
                }
            }
        } catch {
            self.addMessage(error.localizedDescription, type: .error, isUserMessage: false)
        }
    }
    
    private func addMessage(_ content: Any, type: MessageType, isUserMessage: Bool) {
        DispatchQueue.main.async {
            guard let lastMessage = self.messages.last else {
                let message = Message(content: content, type: type, isUserMessage: isUserMessage)
                self.messages.append(message)
                return
            }
            let message = Message(content: content, type: type, isUserMessage: isUserMessage)
            if lastMessage.type == .indicator && !lastMessage.isUserMessage {
                self.messages[self.messages.count - 1] = message
            } else {
                self.messages.append(message)
            }
            
            if self.messages.count > 100 {
                self.messages.removeFirst()
            }
        }
    }
}
