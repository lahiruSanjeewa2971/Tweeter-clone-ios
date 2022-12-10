//
//  ProfileView.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-01.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    // Keeps track of selected filter from Tweet filter ViewModel
    @State private var selectedFilter: TweetFilterViewModel = .tweets
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var mode
    
    @Namespace var animation
    
    // Use dependancy injection to view user profile data.
    init(user: User){
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            
            // Like background color of tweeter profile
            // background color + back button + profile image
            ZStack(alignment: .bottomLeading){
                Color(.systemBlue)
                    .ignoresSafeArea()
                
                VStack{
                    // Back button
                    Button{
                        mode.wrappedValue.dismiss()
                    }label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 20, height: 16)
                            .foregroundColor(.white)
                            .offset(x: 16, y: -3)
                    }
                    
                    KFImage(URL(string: viewModel.user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 72, height: 72)
                        .offset(x: 16, y: 24)
                }
            }
            .frame(height: 96)
            
            // Action buttons
            HStack(spacing: 12){
                Spacer()
                
                Image(systemName: "bell.badge")
                    .font(.title3)
                    .padding(6)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 0.75))
                
                Button{
                    
                }label: {
                    Text(viewModel.actionButtonTitle)
                        .font(.subheadline).bold()
                        .frame(width: 120, height: 32)
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
                }
            }
            .padding(.trailing)
            
            // User name and bio
            userInfoDetails
            
            // View Model
            tweetFilterBar
            
            // Scroll View
            ScrollView{
                LazyVStack{
                    ForEach(viewModel.tweets(forFilter: self.selectedFilter)){ tweets in
                        TweetRowView(tweet: tweets)
          //                  .padding()
                    }
                }
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User(id: NSUUID().uuidString,
                               username: "batman",
                               fullname: "Bruse Wayne",
                               profileImageUrl: "",
                               email: "batman@gmail.com"))
    }
}

extension ProfileView{
    
    // User name and bio
    var userInfoDetails: some View{
        
        VStack(alignment: .leading, spacing: 4){
            HStack{
                Text(viewModel.user.fullname)
                    .font(.title2).bold()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Color(.systemBlue))
            }
            
            Text("@\(viewModel.user.username)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Never stop just go with the flow")
                .font(.subheadline)
                .padding(.vertical)
            
            // Below section of bio (Location + Link)
            HStack(spacing: 24){
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                    
                    Text("Gotham")
                }
                HStack{
                    Image(systemName: "link")
                    
                    Text("www.batman.com")
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            // NO of Following + Followers (From : Components -> Users ->)
            UserStatsView()
                .padding(.vertical)
            
        }
        .padding(.horizontal)
    }
    
    var tweetFilterBar: some View{
        HStack{
            ForEach(TweetFilterViewModel.allCases, id: \.rawValue){ item in
                VStack{
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == item ? .semibold : .regular)
                        .foregroundColor(selectedFilter == item ? .black : .gray)
                    
                    if selectedFilter == item{
                        Capsule()
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    }else{
                        Capsule()
                            .foregroundColor(Color(.clear))
                            .frame(height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut){
                        self.selectedFilter = item
                    }
                }
            }
        }
        .overlay(Divider().offset(x: 0, y: 16))
        
    }
}
