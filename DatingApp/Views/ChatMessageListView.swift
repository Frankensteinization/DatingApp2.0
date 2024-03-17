//
//  ChatMessageListView.swift
//  DatingApp
//
//  Created by Frank on 3/14/24.
//

import SwiftUI
import FirebaseAuth

struct ChatMessageListView: View {
    
    let chatMessages: [ChatMessage]
    
    private func isChatMessageFromCurrentUser(_ chatMessage: ChatMessage) -> Bool {
        
        guard let currentUser = Auth.auth().currentUser else {
            return false
        }
        
        return currentUser.uid == chatMessage.uid
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                ForEach(chatMessages) { chatMessage in
                    VStack {
                        if isChatMessageFromCurrentUser(chatMessage) {
                            HStack {
                                Spacer()
                                ChatMessageView(chatMessage: chatMessage, direction: .right, color: .green)
                            }
                        } else {
                            HStack {
                                ChatMessageView(chatMessage: chatMessage, direction: .left, color: .black)
                                Spacer()
                            }
                        }
                        Spacer().frame(height: 20)
                            .id(chatMessage.id)
                    }.listRowSeparator(.hidden)
                }
            }
        }.padding([.bottom], 60)
        
        
    }
}

#Preview {
    ChatMessageListView(chatMessages:[])
}
