//
//  CompletedViewList.swift
//  OneEye
//
//  Created by Georges on 09/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit
import Firebase

class CompletedViewList: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var views: [View] = []
    
    var db = Firestore.firestore()
    
    let storage = Storage.storage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        setUpRefresher()
    }
    
    func setUpRefresher(){
        tableView.refreshControl = UIRefreshControl()
        
        tableView.refreshControl?.addTarget(self, action: #selector(refreshRequests), for: .valueChanged)
    }
    
    @objc private func refreshRequests(){
        views.removeAll()
        createArray()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func createArray() {
//        var image1 = UIImage(named: "DSC_0215.jpg")

//        image1 = image1?.rotate(radians: -.pi/2)
//
//        let view1 = View(image: image1!, label: "Some place 1")
//        let view2 = View(image: image2!, label: "Some place 2")
        self.db.collection("requests").whereField("answered", isEqualTo: true).getDocuments() {querySnapshot, err in
        if let err = err {
            print("Error getting docs: \(err)")
        } else {
            var i = 1
            for doc in querySnapshot!.documents {
                print("doc #")
                let docData = doc.data()
                let refImage = self.storage.reference(forURL: docData["urlImage"] as! String)
                    refImage.getData(maxSize: 3*1024*1024) {data, error in
                        if error == nil {
                        let image = UIImage(data: data!)
                        self.views.append(View(image: image!, label: docData["name"] as! String, url: docData["url"] as! String))
                        print("Image success")

                        if querySnapshot!.documents.count == i {
                            print(self.views.count)
                            self.tableView.reloadData()
                        }
                        i += 1
                        } else {
                            print("Fail downloading image with error: \(error)")
                        }
                    }
                    
            }
        }
        }
    }
    

    @IBAction func makeEyeRequest(_ sender: Any) {
        performSegue(withIdentifier: "eyeRequest", sender: nil)
    }
    
}

extension CompletedViewList: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return views.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = views[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell") as! ViewCell
        
        cell.setView(view: view)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showViewFeed", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "showViewFeed":
                if let destination = segue.destination as? ViewFeedDetail {
                    destination.url = views[tableView.indexPathForSelectedRow!.row].url
                   }
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            case "eyeRequest": break
        
            default: break
        }
       
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}


class UIStoryBoardSegue2: UIStoryboardSegue {
    
}
