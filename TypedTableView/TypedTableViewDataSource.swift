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
    func reload(objects: [T]) {
        self.objects = objects
        tableView?.reloadData()
    }
    
    func reloadWithAnimation(objects: [T]) {
        removeAll()
        insertContentsOf(contentsOf: objects, atIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    }
}

extension TypedTableViewDataSource {
    func append(newElement: T) {
        objects.append(newElement)
        performChange(.Insert, index: objects.endIndex)
    }
    
    func removeAtIndexPath(indexPath: NSIndexPath) {
        objects.removeAtIndex(indexPath.row)
        performChange(.Delete, index: indexPath.row)
    }
    
    func removeFirst() {
        objects.removeFirst()
        performChange(.Delete, index: objects.startIndex)
    }
    
    func removeLast() {
        objects.removeLast()
        performChange(.Delete, index: objects.endIndex)
    }
    
    func removeAll() {
        let indexPaths = [Int](0..<objects.count).map { NSIndexPath(forRow: $0, inSection: 0) }
        objects.removeAll()
        performChange(.Delete, indexPaths: indexPaths)
    }
    
    func insert(newElement: T, atIndexPath indexPath: NSIndexPath) {
        objects.insert(newElement, atIndex: indexPath.row)
        performChange(.Insert, index: indexPath.row)
    }
    
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


