//
//  SleepyStoryCell.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 28.07.26.
//

import UIKit

final class SleepyStoryCell: UICollectionViewCell {
    static let identifier = String(describing: SleepyStoryCell.self)

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = AppRadius.buttonRadiusSmall.radius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .colorIndigo
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semiBold.font
        label.textColor = AssetColors.buttonTitle.color
        return label
    }()

    private lazy var durationItem: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regularBody.font
        label.textColor = AssetColors.textSecondary.color
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
        durationItem.text = nil
    }

    private func setup() {
        contentView.addSubviews(
            imageView,
            titleLabel,
            durationItem
        )
    }

    private func setConstraint() {
        imageView
            .top(contentView.topAnchor).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor).0
            .height(AppLayout.storyCellImageHeight.value)

        titleLabel
            .top(imageView.bottomAnchor, AppLayout.cellTitleTopSpacing.value).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor, -AppLayout.mediumSpacing.value)

        durationItem
            .top(titleLabel.bottomAnchor, AppLayout.cellSubtitleTopSpacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.cellSmallMargin.value).0
            .trailing(contentView.trailingAnchor).0
            .bottom(contentView.bottomAnchor, -AppLayout.cellSubtitleTopSpacing.value)
    }

    func configure(with item: SleepyStoryModels) {
        imageView.image = item.image
        titleLabel.text = item.title
        durationItem.text = item.durationItem
    }
}
