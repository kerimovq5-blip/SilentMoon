//
//  RelatedHeaderCell.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 29.07.26.
//

import UIKit
final class RelatedHeaderCell: UICollectionReusableView {
    
    static let identifier: String = "RelatedHeaderCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.titleBold.font
        label.textColor = .buttonTitle
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel
            .top(topAnchor).0
            .leading(leadingAnchor).0
            .trailing(trailingAnchor).0
            .bottom(bottomAnchor , -10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
}
