//
//  Model.swift
//  Covid19App
//
//  Created by Vachko on 12.11.20.
//

import Foundation

// MARK: - Results
struct Results: Codable {
    let message: String
    let global: Global
    let countries: [Country]
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case global = "Global"
        case countries = "Countries"
    }
}

// MARK: - Country
struct Country: Codable {
    let country, countryCode, slug: String
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int
    let newRecovered, totalRecovered: Int
    var oldCases: Int {
        totalConfirmed - newConfirmed
    }
    var oldDeaths: Int {
        totalDeaths - newDeaths
    }
    
    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case countryCode = "CountryCode"
        case slug = "Slug"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
    }
}

// MARK: - Global
struct Global: Codable {
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int
    let newRecovered, totalRecovered: Int
    var oldCases: Int {
        totalConfirmed - newConfirmed
    }
    var oldDeaths: Int {
        totalDeaths - newDeaths
    }
    
    enum CodingKeys: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
    }
}
