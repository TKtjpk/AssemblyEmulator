//
//  TOMDocument.swift
//  TOM
//
//  Created by Tomasz Kubicki on 05/10/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct TOMDocument: FileDocument {
    var text: String

    static var readableContentTypes = [UTType("com.hackingwithswift.TOM.source")!]

    init(initialText: String = "") {
        text = initialText
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
