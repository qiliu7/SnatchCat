//
//  SearchResultsTableCell.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-27.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class SearchResultTableCell: UITableViewCell {
    
    private let formatter = RelativeDateTimeFormatter()
    
    var cat: CatResult! {
        didSet {
            resultImageView.layer.cornerRadius = 10
            resultImageView.clipsToBounds = true
            formatter.unitsStyle = .full
            
            nameLabel.text = cat.name
            resultImageView.sd_setImage(with: cat.photoURLs?.first?.full, placeholderImage: #imageLiteral(resourceName: "noImageAvailable"))
            infoLabel.text = cat.age + " • " + cat.breeds.primary
            let publishTime = formatter.localizedString(for: cat.publishedAt, relativeTo: Date())
            publishTimeLabel.text = publishTime
        }
    }
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var publishTimeLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    // Needs to be this way if is created via Storyboard?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
