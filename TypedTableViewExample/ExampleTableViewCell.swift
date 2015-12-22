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
    static var identifier = "ExampleCell"
    
    func configure(data: T) {
        self.textLabel!.text = String(data)
    }
}
