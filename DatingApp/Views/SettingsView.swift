//
//  SettingsView.swift
//  DatingApp
//
//  Created by Frank on 3/15/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct SettingsConfig {
    var showPhotoOptions: Bool = false
    var sourceType: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var displayName: String = ""
}

struct SettingsView: View {
    
    @State private var settingsConfig = SettingsConfig()
    @FocusState var isEditing: Bool
    @EnvironmentObject private var model: Model
    @State private var currentPhotoURL: URL? = Auth.auth().currentUser!.photoURL
    @EnvironmentObject private var appstate: AppState
    
    var displayName: String{
        guard let currentUser = Auth.auth().currentUser else { return "Guest"}
        return currentUser.displayName ?? "Guest"
    }
    
    var body: some View {
        NavigationView{
            VStack{
                AsyncImage(url: currentPhotoURL){ image in
                    image.rounded()
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill").rounded()
                }.onTapGesture {
                    settingsConfig.showPhotoOptions = true
                }.confirmationDialog("Select", isPresented: $settingsConfig.showPhotoOptions) {
                    Button("Camera"){
                        settingsConfig.sourceType = .camera
                    }
                    Button("Photo Library"){
                        settingsConfig.sourceType = .photoLibrary
                    }
                }
                
                TextField(settingsConfig.displayName, text: $settingsConfig.displayName)
                    .textFieldStyle(.roundedBorder)
                    .focused($isEditing)
                    .textInputAutocapitalization(.never)
                
                Spacer()
                
                Button("Sign out"){
                    do {
                        try Auth.auth().signOut()
                        appstate.routes.append(.login)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            }.sheet(item: $settingsConfig.sourceType, content: { sourceType in
                ImagePicker(sourceType: sourceType, image: $settingsConfig.selectedImage)
            })
            .onChange(of: settingsConfig.selectedImage, perform: { image in
                //            resize image
                guard let img = image,
                      let resizeImage = img.resize(to: CGSize(width: 100, height: 100)),
                      let imageData = resizeImage.pngData()
                else { return }
                
                //            uploda image to firebase storage to get url
                Task{
                    guard let currentUser = Auth.auth().currentUser else { return }
                    let filename = "\(currentUser.uid).png"
                    
                    do {
                        let url = try await Storage.storage().uploadData(for: filename, data: imageData, bucket: .photos)
                        try await model.updatePhotoURL(for: currentUser, photoURL: url)
                        currentPhotoURL = url
                    } catch {
                        print(error)
                    }
                }
            })
            .padding()
            .onAppear{
                settingsConfig.displayName = displayName
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save"){
                        guard let currentUser = Auth.auth().currentUser else { return }
                        Task{
                            do {
                                try await model.updateDisplayName(for: currentUser, displayName: settingsConfig.displayName)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
                     
            )
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(Model())
        .environmentObject(AppState())
}
