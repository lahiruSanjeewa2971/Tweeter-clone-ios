//
//  SideMenuView.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-02.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if let user = authViewModel.currentuser{
            VStack(alignment: .leading, spacing: 32){
                // Upper part (User image + Name + Following & Followers detials)
                VStack(alignment: .leading){
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 48, height: 48)
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text(user.fullname).font(.headline)
                        
                        Text("@\(user.username)").font(.caption).foregroundColor(.gray)
                    }
                    
                    UserStatsView().padding(.vertical)
                }
                .padding(.leading)
                
                // Second Part
                ForEach(SideMenuViewModel.allCases, id: \.rawValue){ viewModel in
                    if viewModel == .profile{
                        NavigationLink{
                            ProfileView(user: user)
                        }label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    } else if viewModel == .logout{
                        Button{
                            authViewModel.signOut()
                        }label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    } else{
                        SideMenuOptionRowView(viewModel: viewModel)
                    }
                    
                }
                
                Spacer()
            }
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
