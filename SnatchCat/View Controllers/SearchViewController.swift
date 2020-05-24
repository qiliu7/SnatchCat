//
//  FirstViewController.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-13.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  let petFinder = PetFinderAPI()
  let locationManager = CLLocationManager()
  let suggestions = ["Current Location"]
  
  // TODO: add previous searched locations to tableView
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isHidden = true
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    petFinder.searchAnimals(for: "") { (_) in
      print("finished")
    }
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
//    CLLocationManager.locationServicesEnabled()
//    if CLLocationManager.locationServicesEnabled() {
//        locationManager.requestLocation()
//    } else {
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
//    }
//    performSegue(withIdentifier: "showSearchResults", sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension SearchViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = manager.location
    print(location?.coordinate)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
//
//  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//    
//  }
}
