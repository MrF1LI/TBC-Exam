//
//  FirebaseManager.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 19.08.22.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestoreSwift

/// A convenient interface to the contents of the **Firebase** service, and the primary means of interacting with it.
class FirebaseManager {
    
    static let shared = FirebaseManager()
    let signInConfig = GIDConfiguration(clientID: "617602484734-03or7n1c18rkqp7i6gc3jmr4aoa60279.apps.googleusercontent.com")
    
    // MARK: - Variables
    
    static let currentUser = Auth.auth().currentUser
    
    static let db = Database.database().reference()
    let dbUsers = db.child("users")
    let dbLecturers = db.child("lecturers")
    let dbChats = db.child("chats")
    let dbMemes = db.child("memes")
    let dbPosts = db.child("posts")
    
    let storage = Storage.storage().reference()
    
    // MARK: - Sign In / Sign Up
    
    func signIn(presenting: UIViewController, completion: @escaping (Bool) -> Void) {
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: presenting) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            // If sign in succeeded, display the app's main content
            
            let auth = user.authentication
            guard let idToken = auth.idToken else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
            
            Auth.auth().signIn(with: credentials) { authResult, error in
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // If user is registered
                let referenceOfCurrentUser = self.dbUsers.child(authResult?.user.uid ?? "noid")
                
                referenceOfCurrentUser.observeSingleEvent(of: .value) { snapshot in
                    completion(snapshot.exists())
                }
                
                
            }
            
        }
        
    }
    
    func signUp(with formData: Dictionary<String, Any>, profileImageData: Data?, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        guard let currentUser = FirebaseManager.currentUser else {
            return
        }
        
        let referenceOfUser = dbUsers.child(currentUser.uid)
        
        var userData = formData
        userData["id"] = FirebaseManager.currentUser!.uid
        userData["email"] = FirebaseManager.currentUser!.email
        
        referenceOfUser.setValue(userData) { error, databaseReference in
            completion(error, databaseReference)
        }
        
        if let profileImageData = profileImageData {
            uploadProfilePicture(imageData: profileImageData)
        } else {
            dbUsers.child(FirebaseManager.currentUser!.uid).child("profile").setValue(FirebaseManager.currentUser!.photoURL?.absoluteString)
        }
        
    }
    
    // MARK: - Home
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        
        dbPosts.observeSingleEvent(of: .value) { snapshot in
            var arrayOfPosts = [Post]()
            
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                let postType = dataSnapshot.decode(class: PType.self)
                guard let postType = postType else { return }
                
                switch postType.type {
                    
                case .text:
                    let currentPost = dataSnapshot.decode(class: TextPost.self)
                    guard let currentPost = currentPost else { return }
                    arrayOfPosts.append(currentPost)
                case .images:
                    let currentPost = dataSnapshot.decode(class: ImagePost.self)
                    guard let currentPost = currentPost else { return }
                    arrayOfPosts.append(currentPost)
                }
                
            }
            
            arrayOfPosts.sort { $0.date.compare($1.date) == .orderedDescending }
            
            completion(arrayOfPosts)
            
        }
        
    }
    
    func fetchComments(of post: PostViewModel, completion: @escaping ([Comment]) -> Void) {
        
        let referenceOfComments = dbPosts.child(post.id).child("comments")
        
        referenceOfComments.observe(.value) { snapshot in
            var arrayOfComments = [Comment]()
            
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                let currentComment = dataSnapshot.decode(class: Comment.self)
                guard let currentComment = currentComment else {
                    return
                }
                
                arrayOfComments.append(currentComment)
            }
            
            arrayOfComments.sort { $0.date.compare($1.date) == .orderedDescending }
            
            completion(arrayOfComments)
        }
        
    }
    
    func post(text: String, completion: @escaping () -> Void) {
        
        let referenceOfPost = dbPosts.childByAutoId()
        
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium))
        
        let postData: [String : Any] = [
            "id": referenceOfPost.key!,
            "author": FirebaseManager.currentUser!.uid,
            "date": date,
            "content": text,
            "type": PostType.text.rawValue
        ]
        
        referenceOfPost.setValue(postData) { error, databaseReference in
            completion()
        }
        
    }
    
    func post(text: String, arrayOfImageData: [Data], completion: @escaping () -> Void) {
        
        let referenceOfPost = dbPosts.childByAutoId()
        
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium))
        
        for (imageIndex, imageData) in arrayOfImageData.enumerated() {
            let imageKey = dbPosts.child(referenceOfPost.key!).child("images").childByAutoId()
            
            let storageRef = "images/post_images/\(referenceOfPost.key!)/\(imageKey.key!).png"
            
            storage.child(storageRef).putData(imageData, metadata: nil) { _, error in
                guard error == nil else {
                    print("Failed to upload.")
                    return
                }
                
                self.storage.child(storageRef).downloadURL { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    
                    let urlString = url.absoluteString
                    
                    self.dbPosts.child(referenceOfPost.key!).child("images").updateChildValues(["\(imageKey.key!)": urlString]) { _, _ in
                        if imageIndex + 1 == arrayOfImageData.count {
                            
                            let postData: [String : Any] = [
                                "id": referenceOfPost.key!,
                                "author": FirebaseManager.currentUser!.uid,
                                "date": date,
                                "content": text,
                                "type": PostType.images.rawValue
                            ]
                            
                            referenceOfPost.updateChildValues(postData) { error, databaseReference in
                                completion()
                            }
                            
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func react(post: PostViewModel, completion: @escaping () -> Void) {
        
        let referenceOfReacts = dbPosts.child(post.id).child("reacts")
        let referenceOfUserReact = referenceOfReacts.child(FirebaseManager.currentUser!.uid)
        
        referenceOfUserReact.observeSingleEvent(of: .value) { snapshot in
            
            if snapshot.exists() {
                snapshot.ref.removeValue()
            } else {
                let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none))
                referenceOfReacts.updateChildValues([FirebaseManager.currentUser!.uid: date]) { _, _ in
                    completion()
                }
            }
            
        }
        
    }
    
    func comment(post: PostViewModel, with comment: String, completion: @escaping () -> Void) {
        
        let referenceOfComments = dbPosts.child(post.id).child("comments")
        let referenceOfComment = referenceOfComments.childByAutoId()
        
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium))
        
        let data = [
            "id": referenceOfComment.key,
            "author": Auth.auth().currentUser!.uid,
            "date": date,
            "content": comment
        ]
        
        referenceOfComment.setValue(data) { error, databaseReference in
            completion()
        }
        
    }
    
    // MARK: - Memes
    
    func fetchMemes(completion: @escaping ([Meme]) -> Void) {
        
        dbMemes.observe(.value) { snapshot in
            
            var arrayOfMemes = [Meme]()
            
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                let currentMeme = dataSnapshot.decode(class: Meme.self)
                guard let currentMeme = currentMeme else {
                    return
                }
                
                arrayOfMemes.append(currentMeme)
            }
            
            completion(arrayOfMemes)
            
        }
        
    }
    
    func uploadMeme(data: Data, completion: @escaping () -> Void) {
        
        let databaseReference = dbMemes.childByAutoId()
        
        let id = databaseReference.key
        guard let id = id else { return }
        
        let storageReference = "images/memes/\(id).png"
        
        storage.child(storageReference).putData(data, metadata: nil) { _, error in
            
            guard error == nil else {
                print("Failed to upload.")
                return
            }
            
            self.storage.child(storageReference).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                let meme = Meme(id: id, author: FirebaseManager.currentUser!.uid, url: urlString)
                
                let data = [
                    "id": meme.id,
                    "author": meme.author,
                    "url": meme.url
                ]
                
                self.dbMemes.child(databaseReference.key!).setValue(data) { _, _ in
                    completion()
                }
                
            }
        }
        
    }
    
    // MARK: - Lecturers
    
    func fetchLecturers(completion: @escaping ([Lecturer]) -> Void) {
        
        dbLecturers.observeSingleEvent(of: .value) { snapshot in
            var arrayOfLecturers = [Lecturer]()
            
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                let currentLecturer = dataSnapshot.decode(class: Lecturer.self)
                guard let currentLecturer = currentLecturer else {
                    return
                }
                
                arrayOfLecturers.append(currentLecturer)
            }
            
            completion(arrayOfLecturers)
        }
        
    }
    
    func fetchRating(of lecturer: Lecturer, completion: @escaping ([String:Int], [Int], Float) -> (Void)) {
        
        let referenceOfRates = dbLecturers.child(lecturer.id).child("rates")
        
        referenceOfRates.observeSingleEvent(of: .value) { snapshot in
            let ratingData = snapshot.value as? [String : Int] ?? [:]
            
            let arrayOfRates = ratingData.map { $1 }
            let rating = Float(arrayOfRates.reduce(0, +)) / Float(arrayOfRates.count)
            
            completion(ratingData, arrayOfRates, rating)
        }
        
    }
    
    func fetchReviews(of lecturer: Lecturer, completion: @escaping ([Review]) -> (Void)) {
        
        let referenceOfReviews = dbLecturers.child(lecturer.id).child("reviews")
        
        referenceOfReviews.observe(.value) { snapshot in
            var arrayOfReviews = [Review]()
            
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                let currentReview = dataSnapshot.decode(class: Review.self)
                guard let currentReview = currentReview else { return }
                
                arrayOfReviews.append(currentReview)
            }
            
            arrayOfReviews.sort { $0.date.compare($1.date) == .orderedDescending }
            
            completion(arrayOfReviews)
            
        }
        
    }
    
    func rate(lecturer: Lecturer, by rate: Double, completion: @escaping () -> (Void)) {
        let referenceOfRates = dbLecturers.child(lecturer.id).child("rates")
        referenceOfRates.child(FirebaseManager.currentUser!.uid).setValue(Int(rate))
        
        completion()
    }
    
    func review(lecturer: Lecturer, with review: String, completion: @escaping () -> Void) {
        
        guard !review.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let referenceOfReviews = dbLecturers.child(lecturer.id).child("reviews")
        let referenceOfReview = referenceOfReviews.childByAutoId()
        
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium))
        
        let data = [
            "id": referenceOfReview.key,
            "author": Auth.auth().currentUser!.uid,
            "date": date,
            "text": review
        ]
        
        referenceOfReview.setValue(data)
        
        completion()
        
    }
    
    // MARK: - Profile
    
    func fetchUserInfo(by userId: String, completion: @escaping (User, [UserInfo]) -> Void) {
        
        let referenceOfUser = dbUsers.child(userId)
        
        referenceOfUser.observeSingleEvent(of: .value) { snapshot in
            
            let user = snapshot.decode(class: User.self)
            
            guard let user = user else { return }
            
            // User info
            
            var userInfo = [
                UserInfo(name: "\(user.age)", image: .age),
                UserInfo(name: user.course, image: .course),
                UserInfo(name: user.faculty, image: .faculty)
            ]
            
            if !(user.minor ?? "").isEmpty {
                userInfo.append(UserInfo(name: "Minor: \(user.minor ?? "")", image: .minor))
            }
            
            //
            
            completion(user, userInfo)
            
        }
        
    }
    
    func updateUserProfile(with data: [String:Any], completion: @escaping () -> Void) {
        let referenceOfUser = dbUsers.child(FirebaseManager.currentUser!.uid)
        referenceOfUser.updateChildValues(data) { error, reference in
            completion()
        }
    }
    
    // MARK: - Other functions
    
    func uploadProfilePicture(imageData: Data) {
        
        let ref = "images/profile_images/\(FirebaseManager.currentUser!.uid)/profile.png"
        
        storage.child(ref).putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload.")
                return
            }
            
            self.storage.child(ref).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                
                self.dbUsers.child(FirebaseManager.currentUser!.uid).child("profile").setValue(urlString)
                
            }
        }
        
    }
    
}
