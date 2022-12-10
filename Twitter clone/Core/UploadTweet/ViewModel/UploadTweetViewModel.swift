//
//  UploadTweetViewModel.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-07.
//

import Foundation

class UploadTweetViewModel: ObservableObject{
    @Published var didUploadTweet = false
    let service = TweetService()
    
    func uploadTweet(withCaption caption: String){
        service.uploadTweet(caption: caption) { success in
            if success{
                // Dismiss the screen
                self.didUploadTweet = true
            }else{
                
            }
        }
    }
}
