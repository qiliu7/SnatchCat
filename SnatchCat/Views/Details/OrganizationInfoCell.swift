//
//  OrganizationInfoCell.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class OrganizationInfoCell: UICollectionViewCell {
    
    var showMapHandler: (() -> ())?
    var showEmailHandler: (() -> ())?
    var phoneHandler: (() -> ())?
    
    var orgnization: Organization? {
        didSet {
            guard let org = orgnization else { return }
            imageView.sd_setImage(with: org.organization.photos.first?.medium)
            nameLabel.text = org.organization.name
            let addr = org.organization.address
            
            mapButton.setTitle("\(addr.address1)\n\((addr.address2 != nil) ? "\(addr.address2!)\n" : "")\(addr.city), \(addr.state) \(addr.postcode)", for: .normal)
            emailButton.setTitle(org.organization.email, for: .normal)
            phoneButton.setTitle(org.organization.phone, for: .normal)
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "noImageAvailable"))
         iv.constrainWidth(constant: 70)
        iv.constrainHeight(constant: 70)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 35
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(text: "Saskatoon SPCA", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
        label.textAlignment = .center
        return label
    }()

    private let mapButton: UIButton = {
        let mb = UIButton(type: .system)
        mb.setImage(UIImage(systemName: "map"), for: .normal)
        mb.setTitle("5028 Clarence Avenue South\nSaskatoon, SK S7K 3S9", for: .normal)
        mb.titleLabel?.font = .systemFont(ofSize: 16)
        mb.titleLabel?.numberOfLines = 3
        mb.contentHorizontalAlignment = .leading
        mb.titleEdgeInsets.left = 16
        mb.setTitleColor(.black, for: .normal)
        return mb
    }()
    
    private let emailButton: UIButton = {
        let eb = UIButton(type: .system)
        eb.setImage(UIImage(systemName: "envelope"), for: .normal)
        eb.setTitle("info@saskatoonspca.com", for: .normal)
        eb.titleLabel?.font = .systemFont(ofSize: 16)
        eb.titleLabel?.numberOfLines = 1
        eb.contentHorizontalAlignment = .leading
        eb.titleEdgeInsets.left = 16
        eb.setTitleColor(.black, for: .normal)
        return eb
    }()
    
    private let phoneButton: UIButton = {
        let pb = UIButton(type: .system)
        pb.setImage(UIImage(systemName: "phone"), for: .normal)
        pb.setTitle("306-374-7387", for: .normal)
        pb.titleLabel?.font = .systemFont(ofSize: 16)
        pb.titleLabel?.numberOfLines = 1
        pb.contentHorizontalAlignment = .leading
        pb.titleEdgeInsets.left = 16
        pb.setTitleColor(.black, for: .normal)
        return pb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let infoStackView = VerticalStackView(arrangedViews: [
            imageView, nameLabel
        ], spacing: 16)
        infoStackView.alignment = .center

        let contactInfoStackView = VerticalStackView(arrangedViews: [
            mapButton,
            emailButton,
            phoneButton,
        ], spacing: 16)
        
        addSubview(infoStackView)
        infoStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        addSubview(contactInfoStackView)
        contactInfoStackView.anchor(top: infoStackView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        phoneButton.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func mapButtonTapped() {
        showMapHandler?()
    }
    
    @objc func emailButtonTapped() {
        showEmailHandler?()
    }
    
    @objc func phoneButtonTapped() {
        phoneHandler?()
    }
}
