//
//  ContentView.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-01.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State private var showMenu = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group{
            // Check user session
            if viewModel.userSession == nil{
                LoginView()
            } else{
                // Logged in User
                mainInterfaceView
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView{
    var mainInterfaceView: some View{
        ZStack(alignment: .topLeading){
            MainTabView().navigationBarHidden(showMenu)
            
            if showMenu{
                ZStack{
                    Color(.black).opacity(showMenu ? 0.25 : 0.0)
                }.onTapGesture {
                    withAnimation(.easeInOut){
                        showMenu = false
                    }
                }.ignoresSafeArea()
            }
            
            SideMenuView()
                .frame(width: 300)
                .offset(x: showMenu ? 0: -300, y: 0)
                .background(showMenu ? Color.white : Color.clear)
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                if let user = viewModel.currentuser{
                    Button{
                        withAnimation(.easeInOut){
                            showMenu.toggle()
                        }
                    }label: {
                        KFImage(URL(string: user.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 42, height: 42)
                            .clipShape(Circle())
                    }
                }
            }
        }
        // when goes to a screen using side menu and come back, still the side menu open.
        // close it by using this code
        .onAppear{
            showMenu = false
        }
    }
}
