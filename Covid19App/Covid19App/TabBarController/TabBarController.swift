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
        
        let fromViewIndex = viewControllers.firstIndex(of: selectedViewController!)
        let toViewIndex = viewControllers.firstIndex(of: viewController)
        
        if toViewIndex! < fromViewIndex! {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionFlipFromLeft], completion: nil)
        } else if toViewIndex! > fromViewIndex! {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionFlipFromRight], completion: nil)
        }
        
        return true
    }
}
