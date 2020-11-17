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

// MARK: - Premium
struct Premium: Codable {
}

// MARK: - Global
struct Global: Codable {
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int
    let newRecovered, totalRecovered: Int

    enum CodingKeys: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
    }
}

//struct Results {
//    var NewConfirmed: Int
//    var TotalConfirmed: Int
//    var NewDeaths: Int
//    var TotalDeaths: Int
//    var NewRecovered: Int
//    var TotalRecovered: Int
//
//    enum CodingKeys: String, CodingKey {
//        case NewConfirmed
//        case TotalConfirmed
//        case NewDeaths
//        case TotalDeaths
//        case NewRecovered
//        case TotalRecovered
//    }
//}
//
//extension Results: Decodable {
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        NewConfirmed = try values.decode(Int.self, forKey: .NewConfirmed)
//        TotalConfirmed = try values.decode(Int.self, forKey: .TotalConfirmed)
//        NewDeaths = try values.decode(Int.self, forKey: .NewDeaths)
//        TotalDeaths = try values.decode(Int.self, forKey: .TotalDeaths)
//        NewRecovered = try values.decode(Int.self, forKey: .NewRecovered)
//        TotalRecovered = try values.decode(Int.self, forKey: .TotalRecovered)
//    }
//}
