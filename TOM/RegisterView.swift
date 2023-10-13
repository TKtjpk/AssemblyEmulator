//
//  RegisterView.swift
//  TOM
//
//  Created by Tomasz Kubicki on 05/10/2023.
//

import SwiftUI

struct RegisterView: View {
    var name: String
    var value: Int
    var style: AnyGradient
    @Binding var view: displayedView

    var body: some View {
        Text("\(name): \(binaryValue)")
            .bold()
            .font(.system(size: 15).monospaced())
            .padding(5)
            .frame(maxWidth: .infinity)
            .background(style)
            .clipShape(Capsule())
    }
    
    var binaryValue: String {
        if name == "ZX" || name == "Line" {
            return String(value)
        } else {
            switch view {
            case .binary:
                let baseBinary = String(value, radix: 2)
                return String(repeating: "0", count: 32 - baseBinary.count) + baseBinary
            case .decimal:
                return String(value)
            case .hexadecimal:
                let baseHex = String(value, radix: 16).uppercased()
                return String("0x") + String(baseHex.count % 2 != 0 ? "0" : "") + baseHex
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(name: "AX", value: 127, style: Color.blue.gradient, view: .constant(.binary))
    }
}
