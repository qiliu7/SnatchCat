//
//  CatDetailView.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class CatDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    private let headerCellId = "headerCellId"
    private let nameCellId = "nameCellId"
    private let attributesCellId = "attributesCellId"
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
        case attributes
        case description
        case organization
    }
    
    var dataController: DataController!
    
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
        collectionView.register(AttributesCell.self, forCellWithReuseIdentifier: attributesCellId)
        collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
        collectionView.register(OrganizationInfoCell.self, forCellWithReuseIdentifier: organizationCellId)
        
        fetchOrganizationInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.popViewController(animated: false)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // When scroll above the bottom of profileImage
        // TODO: Add distinguish of speed?
        if collectionView.contentOffset.y >= 400 {
            setOpaqueNavBar()
        } else {
            setTranslucentNavBar()
        }
    }
    
    private func fetchOrganizationInfo() {
        PetfinderAPI.shared.fetchOrganizationInfo(id: cat.organizationId ?? "") { (result) in
            
            switch result {
            case .success(let organization):
                self.organization = organization
            case .failure(let err):
                print("Failed to retrieve organization info \(String(describing: err))")
            }
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
            cell.saveToFavHandler = {
                if !Favorites.catList.contains(self.cat) {
                    Favorites.catList.insert(self.cat, at: 0)
                    
                    let cat = Cat(context: self.dataController.viewContext)
                    cat.id = Int32(self.cat.id)
                    cat.age = self.cat.age
                    let encoder = JSONEncoder()
                    cat.attributes = try? encoder.encode(self.cat.attributes)
                    cat.breeds = try? encoder.encode(self.cat.breeds)
                    cat.coat = self.cat.coat
                    cat.gender = self.cat.gender
                    cat.name = self.cat.name
                    cat.organizationId = self.cat.organizationId
                    cat.photoURLs = try? encoder.encode(self.cat.photoURLs)
                    cat.publishedAt = self.cat.publishedAt
                    cat.simpleDescription = self.cat.description
                    cat.size = self.cat.size
                    cat.url = self.cat.url.absoluteString
                    cat.colors = try? encoder.encode(self.cat.colors)
                    cat.environment = try? encoder.encode(self.cat.environment)
                    
                    do {
                        try self.dataController.viewContext.save()
                    } catch {
                        self.showAlert(title: "Error", message: "Failed to save to Favorites")
                    }
                } else {
                    let index = Favorites.catList.firstIndex(of: self.cat)
                    Favorites.catList.remove(at: index!)
                    
                    if let catToDelete = self.fetchCat() {
                        self.dataController.viewContext.delete(catToDelete)
                        do {
                            // FIXME: fetch object to be deleted first
                            try self.dataController.viewContext.save()
                        } catch {
                            self.showAlert(title: "Error", message: "Failed to remove from Favorites")
                        }
                    }
                }
            }
            return cell
        case .name:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nameCellId, for: indexPath) as! NameCell
            cell.cat = cat
            return cell
        case .attributes:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: attributesCellId, for: indexPath) as! AttributesCell
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
        case .attributes:
            let dummyCell = AttributesCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
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
    
    private func setOpaqueNavBar() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // 不复用了先 啧
//    private func encode(attribute: Encodable) -> Data? {
//
//        let encoder = JSONEncoder()
//        if let data = try? encoder.encode(attribute) {
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print(jsonString)
//            }
//        }
//    }
    private func fetchCat() -> Cat? {
        let fetchRequest : NSFetchRequest<Cat> = Cat.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "addDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let cat = try? dataController.viewContext.fetch(fetchRequest)
        return cat?.first
    }
}
