//
//  CatDetailView.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import SDWebImage

class CatDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    private let headerCellId = "headerCellId"
    private let nameCellId = "nameCellId"
    private let descriptionCellId = "descr"
    private let organizationCellId = "org"
    
    private var cat: CatResult
    private var organization: Organization? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private enum CellType: Int, CaseIterable {
        case profileImage
        case name
        //        case attributes
        case description
        case organization
    }
    
    init(cat: CatResult) {
        self.cat = cat
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTranslucentNavBar()
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 130, right: 0)
        
        collectionView.backgroundColor = .white
        collectionView.register(ImageHeaderCell.self, forCellWithReuseIdentifier: headerCellId)
        collectionView.register(NameCell.self, forCellWithReuseIdentifier: nameCellId)
        collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
        collectionView.register(OrganizationInfoCell.self, forCellWithReuseIdentifier: organizationCellId)
        
        fetchOrganizationInfo()
    }
    
    private func fetchOrganizationInfo() {
        PetfinderAPI.shared.fetchOrganizationInfo(id: cat.organizationId ?? "") { (organization, err) in
            if err != nil {
                print("Failed to retrieve organization info \(String(describing: err))")
                return
            }
            guard let organization = organization else { return }
            self.organization = organization
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CellType.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = CellType(rawValue: indexPath.item)
        
        switch cellType {
        case .profileImage:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellId, for: indexPath) as! ImageHeaderCell
            cell.cat = cat
            return cell
        case .name:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nameCellId, for: indexPath) as! NameCell
            cell.cat = cat
            return cell
        case .description:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! DescriptionCell
            cell.cat = cat
            return cell
        case .organization:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: organizationCellId, for: indexPath) as! OrganizationInfoCell
            cell.orgnization = organization
            return cell
        case .none:
            return UICollectionViewCell()
        }
        
    }
    
    // MARK: REVISION NEEDED?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellType = CellType(rawValue: indexPath.item)
        var height: CGFloat
        switch cellType {
        case .profileImage:
            height = 400
        case .name:
            let dummyCell = NameCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
            dummyCell.cat = cat
            dummyCell.layoutIfNeeded()
            let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 1000))
            height = estimatedSize.height
            
        case .description:
            let dummyCell = DescriptionCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
            dummyCell.cat = cat
            dummyCell.layoutIfNeeded()
            let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 1000))
            height = estimatedSize.height
        case .organization:
            let dummyCell = OrganizationInfoCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
            dummyCell.orgnization = organization
            dummyCell.layoutIfNeeded()
            let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 1000))
            height = estimatedSize.height
        case .none:
            height = 0
            
        }
        return .init(width: view.frame.width, height: height)
    }
    
    private func setTranslucentNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}
