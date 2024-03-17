//
//  GroupDetialView.swift
//  DatingApp
//
//  Created by Frank on 3/13/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct GroupDetialView: View {
    
    let group: Group
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var appState: AppState
    @State private var groupDetailConfig = GroupDetailConfig()
    @FocusState private var isChatTextFieldFocused: Bool
    
    private func sendMessage() async throws {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        var chatMessage = ChatMessage(text: groupDetailConfig.chatText, uid: currentUser.uid, displayName: currentUser.displayName ?? "Guest", profilePhotoURL: currentUser.photoURL == nil ? "": currentUser.photoURL!.absoluteString)
        
        if let selectedImage = groupDetailConfig.selectedImage{
            //            resize the image
            guard let resizedImage = selectedImage.resize(to: CGSize(width: 600, height: 600)),
                  let imageData = resizedImage.pngData()
            else{ return }
            
            let url = try await Storage.storage().uploadData(for: UUID().uuidString, data: imageData, bucket: .attachments)
            chatMessage.attachmentPhotoURL = url.absoluteString
        }
        
        try await model.saveChatMessageToGroup(chatMessage: chatMessage, group: group)
        
    }
    
    private func clearFields(){
        groupDetailConfig.clearForm()
        appState.loadingState = .idle
    }
    
    var body: some View {
        VStack{
            
            ScrollViewReader{proxy in
                ChatMessageListView(chatMessages: model.chatMessages)
                    .onChange(of: model.chatMessages) { oldValue, value in
                        if !model.chatMessages.isEmpty{
                            let lastChatMessage = model.chatMessages[model.chatMessages.endIndex - 1]
                            withAnimation{
                                proxy.scrollTo(lastChatMessage.id, anchor: .bottom)
                            }
                        }
                    }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .confirmationDialog("Options", isPresented: $groupDetailConfig.showOptions, actions: {
            Button("camera"){
                groupDetailConfig.sourceType = .camera
            }
            
            Button("Photo library"){
                groupDetailConfig.sourceType = .photoLibrary
            }
        })
        .sheet(item: $groupDetailConfig.sourceType, content: { sourceType in
            ImagePicker(sourceType: sourceType, image: $groupDetailConfig.selectedImage)
        })
        
        .overlay(alignment: .center, content: {
            if let selectedImage = groupDetailConfig.selectedImage{
                PreviewImageView(selectedImage: selectedImage) {
                    withAnimation{
                        groupDetailConfig.selectedImage = nil
                    }
                }
            }
        })
        
        .overlay(alignment: .bottom, content: {
            ChatMessageInputView(groupDetailConfig: $groupDetailConfig, isChatTextFieldFocused: _isChatTextFieldFocused) {
                //                    send message
                Task{
                    do{
                        appState.loadingState = .loading("Sending")
                        try await sendMessage()
                        clearFields()
                    } catch {
                        print(error.localizedDescription)
                        clearFields()
                    }
                }
            }.padding()
        })
        .onDisappear{
            model.detachFirebaseListener()
        }
        .onAppear{
            model.listenForChatMessage(in: group)
        }
    }
}

#Preview {
    GroupDetialView(group: Group(subject: "Movies")).environmentObject(Model()).environmentObject(AppState())
}
