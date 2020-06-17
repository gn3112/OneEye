//
//  AnswerRequest.swift
//  OneEye
//
//  Created by Georges on 12/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class AnswerRequest: UIViewController {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordVideo()
        
    }
    @IBAction func answerRequest(_ sender: Any) {
        performSegue(withIdentifier: "showVideoCapture", sender: nil)
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
    
}

extension AnswerRequest: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Got the video")
        if let pickerVideo:NSURL = (info[UIImagePickerController.InfoKey.mediaURL] as? NSURL) {
            let selectorCall = Selector("videoWasSavedSuccessfully:didFinishSavingwithError:context:")
            UISaveVideoAtPathToSavedPhotosAlbum(pickerVideo.relativePath!, self, selectorCall, nil)
            
            let videoData = NSData(contentsOf: pickerVideo as URL)
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent("test.mp4")
            
            videoData?.write(to: dataPath, atomically: false)
        }
        imagePicker.dismiss(animated: true, completion: {})
        
    }
}
