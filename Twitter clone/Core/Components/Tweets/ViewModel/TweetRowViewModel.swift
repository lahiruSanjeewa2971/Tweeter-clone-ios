//
//  TweetRowViewModel.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-08.
//

import Foundation

class TweetRowViewModel: ObservableObject{
    private let service = TweetService()
    @Published var tweet: Tweet
    
    init(tweet: Tweet){
        self.tweet = tweet
        checkIfUserLikedTweet()
    }
    
    func likeTweet(){
        service.likeTweet(tweet) {
            self.tweet.didLike = true
        }
    }
    
    func unLikeTweet(){
        service.unLikeTweet(tweet) {
            self.tweet.didLike = false
        }
    }
    
    func checkIfUserLikedTweet(){
        service.checkIfUserLikedTweet(tweet) { didLike in
            if didLike{
                self.tweet.didLike = true
            }
        }
    }
}
