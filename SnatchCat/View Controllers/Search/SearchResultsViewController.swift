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
import SDWebImage

class SearchResultsViewController: UIViewController {
    
    private let resultCell = "searchResultCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    let ROW_HEIGHT = 150
    
    private enum ReuseCellID: String {
        case searchLocationCell
    }
    
    var petFinder: PetfinderAPI!
    
    private enum CellReuseID: String {
        case searchResultCell
    }
    
    private enum Prompt: String {
        case enterLocation = "Enter a Location to Start"
    }
    
    private enum segueID: String {
        case showDetails
    }
    
    private var suggestionController: SearchSuggestionsController!
    private var searchController: UISearchController!
    
    var cats = [CatResult]()
    
    let locationManager = CLLocationManager()
    // TODO: add previous searched locations
    
    var isSearching: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petFinder = PetfinderAPI()
        // TODO: add appropiate title
        navigationItem.title = "Calgary, AB"
        authenticate()
        configureSearchController()
        configureTableView()
        configureLocationManager()
    }
    
    fileprivate func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = CGFloat(ROW_HEIGHT)
        let nib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: resultCell)
    }
    private func configureSearchController() {
        suggestionController = SearchSuggestionsController(style: .plain)
        suggestionController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: suggestionController)
        searchController.searchResultsUpdater = suggestionController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Prompt.enterLocation.rawValue
        searchController.setTextColorToGray()
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    fileprivate func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        definesPresentationContext = true
    }
    
    private func authenticate() {
        petFinder.requestAccessToken { (result) in
            switch result {
            case .results(_):
                ()
            case .error(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func search(location: String) {
        petFinder.searchAnimals(at: location, completion: handleSearchResponse(results:))
    }
    
    func handleSearchResponse(results: Result<SearchAnimalsResults>) {
        switch results {
        case .results(let results):
            cats = results.cats
            dispatchToMain {
                self.tableView.reloadData()
            }
        case .error(let error):
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCell, for: indexPath) as! SearchResultCell

        let cat = cats[indexPath.row]
        cell.cat = cat
        return cell
    }
}

extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        suggestionController.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
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
            searchController.setTextColorToGray()
            searchController.searchBar.text = suggestion
            tableView.deselectRow(at: indexPath, animated: false)
            // Select a search result
        } else if tableView == self.tableView {
//            let selectedCat = catProfiles.filter {$0.cat == cats[indexPath.row]}
            //  MARK: DOES NOT WORK WHEN NO IMAGE?
            
            navigationController?.pushViewController(CatDetailController(cat: cats[indexPath.row]), animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == segueID.showDetails.rawValue {
//            let detailVC = segue.destination as! CatDetailController
////            detailVC.selectedCat = (sender as! CatProfile)
//        }
//    }
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

extension UISearchController {
    
    func setTextColorToGray() {
        if let searchField = self.searchBar.value(forKey: "searchField") as? UITextField {
            searchField.textColor = .darkGray
        }
    }
}
