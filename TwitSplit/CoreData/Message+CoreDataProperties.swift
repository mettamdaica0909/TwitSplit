//
//  Message+CoreDataProperties.swift
//  TwitSplit
//
//  Created by Mettamdaica on 2/3/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var chunk: String?

}
