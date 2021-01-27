//
//  SecondTableViewController.swift
//  Covid19App
//
//  Created by Vachko on 8.12.20.
//

import UIKit
import GoogleMobileAds

class SecondTableViewController: UITableViewController {
    
    var secondBannerView: GADBannerView!
    
    private var arrIndexPath = [IndexPath]()
    
    private func registerCell() {
        let cell = UINib(nibName: "TableViewCell",
                         bundle: nil)
        self.tableView.register(cell,
                                forCellReuseIdentifier: "CountryCustomCell")
        
        let countryCell = UINib(nibName: "CountryLabelTableViewCell",
                                bundle: nil)
        self.tableView.register(countryCell,
                                forCellReuseIdentifier: "CountryLabelCustomCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        registerCell()
        
        tableView.sectionHeaderHeight = 20
        tableView.sectionFooterHeight = 0
        
        self.refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action:
                                    #selector(self.handleRefresh(_:)),
                                  for: UIControl.Event.valueChanged)
        refreshControl!.tintColor = UIColor.red
        
        secondBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        secondBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        secondBannerView.rootViewController = self
        secondBannerView.load(GADRequest())
        
        secondBannerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrIndexPath.removeAll()
        tableView.reloadData()
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        print("Refreshed")
        
        arrIndexPath.removeAll()
        getDataFromServer(completion: {
            self.tableView.reloadData()
        })
        
        refreshControl.endRefreshing()
    }
    
    func addViews(textForLabel: String) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 212))
        parentView.backgroundColor = UIColor.clear
        
        let imageView: UIImageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: parentView.bounds.width, height: parentView.bounds.height)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image =  UIImage(named: "corona")!
        
        let textLabel: UILabel = UILabel()
        textLabel.frame = CGRect(x: 0, y: 182, width: 280.0, height: 30.0)
        textLabel.center.x = parentView.bounds.width / 2
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.textColor = UIColor.white
        textLabel.backgroundColor = UIColor.clear
        textLabel.text = textForLabel
        
        secondBannerView.center.x = parentView.bounds.width / 2
        secondBannerView.frame.origin.y = 15
        
        parentView.addSubview(imageView)
        parentView.addSubview(textLabel)
        parentView.bringSubviewToFront(textLabel)
        parentView.addSubview(secondBannerView)
        
        return parentView
    }
    
    // MARK: - Table view data source and delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryLabelCustomCell") as? CountryLabelTableViewCell else {
                return UITableViewCell()
            }
            cell.countryLabel.text = currentCountry!.country.uppercased()
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCustomCell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.smallLabel.text = """
                Total
                cases:
                """
            if globalData == nil {
                cell.label.text = " "
            } else {
                if arrIndexPath.contains(indexPath) == false {
                    cell.label.text = "\(Int(currentCountry!.totalConfirmed).formattedWithSeparator)"
                    cell.animate(fromValue: currentCountry!.oldCases, toValue: currentCountry!.totalConfirmed, duration: 1.5)
                    
                    arrIndexPath.append(indexPath)
                }
            }
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCustomCell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.smallLabel.text = """
                New
                cases:
                """
            if globalData == nil {
                cell.label.text = " "
            } else {
                if arrIndexPath.contains(indexPath) == false {
                    cell.label.text = "\(Int(currentCountry!.newConfirmed).formattedWithSeparator)"
                    cell.animate(fromValue: 0, toValue: currentCountry!.newConfirmed, duration: 1.5)
                    
                    arrIndexPath.append(indexPath)
                }
            }
            return cell
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCustomCell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.smallLabel.text = """
                Total
                deaths:
                """
            if globalData == nil {
                cell.label.text = " "
            } else {
                if arrIndexPath.contains(indexPath) == false {
                    cell.label.text = "\(Int(currentCountry!.totalDeaths).formattedWithSeparator)"
                    cell.animate(fromValue: currentCountry!.oldDeaths, toValue: currentCountry!.totalDeaths, duration: 1.5)
                    
                    arrIndexPath.append(indexPath)
                }
            }
            return cell
        } else if indexPath.section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCustomCell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.smallLabel.text = """
                New
                deaths:
                """
            if globalData == nil {
                cell.label.text = " "
            } else {
                if arrIndexPath.contains(indexPath) == false {
                    cell.label.text = "\(Int(currentCountry!.newDeaths).formattedWithSeparator)"
                    cell.animate(fromValue: 0, toValue: currentCountry!.newDeaths, duration: 1.5)
                    
                    arrIndexPath.append(indexPath)
                }
            }
            return cell
        } else if indexPath.section == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCustomCell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.smallLabel.text = """
                Total
                recovered:
                """
            if globalData == nil {
                cell.label.text = " "
            } else {
                if arrIndexPath.contains(indexPath) == false {
                    cell.label.text = "\(Int(currentCountry!.totalRecovered).formattedWithSeparator)"
                    cell.animate(fromValue: currentCountry!.oldRecovered, toValue: currentCountry!.totalRecovered, duration: 1.5)
                    
                    arrIndexPath.append(indexPath)
                }
            }
            return cell
        } else if indexPath.section == 6 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCustomCell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.smallLabel.text = """
                New
                recovered:
                """
            if globalData == nil {
                cell.label.text = " "
            } else {
                if arrIndexPath.contains(indexPath) == false {
                    cell.label.text = "\(Int(currentCountry!.newRecovered).formattedWithSeparator)"
                    cell.animate(fromValue: 0, toValue: currentCountry!.newRecovered, duration: 1.5)
                    
                    arrIndexPath.append(indexPath)
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 212
        }
        
        return UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
//            let screenWidth = UIScreen.main.bounds.width
//            let parentView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 212))
//            parentView.backgroundColor = UIColor.clear
//
//            let imageView: UIImageView = UIImageView()
//            imageView.frame = CGRect(x: 0, y: 0, width: parentView.bounds.width, height: parentView.bounds.height)
//            imageView.clipsToBounds = true
//            imageView.contentMode = .scaleAspectFill
//            imageView.image =  UIImage(named: "corona")!
//
//            let textLabel: UILabel = UILabel()
//            textLabel.frame = CGRect(x: 0, y: 182, width: 280.0, height: 30.0)
//            textLabel.center.x = parentView.bounds.width / 2
//            textLabel.textAlignment = NSTextAlignment.center
//            textLabel.textColor = UIColor.white
//            textLabel.backgroundColor = UIColor.clear
//            textLabel.text = "Last updated: \(dateOfUpdateCountry ?? "No info")"
//
//            parentView.addSubview(imageView)
//            parentView.addSubview(textLabel)
//            parentView.bringSubviewToFront(textLabel)
//
//            return parentView
            return addViews(textForLabel: "Last updated: \(dateOfUpdateCountry ?? "No info")")
        }
        
        return nil
        
    }
    
}

extension SecondTableViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        //        addBannerViewToView(bannerView)
        
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
