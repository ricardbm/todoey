//
//  Category.swift
//  todoey
//
//  Created by ricard on 16.01.19.
//  Copyright © 2019 ricard. All rights reserved.
//
// MARK: REALMSWIFT
import Foundation
import RealmSwift

class Category : Object {
    //    MARK: REALMSWIFT
    //    the objc dynamic is necessary inside a Object that is a Realm Class
    @objc dynamic var name : String = ""
    //    MARK: This is the relationship with list
    //    the variable items will contain a List of class Item
    let items = List<Item>()
}
