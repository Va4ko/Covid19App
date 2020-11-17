//
//  Int+Extensions.swift
//  Covid19App
//
//  Created by Vachko on 13.11.20.
//

import Foundation

extension Int {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
