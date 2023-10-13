//
//  TOMApp.swift
//  TOM
//
//  Created by Tomasz Kubicki on 05/10/2023.
//

import SwiftUI

@main
struct TOMApp: App {
    
    @State var showHelp = false
    
    var body: some Scene {
        DocumentGroup(newDocument: TOMDocument()) { file in
            ContentView(document: file.$document)
                .sheet(isPresented: self.$showHelp) { HelpView(showHelp: $showHelp) }
        }.commands {
            CommandGroup(replacing: .help) {
                Button(action: {showHelp.toggle()}) {
                    Text("TOM - help")
                }
            }
        }
    }
}
