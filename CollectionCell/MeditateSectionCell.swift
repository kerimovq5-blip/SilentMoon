//
//  MeditateSectionCell.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 19.07.26.
//

import UIKit

protocol MeditateSectionData {
    var image : UIImage? { get }
    var title: String { get }
    var isSelected: Bool { get }
    var viewColor: UIColor? { get }
}

final class MeditateSectionCell: UICollectionViewCell {
    
    static let identifier = "MeditateSectionCell"

    private lazy var sectionImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        return view
    }()
    
    private lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body.font
        label.textAlignment = .center
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
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubviews(
            sectionImage,
            sectionLabel
        )
    }

    private func setupConstraints() {
        sectionImage
          .top(contentView.topAnchor).0
          .centerX(contentView.centerXAnchor).0
          .height(65).0
         .width(65)

        sectionLabel
            .top(sectionImage.bottomAnchor, 10).0
            .leading(contentView.leadingAnchor, 2).0
            .trailing(contentView.trailingAnchor, -2)
    }

    func configure(data: MeditateSectionData) {
        sectionLabel.text = data.title
        sectionImage.image = data.image

        if data.isSelected {
            sectionImage.backgroundColor = AssetColors.colorIndigo.color
            sectionImage.tintColor = .white
            
            sectionLabel.textColor = AssetColors.textPrimary.color
        } else {
            sectionImage.backgroundColor = AssetColors.sectionColor.color
            sectionImage.tintColor = AssetColors.textSecondary.color
            
            sectionLabel.textColor = AssetColors.textSecondary.color
        }
    }
}
