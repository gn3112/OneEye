//
//  UnansweredRequest.swift
//  OneEye
//
//  Created by Georges on 13/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit

class UnansweredRequest: UIViewController {

    @IBOutlet weak var tableRequest: UITableView!
    
    var requests: [Request] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableRequest.delegate = self
        tableRequest.dataSource = self
        
        loadRequests()

    }
    
    func loadRequests() {
        requests.append(Request(description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu purus turpis.", name: "Lorem"))
        requests.append(Request(description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu purus turpis.", name: "Lorem"))

    }
    
}

extension UnansweredRequest: UITableViewDataSource, UITableViewDelegate {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return requests.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let request = requests[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
    
    cell.setView(request: request)
    
    return cell
}

//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    performSegue(withIdentifier: "showVideoCapture", sender: self)
//    }
}
