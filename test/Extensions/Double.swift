//
//  Double.swift
//  test
//
//  Created by rabie houssaini on 25/5/2024.
//

import Foundation

extension Double{
    
    private var CurrencyFormatter6 : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 2
        return formatter
    }
    private var CurrencyFormatter2 : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    func asCurrencyWith2Decimals()->String{
        let number = NSNumber(value: self)
        return CurrencyFormatter2.string(from: number) ?? "$0.00"
    }
    func asCurrencyWith6Decimals()->String{
        let number = NSNumber(value: self)
        return CurrencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    func asNumberString()->String{
        return String(format: "%.2f", self)
    }
    
    func asPercentString()->String{
        return asNumberString() + "%"
    }
    
    func formattedWithAbbreviations() -> String {
           let num = abs(Double(self))
           let sign = (self < 0) ? "-" : ""

           switch num {
           case 1_000_000_000_000...:
               let formatted = num / 1_000_000_000_000
               let stringFormatted = formatted.asNumberString()
               return "\(sign)\(stringFormatted)Tr"
           case 1_000_000_000...:
               let formatted = num / 1_000_000_000
               let stringFormatted = formatted.asNumberString()
               return "\(sign)\(stringFormatted)Bn"
           case 1_000_000...:
               let formatted = num / 1_000_000
               let stringFormatted = formatted.asNumberString()
               return "\(sign)\(stringFormatted)M"
           case 1_000...:
               let formatted = num / 1_000
               let stringFormatted = formatted.asNumberString()
               return "\(sign)\(stringFormatted)K"
           case 0...:
               return self.asNumberString()

           default:
               return "\(sign)\(self)"
           }
       }
}
