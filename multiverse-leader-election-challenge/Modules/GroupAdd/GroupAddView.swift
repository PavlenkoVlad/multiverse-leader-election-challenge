//
//  GroupAddView.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 08.04.2021.
//

import SwiftUI

struct GroupAddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = GroupAddViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Enter group name:")
                Spacer()
            }
            
            TextField("Group name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            FilledButton(title: "Add") {
                viewModel.addGroup {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            Spacer()
        }
        .padding()
    }
}
