//
//  ProfilePhotoSelectorView.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-05.
//

import SwiftUI

struct ProfilePhotoSelectorView: View {
    
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            AuthHeaderView(title1: "Setup account", title2: "Select a profile image")
            
            Button {
                showingImagePicker.toggle()
            } label: {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .padding(.top, 44)
                        .clipShape(Circle())
                } else{
                    Image("plusIcon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.systemCyan))
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .padding(.top, 44)
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $selectedImage)
            }
            
            // Appear continue button after profile image selected.
            if let selectedImage = selectedImage {
                Button{
                    viewModel.uploadProfileImage(selectedImage)
                }label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            }
            
            Spacer()
        }
        .ignoresSafeArea()
    }
    
    // Help to construct SwiftUI image from a UI-kit image
    func loadImage(){
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
}

struct ProfilePhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoSelectorView()
    }
}
