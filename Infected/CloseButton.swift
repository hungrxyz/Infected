//
//  CloseButton.swift
//  Infected
//
//  Created by marko on 11/14/20.
//

import SwiftUI

struct CloseButton: View {

    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(action: action, label: {
            Image(systemName: "xmark")
                .foregroundColor(.secondary)
                .padding(8)
                .background(Color.secondary.opacity(0.15))
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
        })
    }
}

#if DEBUG
struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CloseButton(action: {})
            CloseButton(action: {})
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
