//
//  ViewFeedDetail.swift
//  OneEye
//
//  Created by Georges on 09/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit

class ViewFeedDetail: UIViewController {
        
    @IBOutlet weak var detailTableView: UITableView!
    
    var image: UIImage?
    
    var views: [DetailEye] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views.append(DetailEye(image: image!))

        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.backgroundColor = .white
    }


}

extension ViewFeedDetail: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return views.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = views[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewCell") as! DetailViewCell
        
        cell.setImage(image: view.image)
        
        return cell
    }
}
