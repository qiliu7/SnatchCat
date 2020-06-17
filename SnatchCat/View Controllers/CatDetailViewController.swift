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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    //    @IBOutlet weak var scrollView: UIScrollView!
    
    private var attributes: [String]! {
        didSet { 
        }
    }
    private enum CellReuseID: String {
        case attributeCell
    }
    
    var selectedCat: CatProfile! {
        didSet {
            attributes = [
                selectedCat.cat.age,
                selectedCat.cat.size,
                selectedCat.cat.gender
            ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = selectedCat.cat.name
        
        attributeTableView.dataSource = self
        attributeTableView.delegate = self
        attributeTableView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = selectedCat.photo
        textView.text = selectedCat.cat.description
        containerView.addSubview(attributeTableView)
    }
}

extension CatDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("row num count: \(attributes.count)")
        return attributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.attributeCell.rawValue, for: indexPath)
        cell.textLabel?.text = attributes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row ==  attributes.count - 1 {
            let rowHeight = attributeTableView.rectForRow(at: indexPath).size.height
            attributeTableView.frame.size.height = rowHeight * CGFloat(attributes.count)
            containerView.frame.size = CGSize(width: view.frame.width, height: rowHeight * CGFloat(attributes.count))
            containerView.addSubview(attributeTableView)

            attributeTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            attributeTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            attributeTableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            attributeTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            
//            attributeTableView.widthAnchor.constraint(equalTo:  containerView.widthAnchor).isActive = true
//            attributeTableView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true

//            cell.layoutIfNeeded()
//            stackView.reloadInputViews()
//            stackView.layoutIfNeeded()


            print("tableView: \(attributeTableView.frame)")
            print("containerView: \(containerView.frame)")
            for subview in stackView.arrangedSubviews {
                print("\(subview.frame)")
            }
            print("tabBar: \(tabBarController?.tabBar.frame)")
            print(stackView.arrangedSubviews)
        }
    }
}
