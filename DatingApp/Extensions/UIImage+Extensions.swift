//
//  UIImage+Extensions.swift
//  DatingApp
//
//  Created by Frank on 3/15/24.
//

import Foundation
import UIKit

extension UIImage{
    
    //    stackoverflow
    func resize(to size: CGSize = CGSize(width: 300, height: 300)) -> UIImage? {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: self.size.width * heightRatio, height: self.size.height * heightRatio)
        } else {
            newSize = CGSize(width: self.size.width * widthRatio, height: self.size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
