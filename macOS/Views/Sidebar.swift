//
//  Sidebar.swift
//  Sidebar
//
//  Created by James Chen on 2021/07/20.
//

import SwiftUI

struct Sidebar: View {
    var body: some View {
        VStack {
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
                .padding(EdgeInsets(top: 2, leading: 14, bottom: 2, trailing: 0))

                NavigationLink(
                    destination: Text("TODO")
                ) {
                    Text(verbatim: "Account #2")
                }
                .padding(EdgeInsets(top: 2, leading: 14, bottom: 2, trailing: 0))

                Text("Portfolio #2")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .contextMenu {
                        Button(action: {}) {
                            Text("Add Account")
                        }
                        Divider()
                        Button(action: {}) {
                            Text("Delete Portfolio")
                        }
                    }

                NavigationLink(
                    destination: Text("TODO")
                ) {
                    Text(verbatim: "Account #1")
                }
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))
                .contextMenu {
                    Button(action: {}) {
                        Text("Delete Account")
                    }
                }
            }
            .listStyle(.sidebar)

            Spacer()

            HStack {
                /*
                Button(action: showNewMenu) {
                    Label("", systemImage: "plus")
                }
                .buttonStyle(.plain)
                .foregroundColor(.primary)
                 */

                Menu {
                    Button(action: {}) {
                        Label("Add Portfolio", systemImage: "plus")
                    }
                    Button(action: {}) {
                        Label("Add Account", systemImage: "plus")
                    }
                } label: {
                    Label("", systemImage: "plus")
                }
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))
                .frame(width: 30, height: 30, alignment: .center)
                .menuStyle(BorderlessButtonMenuStyle(showsMenuIndicator: false))

                Spacer()
            }
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
