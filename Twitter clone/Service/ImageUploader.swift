//
//  ImageUploader.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-06.
//

import Firebase
import UIKit
import FirebaseStorage

struct ImageUploader{
    // completion: @escaping(String) -> Void) : provide URL for uploaded image
    // Store image in storage bucket in firebase and give a pointer for that location
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let filename = NSUUID().uuidString
        // path for image saved
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error{
                print("DEBUG: Error. Failed to upload image, \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { imageUrl, _ in
                guard let imageUrl = imageUrl?.absoluteString else {return}
                completion(imageUrl)
            }
        }
    }
}
