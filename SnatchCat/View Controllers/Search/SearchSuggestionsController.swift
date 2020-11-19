//
//  CompleterResultsTableViewController.swift
//  SnatchCat
//
//  Created by Kappa on 2020-06-02.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import MapKit

class SearchSuggestionsController: UITableViewController{

    var searchCompleter: MKLocalSearchCompleter?
    var completerResults = [MKLocalSearchCompletion]()
    var searchSuggestions = [["Current Location"]] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StartProvidingCompletions()
        tableView.register(SuggestedCompletionTableViewCell.self, forCellReuseIdentifier: SuggestedCompletionTableViewCell.reuseID)
        tableView.separatorStyle = .none
        tableView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        StopProvidingCompletions()
    }
    
    private func StartProvidingCompletions() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .address
    }

    private func StopProvidingCompletions() {
        searchCompleter = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return searchSuggestions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSuggestions[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedCompletionTableViewCell.reuseID, for: indexPath) as! SuggestedCompletionTableViewCell
        let suggestion = searchSuggestions[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.text = suggestion
        cell.imageView?.image = UIImage(systemName: "location")
        return cell
    }
}

extension SearchSuggestionsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter?.queryFragment = searchController.searchBar.text ?? ""
    }
}

extension SearchSuggestionsController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
        
        // Filter out results that are either city or state/province names.
        let results = completerResults.filter{ $0.title.contains(",") }
        let resultTitles = results.map{ $0.title }
        searchSuggestions = [["Current Location"]] + [resultTitles]
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

private class SuggestedCompletionTableViewCell: UITableViewCell {
    
    static let reuseID = "SuggestedCompletionTableViewCellReuseID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
