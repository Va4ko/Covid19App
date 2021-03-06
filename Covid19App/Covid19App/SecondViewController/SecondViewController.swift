//
//  SecondViewController.swift
//  Covid19App
//
//  Created by Vachko on 17.11.20.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var countryLabel: UILabel! {
        didSet{
            countryLabel.text = currentCountry!.country
        }
    }
    @IBOutlet weak var countryTotalCases: CountingLabel! {
        didSet {
            countryTotalCases.text = String(countryold)
        }
    }
    @IBOutlet weak var countryNewCases: CountingLabel! {
        didSet {
            countryNewCases.text = String(countrynewcases)
        }
    }
    @IBOutlet weak var countryTotalDeaths: CountingLabel! {
        didSet {
            countryTotalDeaths.text = String(countrytotaldeaths)
        }
    }
    @IBOutlet weak var countryNewDeaths: CountingLabel! {
        didSet {
            countryNewDeaths.text = String(countrynewdeaths)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
    }
    
    func animate() {
        countryTotalCases.count(fromValue: Float(countryold), to: Float(countrytotal), withDuration: 1.5, AnimationType: .EaseOut, andCounterType: .Int)
        countryNewCases.count(fromValue: 0, to: Float(countrynewcases), withDuration: 1.5, AnimationType: .EaseOut, andCounterType: .Int)
        countryTotalDeaths.count(fromValue: Float(countryoldDeaths), to: Float(countrytotaldeaths), withDuration: 1.5, AnimationType: .EaseOut, andCounterType: .Int)
        countryNewDeaths.count(fromValue: 0, to: Float(countrynewdeaths), withDuration: 1.5, AnimationType: .EaseOut, andCounterType: .Int)
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
    
}
