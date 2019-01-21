//
//  Item.swift
//  todoey
//
//  Created by ricard on 16.01.19.
//  Copyright © 2019 ricard. All rights reserved.
//
// MARK: REALMSWIFT
import Foundation
import RealmSwift

class Item: Object {
    //    MARK: REALMSWIFT
    //    the objc dynamic is necessary inside a Object that is a Realm Class
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //    link back to the category relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
