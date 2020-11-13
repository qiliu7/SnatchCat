//
//  DescriptionCell.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class DescriptionCell: UICollectionViewCell, UITextViewDelegate {
    
    var cat: CatResult? {
        didSet {
            guard let cat = cat else { return }
            imageView.sd_setImage(with: cat.photoURLs?.first?.medium)
            titleLabel.text = "Meet \(cat.name)"
            if let description = cat.description?.html2AttributedString?.string {
                setDescriptionTextView(of: cat.name, with:
                description, at: cat.url)
            }
        }
    }
    private func setDescriptionTextView(of name: String, with description: String, at url: URL) {
        
        let prompt = " [Read more]"
        let description = description + prompt
        let attributedString = NSMutableAttributedString(string: description)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(0..<description.count))
        attributedString.addAttribute(.link, value: url, range: NSRange(description.count - prompt.count..<description.count))
        let style = NSMutableParagraphStyle()
        attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(0..<description.count))
        descriptionTextView.attributedText = attributedString
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
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "Meet Toffee", font: .boldSystemFont(ofSize: 24))
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        // Essential
        tv.isScrollEnabled = false
        
        let description = "[Read more]"
        let attributedString = NSMutableAttributedString(string: description)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(0..<description.count))
        attributedString.addAttribute(.link, value: "https://www.petfinder.com", range: NSRange(description.count - 11..<description.count))
        let style = NSMutableParagraphStyle()
        attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(0..<description.count))
        tv.attributedText = attributedString
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = VerticalStackView(arrangedViews: [
            UIStackView(arrangedSubviews: [
                UIView(), imageView, UIView()
            ]),
            titleLabel, descriptionTextView
//            , askAboutButton
        ], spacing: 16)
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


