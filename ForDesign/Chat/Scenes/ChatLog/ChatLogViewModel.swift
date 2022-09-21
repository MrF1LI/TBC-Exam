//
//  ChatLogViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 13.09.22.
//

import Foundation
import FirebaseDatabase

class ChatLogViewModel: ObservableObject {
    
    // MARK: - Variables 
    
    @Published var chatText = ""
    @Published var arrayOfMessages = [Message]()
    @Published var user: User?
    
    @Published var count = 0
    
    let firebaseManager: FirebaseManager
    let chat: Chat
    
    // MARK: - Initialization
    
    init(with firebaseManager: FirebaseManager, chat: Chat)  {
        self.firebaseManager = firebaseManager
        self.chat = chat
        loadMessages(of: self.chat)
    }
    
    // MARK: - Functions
    
    func loadMessages(of chat: Chat) {
                
        firebaseManager.dbChats.child(chat.id).child("messages").observe(.value) { snapshot in

            self.arrayOfMessages.removeAll()
            
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {

                let currentMessage = dataSnapshot.decode(class: Message.self)
                guard let currentMessage = currentMessage else {
                    return
                }

                self.arrayOfMessages.append(currentMessage)

            }
            
        }
        
    }
    
    func sendMessage(to user: String, chat: Chat) {
        
        if !chatText.trimmingCharacters(in: .whitespaces).isEmpty {
            let referenceOfMessages = firebaseManager.dbChats.child(chat.id).child("messages")
            
            let messageId = referenceOfMessages.childByAutoId()
            let date = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        
            let data = [
                "id": messageId.key ?? "",
                "sender": FirebaseManager.currentUser!.uid,
                "content": chatText,
                "date": date
            ]
            
            messageId.setValue(data) { error, databaseReference in
                self.chatText = ""
            }
        }
        
    }
    
    func getUserOf(chat: Chat) {
        
        let receiver = chat.members.first { $0.key != FirebaseManager.currentUser?.uid ?? "" }?.key
        guard let receiver = receiver else { return }
        
        firebaseManager.dbUsers.child(receiver).observeSingleEvent(of: .value) { snapshot in
            let user = snapshot.decode(class: User.self)
            guard let user = user else { return }
            
            self.user = user
        }
        
    }

    
}
