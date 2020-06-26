//
//  View.swift
//  OneEye
//
//  Created by Georges on 09/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import Foundation
import UIKit

class View {
    var image: UIImage
    var label: String
    var description: String
    var url: String
    var time: String
    var nViews: Int
    
    init(image: UIImage, label: String, url: String, time: String, nViews: Int,description: String) {
        self.image = image
        self.label = label
        self.url = url
        self.time = time
        self.nViews = nViews
        self.description = description
    }
}
