//
//  AuthViewModel.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-05.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    @Published var currentuser: User?   // optional; because when the app launched it's value nil( null ).
    private var tempUserSession: FirebaseAuth.User?
    
    private let service = UserService()
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        // method to fetch user from firebase
        self.fetchUser()
    }
    
    func login(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else {return}
            self.userSession = user
            self.fetchUser()
        }
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String){
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error{
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else {return}
            
            self.tempUserSession = user
            
            let data: [String: Any] = ["email": email,
                        "username": username.lowercased(),
                        "fullname": fullname,
                        ]
               
            
            Firestore.firestore().collection("users2")
                .document(user.uid)
                .setData(data) { error in
                    //print("DEBUG: Registered User and uploaded \(user.uid)")
                    if let error = error {
                        print("DEBUG: Error writing document: \(error)")
                    } else {
                        self.didAuthenticateUser = true
                    }
                }
        }
    }
    
    func signOut(){
        userSession = nil
        
        // Sign out user from server
        try? Auth.auth().signOut()
    }
    
    func uploadProfileImage(_ image: UIImage){
        guard let uid = tempUserSession?.uid else {return}
        
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users2")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]) { _ in
                    self.userSession = self.tempUserSession
                    // re-fetch user details. otherwise it remains previous user details
                    self.fetchUser()
                }
        }
    }
    
    func fetchUser(){
        guard let uid = self.userSession?.uid else {return}
        
        service.fetchUser(withUid: uid) { user in
            // assign mapped user details. then they can use to view user details
            self.currentuser = user
        }
    }
}
