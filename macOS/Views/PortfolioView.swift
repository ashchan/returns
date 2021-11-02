//
//  PortfolioView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/02.
//

import SwiftUI

struct PortfolioView: View {
    @ObservedObject var portfolio: Portfolio

    var body: some View {
        Text("Portfolio View")
        Text(portfolio.name!)
            .navigationTitle(portfolio.name!)
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(portfolio: Portfolio())
    }
}
