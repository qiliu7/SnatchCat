//
//  SearchResultsTableViewController.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-21.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var petFinder: PetFinderAPI!
    var location: Location!
    var cats = [Cat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        switch location {
        case .city(let city):
            searchBar.placeholder = city
        case .coordinate(_, _):
            searchBar.placeholder = "Current Location"
        case .none:
            ()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func handleSearchResponse(results: Result<SearchAnimalsResults>) {
        var animals = [Animal]()
        
        switch results {
        case .results(let results):
            animals = results.animals
        case .error(let error):
            showAlert(title: "Error", message: error.localizedDescription)
        }
        // TODO: add activityIndicator
        let downloadGroup = DispatchGroup()
        print("animals count \(animals.count)")
        for animal in animals {
            var cat = Cat(name: animal.name, photoURL: nil, photo: #imageLiteral(resourceName: "default_profile"))
            if let url = animal.photos?.first?.full {
                downloadGroup.enter()
                petFinder.downloadPhoto(url: url) { (photoResult) in
                    cat.photoURL = url
                    switch photoResult {
                    case .results(let photo):
                        cat.photo = photo
                    case .error(let error):
                        print(error.localizedDescription)
                    }
                    self.cats.append(cat)
                    downloadGroup.leave()
                }
            } else {
                self.cats.append(cat)
            }
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultTableCell", for: indexPath)
        let cat = cats[indexPath.row]
        cell.textLabel?.text = cat.name
        cell.imageView?.image = cat.photo
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    //  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //    searchAndNavigateToResultsVC(lat: 52, lon: -106)
    //  }
}
