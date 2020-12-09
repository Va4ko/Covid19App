//
//  URLComposerAndDownload.swift
//  Covid19App
//
//  Created by Vachko on 12.11.20.
//

import Foundation
import UIKit

var results: Results?
var globalData: Global?
var currentCountry: Country?
var selectedCountry: Country?
var countryNames = ["---SELECT---"]

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

func getcountryData(countryName: String, completion: @escaping ()->Void) -> Country {
    
    let countryResults = results!.countries
    let countryArray = countryResults.filter { $0.country == "\(countryName)" }
    let country = countryArray[0]
    
    DispatchQueue.main.async {
        completion()
    }
    
    return country
}


func parse(_ data: Data) {
    do {
        let decoder = JSONDecoder()
        results = try decoder.decode(Results.self, from: data)
        let countryResults = results!.countries
        
        for country in countryResults {
            countryNames.append(country.country)
        }
        
        let currentCountryArray = countryResults.filter { $0.countryCode == "\(getCountryCode())" }
        currentCountry = currentCountryArray[0]
        
        globalData = Global(newConfirmed: (results?.global.newConfirmed)!, totalConfirmed: (results?.global.totalConfirmed)!, newDeaths: (results?.global.newDeaths)!, totalDeaths: (results?.global.totalDeaths)!, newRecovered: (results?.global.newRecovered)!, totalRecovered: (results?.global.totalRecovered)!)
        
        //        DispatchQueue.main.async {
        //            tableView.reloadData()
        //        }
        
    } catch {
        
        popAlert("Maybe your internet connection is failed or the server is temporarily down! Please try again later!")
        
    }
}

func getDataFromServer(completion: @escaping ()->Void) {
    let url = composeURL("summary")
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("5cf9dfd5-3449-485e-b5ae-70a60e997864", forHTTPHeaderField: "Authorization")
    
    DispatchQueue.global(qos: .userInitiated).async {
        let dataTask: URLSessionDataTask = session.dataTask(with: request) {
            data, response, error in
            
            if data != nil {
                
                parse(data!)
                
                DispatchQueue.main.async {
                    completion()
                }
                
            } else {
                
                popAlert("Maybe your internet connection is failed or the server is temporarily down! Please try again later!")
                
            }
        }
        dataTask.resume()
    }
}

func popAlert(_ message: String) {
    DispatchQueue.main.async {
        let viewController = currentVC()
        let alert = UIAlertController(title: "Attention!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again!", style: .default){ _ in
            getDataFromServer(completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                alert.dismiss(animated: true, completion: nil)
            })
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}


func currentVC() -> UIViewController {
    
    let keyWindow = UIWindow.key
    var currentViewCtrl: UIViewController = keyWindow!.rootViewController!
    while (currentViewCtrl.presentedViewController != nil) {
        currentViewCtrl = currentViewCtrl.presentedViewController!
    }
    
    return currentViewCtrl
    
}
