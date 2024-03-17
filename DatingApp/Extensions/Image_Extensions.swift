//
//  Image_Extensions.swift
//  DatingApp
//
//  Created by Frank on 3/15/24.
//

import Foundation
import SwiftUI

extension Image {
    
    func rounded(width: CGFloat = 100, height: CGFloat = 100) -> some View {
        return self.resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
    
}
