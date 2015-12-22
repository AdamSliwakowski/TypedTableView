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
    
    var objects: [T]
    
    init(objects: [T]) {
        self.objects = objects
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objects.count > 0 ? 1 : 0
    }
    
    func objectAt(indexPath indexPath: NSIndexPath) -> T? {
        return objects[indexPath.row]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let object = objectAt(indexPath: indexPath) as? K.T else { return K() }
        let cell = tableView.dequeueReusableCellWithIdentifier(K.identifier, forIndexPath: indexPath) as! K
        cell.configure(object)
        return cell
    }
}
