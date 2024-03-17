//
//  GroupDetailConfig.swift
//  DatingApp
//
//  Created by Frank on 3/16/24.
//

import Foundation
import UIKit

struct GroupDetailConfig {
    var chatText: String = ""
    var sourceType: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var showOptions: Bool = false
    
    mutating func clearForm(){
        chatText = ""
        selectedImage = nil
    }
    
    var isValid: Bool {
        !chatText.isEmptyOrWhiteSpace || selectedImage != nil
    }
}
