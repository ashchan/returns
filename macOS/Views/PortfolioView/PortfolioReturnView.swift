//
//  PortfolioReturnView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/13.
//

import SwiftUI

struct PortfolioReturnView: View {
    var portfolioReturn: PortfolioReturn
    @State private var showingInvestorReturnViewPopover = false
    @State private var showingPortfolioReturnViewPopover = false
    @AppStorage("upsDownsColor") var upsDownsColor = UpsDownsColor.greenUp

    var body: some View {
        if let returnObject = portfolioReturn.returns.last {
            VStack(alignment: .leading) {
                HStack {
                    Text("Investor return as of \(Self.dateFormatter.string(from: returnObject.closeDate))")
                        .font(.headline)
                    Button {
                        showingInvestorReturnViewPopover.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showingInvestorReturnViewPopover, arrowEdge: .bottom) {
                        InvestorReturnPopover()
                    }
                }

                returnView(
                    label: "Since \(Self.dateFormatter.string(from: portfolioReturn.returns.first!.closeDate))",
                    value: portfolioReturn.internalReturn,
                    showColor: true
                )

                HStack {
                    Text("Portfolio return as of \(Self.dateFormatter.string(from: returnObject.closeDate))")
                        .font(.headline)

                    Button {
                        showingPortfolioReturnViewPopover.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showingPortfolioReturnViewPopover, arrowEdge: .bottom) {
                        PortfolioReturnPopover()
                    }
                }

                HStack {
                    returnView(label: "1 Month", value: returnObject.oneMonthReturn)
                    returnView(label: "3 Months", value: returnObject.threeMonthReturn)
                    returnView(label: "6 Months", value: returnObject.sixMonthReturn)
                    returnView(label: "YTD", value: returnObject.ytdReturn)
                    returnView(label: "1 Year", value: returnObject.oneYearReturn)
                }

                if returnObject.threeYearReturn != nil {
                    Text("Annual compound return")
                        .font(.subheadline).fontWeight(.semibold)

                    HStack {
                        returnView(label: "3 Years", value: returnObject.threeYearReturn)
                        returnView(label: "5 Years", value: returnObject.fiveYearReturn)
                        returnView(label: "10 Years", value: returnObject.tenYearReturn)
                        returnView(label: "15 Years", value: returnObject.fifteenYearReturn)
                        returnView(label: "20 Years", value: returnObject.twentyYearReturn)
                        returnView(label: "30 Years", value: returnObject.thirtyYearReturn)
                        returnView(label: "50 Years", value: returnObject.fiftyYearReturn)
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

private extension PortfolioReturnView {
    func returnView(label: String, value: Decimal?, showColor: Bool) -> some View {
        Group {
            if showColor {
                returnView(label: label, value: value)
                    .foregroundColor(returnColor(value ?? 0))
            } else {
                returnView(label: label, value: value)
            }
        }
    }

    func returnView(label: String, value: Decimal?) -> some View {
        Group {
            if let value = value {
                GroupBox {
                    Text(Self.valueFormatter.string(from: value as NSNumber) ?? "0.0%")
                        .font(.headline)
                } label: {
                    Text(label)
                }
                .groupBoxStyle(ReturnGroupBoxStyle())
            } else {
                EmptyView()
            }
        }
    }

    func returnColor(_ value: Decimal) -> Color {
        if upsDownsColor == .greenUp {
            return value >= 0 ? Color("PriceGreen") : Color("PriceRed")
        } else {
            return value >= 0 ? Color("PriceRed") : Color("PriceGreen")
        }
    }

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = .utc
        return formatter
    }()

    static var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()
}

struct ReturnGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.subheadline)
                .foregroundColor(Color.secondary)
            configuration.content
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color(NSColor.windowBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct InvestorReturnPopover: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Investor Return")
                .font(.headline)

            Text("Money-weighted return, internal rate of return. It represents the annual rate of return of the invested money while taking into account the timing of various contributions to and withdrawals from the portfolio.")
                .lineLimit(6)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 400, maxHeight: .infinity)
        }.padding()
    }
}

struct PortfolioReturnPopover: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Portfolio Return")
                .font(.headline)

            Text("Time-weighted return, comparable return. It represents the annual rate of return of a single lump sum invested in the portfolio during a selected time period.")
                .lineLimit(5)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 400, maxHeight: .infinity)
        }.padding()
    }
}

struct PortfolioReturnView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioReturnView(portfolioReturn: PortfolioReturn(portfolio: testPortfolio))
    }

    static var testPortfolio: Portfolio {
        let context = PersistenceController.preview.container.viewContext
        let portfolio = Portfolio(context: context)
        portfolio.name = "My Portfolio"
        let account = Account(context: context)
        account.name = "My Account #1"
        account.portfolio = portfolio
        return portfolio
    }
}
