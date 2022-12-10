//
//  Tweet.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-08.
//

import Firebase
import FirebaseFirestoreSwift

struct Tweet:Identifiable, Decodable{
    @DocumentID var id: String?
    
    let caption: String
    let timestamp: Timestamp
    let uid: String
    var likes: Int
    
    var user: User?
    
    var didLike: Bool? = false
}
