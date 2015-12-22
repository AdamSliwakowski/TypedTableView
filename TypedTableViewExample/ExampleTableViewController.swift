//
//  ViewController.swift
//  TypedTableView
//
//  Created by Adam Śliwakowski on 20.12.2015.
//  Copyright © 2015 AdamSliwakowski. All rights reserved.
//

import UIKit

class ExampleTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    lazy var dataSource = TypedTableViewDataSource<Int, ExampleTableViewCell>(objects: [Int](0...100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

