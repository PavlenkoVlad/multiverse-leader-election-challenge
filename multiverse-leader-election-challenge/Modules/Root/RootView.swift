//
//  RootView.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 07.04.2021.
//

import SwiftUI
import Firebase

struct RootView: View {
    
    @StateObject var viewModel = RootViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some View {
        
        Group {
            switch viewModel.state {
            case .initial:
                ProgressView()
            case .auth:
                AuthView()
            case .home:
                GroupsView()
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    }
}

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView()
    }
}
