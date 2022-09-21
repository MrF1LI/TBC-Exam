//
//  NewChatView.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 13.09.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewChatView: View {
    
    @State private var searchText = ""
    
    @ObservedObject var viewModel: NewChatViewModel
    
    init () {
        self.viewModel = NewChatViewModel(with: FirebaseManager())
    }

    var body: some View {
        
        VStack {
            ScrollView {
                
                ForEach (users) { user in

                    LazyVStack {
                        
                        NavigationLink (destination: ChatLogView(chat: Chat(id: "123", members: ["asd":true]))) {
                            UserRow(user: user)
                            Spacer()
                        }
                        
                    }.listRowBackground(Color(.sRGB, white: .nan, opacity: .nan))


                }.background(Color(cgColor: UIColor.colorItem.cgColor))
                    .cornerRadius(35)
            }
            .background(Color(cgColor: UIColor.colorBackground.cgColor))
            
        }
        .background(Color(cgColor: UIColor.colorBackground.cgColor))
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        
    }
    
    var users: [User] {
        let arrayOfUsers = viewModel.arrayOfUsers
        
        let result = searchText == "" ? arrayOfUsers : arrayOfUsers.filter { user in
            "\(user.name) \(user.surname)".lowercased()
                .contains(searchText.lowercased())
            || user.email.lowercased().contains(searchText.lowercased())
        }
        
        return result
        
    }
    
}

struct UserRow: View {
    var user: User
    var body: some View {
        HStack {
            
            WebImage(url: URL(string: user.profile))
                .resizable()
                .placeholder(Image("user.default"))
                .frame(width: 60, height: 60, alignment: .center)
                .background(.black).clipShape(Capsule(style: .circular))
            
            VStack(alignment: .leading, spacing: 0) {
                Text("\(user.name) \(user.surname)")
                    .font(.headline)
                    .foregroundColor(Color(cgColor: UIColor.colorPrimary.cgColor))
                
                Text(user.email)
                    .foregroundColor(Color(cgColor: UIColor.colorSecondary.cgColor))
            }
            
        }
        .padding([.vertical], 8)
        .padding(.horizontal)
    }
}

// MARK: - Preview

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView()
    }
}
