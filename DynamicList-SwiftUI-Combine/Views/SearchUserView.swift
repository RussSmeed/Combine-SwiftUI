//
//  SearchUserView.swift
//  DynamicList-SwiftUI-Combine
//
//  Created by Farooq Rasheed on 04/01/2020.
//  Copyright © 2020 Ryo Aoyama. All rights reserved.
//

import SwiftUI

struct SearchUserView: View {
    @ObservedObject var viewModel = SearchUserViewModel()
    @State private var showingSheet = false
    var body: some View {
        VStack {
            SearchUserBar(text: $viewModel.name) {
                self.viewModel.search()
            }
            
            List(viewModel.users) { user in
                SearchUserRow(viewModel: self.viewModel, user: user)
                    .onAppear { self.viewModel.fetchImage(for: user) }
                    .gesture(TapGesture()
                    .onEnded({ _ in
                        self.showingSheet.toggle()
                        
                    })
                ).sheet(isPresented: self.$showingSheet) {
                    CardView(viewModel: self.viewModel, user: user)
                }
                
                }.listRowBackground(Color.white)
                
        }
    }
}

struct CardView: View {
    @ObservedObject var viewModel: SearchUserViewModel
    @State var user: User
    @State private var half = false
    @State private var dim = false
    var body: some View {
        VStack {
            viewModel.userImages[user].map { image in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                    .scaleEffect(half ? 0.5 : 1.0)
                    .opacity(dim ? 0.2 : 1.0)
                    .animation(.easeInOut(duration: 1.0))
                    .onTapGesture {
                        self.dim.toggle()
                        self.half.toggle()
                    }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(user.login)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
                .layoutPriority(100)
         
                Spacer()
            }
            .padding()
        }
        .cornerRadius(10)
        .padding([.top, .horizontal])
    }
}
