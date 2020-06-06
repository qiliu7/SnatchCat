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
    
    private enum Prompt: String {
        case enterLocation = "Enter a Location to Start"
    }
    
    private var suggestionController: SearchSuggestionsTableViewController!
    private var searchController: UISearchController!
    private let imageCache = NSCache<NSURL, UIImage>()
    // TODO: add shelter later
    //    var catProfiles = [CatProfile]()
    var cats = [Cat]()
    
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
        petFinder = PetFinderAPI()
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
    }
    private func configureSearchController() {
        suggestionController = SearchSuggestionsTableViewController(style: .plain)
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
                print(self.cats)
                self.tableView.reloadData()
            }
            print(cats.map{($0.name)})
        case .error(let error):
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    private func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void){
        if let image = imageCache.object(forKey: url as NSURL) {
            dispatchToMain {
                completion(image)
                return
            }
        }
        petFinder.downloadImage(url: url) { (imageResult) in
            switch imageResult {
            case .results(let image):
                dispatchToMain {
                    completion(image)
                    self.imageCache.setObject(image, forKey: url as NSURL)
                }
            case .error(let error):
                dispatchToMain {
                    completion(nil)
                    print(error)
                    
                }
            }
        }
    }
}



extension SearchResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.searchResultCell.rawValue, for: indexPath) as! SearchResultTableCell
        // First reset the image
        cell.resultImageView.image = nil
        let cat = cats[indexPath.row]
        
        cell.nameLabel.text = cat.name
        cell.resultImageView.layer.cornerRadius = 10
        cell.clipsToBounds = true
        // Set default image
        if let url = cat.photoURLs?.first?.full {
            loadImage(for: url) { (image) in
                if let image = image {
                    cell.resultImageView.image = image
                } else {
                    cell.resultImageView.image = #imageLiteral(resourceName: "noImageAvailable")
                }
            }
        } else {
            cell.resultImageView.image = #imageLiteral(resourceName: "noImageAvailable")
        }
        cell.detailLabal.text = cat.age + " • " + cat.breeds.primary
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let publishTime = formatter.localizedString(for: cat.publishedAt, relativeTo: Date())
        cell.secondDetailLabel.text = publishTime
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

extension UISearchController {
    
    func setTextColorToGray() {
        if let searchField = self.searchBar.value(forKey: "searchField") as? UITextField {
            searchField.textColor = .darkGray
        }
    }
}
