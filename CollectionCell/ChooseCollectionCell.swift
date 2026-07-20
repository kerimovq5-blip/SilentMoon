//
//  ChooseCollectionCell.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.06.26.

import UIKit

final class ChooseCollectionCell: UICollectionViewCell {
    
    
    private lazy var topicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .colorIndigo
        imageView.isUserInteractionEnabled = true
        
        
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()

    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupView() {
        contentView.backgroundColor = .backgroundSecondary
        contentView.addSubviews(topicImageView, titleLabel)
    }

    private func setupConstraints() {
        
        topicImageView
            .top(contentView.topAnchor).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor).0
            .bottom(contentView.bottomAnchor)

        
        titleLabel
            .leading(topicImageView.leadingAnchor, 12).0
            .trailing(topicImageView.trailingAnchor, -12).0
            .bottom(topicImageView.bottomAnchor, -12)
    }

    

    func configure(model: ChooseTopicModel) {
            topicImageView.image = model.image.image
     titleLabel.text = model.title
    }
    
    func configure(data: MeditateCollectionModels) {
          topicImageView.image = data.image
          topicImageView.backgroundColor = data.viewColor ?? .colorIndigo
          titleLabel.text = data.title
      }
}
