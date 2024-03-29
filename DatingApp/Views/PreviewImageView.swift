//
//  PreviewImageView.swift
//  DatingApp
//
//  Created by Frank on 3/17/24.
//

import SwiftUI

struct PreviewImageView: View {
    
    let selectedImage: UIImage
    var onCancel: () -> Void
    
    var body: some View {
        ZStack{
            Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(alignment: .top){
                    Button{
                        onCancel()
                    }label: {
                        Image(systemName: "multiply.circle.fill")
                            .padding([.top],10)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                }
        }
    }
}

#Preview {
    PreviewImageView(selectedImage: UIImage(named: "sample")!, onCancel: {})
}
