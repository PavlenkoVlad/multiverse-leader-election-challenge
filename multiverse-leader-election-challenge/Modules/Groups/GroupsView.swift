//
//  GroupsView.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 07.04.2021.
//

import SwiftUI

struct GroupsView: View {
    
    @StateObject var viewModel = GroupsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.groups) { group in
                NavigationLink(
                    group.name,
                    destination: TracklistView(
                        viewModel: TracklistViewModel(group: group),
                        onDismiss: viewModel.updateUserGroups
                    )
                )
            }
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Create") { viewModel.presentSheet(.create) }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") { viewModel.presentSheet(.add) }
                }
            }
            .sheet(isPresented: $viewModel.showSheet, onDismiss: viewModel.updateUserGroups) {
                switch viewModel.sheet {
                case .create:
                    GroupCreateView()
                case .add:
                    GroupAddView()
                }
            }
        }
        .onAppear(perform: viewModel.updateUserGroups)
    }
}
