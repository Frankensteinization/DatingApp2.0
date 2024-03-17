//
//  ChatMessage.swift
//  DatingApp
//
//  Created by Frank on 3/13/24.
//

import Foundation
import FirebaseFirestore

struct ChatMessage: Codable, Identifiable, Equatable {
    var documentId: String?
    var text: String
    var uid: String
    var dateCreated = Date()
    let displayName: String
    var profilePhotoURL: String = ""
    var attachmentPhotoURL: String = ""
    
    var id: String{
        documentId ?? UUID().uuidString
    }
    
    var displayAttachmentPhotoURL: URL? {
        attachmentPhotoURL.isEmpty ? nil : URL(string: attachmentPhotoURL)
    }
    
    var displayProfilePhotoURL: URL? {
        profilePhotoURL.isEmpty ? nil : URL(string: profilePhotoURL)
    }
}

extension ChatMessage{
    func toDictionary() -> [String: Any]{
        return [
            "text": text,
            "uid": uid,
            "dateCreated": dateCreated,
            "displayName": displayName,
            "profilePhotoURL": profilePhotoURL,
            "attachmentPhotoURL": attachmentPhotoURL
        ]
    }
    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> ChatMessage? {
        let dictionary = snapshot.data()
        guard let text = dictionary["text"] as? String,
              let uid = dictionary["uid"] as? String,
              let dateCreated = (dictionary["dateCreated"] as? Timestamp)?.dateValue(),
              let displayName = dictionary["displayName"] as? String,
              let profilePhotoURL = dictionary["profilePhotoURL"] as? String,
              let attachmentPhotoURL = dictionary["attachmentPhotoURL"] as? String
        else {
            return nil
        }
        return ChatMessage(documentId: snapshot.documentID, text: text, uid: uid, dateCreated: dateCreated, displayName: displayName, profilePhotoURL: profilePhotoURL, attachmentPhotoURL: attachmentPhotoURL)
    }
}
