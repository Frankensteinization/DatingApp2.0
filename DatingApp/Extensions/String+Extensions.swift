//
//  String+Extensions.swift
//  DatingApp
//
//  Created by Frank on 3/12/24.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
