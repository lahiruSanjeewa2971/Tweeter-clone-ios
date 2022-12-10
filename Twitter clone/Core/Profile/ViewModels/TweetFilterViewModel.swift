//
//  TweetFilterViewModel.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-02.
//

import Foundation

// View Model
// Act as an array

enum TweetFilterViewModel: Int, CaseIterable{
    case tweets
    case replies
    case likes
    
    var title: String{
        switch self{
        case .tweets: return "Tweets"
        case .replies: return "Replies"
        case .likes: return "Likes"
        }
    }
}
