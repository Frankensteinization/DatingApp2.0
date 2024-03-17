//
//  Storage+Extensions.swift
//  DatingApp
//
//  Created by Frank on 3/15/24.
//

import Foundation
import FirebaseStorage

enum FirebaseStorageBuckets: String{
    case photos
    case attachments
}

extension Storage {
    func uploadData(for key: String, data: Data, bucket: FirebaseStorageBuckets) async throws -> URL{
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child("\(bucket.rawValue)/\(key).png")
        
        let _ = try await photoRef.putDataAsync(data)
        let downloadURL = try await photoRef.downloadURL()
        
        return downloadURL
    }
}
