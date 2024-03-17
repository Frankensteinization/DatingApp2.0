//
//  Model.swift
//  DatingApp
//
//  Created by Frank on 3/13/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class Model: ObservableObject {
    
    @Published var groups: [Group] = []
    @Published var chatMessages: [ChatMessage] = []
    
    var firestoreListener: ListenerRegistration?
    
    private func updateUserInfoForAllMessages(uid: String, updatedInfo: [AnyHashable: Any]) async throws{
        let db = Firestore.firestore()
        let groupDocuments = try await db.collection("groups").getDocuments().documents
        
        for groupDoc in groupDocuments{
            let messages = try await groupDoc.reference.collection("messages")
                .whereField("uid", isEqualTo: uid)
                .getDocuments().documents
            
            for message in messages{
                try await message.reference.updateData(updatedInfo)
            }
        }
    }
    
    func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["displayName": user.displayName ?? "Guest"])
    }
    
    func detachFirebaseListener() {
        self.firestoreListener?.remove()
    }
    
    func updatePhotoURL(for user: User, photoURL: URL) async throws {
        let request  = user.createProfileChangeRequest()
        request.photoURL = photoURL
        try await request.commitChanges()
        
//        update info for all messages
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["profilePhotoURL": photoURL.absoluteString])

    }
    
    func listenForChatMessage(in group: Group){
        let db = Firestore.firestore()
        chatMessages.removeAll()
        
        guard let documentId = group.documentId else { return }
        self.firestoreListener = db.collection("groups").document(documentId).collection("messages").order(by: "dateCreated", descending: false).addSnapshotListener({ [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    let chatMessage = ChatMessage.fromSnapshot(snapshot: diff.document)
                    if let chatMessage {
                        let exists = self?.chatMessages.contains(where: {cm in
                            cm.documentId == chatMessage.documentId
                        })
                        
                        if !exists! {
                            self?.chatMessages.append(chatMessage)
                        }
                    }
                }
            }
        })
    }
    
    func populateGroups() async throws {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("groups").getDocuments()
        groups = snapshot.documents.compactMap { snapshot in
            //            get a group base on snapshot
            Group.fromSnapshot(snapshot: snapshot)
        }
    }
    
    func saveChatMessageToGroup(chatMessage: ChatMessage, group: Group) async throws {
        let db = Firestore.firestore()
        guard let groupDocumentId = group.documentId else { return }
        let _ = try await db.collection("groups").document(groupDocumentId).collection("messages").addDocument(data: chatMessage.toDictionary())
    }
    
    //    func saveChatMessageToGroup(text: String, group: Group, completion: @escaping (Error?) -> Void){
    //        let db = Firestore.firestore()
    //        guard let groupDocumentId = group.documentId else {return}
    //        db.collection("groups").document(groupDocumentId).collection("messages").addDocument(data: ["chatText": text]){
    //            error in
    //            completion(error)
    //        }
    //    }
    
    func saveGroup(group: Group, completion: @escaping (Error?) -> Void){
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef = db.collection("groups").addDocument(data: group.toDictionary()){ [weak self]
            error in
            if error != nil{
                completion(error)
            } else {
                //                add group to group array
                if let docRef{
                    var newGroup = group
                    newGroup.documentId = docRef.documentID
                    self?.groups.append(newGroup)
                    completion(nil)
                }else{
                    completion(nil)
                }
            }
        }
    }
}
