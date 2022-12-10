//
//  UserService.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-06.
//

import Firebase
import FirebaseFirestoreSwift

struct UserService {
    
    // Fetch user by UID ( User ID)
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void){
        Firestore.firestore().collection("users2")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else {return}
                                
                // Map fetching data
                guard let user = try? snapshot.data(as: User.self) else {return}
                
                completion(user)
            }
    }
    
    // Fetch all the users in "usrs2" collection
    func fetchUsers(completion: @escaping([User]) -> Void){
        
        Firestore.firestore().collection("users2")
            .getDocuments { snapshot, _ in
                guard let document = snapshot?.documents else {return}
                let users = document.compactMap ({ try? $0.data(as: User.self) })
                completion(users)
            }
    }
}
