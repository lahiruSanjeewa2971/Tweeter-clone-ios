//
//  Twitter_cloneApp.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-01.
//

import SwiftUI
import Firebase

@main
struct Twitter_cloneApp: App {
    
    @StateObject var viewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
//                ProfilePhotoSelectorView()
//              LoginView()
 //               SideMenuView()
      //          ProfileView()
            }
            .environmentObject(viewModel)
        }
    }
}
