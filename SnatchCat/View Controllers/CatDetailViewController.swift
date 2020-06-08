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
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var attributes: [String]! {
        didSet {
            print(attributes)
        }
    }
    private enum CellReuseID: String {
        case attributeCell
    }

    var selectedCat: CatProfile! {
        didSet {
            attributes = [
                "Age: \(selectedCat.cat.age)",
                "Size: \(selectedCat.cat.size)",
                "Gender: \(selectedCat.cat.gender)"
            ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        attributeTableView.dataSource = self
        attributeTableView.delegate = self
        
//        scrollView.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = selectedCat.photo
        textView.text = selectedCat.cat.description
    }
}

extension CatDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.attributeCell.rawValue, for: indexPath)
        cell.textLabel?.text = attributes[indexPath.row]
        return cell
    }
}
