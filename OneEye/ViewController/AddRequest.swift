//
//  AddRequest.swift
//  OneEye
//
//  Created by Georges on 10/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class AddRequest: UIViewController {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var resultSearchController:UISearchController? = nil
    
    var searchCompleter = MKLocalSearchCompleter()
        
    var selectedPin:MKPlacemark? = nil
    
    let annotation = MKPointAnnotation()

    @IBOutlet var gestureRecognition: UIPanGestureRecognizer!
    
    @IBOutlet weak var descriptionRequest: UITextField!
    
    @IBOutlet weak var sendRequest: UIButton!
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionRequest.delegate = self
        
        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
                
        locationSearchTable.searchBar = searchBar
        
        locationSearchTable.handleMapSearchDelegate = self
        
        gestureRecognition.delegate = self
        
//        Button layout
        sendRequest.layer.cornerRadius = 10
        sendRequest.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if #available(iOS 11.0, *) {
//            navigationItem.hidesSearchBarWhenScrolling = true
//        }
//    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
          // if keyboard size is not available for some reason, dont do anything
          return
        }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
          
      
      // reset back the content inset to zero after keyboard is gone
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        annotation.coordinate = mapView.centerCoordinate
    }
    
    private func searchLocationFromCoordinate(){
        let location = CLLocation(coordinate: annotation.coordinate, altitude: 0, horizontalAccuracy: 0.1, verticalAccuracy: -1, timestamp: Date())
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location,
                    completionHandler: {(placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                self.resultSearchController?.searchBar.text = firstLocation?.name

                }
            else {
             // An error occurred during geocoding.
                print(error)
                        }
                        
        })
        }
    
    func getDateAndTime() -> [String] {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        
        let d_t = dateFormatter.string(from: Date())
        
        return d_t.components(separatedBy: " ")
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        let d_t = getDateAndTime()
        
        let requestsRef = db.collection("requests")
        var ref: DocumentReference? = nil
        ref = requestsRef.addDocument(data: [
            "name": self.resultSearchController?.searchBar.text!,
            "description": descriptionRequest.text!,
            "coordinate": [annotation.coordinate.latitude, annotation.coordinate.longitude],
            "time": d_t[1],
            "date": d_t[0],
            "user": "",
            "answered": false,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension AddRequest : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
            
            annotation.coordinate = mapView.centerCoordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

extension AddRequest: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
//        if let city = placemark.locality,
//        let state = placemark.administrativeArea {
//            annotation.subtitle = "(city) (state)"
//        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
}

extension AddRequest : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        pinView?.isDraggable = true
        let smallSquare = CGSize(width: 30, height: 30)
        
//        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
//
//        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
//
//        button.addTarget(self, action: "getDirections", forControlEvents: .TouchUpInside)
//
//        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        annotation.coordinate = mapView.centerCoordinate
        searchLocationFromCoordinate()
    }
//    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        annotation.coordinate = mapView.centerCoordinate
//    }
}

extension AddRequest: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension AddRequest: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
