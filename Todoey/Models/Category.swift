//
//  Category.swift
//  Todoey
//
//  Created by Fivecode on 08/08/19.
//  Copyright © 2019 Fivecode. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
