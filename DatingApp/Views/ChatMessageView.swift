//
//  ChatMessageView.swift
//  DatingApp
//
//  Created by Frank on 3/14/24.
//

import SwiftUI

enum ChatMessageDirection{
    case left
    case right
}

struct ChatMessageView: View {
    
    let chatMessage: ChatMessage
    let direction: ChatMessageDirection
    let color: Color
    
    @ViewBuilder
    private func profilePhotoForChatMessage(chatMessage: ChatMessage) -> some View {
        if let profilePhotoURL = chatMessage.displayProfilePhotoURL {
            AsyncImage(url: profilePhotoURL) { image in
                image.rounded(width: 34, height: 34)
            } placeholder: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
            }
        } else {
            Image(systemName: "person.crop.circle")
                .font(.title)
        }
    }
    
    var body: some View {
        HStack{
//            profile photo
            if direction == .left{
                profilePhotoForChatMessage(chatMessage: chatMessage)
            }
            
            VStack(alignment: .leading, spacing: 5){
                Text(chatMessage.displayName).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).font(.caption).foregroundColor(.black)
                
//                attachment photo url
                if let attachmentPhotoURL = chatMessage.displayAttachmentPhotoURL{
                    AsyncImage(url: attachmentPhotoURL){ image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView("Loading...")
                    }
                }
                
                Text(chatMessage.text)
                Text(chatMessage.dateCreated, format: .dateTime).font(.caption).opacity(0.4).frame(maxWidth: 200, alignment: .trailing)
            }.padding(8)
                .background(color)
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            
//            profile photo
        }.listRowSeparator(.hidden)
            .overlay(alignment: direction == .left ? .bottomLeading : .bottomTrailing) {
//                Image(systemName: "arrowtriangle.down.fill")
//                    .font(.title)
//                    .rotationEffect(.degrees(direction == .left ? 45 : -45))
//                    .offset(x:direction == .left ? 30 : -30, y: 10)
//                    .foregroundColor(color)
            }
        
        if direction == .right{
            profilePhotoForChatMessage(chatMessage: chatMessage)
        }
    }
}

#Preview {
    ChatMessageView(chatMessage: ChatMessage(documentId: "ABCD", text: "Hello world", uid: "QUERY", dateCreated: Date(), displayName: "John"), direction: .right, color: .green)
}
