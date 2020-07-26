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

class SearchResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    
    let ROW_HEIGHT = 150
    
    private enum ReuseCellID: String {
        case searchLocationCell
    }
    
    var petFinder: PetFinderAPI!
    
    private enum CellReuseID: String {
        case searchResultCell
    }
    
    private var suggestionController: SuggestionTableViewController!
    private var searchController: UISearchController!
    // TODO: add shelter later
    private var searchResults: [Cat]? {
        didSet {
            tableView.reloadData()
        }
    }
    var catProfiles = [CatProfile]()
    
    let locationManager = CLLocationManager()
    // TODO: add previous searched locations
    
    var isSearching: Bool {
        return searchController.isActive
    }
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petFinder = PetFinderAPI()
        // TODO: add appropiate title
        navigationItem.title = "Calgary, AB"
        suggestionController = SuggestionTableViewController(style: .plain)
        suggestionController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: suggestionController)
        searchController.searchResultsUpdater = suggestionController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter a location"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.isHidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        definesPresentationContext = true
        
        tableView.rowHeight = CGFloat(ROW_HEIGHT)
        
    }
    
    private func search(location: String) {
        petFinder.searchAnimals(at: location, completion: handleSearchResponse(results:))
    }
    
    func handleSearchResponse(results: Result<SearchAnimalsResults>) {
        print(results)
        var cats = [Cat]()
        
        switch results {
        case .results(let results):
            cats = results.cats
        case .error(let error):
            showAlert(title: "Error", message: error.localizedDescription)
        }
        // TODO: add activityIndicator
        let downloadGroup = DispatchGroup()
        for cat in cats {
            var catProfile = CatProfile(cat: cat, photo: nil)
            if let url = cat.photoURLs?.first?.full {
                downloadGroup.enter()
                petFinder.downloadPhoto(url: url) { (photoResult) in
                    switch photoResult {
                    case .results(let photo):
                        catProfile.photo = photo
                    case .error(let error):
                        print(error.localizedDescription)
                    }
                    self.catProfiles.append(catProfile)
                    downloadGroup.leave()
                }
            } else {
                self.catProfiles.append(catProfile)
            }
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return suggestions.count
        }
        return emptySeggustions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.searchLocationCell.rawValue, for: indexPath)
        let search: String
        if isSearching {
            search = suggestions[indexPath.row]
            print(search)
        } else {
            search = emptySeggustions[indexPath.row]
            print(search)
        }
        cell.textLabel?.text = search
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: only when the 1st row is selected
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension SearchResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.searchResultCell.rawValue, for: indexPath) as! SearchResultTableCell
        let profile = catProfiles[indexPath.row]
        cell.nameLabel.text = profile.cat.name
        cell.resultImageView.image = catProfiles[indexPath.row].photo
        cell.detailLabal.text = profile.cat.age + " • " + profile.cat.breeds.primary
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let publishTime = formatter.localizedString(for: profile.cat.publishedAt, relativeTo: Date())
        cell.secondDetailLabel.text = publishTime
        return cell
    }
}

extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        suggestionController.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //TODO: add zip code later, AUTOCORRECTION
        if searchBar.text == "" {
            return
        }
        guard let location = searchBar.text else {
            return
        }
        search(location: location)
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == suggestionController.tableView {
            let suggestion = suggestionController.searchSuggestions[indexPath.section][indexPath.row]
            if indexPath.section == 0 {
                // Current Location is selected
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestLocation()
            } else {
                search(location: suggestion)
            }
            searchController.isActive = false
            searchController.searchBar.text = suggestion
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

extension SearchResultsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            showAlert(title: "Error", message: "Failed To Retrieve Your Location")
            return
        }
        let coordinate = location.coordinate
        // TODO: need better doc or encapsulation
        search(location: "\(coordinate.latitude),\(coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "Failed To Retrieve Your Location", message: "\(error.localizedDescription)")
    }
    //
    //  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //
    //  }
}
