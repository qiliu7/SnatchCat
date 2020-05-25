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
  
  // TODO: change naming
  private func showSearchResults(lat: Double, lon: Double) {
    let resultsVC = storyboard?.instantiateViewController(identifier: "searchResultsVC") as! SearchResultsTableViewController
    petFinder.searchAnimals(at: (lat: lat, lon: lon), completion: resultsVC.dataReceived)
    navigationController?.pushViewController(resultsVC, animated: true)
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
    showSearchResults(lat: 52, lon: -106)
    
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
    // TODO: only when the 1st rown is selected
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
    let lat = location.coordinate.latitude
    let lon = location.coordinate.longitude
    showSearchResults(lat: lat, lon: lon)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    showAlert(title: "Failed To Retrieve Your Location", message: "\(error.localizedDescription)")
  }
//
//  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//  }
}
