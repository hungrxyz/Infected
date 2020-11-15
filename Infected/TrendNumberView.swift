//
//  TrendNumberView.swift
//  Infected
//
//  Created by marko on 10/29/20.
//

import SwiftUI

struct TrendNumberView: View {

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.positivePrefix = "+"
        formatter.negativePrefix = "-"
        formatter.zeroSymbol = "0"
        return formatter
    }()

    let trendNumber: Int

    var body: some View {
        HStack {
            Text(Self.numberFormatter.string(for: trendNumber) ?? "--")
                .font(.system(.title2, design: .rounded)).bold()
            Image(systemName: trendNumber.imageName)
                .font(Font.title2.weight(.bold))
        }
        .foregroundColor(trendNumber.color)
    }
}

private extension Int {

    var imageName: String {
        switch signum() {
        case -1:
            return "arrow.down.forward"
        case 0:
            return "arrow.forward"
        case 1:
            return "arrow.up.forward"
        default:
            fatalError()
        }
    }

    var color: Color {
        switch signum() {
        case -1:
            return .green
        case 0:
            return .orange
        case 1:
            return .red
        default:
            fatalError()
        }
    }

}

#if DEBUG
struct TrendView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TrendNumberView(trendNumber: 1234)
            TrendNumberView(trendNumber: 0)
            TrendNumberView(trendNumber: -1234567)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
