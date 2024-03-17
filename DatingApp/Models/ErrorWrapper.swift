//
//  ErrorWrapper.swift
//  DatingApp
//
//  Created by Frank on 3/17/24.
//

import Foundation

struct ErrorWrapper: Identifiable{
    let id = UUID()
    let error: Error
    var guidance: String = ""
}
