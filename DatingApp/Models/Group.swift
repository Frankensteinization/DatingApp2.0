//
//  Group.swift
//  DatingApp
//
//  Created by Frank on 3/13/24.
//

import Foundation
import FirebaseFirestore

struct Group: Codable, Identifiable{
    var documentId: String? = nil
    let subject: String
    
    var id: String{
        documentId ?? UUID().uuidString
    }
}

extension Group {
    func toDictionary() -> [String: Any]{
        return ["subject": subject]
    }
    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> Group?{
        let dictionary = snapshot.data()
        guard let subject = dictionary["subject"] as? String else {
            return nil
        }
        return Group(documentId: snapshot.documentID, subject: subject)
    }
}
