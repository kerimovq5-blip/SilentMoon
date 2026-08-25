//
//  CoursesCardCell.swift
//  SilentMoon
//

import UIKit

final class CoursesCardCell: UICollectionViewCell {
    var onStartTapped: (() -> Void)?
    static let identifier = "CoursesCardCell"

    private lazy var illustrationView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.titleBold.font
        label.textColor = .white
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.title.font
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        return label
    }()

    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body.font
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        return label
    }()

    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = AppFonts.litletitle.font
        button.layer.cornerRadius = AppRadius.buttonRadiusSmall.radius
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        illustrationView.image = nil
        titleLabel.text = nil
        categoryLabel.text = nil
        durationLabel.text = nil
        
    }

    private func setupHierarchy() {
        contentView.layer.cornerRadius = AppRadius.buttonRadiusMedium.radius
        contentView.clipsToBounds = true
        contentView.addSubviews(
            illustrationView,
            titleLabel,
            categoryLabel,
            durationLabel,
            startButton)
    }

    private func setupLayout() {
        illustrationView
            .top(contentView.topAnchor).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(contentView.bottomAnchor).0
            .leading(contentView.leadingAnchor)

        startButton
            .bottom(contentView.bottomAnchor, -AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.oceanButtonHeight.value).0
            .width(AppLayout.oceanButtonWidth.value)

        durationLabel
            .centerY(startButton.centerYAnchor).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value)

        titleLabel
            .top(illustrationView.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value)

        categoryLabel
            .top(titleLabel.bottomAnchor, AppLayout.cellSmallMargin.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value)
    }
    @objc private func didTapStartButton() {
        onStartTapped?()
    }

    func configure(with item: CoursesCardItem) {
        contentView.backgroundColor = item.backgroundColor
        illustrationView.image = item.image
        titleLabel.text = item.title
        categoryLabel.text = item.category
        durationLabel.text = item.duration
        startButton.backgroundColor = item.buttonBackgroundColor
        startButton.setTitleColor(item.buttonTitleColor, for: .normal)

        contentView.layer.borderWidth = item.isSelected ? 2 : 0
        contentView.layer.borderColor = UIColor.white.cgColor
    }
}
