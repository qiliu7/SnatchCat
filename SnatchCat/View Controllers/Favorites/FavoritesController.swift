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
    private let ROW_HEIGHT = 150
    
//    // injected thru SceneDelegate
//    var dataController: DataController!
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: resultCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.rowHeight = CGFloat(ROW_HEIGHT)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favorites.catList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCell, for: indexPath) as! SearchResultCell
        cell.cat = Favorites.catList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = CatDetailController(cat: Favorites.catList[indexPath.row])
        // inject dataController dependency
        detailController.dataController = self.dataController
        navigationController?.pushViewController(detailController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
