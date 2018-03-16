//
//  Item.swift
//  Todoey
//
//  Created by Kejsi Struga on 15/03/2018.
//  Copyright © 2018 Kejsi Struga. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    // here we define our props for the class Data
    // dynamic bcz using Object
    // dynamic is a declaration modifier => tells the runtime to use dynamic dispatch over the standard which is a static
    // => this prop will be monitored for change on runtime => if user changes the name val while app running => realm will dynamically update those changes in db
    // but dynamic dispatch comes from Objective-C api => mark it wil @objc to be explicit that we are using the objective c runtime
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var itemUIColor: String = ""
    // LinkingObjects are the inverse realtionship, and are autoupdating container type that represent 0-n objects
    // which are linked to its owning model throgh a relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    // Category.self => the category type!
}
