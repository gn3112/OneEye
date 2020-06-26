//
//  UnansweredRequest.swift
//  OneEye
//
//  Created by Georges on 13/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit
import MapKit
import AVKit
import MobileCoreServices
import FirebaseStorage
import Firebase
import AVFoundation

class UnansweredRequest: UIViewController {

    @IBOutlet weak var tableRequest: UITableView!
    
    var requests: [Request] = []
    
    let locationManager = CLLocationManager()
    
    var coordinateUser: CLLocationCoordinate2D?
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    let db = Firestore.firestore()
    
    var requestId : String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableRequest.delegate = self
        tableRequest.dataSource = self
        setUpRefresher()
        
        loadRequests()
        
        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func setUpRefresher(){
        tableRequest.refreshControl = UIRefreshControl()
        
        tableRequest.refreshControl?.addTarget(self, action: #selector(refreshRequests), for: .valueChanged)
    }
    
    @objc private func refreshRequests(){
        requests.removeAll()
        loadRequests()
        DispatchQueue.main.async {
            self.tableRequest.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func answerRequest(_ sender: UIButton) {
        
        if verifyUserLocation(requestCoordinate: requests[sender.tag].coordinate) {
            requestId = requests[sender.tag].id
            recordVideo()
            }
        else {
            print("Not in the correct location")
        }
    }
    
    func verifyUserLocation(requestCoordinate:[Double]) -> Bool {
        if let coordinate = self.coordinateUser {
            let R:Double = 6371000
            let lat1 = coordinate.latitude * .pi/180.0
            let long1 = coordinate.longitude * .pi/180.0
            
            let lat2:Double = requestCoordinate[0] * .pi/180.0
            let long2:Double = requestCoordinate[1] * .pi/180.0
            
            let deltaLat = lat1 - lat2
            let deltaLong = long1 - long2
            
            let a = sin(deltaLat/2) * sin(deltaLat/2) + cos(lat1) * cos(lat2) * sin(deltaLong/2) * sin(deltaLong/2)
            
            let c = 2 * atan2(sqrt(a), sqrt(1-a))
            
            let distance = R * c
            print(distance)
            print(coordinate)
            print(requestCoordinate)
            if distance < 1500 {
                return true
            }
        }
        
        print("coordinate not available")
        return false
        
    }
    
    func loadRequests() {
        db.collection("requests").getDocuments(){querySnapshot, err in
            if let err = err {
                print("Error getting docs: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    let docId = doc.documentID
                    let docData = doc.data()
                    self.requests.append(Request(description: docData["description"] as! String, name: docData["name"] as! String, id: docId, coordinate: docData["coordinate"] as! [Double]))
                    print(docData["description"] as! String)
                
                self.tableRequest.reloadData()
                }
            }
        }
    }
    
    func recordVideo(){
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if (UIImagePickerController.availableCaptureModes(for: .rear) != nil){
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.videoMaximumDuration = 7
                imagePicker.delegate = self
                
                present(imagePicker, animated: true, completion:{})
            }
            else {
                print("Can't access rear camera")
            }
        }
        else {
            print("Can't access camera")
        }
                
    }
    
    func imageFromVideo(url: URL, at time: TimeInterval) -> UIImage? {
        let asset = AVURLAsset(url: url)

        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels

        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }

        return UIImage(cgImage: thumbnailImageRef)
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
        
        cell.answerButton.tag = indexPath.row
        
        return cell
    }

//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    performSegue(withIdentifier: "showVideoCapture", sender: self)
//    }
}

extension UnansweredRequest : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.coordinateUser = locValue
        }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension UnansweredRequest: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Got the video")
        if let pickerVideoURL:NSURL = (info[UIImagePickerController.InfoKey.mediaURL] as? NSURL) {
//            let selectorCall = Selector("videoWasSavedSuccessfully:didFinishSavingwithError:context:")
//            UISaveVideoAtPathToSavedPhotosAlbum(pickerVideo.relativePath!, self, selectorCall, nil)
//
//            let videoData = NSData(contentsOf: pickerVideo as URL)
//            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//            let documentsDirectory = URL(fileURLWithPath: paths[0])
//            let dataPath = documentsDirectory.appendingPathComponent("test.mp4")
//
//            videoData?.write(to: dataPath, atomically: false)
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            let fileRef = storageRef.child("video/\(requestId!).mp4")

            fileRef.putFile(from: pickerVideoURL as URL, metadata: nil, completion: {(metadata, error) in
                if error == nil {
                    print("Success video transfer")
                    fileRef.downloadURL {URL, error in
                        if let error = error {
                            print("Error while get video URL: \(error)")
                        } else {
                            let ref = self.db.collection("requests").document(self.requestId!)
                            ref.setData(["url": URL!.absoluteString], merge: true)
                            ref.updateData(["answered": true])
                        }
                    }
                }
                else {
                    print(error?.localizedDescription)
                }
            }
            )
            
            let firstImage = self.imageFromVideo(url: pickerVideoURL as URL, at: 0)
            
            let data = firstImage!.jpegData(compressionQuality: 0.8)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            let fileRef2 = storageRef.child("image/\(requestId!)")
            
            fileRef2.putData(data!, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                //store downloadURL
                fileRef2.downloadURL {URL, error in
                    if let error = error {
                        print("Error while get image URL: \(error)")
                    } else {
                        let ref = self.db.collection("requests").document(self.requestId!)
                        ref.setData(["urlImage": URL!.absoluteString], merge: true)
                    }
                }
            }
        }
        imagePicker.dismiss(animated: true, completion: {})
    }
}
}
