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
        getDataFromServer(completion: animate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func animate() {
        totalCounts.count(fromValue: Float(old), to: Float(total), withDuration: 10, AnimationType: .EaseOut, andCounterType: .Int)
        newCases.count(fromValue: 0, to: Float(newcases), withDuration: 10, AnimationType: .EaseOut, andCounterType: .Int)
        totalDeaths.count(fromValue: Float(oldDeaths), to: Float(totaldeaths), withDuration: 10, AnimationType: .EaseOut, andCounterType: .Int)
        newDeaths.count(fromValue: 0, to: Float(newdeaths), withDuration: 10, AnimationType: .EaseOut, andCounterType: .Int)
    }
    
}

