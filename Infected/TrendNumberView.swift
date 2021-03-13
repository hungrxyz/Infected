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
        formatter.positivePrefix = ""
        formatter.negativePrefix = ""
        formatter.zeroSymbol = "0"
        return formatter
    }()

    let number: Int
    let isPositiveUp: Bool

    var body: some View {
        HStack(spacing: 0) {
            Text(Self.numberFormatter.string(for: number) ?? "--")
                .font(.system(.callout, design: .rounded)).bold()
                .layoutPriority(10)
            Image(systemName: number.imageName)
                .font(Font.caption.weight(.bold))
        }
        .foregroundColor(isPositiveUp ? number.positiveUpColor : number.positiveDownColor)
    }
}

private extension Int {

    var imageName: String {
        switch signum() {
        case -1:
            return "arrow.down"
        case 0:
            return "arrow.forward"
        case 1:
            return "arrow.up"
        default:
            fatalError()
        }
    }

    var positiveDownColor: Color {
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

    var positiveUpColor: Color {
        switch signum() {
        case -1:
            return .red
        case 0:
            return .orange
        case 1:
            return .green
        default:
            fatalError()
        }
    }

}

#if DEBUG
struct TrendView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TrendNumberView(number: 1234, isPositiveUp: true)
            TrendNumberView(number: 0, isPositiveUp: false)
            TrendNumberView(number: -1234567, isPositiveUp: true)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
