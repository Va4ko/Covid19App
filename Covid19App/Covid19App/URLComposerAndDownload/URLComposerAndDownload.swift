//
//  URLComposerAndDownload.swift
//  Covid19App
//
//  Created by Vachko on 12.11.20.
//

import Foundation
import UIKit

var results: Results?
var currentCountry: Country?
var selectedCountry: Country?
var countryNames = [String]()

var old = Int()
var oldDeaths = Int()
var total = Int()
var newcases = Int()
var totaldeaths = Int()
var newdeaths = Int()

var countryold = Int()
var countryoldDeaths = Int()
var countrytotal = Int()
var countrynewcases = Int()
var countrytotaldeaths = Int()
var countrynewdeaths = Int()

func composeURL(_ string: String) -> URL {
    let encodedText = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let urlString = "https://api.covid19api.com/\(encodedText!)"
    let url = URL(string: urlString)
    return url!
}

func getCountryCode() -> String {
    let locale = Locale.current
    
    return locale.regionCode!
    
}

func updateUI() {
    total = (results?.global.totalConfirmed)!
    newcases = (results?.global.newConfirmed)!
    totaldeaths = (results?.global.totalDeaths)!
    newdeaths = (results?.global.newDeaths)!
    old = (results?.global.totalConfirmed)! - (results?.global.newConfirmed)!
    oldDeaths = (results?.global.totalDeaths)! - (results?.global.newDeaths)!
    
    countrytotal = currentCountry!.totalConfirmed
    countrynewcases = currentCountry!.newConfirmed
    countryold = currentCountry!.totalConfirmed - currentCountry!.newConfirmed
    countrytotaldeaths = currentCountry!.totalDeaths
    countryoldDeaths = currentCountry!.totalDeaths - currentCountry!.newDeaths
    countrynewdeaths = currentCountry!.newDeaths
    
}

func getcountryData(countryName: String, completion: @escaping ()->Void) -> Country {
    
    let countryResults = results!.countries
    let countryArray = countryResults.filter { $0.country == "\(countryName)" }
    let country = countryArray[0]
    
    DispatchQueue.main.async {
        completion()
    }
    
    return country
}

//func currentVC() -> UIViewController {
//    
//    let keyWindow = UIWindow.key
//    var currentViewCtrl: UIViewController = keyWindow!.rootViewController!
//    while (currentViewCtrl.presentedViewController != nil) {
//        currentViewCtrl = currentViewCtrl.presentedViewController!
//    }
//    
//    return currentViewCtrl
//    
//}
