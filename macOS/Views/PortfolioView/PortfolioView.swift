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
        TextField("Name", text: Binding($portfolio.name)!)
            .navigationTitle(portfolio.name!)

        HStack {
            Text("Since:")
            TextField("Since year", value: $portfolio.startYear, formatter: NumberFormatter())
            TextField("Since month", value: $portfolio.startMonth, formatter: NumberFormatter())
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(portfolio: Portfolio())
    }
}
