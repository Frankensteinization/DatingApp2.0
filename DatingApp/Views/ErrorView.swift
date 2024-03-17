//
//  ErrorView.swift
//  DatingApp
//
//  Created by Frank on 3/17/24.
//

import SwiftUI


struct ErrorView: View {
    
    let errorWrapper: ErrorWrapper
    
    var body: some View {
        VStack {
            Text("An error has occurred!")
                .font(.title)
                .padding(.bottom)
            
            Text(errorWrapper.error.localizedDescription)
                .font(.headline)
            
            Text(errorWrapper.guidance)
                .font(.caption)
                .padding(.top)
            
            Spacer()
        }.padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
    }
}

struct ErrorView_Previews: PreviewProvider {
    
    enum SampleError: Error {
        case operationFailed
    }
    
    static var previews: some View {
        ErrorView(errorWrapper: ErrorWrapper(error: SampleError.operationFailed, guidance: "Operation has failed. Please try again later."))
    }
}
