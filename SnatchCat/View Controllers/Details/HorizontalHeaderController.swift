//
//  HorizontalImagesController.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-30.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class imageCell: UICollectionViewCell {
    
    var imageURL: URL? {
        didSet {
            imageView.sd_setImage(with: imageURL)
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "noImageAvailable"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HorizontalHeaderController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
    
    private let imageCellId = "imageCellId"
    
    var cat: CatResult? {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.register(imageCell.self, forCellWithReuseIdentifier: imageCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = cat?.photoURLs?.count {
            return count > 1 ? count : 1
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! imageCell
        if let count = cat?.photoURLs?.count, let urls = cat?.photoURLs {
            if count > 0 {
                cell.imageURL = urls[indexPath.item].full
            }
        }
        cell.backgroundColor = #colorLiteral(red: 0.9135770798, green: 0.9134877324, blue: 0.9299390912, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height)
    }
}
