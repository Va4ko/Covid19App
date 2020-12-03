//
//  ViewController.swift
//  Covid19App
//
//  Created by Vachko on 6.11.20.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var totalCounts: CountingLabel! {
        didSet {
            totalCounts.text = String(old)
        }
    }
    
    @IBOutlet weak var newCases: CountingLabel! {
        didSet {
            newCases.text = String(newcases)
        }
    }
    @IBOutlet weak var totalDeaths: CountingLabel! {
        didSet {
            totalDeaths.text = String(totaldeaths)
        }
    }
    @IBOutlet weak var newDeaths: CountingLabel! {
        didSet {
            newDeaths.text = String(newdeaths)
        }
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        getDataFromServer(completion: animate)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    func animate() {        
        totalCounts.count(fromValue: Float(old), to: Float(total), withDuration: 1, AnimationType: .EaseOut, andCounterType: .Int)
        newCases.count(fromValue: 0, to: Float(newcases), withDuration: 1, AnimationType: .EaseOut, andCounterType: .Int)
        totalDeaths.count(fromValue: Float(oldDeaths), to: Float(totaldeaths), withDuration: 1, AnimationType: .EaseOut, andCounterType: .Int)
        newDeaths.count(fromValue: 0, to: Float(newdeaths), withDuration: 1, AnimationType: .EaseOut, andCounterType: .Int)
    }
    
    @objc fileprivate func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        guard let tabBarController = self.tabBarController, let selectedController = tabBarController.selectedViewController else {return}
        let selectedIndex = tabBarController.selectedIndex
        let viewControllers = tabBarController.viewControllers! as [UIViewController]
        let fromView = selectedController.view
        
        if gesture.direction == .left {
            if selectedIndex < viewControllers.count {
                let toView: UIView = viewControllers[selectedIndex + 1].view
                
                UIView.transition(from: fromView!, to: toView, duration: 0.3, options: [.transitionFlipFromRight], completion: nil)
                
                tabBarController.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if selectedIndex > 0 {
                let toView: UIView = viewControllers[selectedIndex - 1].view
                
                UIView.transition(from: fromView!, to: toView, duration: 0.3, options: [.transitionFlipFromLeft], completion: nil)
                
                tabBarController.selectedIndex -= 1
            }
        }
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
            
            DispatchQueue.main.async {
                updateUI()
            }
            
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
                    
                    self.parse(data!)
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                } else {
                    
                    self.popAlert("Maybe your internet connection is failed or the server is temporarily down! Please try again later!")
                    
                }
            }
            dataTask.resume()
        }
    }
    
    func popAlert(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Attention!", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Try again!", style: .default){ _ in
                self.getDataFromServer(completion: {
                    alert.dismiss(animated: true, completion: nil)
                    self.animate()
                })
                
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
        }
    }
    
}

