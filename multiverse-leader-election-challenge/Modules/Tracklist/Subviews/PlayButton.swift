//
//  PlayButton.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 09.04.2021.
//

import SwiftUI

struct PlayButton: View {
    
    @Binding var playing: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 50, height: 50)
                Image(systemName: playing ? "pause.fill" : "play.fill")
                    .foregroundColor(.white)
            }
        }
    }
}
