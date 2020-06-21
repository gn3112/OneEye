//
//  Request.swift
//  OneEye
//
//  Created by Georges on 14/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import Foundation

class Request {
    var description: String
    var name: String
    var id: String
    var coordinate: [Double]
    
    init(description: String, name: String, id: String, coordinate:[Double]) {
        self.description = description
        self.name = name
        self.id = id
        self.coordinate = coordinate
    }
}
