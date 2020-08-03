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
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
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
    
//    init(cat: CatResult) {
//        self.cat = cat
//        super.init()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(imageCell.self, forCellWithReuseIdentifier: imageCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cat?.photoURLs?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! imageCell
        let photoURLs = cat?.photoURLs
        cell.imageURL = photoURLs?[indexPath.item].full
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height)
    }
}
