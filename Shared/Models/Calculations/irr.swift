//
//  irr.swift
//  Returns
//
//  Created by James Chen on 2021/11/15.
//

// Modified from https://gist.github.com/openopen114/afca3fab3afe2a6860a473426b4151de

import Foundation

// Internal Return Rate
struct Irr {
    static func compute(cashFlows: [Int]) -> Double {
        //const
        let lowRate = 0.005 // 1%
        let highRate = 0.5 // 50%
        let maxIteration = 1000
        let precisionReq = 0.00000001

        //variable
        var old: Double = 0
        var new: Double = 0
        var newGuessRate: Double = lowRate
        var guessRate: Double = lowRate
        var lowGuessRate: Double = lowRate
        var highGuessRate: Double = highRate
        var npv: Double = 0
        var denom: Double = 0

        for i in 0 ..< maxIteration {
            npv = 0
            for j in 0 ..< cashFlows.count {
                denom = pow(1 + guessRate, Double(j))
                npv = npv + (Double(cashFlows[j]) / denom)
            }
            if ((npv > 0) && (npv < precisionReq)) {
                break
            }

            if (old == 0) {
                old = npv
            } else {
                old = new
            }
            new = npv

            if (i > 0) {
                if (old < new) {
                    if (old < 0 && new < 0){
                        highGuessRate = newGuessRate
                    } else {
                        lowGuessRate = newGuessRate
                    }
                } else {
                    if (old > 0 && new > 0) {
                        lowGuessRate = newGuessRate
                    } else {
                        highGuessRate = newGuessRate
                    }
                }
            }
            guessRate = (lowGuessRate + highGuessRate) / 2
            newGuessRate = guessRate
        }

        return guessRate
    }
}
