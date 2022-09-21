//
//  ChatListViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 13.09.22.
//

import FirebaseDatabase

class ChatListViewModel: ObservableObject {
    
    let firebaseManager: FirebaseManager
    
    @Published var arrayOfChats = [Chat]()
    
    init(with firebaseManager: FirebaseManager)  {
        self.firebaseManager = firebaseManager
        getUserChats()
    }
    
    func getUserChats() {
        
        firebaseManager.dbUsers.child(FirebaseManager.currentUser!.uid).observeSingleEvent(of: .value) { snapshot in
            
            let user = snapshot.decode(class: User.self)
            let userChats = user?.chats?.map { $0.key } ?? []
            self.loadChats(by: userChats)
            
        }
    
    }
    
    func loadChats(by chatIds: [String]) {
        
        firebaseManager.dbChats.observe(.value) { snapshot in

            self.arrayOfChats.removeAll()

            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {

                let currentChat = dataSnapshot.decode(class: Chat.self)
                guard var currentChat = currentChat else { return }

                dataSnapshot.childSnapshot(forPath: "messages").ref.queryOrderedByKey().queryLimited(toLast: 1).observe(.childAdded) { messageSnapshot in
                    let message = messageSnapshot.decode(class: Message.self)

                    currentChat.lastMessage = message

                    if chatIds.contains(currentChat.id) {
                        self.arrayOfChats.append(currentChat)
                    }

                }

            }

        }
        
    }
    
    func getUserOf(chat: Chat, completion: @escaping (User) -> Void) {
        
        let receiver = chat.members.first { $0.key != FirebaseManager.currentUser?.uid ?? "" }?.key
        guard let receiver = receiver else { return }
        
        firebaseManager.dbUsers.child(receiver).observeSingleEvent(of: .value) { snapshot in
            let user = snapshot.decode(class: User.self)
            guard let user = user else { return }
            
            completion(user)
        }
        
    }
    
}
