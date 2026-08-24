//
//  RecomendedCell.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 10.07.26.
//

import UIKit

final class RecomendedCell: UICollectionViewCell {
    static let identifier: String = "RecomendedCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = AppRadius.buttonRadiusLarge.radius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .colorIndigo
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semiBold.font
        label.textColor = .textPrimary
        return label
    }()

    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .textSecondary
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        durationLabel.text = nil
    }

    private func setup() {
        
        contentView.addSubviews(
            imageView,
            titleLabel,
            durationLabel
        )
    }

    private func setConstraint() {
        imageView
                .top(contentView.topAnchor).0
                .leading(contentView.leadingAnchor).0
                .trailing(contentView.trailingAnchor).0
                .height(120)

            titleLabel
                .top(imageView.bottomAnchor, 10).0
                .leading(contentView.leadingAnchor).0
                .trailing(contentView.trailingAnchor, -12)

            durationLabel
            .top(titleLabel.bottomAnchor, 4).0
            .leading(contentView.leadingAnchor, 2).0
            .trailing(contentView.trailingAnchor, -2).0
            .bottom(contentView.bottomAnchor, -4)
    }

    func configure(with item: RecommendedItem) {
        imageView.image = item.image
        titleLabel.text = item.title
        durationLabel.text = item.description
    }
}
