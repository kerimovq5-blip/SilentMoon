//
//  MusicListViewCell.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 31.07.26.
//

import UIKit

final class MusicListViewCell: UITableViewCell {
    static let identifier: String = "MusicListViewCell"

    internal  lazy var imageview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = AppFonts.AppRaduis.buttonRadius
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

    private lazy var durationItem: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .textSecondary
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setup()
        setConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageview.image = nil
        titleLabel.text = nil
        durationItem.text = nil
    }

    private func setup() {
        contentView.addSubviews(
            imageview,
            titleLabel,
            durationItem
        )
    }

    private func setConstraint() {

        imageview
            .top(contentView.topAnchor, AppLayout.smallSpacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .height(60).0
            .width(60)

        titleLabel
            .centerY(imageview.centerYAnchor , -10).0
            .leading(imageview.trailingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value)

        durationItem
            .top(titleLabel.bottomAnchor ).0
            .leading(imageview.trailingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(contentView.bottomAnchor)
    }

    func configure(with item: SleepyStoryModels) {
        imageview.image = item.image
        titleLabel.text = item.title
        durationItem.text = item.durationItem
    }
}
