//
//  ExampleTableViewCell.swift
//  TypedTableView
//
//  Created by Adam Śliwakowski on 22.12.2015.
//  Copyright © 2015 AdamSliwakowski. All rights reserved.
//

import UIKit

class ExampleTableViewCell: UITableViewCell, TypedTableViewConfigurableCell {
    
    typealias T = Int
    
    func configure(data: T) {
        configureText(data)
        backgroundColor = UIColor(hue: CGFloat(0.01 * Double(data)), saturation: 0.8, brightness: 1, alpha: 1)
    }
    
    func configureText(data: T) {
        textLabel!.text = "Cell number: " + String(data)
        textLabel!.textColor = .whiteColor()
        textLabel!.font = .boldSystemFontOfSize(17.0)
        textLabel!.textAlignment = .Center
    }
}
