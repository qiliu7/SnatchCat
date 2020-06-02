//
//  FirstViewController.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-13.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SearchViewController: UIViewController {
    
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let petFinder = PetFinderAPI()
    // NOT SURE IF NIL YET
    let searchController = UISearchController(searchResultsController: nil)
    let locationManager = CLLocationManager()
    // TODO: add previous searched locations
    let suggestions = ["Current Location"]
    let locationCompleter = MKLocalSearchCompleter()
    
    var isSearching: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: add appropiate title
        navigationItem.title = "Calgary, AB"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter a location"
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationCompleter.delegate = self
        locationCompleter.resultTypes = .address
        definesPresentationContext = true
    }
    
    // TODO: change naming
    private func startSearchAndNavigateToResultsVC(location: Location) {
        let resultsVC = storyboard?.instantiateViewController(identifier: "searchResultsVC") as! SearchResultsTableViewController
        resultsVC.petFinder = petFinder
        resultsVC.location = location
        petFinder.searchAnimals(at: location, completion: resultsVC.handleSearchResponse)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        locationCompleter.queryFragment = searchController.searchBar.text!
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        tableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        tableView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        tableView.isHidden = true
    }

//    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        locationCompleter.queryFragment = text
//        return true
//    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //TODO: add zip code later, AUTOCORRECTION
        if searchBar.text == "" {
            return
        }
        guard let city = searchBar.text else {
            return
        }
        startSearchAndNavigateToResultsVC(location: Location.city(city))
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        print(completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchLocationCell", for: indexPath)
        cell.textLabel?.text = suggestions[indexPath.row]
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: only when the 1st row is selected
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            showAlert(title: "Error", message: "Failed To Retrieve Your Location")
            return
        }
        let coordinate = Location.coordinate(location.coordinate.latitude, location.coordinate.longitude)
        startSearchAndNavigateToResultsVC(location: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "Failed To Retrieve Your Location", message: "\(error.localizedDescription)")
    }
    //
    //  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //
    //  }
}
