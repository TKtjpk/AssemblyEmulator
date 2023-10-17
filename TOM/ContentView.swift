//
//  ContentView.swift
//  TOM
//
//  Created by Tomasz Kubicki on 05/10/2023.
//

import SwiftUI

enum displayedView: String, CaseIterable, Identifiable {
    case binary, decimal, hexadecimal
    var id: Self { self }
}

struct ContentView: View {
    @Binding var document: TOMDocument
    @StateObject private var viewModel = ViewModel()
    @State var view: displayedView = .binary
    @State private var step: Int = 0
    @State private var stackSize = 30.0

    var body: some View {
        NavigationSplitView {
            VStack {
                Picker("", selection: $view) {
                    ForEach(displayedView.allCases) {item in
                        Text(item.rawValue.capitalized)
                    }
                }
                .bold()
                .monospaced()
                .padding(5)
                .frame(maxWidth: .infinity)
                .background(Color.blue.gradient)
                .clipShape(Capsule())
                .padding(.bottom)
                
                ForEach(viewModel.registers.keys.sorted(), id: \.self) { register in
                    RegisterView(name: register, value: viewModel.registers[register, default: 0], style: Color.blue.gradient, view: $view)
                }
                
                RegisterView(name: "ZX", value: viewModel.zx, style: Color.red.gradient, view: $view)
                
                Spacer()
                Text("Memory size: \(Int(stackSize))")
                    .bold()
                    .monospaced()
                    .padding([.top, .bottom], 5)
                Slider(value: $stackSize, in: 30...150, onEditingChanged: {_ in
                    viewModel.run(code: document.text, limit: step)
                })
                .padding()
                Text("Execute until")
                    .bold()
                    .monospaced()
                    .padding([.top, .bottom], 5)
                Stepper(value: $step,
                        in: 0...document.text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).count,
                        step: 1)
                {
                    RegisterView(name: "Line", value: step, style: Color.gray.gradient, view: $view)
                }
                        .onChange(of: step) { value in
                            if step > 0 {
                                viewModel.run(code: document.text, limit: value)
                            }
                        }
                        .accessibilityLabel("Stepper")
                Spacer()
            }
            .padding()
            .frame(minWidth: 400)
        } detail: {
            HStack {
                VSplitView {
                    VStack {
                        Text("Editor")
                            .font(.system(size: 18).monospaced())
                        TextEditor(text: $document.text)
                            .font(.system(size: 15).monospaced())
                            .scrollContentBackground(.hidden)
                            .padding()
                    }
                    VStack {
                        Text("Log")
                            .font(.system(size: 18).monospaced())
                        TextEditor(text: .constant(viewModel.log))
                            .font(.system(size: 15).monospaced())
                            .scrollContentBackground(.hidden)
                            .foregroundStyle(.secondary)
                            .padding()
                    }
                }
                StackView(document: $document, step: $step, view: $view, stackSize: $stackSize, viewModel: viewModel)
            }
        }
        .onAppear(perform: viewModel.reset)
        .toolbar {
            Text("Code executed at line \(step)")
                .bold()
                .monospaced()
            Spacer()
            Button {
                let limit = document.text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).count
                viewModel.run(code: document.text, limit: limit)
                step = 0
            } label: {
                Label("Play", systemImage: "play")
                    .symbolVariant(.fill)
            }
            .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
            
            Spacer()
            Button {
                viewModel.reset()
                step = 0
            } label: {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }
            .accessibilityLabel("Label")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(TOMDocument()))
    }
}
