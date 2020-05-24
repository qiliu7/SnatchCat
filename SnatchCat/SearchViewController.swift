//
//  FirstViewController.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-13.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  let suggestedSearches = ["tabby", "black", "white", "short hair", "calico"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return suggestedSearches.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "suggestedSearchCell", for: indexPath)
    // Put the non-selectable text "Suggested Searches: in the first row"
    if indexPath.row == 0 {
      cell.textLabel?.text = "Suggested Searches:"
      cell.selectionStyle = .none
    } else {
      cell.textLabel?.text = suggestedSearches[indexPath.row - 1]
    }
    return cell
  }
}

extension SearchViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // The first cell can't be selected
    if indexPath.row == 0 {
      tableView.deselectRow(at: indexPath, animated: false)
      return
    }
    performSegue(withIdentifier: "showSearchResults", sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
