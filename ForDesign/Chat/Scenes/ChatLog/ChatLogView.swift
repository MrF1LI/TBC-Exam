//
//  ChatLogView.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 11.09.22.
//

import SwiftUI
import FirebaseDatabase

struct ChatLogView: View {
    
    // MARK: - Variables
        
    var chat: Chat
    @ObservedObject var viewModel: ChatLogViewModel
    
    // MARK: - Initialization
    
    init(chat: Chat) {
        self.chat = chat
        self.viewModel = ChatLogViewModel(with: FirebaseManager(), chat: chat)
        self.viewModel.getUserOf(chat: chat)
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .colorItem
    }
    
    // MARK: - Main view
    
    var body: some View {
        
        ZStack {
            messagesView
        }
        .navigationTitle("\(viewModel.user?.name ?? "") \(viewModel.user?.surname ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    // MARK: - Messages list view
    
    private var messagesView: some View {
        VStack {
                        
            if #available(iOS 15.0, *) {
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        
                        VStack {
                            
                            ForEach (viewModel.arrayOfMessages) { currentMessage in
                                MessageView(message: currentMessage)
                                    .id(currentMessage.id)
                            }.onAppear {
                                withAnimation(.easeOut(duration: 0)) {
                                    scrollViewProxy.scrollTo(viewModel.arrayOfMessages.last?.id, anchor: nil)
                                }
                            }
                            
                        }
                        
                    }
                }.background(Color(cgColor: UIColor.colorBackground.cgColor))
            }
                
            // MARK: - Chat bottom bar
            
            HStack {
                Image("more.fill")
                    .foregroundColor(Color(cgColor: UIColor.colorBTU.cgColor))
                
                HStack {
                    Image("smile").foregroundColor(Color(cgColor: UIColor.colorSecondary.cgColor))
                    
                    TextField("Type message...", text: $viewModel.chatText)
                        .tint(Color(cgColor: UIColor.colorBTU.cgColor))
                }
                .padding(.horizontal)
                .padding([.vertical], 12)
                .background(Capsule().fill(Color(cgColor: UIColor.colorBackground.cgColor)))
                
                Button {
                    
                    guard let userId = chat.getMemberIds().first(where: { $0 != FirebaseManager.currentUser?.uid }) else { return }
                    viewModel.sendMessage(to: userId, chat: chat)
                            
                } label: {
                    Image("send")
                        .tint(.white)
                }
                .padding(8)
                .background(Color(cgColor: UIColor.colorBTU.cgColor))
                .cornerRadius(100)

                
            }.padding(.horizontal).padding([.vertical], 10)
                .background(Color(cgColor: UIColor.colorItem.cgColor))
            
        }
        .background(Color(cgColor: UIColor.colorBackground.cgColor))
    }

}

// MARK: - Message View

struct MessageView: View {
    
    var message: Message
    
    var body: some View {
        LazyVStack {
            if message.sender == FirebaseManager.currentUser!.uid {
                
                HStack {
                    Spacer()
                    HStack {
                        Text(message.content)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding([.vertical], 10)
                    }
                    .background(Color(cgColor: UIColor.colorBTU.cgColor))
                    .cornerRadius(30)
                }
                .padding(.horizontal)
                .padding(.top, 3)
                
            } else {
                
                HStack {
                    HStack {
                        Text(message.content)
                            .foregroundColor(Color(cgColor: UIColor.colorPrimary.cgColor))
                            .padding(.horizontal)
                            .padding([.vertical], 10)
                    }
                    .background(Color(cgColor: UIColor.colorItem.cgColor))
                    .cornerRadius(30)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 3)
                
            }
        }
    }
    
}

// MARK: - Preview

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chat: Chat(id: "title", members: [:], type: .personal))
        }
        .background(Color(cgColor: UIColor.colorItem.cgColor))
        .previewInterfaceOrientation(.portrait)
    }
}
