//
//  Category.swift
//  ToDoList
//
//  Created by Ajay Singh on 11/19/19.
//  Copyright © 2019 Intellinum. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    let items = List<Item>() // relation ship one to many one category has relationship with many items.
}
