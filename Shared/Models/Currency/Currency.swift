//
//  Currency.swift
//  Returns
//
//  Created by James Chen on 2021/11/06.
//

import Foundation
import Money

struct Currency {
    let type: CurrencyType.Type

    var code: String { type.code }
    var name: String {
        Locale.current.localizedString(forCurrencyCode: type.code) ?? type.name
    }
    var symbol: String {
        CurrencySymbol.symbol(for: code)
    }
    var minorUnit: Int { type.minorUnit }
}

extension Currency: Identifiable {
    var id: String { code }
}

extension Currency: Hashable {
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

extension Currency {
    static func from(code: String) -> Currency? {
        if let crypto = cryptocurrencies.first(where: { c in
            c.code == code
        }) {
            return crypto
        }

        if let type = iso4217Currency(for: code) {
            return Currency(type: type)
        }

        return nil
    }

    static let allCurrencies: [Currency] = {
        popularCurrencies + cryptocurrencies + otherCurrencies
    }()

    static let popularCurrencies: [Currency] = {
        let popular = [
            Currency(type: USD.self),
            Currency(type: EUR.self),
            Currency(type: JPY.self),
            Currency(type: GBP.self),
            Currency(type: CAD.self),
            Currency(type: CHF.self),
            Currency(type: CNY.self),
        ]
        return popular
    }()

    static let cryptocurrencies: [Currency] = {
        let crypto = [
            Currency(type: BTC.self),
            Currency(type: ETH.self),
            Currency(type: LTC.self)
        ]
        return crypto
    }()

    static let otherCurrencies: [Currency] = {
        let others = [
            Currency(type: AED.self),
            Currency(type: AFN.self),
            Currency(type: ALL.self),
            Currency(type: AMD.self),
            Currency(type: ANG.self),
            Currency(type: AOA.self),
            Currency(type: ARS.self),
            Currency(type: AUD.self),
            Currency(type: AWG.self),
            Currency(type: AZN.self),
            Currency(type: BAM.self),
            Currency(type: BBD.self),
            Currency(type: BDT.self),
            Currency(type: BGN.self),
            Currency(type: BHD.self),
            Currency(type: BIF.self),
            Currency(type: BMD.self),
            Currency(type: BND.self),
            Currency(type: BOB.self),
            Currency(type: BOV.self),
            Currency(type: BRL.self),
            Currency(type: BSD.self),
            Currency(type: BTN.self),
            Currency(type: BWP.self),
            Currency(type: BYN.self),
            Currency(type: BZD.self),
            Currency(type: CDF.self),
            Currency(type: CHE.self),
            Currency(type: CHW.self),
            Currency(type: CLF.self),
            Currency(type: CLP.self),
            Currency(type: COP.self),
            Currency(type: COU.self),
            Currency(type: CRC.self),
            Currency(type: CUC.self),
            Currency(type: CUP.self),
            Currency(type: CVE.self),
            Currency(type: CZK.self),
            Currency(type: DJF.self),
            Currency(type: DKK.self),
            Currency(type: DOP.self),
            Currency(type: DZD.self),
            Currency(type: EGP.self),
            Currency(type: ERN.self),
            Currency(type: ETB.self),
            Currency(type: FJD.self),
            Currency(type: FKP.self),
            Currency(type: GEL.self),
            Currency(type: GHS.self),
            Currency(type: GIP.self),
            Currency(type: GMD.self),
            Currency(type: GNF.self),
            Currency(type: GTQ.self),
            Currency(type: GYD.self),
            Currency(type: HKD.self),
            Currency(type: HNL.self),
            Currency(type: HRK.self),
            Currency(type: HTG.self),
            Currency(type: HUF.self),
            Currency(type: IDR.self),
            Currency(type: ILS.self),
            Currency(type: INR.self),
            Currency(type: IQD.self),
            Currency(type: IRR.self),
            Currency(type: ISK.self),
            Currency(type: JMD.self),
            Currency(type: JOD.self),
            Currency(type: KES.self),
            Currency(type: KGS.self),
            Currency(type: KHR.self),
            Currency(type: KMF.self),
            Currency(type: KPW.self),
            Currency(type: KRW.self),
            Currency(type: KWD.self),
            Currency(type: KYD.self),
            Currency(type: KZT.self),
            Currency(type: LAK.self),
            Currency(type: LBP.self),
            Currency(type: LKR.self),
            Currency(type: LRD.self),
            Currency(type: LSL.self),
            Currency(type: LYD.self),
            Currency(type: MAD.self),
            Currency(type: MDL.self),
            Currency(type: MGA.self),
            Currency(type: MKD.self),
            Currency(type: MMK.self),
            Currency(type: MNT.self),
            Currency(type: MOP.self),
            Currency(type: MRU.self),
            Currency(type: MUR.self),
            Currency(type: MVR.self),
            Currency(type: MWK.self),
            Currency(type: MXN.self),
            Currency(type: MXV.self),
            Currency(type: MYR.self),
            Currency(type: MZN.self),
            Currency(type: NAD.self),
            Currency(type: NGN.self),
            Currency(type: NIO.self),
            Currency(type: NOK.self),
            Currency(type: NPR.self),
            Currency(type: NZD.self),
            Currency(type: OMR.self),
            Currency(type: PAB.self),
            Currency(type: PEN.self),
            Currency(type: PGK.self),
            Currency(type: PHP.self),
            Currency(type: PKR.self),
            Currency(type: PLN.self),
            Currency(type: PYG.self),
            Currency(type: QAR.self),
            Currency(type: RON.self),
            Currency(type: RSD.self),
            Currency(type: RUB.self),
            Currency(type: RWF.self),
            Currency(type: SAR.self),
            Currency(type: SBD.self),
            Currency(type: SCR.self),
            Currency(type: SDG.self),
            Currency(type: SEK.self),
            Currency(type: SGD.self),
            Currency(type: SHP.self),
            Currency(type: SLL.self),
            Currency(type: SOS.self),
            Currency(type: SRD.self),
            Currency(type: SSP.self),
            Currency(type: STN.self),
            Currency(type: SVC.self),
            Currency(type: SYP.self),
            Currency(type: SZL.self),
            Currency(type: THB.self),
            Currency(type: TJS.self),
            Currency(type: TMT.self),
            Currency(type: TND.self),
            Currency(type: TOP.self),
            Currency(type: TRY.self),
            Currency(type: TTD.self),
            Currency(type: TWD.self),
            Currency(type: TZS.self),
            Currency(type: UAH.self),
            Currency(type: UGX.self),
            Currency(type: UYI.self),
            Currency(type: UYU.self),
            Currency(type: UZS.self),
            Currency(type: VEF.self),
            Currency(type: VND.self),
            Currency(type: VUV.self),
            Currency(type: WST.self),
            Currency(type: XCD.self),
            Currency(type: YER.self),
            Currency(type: ZAR.self),
            Currency(type: ZMW.self),
            Currency(type: ZWL.self)
        ]
        return others.filter { currency in
            !CurrencySymbol.symbol(for: currency.code).isEmpty
        }
    }()
}
