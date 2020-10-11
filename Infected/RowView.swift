//
//  RowView.swift
//  Infected
//
//  Created by marko on 9/27/20.
//

import SwiftUI

struct RowView: View {
    let imageName: String?
    let captionText: String?
    let value: Int?

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading) {
                if let captionText = captionText {
                    Text(captionText)
                        .font(Font.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                }
                Text(value.flatMap(Self.numberFormatter.string) ?? "--")
                    .font(Font.system(size: 17, weight: .regular))
            }
        }
    }

}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RowView(imageName: "number", captionText: "This", value: 23904823)
            RowView(imageName: "questionmark", captionText: nil, value: nil)
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
