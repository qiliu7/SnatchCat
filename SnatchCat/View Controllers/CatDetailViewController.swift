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
//    @IBOutlet weak var containerView: UIView!
    //    @IBOutlet weak var scrollView: UIScrollView!
    
    // TODO: add enum for breed? fur? etc?
    // MARK: How to group data...
    private enum CellReuseID: String {
        case attributeCell
    }
    
//    private var attributeTableView: UITableView!
    
//    private var attributesDict: [String: [String]]!

    // TODO: encapsulate this
    private var sectionNames = ["Breed", "Physical", "Health", "Behavioral"]
    var selectedCat: CatProfile! {
        didSet {
//            attributes = [
//                selectedCat.cat.age,
//                selectedCat.cat.size,
//                selectedCat.cat.gender
//            ]
            print(selectedCat.attributesDict)

//            attributesDict = selectedCat.attributesDict
//            attributes = selectedCat.attributes
//            print(selectedCat.attributes)
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
//        textView.text = selectedCat.cat.description
//        containerView.addSubview(attributeTableView)
    }
}

extension CatDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("section: \(sectionNames.count)")
        return sectionNames.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = sectionNames[section]
        print("section: \(sectionName)")
        if let count = selectedCat.attributesDict[sectionName]?.count {
            print("numOfRows: \(count)")
            return count
        } else {
            print("numOfRows: \(0)")
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.attributeCell.rawValue, for: indexPath)
        let sectionName = sectionNames[indexPath.section]
        print(selectedCat.attributesDict[sectionName]?[indexPath.row])
        cell.textLabel?.text = selectedCat.attributesDict[sectionName]?[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        let sectionName = sectionNames[indexPath.section]
////        if indexPath.section == sectionNames.count && indexPath.row ==  selectedCat.attributesDict[sectionName]?.count ?? 0 - 1 {
//        if indexPath.section == 1 && indexPath.row == 1 {
//            let rowHeight = attributeTableView.rectForRow(at: indexPath).size.height
////            print("header height: \(attributeTableView.rectForHeader(inSection: indexPath.section).size.height)")
//            attributeTableView.frame.size.height = rowHeight * CGFloat(selectedCat.attributesDict.values.count) + attributeTableView.rectForHeader(inSection: indexPath.section).size.height * CGFloat(sectionNames.count)
////            containerView.frame.size = CGSize(width: view.frame.width, height: rowHeight * CGFloat(attributesDict.count))
//            containerView.frame.size = CGSize(width: view.frame.width, height: attributeTableView.frame.size.height)
//            containerView.addSubview(attributeTableView)
//
//            attributeTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//            attributeTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//            attributeTableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//            attributeTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
//
////            attributeTableView.widthAnchor.constraint(equalTo:  containerView.widthAnchor).isActive = true
////            attributeTableView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
////            cell.layoutIfNeeded()
////            stackView.reloadInputViews()
////            stackView.layoutIfNeeded()
//
//
//            print("tableView: \(attributeTableView.frame)")
//            print("containerView: \(containerView.frame)")
//            for subview in stackView.arrangedSubviews {
//                print("\(subview.frame)")
//            }
//            print("tabBar: \(tabBarController?.tabBar.frame)")
//            print(stackView.arrangedSubviews)
//        }
//    }
}
