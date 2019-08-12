//
//  Item.swift
//  Todoey
//
//  Created by Fivecode on 08/08/19.
//  Copyright © 2019 Fivecode. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: String = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
