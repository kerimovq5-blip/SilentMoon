//
//  MeditateCollectionCell.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 12.08.26.
//



import UIKit

final class MeditateCollectionCell: UICollectionViewCell {
    
       
    private lazy var topicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = AppFonts.AppRaduis.buttonRadiusSmall
        imageView.backgroundColor = .colorIndigo
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var selectionBorderView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = AppFonts.AppRaduis.buttonRadiusSmall
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    }()
    
    private lazy var checkmarkIcon: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(systemName: "checkmark.circle.fill")
        )
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    
    override var isSelected: Bool {
        didSet {
            updateSelectionAppearance()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isSelected = false
        topicImageView.image = nil
        titleLabel.text = nil
        topicImageView.backgroundColor = .colorIndigo
    }
    
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
        
        contentView.addSubviews(
            topicImageView,
            titleLabel,
            selectionBorderView,
            checkmarkIcon
        )
    }
    
    private func setupConstraints() {
        
        topicImageView
            .top(contentView.topAnchor).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor).0
            .bottom(contentView.bottomAnchor)
        
        selectionBorderView
            .top(topicImageView.topAnchor).0
            .leading(topicImageView.leadingAnchor).0
            .trailing(topicImageView.trailingAnchor).0
            .bottom(topicImageView.bottomAnchor)
        
        checkmarkIcon
            .top(topicImageView.topAnchor, 8).0
            .trailing(topicImageView.trailingAnchor, -8).0
            .height(22).0
            .width(22)
        
        titleLabel
            .leading(topicImageView.leadingAnchor, 12).0
            .trailing(topicImageView.trailingAnchor, -12).0
            .bottom(topicImageView.bottomAnchor, -12)
    }
    
    private func updateSelectionAppearance() {
        selectionBorderView.layer.borderColor = isSelected
            ? AssetColors.accent.color.cgColor
            : UIColor.clear.cgColor
        
        checkmarkIcon.isHidden = !isSelected
    }
        
    func configure(data: MeditateCollectionModels) {
          topicImageView.image = data.image
          topicImageView.backgroundColor = data.viewColor ?? .colorIndigo
          titleLabel.text = data.title
      
        
        updateSelectionAppearance()
    }
}
    
