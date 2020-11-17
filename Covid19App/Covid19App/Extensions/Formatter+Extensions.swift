//
//  Formatter+Extensions.swift
//  Covid19App
//
//  Created by Vachko on 13.11.20.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}
