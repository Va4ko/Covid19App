//
//  WebMapViewController.swift
//  Covid19App
//
//  Created by Vachko on 28.01.21.
//

import UIKit
import WebKit

@available(iOS 13.0, *)
class WebMapViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loading()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        
        let url = URL(string: "https://covid19.who.int")!
        
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        
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
    
//    func loading() {
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: nil, message: "Loading", preferredStyle: .alert)
//
//            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//            loadingIndicator.hidesWhenStopped = true
//            loadingIndicator.style = UIActivityIndicatorView.Style.large
//            loadingIndicator.startAnimating();
//
//            alert.view.addSubview(loadingIndicator)
//
//            self.present(alert, animated: true)
//        }
//    }
    
}

@available(iOS 13.0, *)
extension WebMapViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.dismiss(animated: true, completion: nil)
    }
    
    
}
