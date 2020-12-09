//
//  TableTableViewController.swift
//  Covid19App
//
//  Created by Vachko on 7.12.20.
//

import UIKit

class TableViewController: UITableViewController {
    
    private func registerCell() {
        let cell = UINib(nibName: "TableViewCell",
                         bundle: nil)
        self.tableView.register(cell,
                                forCellReuseIdentifier: "CustomCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        registerCell()
        
        getDataFromServer(completion: {
            self.tableView.reloadData()
        })
        
        tableView.sectionHeaderHeight = 30
        tableView.sectionFooterHeight = 0
        
        self.refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action:
                                    #selector(self.handleRefresh(_:)),
                                  for: UIControl.Event.valueChanged)
        refreshControl!.tintColor = UIColor.red
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func loadList(notification: NSNotification){
        self.tableView.reloadData()
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
        getDataFromServer(completion: {
            self.tableView.reloadData()
        })
        
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table view data source and Delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 212
        }
        
        return UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let imageView: UIImageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.image =  UIImage(named: "corona")!
            return imageView
        }
        
        return nil
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 0 }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.smallLabel.text = """
                Total
                cases:
                """
            if globalData == nil {
                cell.label.text = " "
            } else {
                cell.label.text = "\(Int(globalData!.totalConfirmed).formattedWithSeparator)"
                cell.animate(fromValue: globalData!.oldCases, toValue: globalData!.totalConfirmed, duration: 1)
            }
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.smallLabel.text = """
                New
                cases:
                """
            if globalData == nil {
                cell.label.text = " "
            } else {
                cell.label.text = "\(Int(globalData!.newConfirmed).formattedWithSeparator)"
                cell.animate(fromValue: 0, toValue: globalData!.newConfirmed, duration: 1)
            }
            return cell
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.smallLabel.text = """
                Total
                deaths:
                """
            if globalData == nil {
                cell.label.text = " "
            } else {
                cell.label.text = "\(Int(globalData!.totalDeaths).formattedWithSeparator)"
                cell.animate(fromValue: globalData!.oldDeaths, toValue: globalData!.totalDeaths, duration: 1)
            }
            return cell
        } else if indexPath.section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? TableViewCell else {
                return UITableViewCell()
            }
            cell.smallLabel.text = """
                New
                deaths:
                """
            if globalData == nil {
                cell.label.text = " "
            } else {
                cell.label.text = "\(Int(globalData!.newDeaths).formattedWithSeparator)"
                cell.animate(fromValue: 0, toValue: globalData!.newDeaths, duration: 1)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
}
