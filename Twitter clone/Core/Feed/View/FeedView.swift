//
//  FeedView.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-01.
//

import SwiftUI

struct FeedView: View {
    @State private var ShowNewTweetView = false
    @ObservedObject var viewModel = FeedViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView{
                LazyVStack{
                    ForEach(viewModel.tweets){ tweet in
                        TweetRowView(tweet: tweet)
                    }
                }
            }
            
            Button{
                ShowNewTweetView.toggle()
            }label: {
                Circle()
                    .frame(width: 28, height: 28)
                    .padding()
            }
            .background(Color(.systemIndigo))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            // when the above state true, show new tweet creen in full screen mode.
            .fullScreenCover(isPresented: $ShowNewTweetView){
                NewTweetView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
