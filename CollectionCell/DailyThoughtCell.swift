//
//  DailyThoughtCell.swift
//  SilentMoon
//

import UIKit

final class DailyThoughtCell: UICollectionViewCell {

    static let identifier = "DailyThoughtCell"
    
private lazy var imageView: UIImageView = {
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

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body.font
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.tintColor = .textPrimary
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.isUserInteractionEnabled = false
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
        titleLabel.text = nil
        descriptionLabel.text = nil
    }

    private func setupHierarchy() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .colorIndigo
        contentView.addSubviews(
            imageView ,
            titleLabel,
            descriptionLabel,
            playButton)
    }

    private func setupLayout() {
        imageView
            .top(contentView.topAnchor).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(contentView.bottomAnchor).0
            .leading(contentView.leadingAnchor)
        
        
        playButton
            .centerY(imageView.centerYAnchor).0
            .trailing(imageView.trailingAnchor, -AppLayout.spacing.value).0
            .width(40).0
            .height(40)

        titleLabel
            .leading(imageView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(playButton.leadingAnchor, -AppLayout.spacing.value).0
            .centerY(imageView.centerYAnchor, -10)

        descriptionLabel
            .top(titleLabel.bottomAnchor, 2).0
            .leading(imageView.leadingAnchor, AppLayout.spacing.value)
    }

    func configure(with item: DailyThoughtItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
}
