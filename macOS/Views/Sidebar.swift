//
//  Sidebar.swift
//  Sidebar
//
//  Created by James Chen on 2021/07/20.
//

import SwiftUI

struct Sidebar: View {
    var body: some View {
        List {
            Text("Portfolio #1")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            NavigationLink(
                destination: Text("TODO")
            ) {
                Text(verbatim: "Account #1")
            }
            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))

            NavigationLink(
                destination: Text("TODO")
            ) {
                Text(verbatim: "Account #2")
            }
            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))

            Text("Portfolio #2")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            NavigationLink(
                destination: Text("TODO")
            ) {
                Text(verbatim: "Account #1")
            }
            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))
        }
        .listStyle(.sidebar)
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
