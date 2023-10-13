//
//  SingleStackView.swift
//  TOM
//
//  Created by Tomasz Kubicki on 05/10/2023.
//

import SwiftUI



struct SingleStackView<T>: View {
    var value: T
    var view: displayedView
    var alignment: Alignment

    init(value: T, view: displayedView, alignment: Alignment) {
        self.value = value
        self.view = view
        self.alignment = alignment
    }
    
    var body: some View {
        Text("\(binaryValue)")
            .font(.system(size: 13).monospaced())
            .frame(maxWidth: 270, alignment: alignment)
    }
    
    var binaryValue: String {
        switch view {
        case .binary:
            if value.self is Int {
                let intValue = value.self as! (any BinaryInteger)
                let baseBinary = String(intValue, radix: 2)
                return String(repeating: "0", count: 32 - baseBinary.count) + baseBinary
            } else {
                return value as! String
            }
        case .decimal:
            if value.self is Int {
                return String("\(value)")
            } else {
                return value as! String
            }
        case .hexadecimal:
            if value.self is Int {
                let intValue = value.self as! (any BinaryInteger)
                let baseHex = String(intValue, radix: 16).uppercased()
                return String("0x") + String(baseHex.count % 2 != 0 ? "0" : "") + baseHex
            } else {
                return value as! String
            }
        }
    }
}

struct SingleStackView_Previews: PreviewProvider {
    static var previews: some View {
        SingleStackView(value: 127, view: .binary, alignment: .center)
    }
}
