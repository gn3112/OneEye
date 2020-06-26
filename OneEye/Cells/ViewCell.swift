//
//  ViewCell.swift
//  OneEye
//
//  Created by Georges on 09/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit

class ViewCell: UITableViewCell {

    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var descriptionRequest: UILabel!
    @IBOutlet weak var viewsN: UILabel!
    
    func setView(view: View) {
        videoImageView.image = view.image
        videoTitleLabel.text = view.label
        descriptionRequest.text = view.description
        time.text = view.time
        viewsN.text = String(view.nViews)
        
    }
}
