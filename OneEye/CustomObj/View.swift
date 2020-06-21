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
    var url: String
    
    init(image: UIImage, label: String, url: String) {
        self.image = image
        self.label = label
        self.url = url
    }
}
