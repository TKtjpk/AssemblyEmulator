//
//  HelpView.swift
//  TOM
//
//  Created by Tomasz Kubicki on 05/10/2023.
//

import SwiftUI
import MarkdownUI


struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    @State var mdText = String()
    @Binding var showHelp: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {dismiss()}) {
                Text("Done").foregroundColor(.white)
            }.padding(10)
            List {                
                Markdown {
                    mdText
                }
                .markdownTextStyle(\.code) {
                  FontFamilyVariant(.monospaced)
                  FontSize(.em(0.85))
                  ForegroundColor(.purple)
                  BackgroundColor(.purple.opacity(0.25))
                }
                .markdownBlockStyle(\.blockquote) { configuration in
                    configuration.label
                        .padding()
                        .markdownTextStyle {
                            FontCapsVariant(.lowercaseSmallCaps)
                            FontWeight(.semibold)
                            BackgroundColor(nil)
                        }
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(Color.teal)
                                .frame(width: 4)
                        }
                        .background(Color.teal.opacity(0.5))
                }
            }
            .frame(minWidth: 800, minHeight: 700)
        }
        .onAppear {
            if let mdFile = Bundle.main.path(forResource: "README", ofType: "md") {
                do {
                    mdText = try String(contentsOfFile: mdFile)
                } catch {
                    mdText = "# Couldn't load help file !"
                }
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(showHelp: .constant(true))
    }
}
