//
//  TabBarController.swift
//  Covid19App
//
//  Created by Vachko on 26.11.20.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        let viewControllers = tabBarController.viewControllers! as [UIViewController]
        let selectedIndex = tabBarController.selectedIndex
        
        if selectedIndex < viewControllers.count - 1 {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionFlipFromRight], completion: nil)
            tabBarController.selectedIndex += 1
        } else if selectedIndex == viewControllers.count - 1 {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionFlipFromLeft], completion: nil)
            tabBarController.selectedIndex -= 1
        }
        
        return true
    }
}
