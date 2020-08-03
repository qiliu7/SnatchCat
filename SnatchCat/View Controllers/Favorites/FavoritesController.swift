//
//  Saved.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-29.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class FavoritesController: UITableViewController {
    
    private let resultCell = "searchResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: resultCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favorites.catList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCell, for: indexPath)
        cell.backgroundColor = .yellow
        return cell
    }
}
