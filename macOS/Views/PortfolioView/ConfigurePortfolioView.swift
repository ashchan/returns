//
//  ConfigurePortfolioView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/05.
//

import SwiftUI

struct ConfigurePortfolioView: View {
    @Environment(\.presentationMode) var presentationMode
    var onSave: (() -> Void)? // TODO: parameter

    var body: some View {
        VStack {
            HStack {
                Text("Configure Portfolio: TODO")
                Spacer()
            }

            Spacer()

            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                Button("Save") {
                    dismiss()
                    onSave?()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(width: 400, height: 120)
    }
}

private extension ConfigurePortfolioView {
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ConfigurePortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurePortfolioView()
    }
}
