//
//  TrackSelectableRow.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 08.04.2021.
//

import SwiftUI

struct TrackSelectableRow: View {
    
    let name: String
    
    @Binding var selection: [String]
    @State var isSelected: Bool = false
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .onTapGesture(perform: tapGestureHandle)
    }
    
    private func tapGestureHandle() {
        isSelected.toggle()
        if isSelected {
            selection.append(name)
        } else {
            guard let index = selection.firstIndex(of: name) else { return }
            selection.remove(at: index)
        }
    }
}
