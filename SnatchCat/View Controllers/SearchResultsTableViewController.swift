//
//  SearchResultsTableViewController.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-21.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    let ROW_HEIGHT = 150
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var petFinder: PetFinderAPI!
    var location: Location!
    var catProfiles = [CatProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        tableView.rowHeight = CGFloat(ROW_HEIGHT)
    }

    private func setUpSearchBar() {
        searchBar.delegate = self
        
        switch location {
        case .city(let city):
            searchBar.placeholder = city
        case .coordinate(_, _):
            searchBar.placeholder = "Current Location"
        case .none:
            ()
        }
    }
    
    func handleSearchResponse(results: Result<SearchAnimalsResults>) {
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catProfiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultTableCell", for: indexPath) as! SearchResultTableCell
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
