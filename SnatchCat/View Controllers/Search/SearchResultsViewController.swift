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
import CoreData

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
    // injected by SceneDelegate
    var dataController: DataController!
    
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
            case .success(_):
                self.fetchFavoritesList()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    fileprivate func fetchFavoritesList() {
        let fetchRequest: NSFetchRequest<Cat> = Cat.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "addDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var favlistByAddDate = [CatResult]()
        
        if let favCats = try? dataController.viewContext.fetch(fetchRequest) {
            
            // convert [Cat] to [CatResult] and save to Favorites
            favCats.forEach { (cat) in
                
                let decoder = JSONDecoder()
                if let photoURLS = try? decoder.decode([PhotoURL].self, from: cat.photoURLs ?? Data()),
                let breeds = try? decoder.decode(Breed.self, from: cat.breeds ?? Data()),
                let attributes = try? decoder.decode(Attributes.self, from: cat.attributes ?? Data()),
                let colors = try? decoder.decode(Colors.self, from: cat.colors ?? Data()),
                let environment = try? decoder.decode(Environment.self, from: cat.environment ?? Data()) {
                    
                    let result: CatResult = CatResult(id: Int(cat.id), name: cat.name ?? "", breeds: breeds, age: cat.age ?? "", url: URL(string: cat.url ?? "")!, photoURLs: photoURLS, publishedAt: cat.publishedAt ?? Date(), description: cat.simpleDescription, gender: cat.gender ?? "", size: cat.size ?? "", environment: environment, attributes: attributes, coat: cat.coat, colors: colors, organizationId: cat.organizationId)
                    favlistByAddDate.append(result)
                }
            }
        }
        Favorites.catList = favlistByAddDate
    }
    
    private func search(location: String) {
        petFinder.searchAnimals(at: location, completion: handleSearchResponse(results:))
    }
    
    func handleSearchResponse(results: Result<SearchAnimalsResults, Error>) {
        switch results {
        case .success(let results):
            cats = results.cats
            dispatchToMain {
                self.tableView.reloadData()
            }
        case .failure(let error):
            showAlert(title: "Could Not Find Pets For This Location", message: "Please try searching for another one.")
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
            let detailController = CatDetailController(cat: cats[indexPath.row])
            detailController.dataController = dataController
            navigationController?.pushViewController(detailController, animated: true)
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
        showAlert(title: "Could Not Find Pets For This Location", message: "Please try searching for another one.")
    }
}

extension UISearchController {
    
    func setTextColorToGray() {
        if let searchField = self.searchBar.value(forKey: "searchField") as? UITextField {
            searchField.textColor = .darkGray
        }
    }
}
