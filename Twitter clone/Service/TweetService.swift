//
//  TweetService.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-07.
//

import Firebase

struct TweetService{
    func uploadTweet(caption: String, completion: @escaping(Bool) -> Void){
        // Grab UID of the user who upload the tweet
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        // Dictionary about new tweet
        let data = ["uid": uid,
                    "caption": caption,
                    "likes": 0,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        Firestore.firestore().collection("tweets")
            .document()
            .setData(data){ error in
                if let error = error{
                    print("DEBUG: Failed to upload the tweet. \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                completion(true)
            }
    }
    
    // Fetch all the tweets that stored in the db
    func fetchTweets(completion: @escaping([Tweet]) -> Void){
        Firestore.firestore()
            .collection("tweets")
        //sort tweets by date and time
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {return}
                let tweets = documents.compactMap({ try? $0.data(as: Tweet.self) })
                
                completion(tweets)
            }
    }
    
    // Fetch tweets by user ID
    func fetchTweetsByUID(forUid uid: String, completion: @escaping([Tweet]) -> Void){
        Firestore.firestore()
            .collection("tweets")
            .whereField("uid", isEqualTo : uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {return}
                let tweets = documents.compactMap({ try? $0.data(as: Tweet.self) })
                
                completion(tweets.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }))
            }
    }
    
    //
    func likeTweet(_ tweet: Tweet, completion: @escaping() -> Void){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        guard let tweetId = tweet.id else {return}
        
        let userLikesRef = Firestore.firestore().collection("users2").document(uid).collection("user-likes")
        
        Firestore.firestore().collection("tweets").document(tweetId)
            .updateData(["likes" : tweet.likes + 1]) { _ in
                userLikesRef.document(tweetId).setData([:]){ _ in
                    completion()
                }
            }
    }
    
    // Check a tweet already liked or not by a specific user, if liked, then update UI with liked mark.
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        guard let tweetId = tweet.id else {return}
        
        Firestore.firestore().collection("users2").document(uid).collection("user-likes")
            .document(tweetId).getDocument { snapshot, _ in
                guard let snapshot = snapshot else {return}
                completion(snapshot.exists)
            }
    }
    
    // Unlike a tweet. then no of likes in the db should -= by 1
    func unLikeTweet(_ tweet: Tweet, completion: @escaping() -> Void){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        guard let tweetId = tweet.id else {return}
        guard tweet.likes > 0 else {return}
        
        let userLikesRef = Firestore.firestore().collection("users2").document(uid).collection("user-likes")
        
        Firestore.firestore().collection("tweets").document(tweetId)
            .updateData(["likes" : tweet.likes - 1]) { _ in
                userLikesRef.document(tweetId).delete { _ in
                    completion()
                }
            }
    }
    
    
    // Fetched specific user liked tweets.
    
    // get the likes-tweet IDs from a specific user
    //loop through those document collection and store IDs.
    // retrieve full details of specific tweet from tweets table, using above saved ID.
    func fetchLikedTweets(forUid uid: String, completion: @escaping([Tweet])  -> Void){
        var tweets = [Tweet]()
        
        Firestore.firestore().collection("users2")
            .document(uid)
            .collection("user-likes")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {return}
                
                documents.forEach { doc in
                    let tweetID = doc.documentID
                    
                    // single tweet fetch function using tweetID
                    Firestore.firestore().collection("tweets")
                        .document(tweetID)
                        .getDocument { snapshot, _ in
                            guard let tweet = try? snapshot?.data(as: Tweet.self) else {return}
                            
                            tweets.append(tweet)
                            
                            completion(tweets)
                        }
                }
            }
    }
}
