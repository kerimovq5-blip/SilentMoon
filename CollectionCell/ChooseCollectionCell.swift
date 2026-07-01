//
//  ChooseCollectionCell.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 01.07.26.
//

import UIKit

final class ChooseCollectionCell: UICollectionViewCell {
    private lazy var topicImageView : UIImageView = {
        let pageView = UIImageView()
        pageView.contentMode = .scaleAspectFill
        pageView.clipsToBounds = true
        pageView.layer.cornerRadius = 16
        return pageView
    }()
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        contentView.addSubviews(topicImageView , titleLabel)
        
    }
    private func setupConstraints() {
        topicImageView
            .top(contentView.topAnchor).0
            .leading(contentView.leadingAnchor,  16).0
            .trailing(contentView.trailingAnchor, -16).0
            .width(160).0
            .height(220)
        titleLabel
            .top(topicImageView.bottomAnchor).0
            .leading(topicImageView.leadingAnchor)
            
            
    }
    func configure(model : ChooseTopicModel){
        topicImageView.image = model.pageController
        titleLabel.text = model.title
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
