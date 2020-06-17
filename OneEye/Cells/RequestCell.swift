//
//  RequestCell.swift
//  OneEye
//
//  Created by Georges on 13/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {
    
    @IBOutlet weak var descriptionRequest: UILabel!
    @IBOutlet weak var nameRequest: UILabel!
    

    func setView(request: Request) {
        descriptionRequest.text = request.description
        nameRequest.text = request.name
    }
}
