//
//  RecomendedHeader.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 10.07.26.
//

import UIKit
final class SectionHeaderCell: UICollectionReusableView {
    
    static let identifier: String = "SectionHeaderCell"
    
    private lazy var titleLabel: UILabel = {
            let label = UILabel()
        label.font = AppFonts.titleBold.font
            label.textColor = .textPrimary
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
