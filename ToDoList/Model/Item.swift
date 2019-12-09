//
//  Item.swift
//  ToDoList
//
//  Created by Ajay Singh on 11/19/19.
//  Copyright © 2019 Intellinum. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var itemCreatedDate : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
