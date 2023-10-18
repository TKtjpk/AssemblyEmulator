//
//  StackView.swift
//  TOM
//
//  Created by Tomasz Kubicki on 05/10/2023.
//

import SwiftUI

struct StackView: View {
    @Binding var document: TOMDocument
    @Binding var step: Int
    @Binding var view: displayedView
    @Binding var stackSize: Double
    @StateObject var viewModel: ViewModel
    let ran = 75654 * 32
    var body: some View {
        VStack {
            Text("Program memory")
                .font(.system(size: 18).monospaced())
            HStack {
                Spacer()
                Text("Address")
                Spacer()
                Text("Instruction")
                Spacer()
            }
            ScrollView {
                let commands = document.text.trimmingCharacters(in: .newlines).components(separatedBy: .newlines)
                ForEach (0..<commands.count, id: \.self) { line in
                    HStack {
                        SingleStackView(value: ran - 32 * line, view: view, alignment: .center)
                            .foregroundColor(step == line + 1 ? .secondary : .primary)
                        SingleStackView(value: commands[line], view: view, alignment: .leading)
                            .foregroundColor(step == line + 1 ? .secondary : .primary)
                    }
                }
            }
            Text("Stack memory")
                .font(.system(size: 18).monospaced())
            HStack {
                Spacer()
                Text("Address")
                Spacer()
                Text("Value")
                Spacer()
            }
            ScrollView {
                let lim = viewModel.stack.count
                ForEach (0..<lim, id: \.self) { element in
                    HStack {
                        let ebp = ran - 32 * Int(stackSize)
                        let value = ebp + 32 * (lim - element)
                        let lines = document.text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).count
                        let lss = ran - 32 * (lines - 1)
                        SingleStackView(value: value, view: view, alignment: .center)
                            .onChange(of: viewModel.stack) { _ in
                                if value >= lss {
                                    viewModel.ebp()
                                }
                            }
                        SingleStackView(value: viewModel.stack.reversed()[element], view: view, alignment: .center)
                    }
                }
            }
        }
        .padding()
    }
}
//
//struct StackView_Previews: PreviewProvider {
//    static var previews: some View {
//        StackView(document: .constant(TOMDocument()), step: .constant(1), view: .constant(.binary), stackSize: .constant(3.0), viewModel: ViewModel())
//    }
//}
