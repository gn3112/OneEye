//
//  LocationSearchTable.swift
//  OneEye
//
//  Created by Georges on 10/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    
    var searchResults = [MKLocalSearchCompletion]()
    var searchCompleter = MKLocalSearchCompleter()
    var searchBar: UISearchBar?
    
    var handleMapSearchDelegate:HandleMapSearch? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self

    }
}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {        
        searchCompleter.queryFragment = searchBar!.text!
        }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = searchResults[indexPath.row]
        cell.textLabel?.text = selectedItem.title
        cell.detailTextLabel?.text = selectedItem.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = searchResults[indexPath.row]
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = selectedItem.subtitle + " " + selectedItem.title
                
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response else {return}
            guard let item = response.mapItems.first else {return}
            
            self.handleMapSearchDelegate?.dropPinZoomIn(placemark: item.placemark)
            
            self.searchBar?.text = item.placemark.title
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}

extension LocationSearchTable: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    }
}
