//
//  DetailView.swift
//  OneEye
//
//  Created by Georges on 09/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit

class DetailViewCell: UITableViewCell {

    
    @IBOutlet weak var imageDetail: UIImageView!
    
    func setImage(image: UIImage) {
        imageDetail.image = image
    }
    
}
