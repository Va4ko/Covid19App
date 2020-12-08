//
//  TableViewCell.swift
//  Covid19App
//
//  Created by Vachko on 7.12.20.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: CountingLabel!
    @IBOutlet weak var smallLabel: UILabel!
    
    func animate(fromValue: Int, toValue: Int, duration: TimeInterval) {
        
        label.count(fromValue: Float(fromValue), to: Float(toValue), withDuration: duration, AnimationType: .EaseOut, andCounterType: .Int)
        
    }
    
}
