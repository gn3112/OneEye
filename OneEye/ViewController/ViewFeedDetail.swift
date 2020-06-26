//
//  ViewFeedDetail.swift
//  OneEye
//
//  Created by Georges on 09/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit
import AVFoundation

class ViewFeedDetail: UIViewController {
        
    @IBOutlet weak var detailTableView: UITableView!
    
    var url: String?
    
    var views: [DetailEye] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views.append(DetailEye(url: url!))

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
        
        let videoURL = NSURL(string: view.url)
        
        let avPlayer = AVPlayer(url: videoURL! as URL)
        cell.PlayerView?.playerLayer.player = avPlayer
                
        cell.PlayerView.player?.play()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = tableView.cellForRow(at: indexPath) as! DetailViewCell
        c.PlayerView.player?.seek(to: CMTime.zero)
        c.PlayerView.player?.play()
        print("replay")
    }
}
