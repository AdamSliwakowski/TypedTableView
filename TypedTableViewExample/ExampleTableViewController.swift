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
    var dataSource: TypedTableViewDataSource<Int, ExampleTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        dataSource = TypedTableViewDataSource<Int, ExampleTableViewCell>(objects: [Int](0...100), tableView: tableView)
        tableView.delegate = self
    }
}

extension ExampleTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        dataSource.reloadWithAnimation([1,2,3])
//        dataSource.removeAtIndexPath(indexPath)
//        dataSource[indexPath] = 100
//        dataSource.removeLast()
//        dataSource.removeFirst()
//        dataSource.append(100)
//        dataSource.insert(100, atIndexPath: indexPath)
//        dataSource.insertContentsOf(contentsOf: [100, 101, 102], atIndexPath: indexPath)
    }
}

