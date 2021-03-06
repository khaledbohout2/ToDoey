//
//  Item.swift
//  ToDoey
//
//  Created by Khaled Bohout on 5/10/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    @objc dynamic var cellColor: String = ""
}
