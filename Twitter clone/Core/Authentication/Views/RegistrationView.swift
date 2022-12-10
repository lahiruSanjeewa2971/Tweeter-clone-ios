//
//  RegistrationView.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-03.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var fullname = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            NavigationLink(destination: ProfilePhotoSelectorView(),
                           isActive: $viewModel.didAuthenticateUser,
                           label: { })
            
            // Header view
            AuthHeaderView(title1: "Get Stated", title2: "Create your account")
            
            VStack(spacing: 40){
                CustomInputFields(imageName: "envelope", placeholderText: "Email", text: $email)
                
                CustomInputFields(imageName: "person", placeholderText: "User Name", text: $username)
                
                CustomInputFields(imageName: "person", placeholderText: "Full Name", text: $fullname)
                
                CustomInputFields(imageName: "lock", placeholderText: "Password", isSecureField: true, text: $password)
            }
            .padding(32)
            
            // Sign UP button
            Button{
                viewModel.register(withEmail: email, password: password, fullname: fullname, username: username)
            }label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(Color(.systemBlue))
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Text("Already have an account?")
                        .font(.body)
                    
                    Text("Sing In")
                        .font(.body )
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 32)
        }
        .ignoresSafeArea()
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
