//
//  ChatListView.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 11.09.22.
//

import SwiftUI
import FirebaseDatabase
import SDWebImageSwiftUI

// MARK: - Main view

struct ChatListView: View {
    
    @ObservedObject var viewModel: ChatListViewModel
    
    init() {
        self.viewModel = ChatListViewModel(with: FirebaseManager())
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
                        
            ScrollView {
                
                // MARK: - Recent title and new message icon
                
                HStack(alignment: .center) {
                    Text("Recent")
                        .font(.headline)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(cgColor: UIColor.colorPrimary.cgColor))
        
                    NavigationLink(destination: NewChatView()) {
                        Image("edit")
                            .padding(.horizontal)
                            .foregroundColor(Color(cgColor: UIColor.colorBTU.cgColor))
                    }
                   
                }
                
                // MARK: - Chat list
                
                ForEach (viewModel.arrayOfChats) { chat in

                    LazyVStack {

                        NavigationLink (destination: ChatLogView(chat: chat)) {
                            ChatRow(chat: chat, viewModel: ChatRowViewModel(with: FirebaseManager()))
                            Spacer()
                        }

                    }.listRowBackground(Color(.sRGB, white: .nan, opacity: .nan))


                }.background(Color(cgColor: UIColor.colorItem.cgColor))
                    .cornerRadius(35)
                
            }
            
        }.navigationTitle("Chats")
        .background(Color(cgColor: UIColor.colorBackground.cgColor))
        
    }
}

struct ChatRow: View {
    
    var chat: Chat
    @ObservedObject var viewModel: ChatRowViewModel

    init(chat: Chat, viewModel: ChatRowViewModel) {
        self.chat = chat
        self.viewModel = viewModel
        self.viewModel.getUserOf(chat: chat)
    }
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: viewModel.user?.profile ?? ""))
                .resizable()
                .placeholder(Image("user.default"))
                .frame(width: 60, height: 60, alignment: .center)
                .background(.black).clipShape(Capsule(style: .circular))
                        
            VStack(alignment: .leading, spacing: 0) {
                
                Text("\(viewModel.user?.name ?? "") \(viewModel.user?.surname ?? "")")
                    .font(.headline)
                    .foregroundColor(Color(cgColor: UIColor.colorPrimary.cgColor))
                
                Text(
                    (chat.lastMessage?.sender ?? "" == FirebaseManager.currentUser?.uid ?? "1" ? "You: " : "") +
                    (chat.lastMessage?.content ?? ""))
                    .foregroundColor(Color(cgColor: UIColor.colorSecondary.cgColor))
                
            }
        }
        .padding([.vertical], 8)
        .padding(.horizontal)
    }
    
}

class ChatRowViewModel: ObservableObject {
    
    let firebaseManager: FirebaseManager
    
    @Published var user: User?
    
    init(with firebaseManager: FirebaseManager)  {
        self.firebaseManager = firebaseManager
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

// MARK: - Preview

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
