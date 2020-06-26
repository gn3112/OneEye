//
//  RequestCell.swift
//  OneEye
//
//  Created by Georges on 13/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit
import MapKit

class RequestCell: UITableViewCell {
    
    @IBOutlet weak var descriptionRequest: UILabel!
    @IBOutlet weak var nameRequest: UILabel!
    
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()

    
    func setView(request: Request) {
        //        Button layout
        answerButton.layer.cornerRadius = 10
        answerButton.clipsToBounds = true

        
        descriptionRequest.text = request.description
        nameRequest.text = request.name
        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let coordinate = CLLocationCoordinate2DMake(request.coordinate[0], request.coordinate[1])
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: false)
    }
}

extension RequestCell : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
