//
//  RenameAccountSheet.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/05.
//

import SwiftUI

struct RenameSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @State var name: String
    var label: String = "Name:"
    var onSave: ((String) -> ())?

    var body: some View {
        VStack {
            HStack {
                Text(label)
                TextField("", text: $name, onCommit: {
                    validate()
                })
            }

            Spacer()

            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Save") {
                    dismiss()
                    onSave?(name)
                }
            }
        }
        .padding(20)
        .frame(width: 400, height: 120)
    }
}

private extension RenameSheet {
    func validate() {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            name = "New name"
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct RenameAccountSheet_Previews: PreviewProvider {
    static var previews: some View {
        RenameSheet(name: "Name #1")
    }
}
