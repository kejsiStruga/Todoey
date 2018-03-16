//
//  Category.swift
//  Todoey
//
//  Created by Kejsi Struga on 15/03/2018.
//  Copyright © 2018 Kejsi Struga. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var categoryUIColor: String = ""
    // Container type
    let items = List<Item>() // List class comes from Realm framework
    
//    let array = [1,2] // using type inference for declaring array
//    let arr : [Int] = [1,1] //
//    let arrr : Array<Int> = [1,2]
//    // empty arr
//    let arrrr : Array<Int>()
    
}
