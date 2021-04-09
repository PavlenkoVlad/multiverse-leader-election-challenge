//
//  ControlButton.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 09.04.2021.
//

import SwiftUI

struct ControlButton: View {
    
    var systemName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .frame(width: 50, height: 50)
                Image(systemName: systemName)
                    .foregroundColor(.white)
            }
        }
    }
}
