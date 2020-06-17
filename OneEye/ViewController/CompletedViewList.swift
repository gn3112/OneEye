//
//  CompletedViewList.swift
//  OneEye
//
//  Created by Georges on 09/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit

class CompletedViewList: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var views: [View] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white

    }
    
    func createArray() -> [View] {
        var tempViews: [View] = []
        
        var image1 = UIImage(named: "DSC_0215.jpg")
        let image2 = UIImage(named: "DSC_0216.jpg")
        
        image1 = image1?.rotate(radians: -.pi/2)

        let view1 = View(image: image1!, label: "Some place 1")
        let view2 = View(image: image2!, label: "Some place 2")
        
        tempViews.append(view1)
        tempViews.append(view2)
        
        return tempViews
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
                       destination.url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
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
