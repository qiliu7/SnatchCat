//
//  DetailViewController.swift
//  SnatchCat
//
//  Created by Kappa on 2020-06-05.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class CatDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var attributeTableView: UITableView!
//    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    //    @IBOutlet weak var scrollView: UIScrollView!
    
    // TODO: add enum for breed? fur? etc?
    // MARK: How to group data...
    private enum CellReuseID: String {
        case attributeCell
    }

    // TODO: encapsulate this
    private var sectionNames = [String]()
    var selectedCat: CatProfile! {
        didSet {
            print(selectedCat.attributesDict)
            sectionNames = Array(selectedCat.attributesDict.keys)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        attributeTableView.dataSource = self
        attributeTableView.delegate = self
//        attributeTableView.isScrollEnabled = false
        attributeTableView.estimatedRowHeight = 44
        attributeTableView.estimatedSectionHeaderHeight = 28
        attributeTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = selectedCat.photo
        nameLabel.text = selectedCat.cat.name
    }
}

extension CatDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = selectedCat.attributesDict[sectionNames[section]]!.count
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.attributeCell.rawValue, for: indexPath)
        let sectionName = sectionNames[indexPath.section]
        cell.textLabel?.text = selectedCat.attributesDict[sectionName]?[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName = sectionNames[section]
        if let count = selectedCat.attributesDict[sectionName]?.count {
            return count == 0 ? nil : sectionName
        }
        return nil
    }
}
