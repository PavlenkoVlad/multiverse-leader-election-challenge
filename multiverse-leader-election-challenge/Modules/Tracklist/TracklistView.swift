//
//  TracklistView.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 08.04.2021.
//

import SwiftUI

struct TracklistView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: TracklistViewModel
    
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                List(viewModel.group.tracks, id: \.self) { name in
                    Text(name)
                        .onTapGesture {
                            if viewModel.isDownloaded {
                                viewModel.playTrack(with: name)
                            }
                        }
                }
                Spacer(minLength: 200)
            }
            
            ZStack {
                Rectangle()
                    .foregroundColor(Color("PlayerBackground"))
                    .cornerRadius(30)
                
                VStack(spacing: 20) {
                    if viewModel.isDownloaded {
                        Text(viewModel.selectedTrack)
                        
                        HStack(spacing: 32) {
                            ControlButton(systemName: "backward.fill", action: viewModel.playBackward)
                            
                            PlayButton(playing: $viewModel.isPlaying, action: viewModel.playPause)
                            
                            ControlButton(systemName: "forward.fill", action: viewModel.playForward)
                        }
                    }
                    
                    FilledButton(title: "Leave from group") {
                        viewModel.leaveFromGroup()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
            }
            .frame(height: 200)
        }
        .navigationTitle(viewModel.group.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isDownloaded {
                    EmptyView()
                } else {
                    Button(action: viewModel.downloadTracks) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: onDismiss)
    }
}
