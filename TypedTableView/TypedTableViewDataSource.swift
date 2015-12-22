//
//  TypedTableViewDataSource.swift
//  TypedTableView
//
//  Created by Adam Śliwakowski on 20.12.2015.
//  Copyright © 2015 AdamSliwakowski. All rights reserved.
//

import UIKit

protocol TypedTableViewConfigurableCell {
    typealias T
    static var identifier: String { get set }
    func configure(data: T)
}

class TypedTableViewDataSource<T, K where K: UITableViewCell, K: TypedTableViewConfigurableCell>: NSObject, UITableViewDataSource {
    
    var tableViewRowAnimation: UITableViewRowAnimation = .Automatic
    
    weak var tableView: UITableView?
    var objects = [T]()
    
    init(objects: [T], tableView: UITableView? = nil) {
        super.init()
        reload(objects)
        configureTableView(tableView)
    }
    
    private func configureTableView(tableView: UITableView?) {
        self.tableView = tableView
        tableView?.dataSource = self
    }
    
    func reload(objects: [T]) {
        self.objects = objects
        tableView?.reloadData()
    }
    
    func reloadWithAnimation(objects: [T]) {
        removeAll()
        insertContentsOf(contentsOf: objects, atIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    }
     
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let object = self[indexPath] as? K.T else { return K() }
        let cell = tableView.dequeueReusableCellWithIdentifier(K.identifier, forIndexPath: indexPath) as! K
        cell.configure(object)
        return cell
    }
}

extension TypedTableViewDataSource {
    
    func append(newElement: T) {
        objects.append(newElement)
        tableView?.insertRowsAtIndexPaths([NSIndexPath(forRow: objects.endIndex, inSection: 0)], withRowAnimation: tableViewRowAnimation)
    }
    
    func removeAtIndexPath(indexPath: NSIndexPath) {
        objects.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: tableViewRowAnimation)
    }
    
    func removeFirst() {
        objects.removeFirst()
        tableView?.deleteRowsAtIndexPaths([NSIndexPath(forRow: objects.startIndex, inSection: 0)], withRowAnimation: tableViewRowAnimation)
    }
    
    func removeLast() {
        objects.removeLast()
        tableView?.deleteRowsAtIndexPaths([NSIndexPath(forRow: objects.endIndex, inSection: 0)], withRowAnimation: tableViewRowAnimation)
    }
    
    func removeAll() {
        let indexPaths = [Int](0..<objects.count).map { NSIndexPath(forRow: $0, inSection: 0) }
        objects.removeAll()
        tableView?.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: tableViewRowAnimation)
    }
    
    func insert(newElement: T, atIndexPath indexPath: NSIndexPath) {
        objects.insert(newElement, atIndex: indexPath.row)
        tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: tableViewRowAnimation)
    }
    
    func insertContentsOf(contentsOf newElements: [T], atIndexPath indexPath: NSIndexPath) {
        objects.insertContentsOf(newElements, at: indexPath.row)
        var indexPaths = [NSIndexPath]()
        for (index, _) in newElements.enumerate() {
            indexPaths.append(NSIndexPath(forRow: indexPath.row + index, inSection: 0))
        }
        tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: tableViewRowAnimation)
    }
    
    subscript(indexPath: NSIndexPath) -> T {
        get {
            return objects[indexPath.row]
        }
        set(newValue) {
            objects[indexPath.row] = newValue
            tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: tableViewRowAnimation)
        }
    }
}
