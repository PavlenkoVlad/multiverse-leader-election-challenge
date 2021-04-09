//
//  GroupCreateView.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 08.04.2021.
//

import SwiftUI

struct GroupCreateView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = GroupCreateViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 16) {
                HStack {
                    Text("Enter group name:")
                    Spacer()
                }
                TextField("Group name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 16)
                
                HStack {
                    Text("Select tracks:")
                    Spacer()
                }
                List(viewModel.tracklist, id: \.self) { track in
                    TrackSelectableRow(name: track, selection: $viewModel.selectedTracks)
                }
                
                Spacer(minLength: 30)
            }
            
            FilledButton(title: "Create") {
                viewModel.createGroup {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .padding()
        .onAppear(perform: viewModel.onAppear)
    }
}
