//
//  ReminderWeekCell.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 08.07.26.
//

import UIKit

protocol ReminderCellData {
    var title: String { get }
    var isSelected: Bool { get }
}

final class ReminderCell: UICollectionViewCell {

    

    private lazy var weekLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 21
        label.layer.borderWidth = 1.5
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
        contentView.addSubview(weekLabel)
    }

    private func setupConstraints() {
        weekLabel
            .centerY(contentView.centerYAnchor).0
            .centerX(contentView.centerXAnchor).0
            .width(42).0
            .height(42)
    }

    func configure(data: ReminderCellData) {
        weekLabel.text = data.title
        apply(selected: data.isSelected)
    }

    private func apply(selected: Bool) {
        if selected {
            weekLabel.backgroundColor = .black
            weekLabel.layer.borderColor = UIColor.clear.cgColor
            weekLabel.textColor = .buttonTitle
        } else {
            weekLabel.backgroundColor = .clear
            weekLabel.layer.borderColor = UIColor.textSecondary.withAlphaComponent(0.4).cgColor
            weekLabel.textColor = .textSecondary.withAlphaComponent(0.6)
        }
    }
}
