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
    func configure(data: T)
}

private enum TypedTableViewDataSourceChange {
    case Insert
    case Update
    case Delete
    
    var tableViewRowAnimation: UITableViewRowAnimation {
        switch self {
        case .Insert: return .Automatic
        case .Update: return .Fade
        case .Delete: return .Bottom
        }
    }
}

class TypedTableViewDataSource<T, K where K: UITableViewCell, K: TypedTableViewConfigurableCell>: NSObject, UITableViewDataSource {
    
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
     
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let object = self[indexPath] as? K.T else { return K() }
        let cell = tableView.dequeueReusableCellWithIdentifier("\(K.self)", forIndexPath: indexPath) as! K
        cell.configure(object)
        return cell
    }
}

extension TypedTableViewDataSource {
    /**
     Sets tableView's data to array received in param and realods tableView without animation.
     
     - parameter objects: Array of all objects of specified type that will be populated to dataSource array.
     */
    func reload(objects: [T]) {
        self.objects = objects
        tableView?.reloadData()
    }
    
    /**
     Sets tableView's data to array received in param and realods tableView with animation.
     
     - Removes all objects from dataSource array and all rows from tableView with animation.
     - Inserts new objects to dataSource array with insertion of rows to tableView with animation.
     
     - parameter objects: Array of all objects of specified type that will be populated to tableView.
     */
    func reloadWithAnimation(objects: [T]) {
        removeAll()
        insertContentsOf(contentsOf: objects, atIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    }
}

extension TypedTableViewDataSource {
    /**
     Appends received object to dataSource array and inserts row into tableView.
     
     - parameter newElement: Object of specified type that will be appended to dataSource array.
     */
    func append(newElement: T) {
        objects.append(newElement)
        performChange(.Insert, index: objects.endIndex)
    }
    
    /**
     Removes object at indexPath from dataSource array and deletes row from tableView.
     
     - parameter indexPath: TableView's indexPath that should be deleted from tableView and removed from dataSource.
     */
    func removeAtIndexPath(indexPath: NSIndexPath) {
        objects.removeAtIndex(indexPath.row)
        performChange(.Delete, index: indexPath.row)
    }
    
    /**
     Removes first object from dataSource array and deletes row from tableView.
     */
    func removeFirst() {
        objects.removeFirst()
        performChange(.Delete, index: objects.startIndex)
    }
    
    /**
     Removes last object from dataSource array and deletes row from tableView.
     */
    func removeLast() {
        objects.removeLast()
        performChange(.Delete, index: objects.endIndex)
    }
    
    /**
     Removes all objects from dataSource array and deletes rows from tableView.
     */
    func removeAll() {
        let indexPaths = [Int](0..<objects.count).map { NSIndexPath(forRow: $0, inSection: 0) }
        objects.removeAll()
        performChange(.Delete, indexPaths: indexPaths)
    }
    
    /**
     Inserts received object at specified indexPath to dataSource array and inserts row into tableView.
     
     - parameter newElement: Object of specified type that will be inserted into dataSource array.
     - parameter indexPath: IndexPath that would be used to insert row into tableView and object into dataSource.
     */
    func insert(newElement: T, atIndexPath indexPath: NSIndexPath) {
        objects.insert(newElement, atIndex: indexPath.row)
        performChange(.Insert, index: indexPath.row)
    }
    
    /**
     Inserts received objects at specified indexPath to dataSource array and inserts rows into tableView.
     
     - parameter newElement: Array of objects of specified type that will be inserted into dataSource array.
     - parameter indexPath: IndexPath that would be used to insert rows into tableView and object into dataSource.
     */
    func insertContentsOf(contentsOf newElements: [T], atIndexPath indexPath: NSIndexPath) {
        objects.insertContentsOf(newElements, at: indexPath.row)
        var indexPaths = [NSIndexPath]()
        for (index, _) in newElements.enumerate() {
            indexPaths.append(NSIndexPath(forRow: indexPath.row + index, inSection: 0))
        }
        performChange(.Insert, indexPaths: indexPaths)
    }
    
    subscript(indexPath: NSIndexPath) -> T {
        get {
            return objects[indexPath.row]
        }
        set(newValue) {
            objects[indexPath.row] = newValue
            performChange(.Update, index: indexPath.row)
        }
    }
}

extension TypedTableViewDataSource {
    private func performChange(type: TypedTableViewDataSourceChange, indexPaths: [NSIndexPath]) {
        switch type {
        case .Insert: tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: type.tableViewRowAnimation)
        case .Update: tableView?.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: type.tableViewRowAnimation)
        case .Delete: tableView?.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: type.tableViewRowAnimation)
        }
    }
    
    private func performChange(type: TypedTableViewDataSourceChange, index: Int) {
        performChange(type, indexPaths: [NSIndexPath(forRow: index, inSection: 0)])
    }
}


