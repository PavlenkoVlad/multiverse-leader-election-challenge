//
//  FilledButton.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 08.04.2021.
//

import SwiftUI

struct FilledButton: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                Spacer()
            }
        }
        .background(Color.blue)
        .cornerRadius(10)
    }
}
