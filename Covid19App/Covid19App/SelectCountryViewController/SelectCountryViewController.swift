//
//  SelectCountryViewController.swift
//  Covid19App
//
//  Created by Vachko on 27.11.20.
//

import UIKit

class SelectCountryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var PickerView: UIPickerView!
    
    @IBOutlet weak var totalCases: CountingLabel! {
        didSet {
            totalCases.text = String(0)
        }
    }
    @IBOutlet weak var newCases: CountingLabel! {
        didSet {
            newCases.text = String(0)
        }
    }
    @IBOutlet weak var totalDeath: CountingLabel! {
        didSet {
            totalDeath.text = String(0)
        }
    }
    @IBOutlet weak var newDeaths: CountingLabel! {
        didSet {
            newDeaths.text = String(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
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
    
    func updateLabels() {
        totalCases.text = String(selectedCountry[0].totalConfirmed.formattedWithSeparator)
        newCases.text = String(selectedCountry[0].newConfirmed.formattedWithSeparator)
        totalDeath.text = String(selectedCountry[0].totalDeaths.formattedWithSeparator)
        newDeaths.text = String(selectedCountry[0].newDeaths.formattedWithSeparator)
        
        totalCases.count(fromValue: 0, to: Float(selectedCountry[0].totalConfirmed), withDuration: 0.5, AnimationType: .EaseOut, andCounterType: .Int)
        newCases.count(fromValue: 0, to: Float(selectedCountry[0].newConfirmed), withDuration: 0.5, AnimationType: .EaseOut, andCounterType: .Int)
        totalDeath.count(fromValue: 0, to: Float(selectedCountry[0].totalDeaths), withDuration: 0.5, AnimationType: .EaseOut, andCounterType: .Int)
        newDeaths.count(fromValue: 0, to: Float(selectedCountry[0].newDeaths), withDuration: 0.5, AnimationType: .EaseOut, andCounterType: .Int)
    }
    
}

extension SelectCountryViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = getcountryData(countryName: "\(countryNames[pickerView.selectedRow(inComponent: 0)])", completion: updateLabels)
    }
}

extension SelectCountryViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = countryNames[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Arial", size: 25.0)!, NSAttributedString.Key.foregroundColor:UIColor.red])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .center
        return pickerLabel
        
    }
}
