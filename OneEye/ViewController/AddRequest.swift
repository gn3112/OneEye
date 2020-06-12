//
//  AddRequest.swift
//  OneEye
//
//  Created by Georges on 10/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import UIKit
import MapKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
