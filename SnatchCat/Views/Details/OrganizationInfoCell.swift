//
//  OrganizationInfoCell.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class OrganizationInfoCell: UICollectionViewCell {
    
    var orgnization: Organization? {
        didSet {
            guard let org = orgnization else { return }
            imageView.sd_setImage(with: org.organization.photos.first?.full)
            nameLabel.text = org.organization.name
            let addr = org.organization.address
            addressLabel.text = "\(addr.address1)\n\((addr.address2 != nil) ? "\(addr.address2!)\n" : "")\(addr.city), \(addr.state) \(addr.postcode)"
            emailLabel.text = org.organization.email
            phoneLabel.text = org.organization.phone
        }
    }
    
    private let mapIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "map"))
        iv.constrainWidth(constant: 20)
        iv.constrainHeight(constant: 20)
        return iv
    }()
    private let emailIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "envelope"))
        iv.constrainWidth(constant: 20)
        iv.constrainHeight(constant: 20)
        return iv
    }()
    private let phoneIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "phone"))
        iv.constrainWidth(constant: 20)
        iv.constrainHeight(constant: 20)
        return iv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "noImageAvailable"))
        iv.constrainWidth(constant: 50)
        iv.constrainHeight(constant: 50)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    let nameLabel: UILabel = {
        let label = UILabel(text: "Saskatoon SPCA", font: .boldSystemFont(ofSize: 20), numberOfLines: 2)
        label.textAlignment = .center
        return label
    }()
    let addressLabel: UILabel = {
        let label = UILabel(text: "5028 Clarence Avenue South\nSaskatoon\n,SK S7K 3S9", font: .systemFont(ofSize: 16), numberOfLines: 3)
        return label
    }()
    let emailLabel: UILabel = {
        let label = UILabel(text: "info@saskatoonspca.com", font: .systemFont(ofSize: 16), numberOfLines: 1)
        return label
    }()
    let phoneLabel: UILabel = {
        let label = UILabel(text: "306-374-7387", font: .systemFont(ofSize: 16), numberOfLines: 1)
        return label
    }()
    let seeDetailButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("SEE FULL SHELTER DETAILS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.constrainHeight(constant: 32)
        button.constrainWidth(constant: 350)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let addrStackView = UIStackView(arrangedSubviews: [
            mapIconView, addressLabel
        ], spacing: 16)
        let emailStackView = UIStackView(arrangedSubviews: [
            emailIconView, emailLabel
        ], spacing: 16)
        let phoneStackView = UIStackView(arrangedSubviews: [
            phoneIconView, phoneLabel
        ], spacing: 16)
        
        let contactInfoStackView = VerticalStackView(arrangedViews: [
            addrStackView,
            emailStackView,
            phoneStackView,
            UIStackView(arrangedSubviews: [
            UIView(), seeDetailButton, UIView()
            ])
        ], spacing: 16)
        addrStackView.alignment = .leading

        let infoStackView = VerticalStackView(arrangedViews: [
            imageView, nameLabel
        ], spacing: 8)
        infoStackView.alignment = .center
        
        addSubview(infoStackView)
        infoStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        addSubview(contactInfoStackView)
        contactInfoStackView.anchor(top: infoStackView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
