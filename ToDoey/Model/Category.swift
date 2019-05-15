//
//  Category.swift
//  ToDoey
//
//  Created by Khaled Bohout on 5/10/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    let items = List<Item>()
    
}
