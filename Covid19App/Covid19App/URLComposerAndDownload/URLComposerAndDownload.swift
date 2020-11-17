//
//  URLComposerAndDownload.swift
//  Covid19App
//
//  Created by Vachko on 12.11.20.
//

import Foundation

var results: Results?
var old = 0
var oldDeaths = 0
var total = 0
var newcases = 0
var totaldeaths = 0
var newdeaths = 0

func composeURL(_ string: String) -> URL {
    let encodedText = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let urlString = "https://api.covid19api.com/\(encodedText!)"
    let url = URL(string: urlString)
    return url!
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

        total = (results?.global.totalConfirmed)!
        newcases = (results?.global.newConfirmed)!
        totaldeaths = (results?.global.totalDeaths)!
        newdeaths = (results?.global.newDeaths)!
        old = (results?.global.totalConfirmed)! - (results?.global.newConfirmed)!
        oldDeaths = (results?.global.totalDeaths)! - (results?.global.newDeaths)!
        
        DispatchQueue.main.sync {
            completion()
        }
    }

    dataTask.resume()
    
}

func parse(_ data: Data) {
    do {
        let decoder = JSONDecoder()
        results = try decoder.decode(Results.self, from: data)
    } catch {
        print(error)
    }
}
