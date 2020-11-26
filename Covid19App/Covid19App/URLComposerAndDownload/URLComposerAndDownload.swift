//
//  URLComposerAndDownload.swift
//  Covid19App
//
//  Created by Vachko on 12.11.20.
//

import Foundation

var results: Results?
var currentCountry = [Country]()

var old = 0
var oldDeaths = 0
var total = 0
var newcases = 0
var totaldeaths = 0
var newdeaths = 0

var countryold = 0
var countryoldDeaths = 0
var countrytotal = 0
var countrynewcases = 0
var countrytotaldeaths = 0
var countrynewdeaths = 0

func composeURL(_ string: String) -> URL {
    let encodedText = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let urlString = "https://api.covid19api.com/\(encodedText!)"
    let url = URL(string: urlString)
    return url!
}

func getCountryCode() -> String {
    let locale = Locale.current
    
    return locale.regionCode!
    
    //    if locale.regionCode == "BG" {
    //        return "bulgaria"
    //    }
    //
    //    return "united-states"
}

func getDataFromServer(completion: @escaping ()->Void) {
    let url = composeURL("summary")
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("5cf9dfd5-3449-485e-b5ae-70a60e997864", forHTTPHeaderField: "Authorization")
    
    let dataTask: URLSessionDataTask = session.dataTask(with: request) {
        data, response, error in
        
        parse(data!)
        updateUI()
        
        DispatchQueue.main.sync {
            completion()
        }
    }
    
    dataTask.resume()
    
}

func updateUI() {
    total = (results?.global.totalConfirmed)!
    newcases = (results?.global.newConfirmed)!
    totaldeaths = (results?.global.totalDeaths)!
    newdeaths = (results?.global.newDeaths)!
    old = (results?.global.totalConfirmed)! - (results?.global.newConfirmed)!
    oldDeaths = (results?.global.totalDeaths)! - (results?.global.newDeaths)!
    
    countrytotal = currentCountry[0].totalConfirmed
    countrynewcases = currentCountry[0].newConfirmed
    countryold = currentCountry[0].totalConfirmed - currentCountry[0].newConfirmed
    countrytotaldeaths = currentCountry[0].totalDeaths
    countryoldDeaths = currentCountry[0].totalDeaths - currentCountry[0].newDeaths
    countrynewdeaths = currentCountry[0].newDeaths
    
}

func parse(_ data: Data) {
    do {
        let decoder = JSONDecoder()
        results = try decoder.decode(Results.self, from: data)
        let countryResults = results!.countries
        currentCountry = countryResults.filter { $0.countryCode == "\(getCountryCode())" }
    } catch {
        print(error)
    }
}
