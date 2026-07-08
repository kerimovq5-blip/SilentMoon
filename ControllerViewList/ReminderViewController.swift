//
//  ReminderViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 08.07.26.
//

import UIKit

final class ReminderViewController: UIViewController {
    var coordinator: AuthCoordinator?
    private let weekLabels = ReminderDayItem.weeknames
    private var selectedIndexes: Set<Int> = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "What time would you like to meditate?\n",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppStyle.AppFonts.titleBold
            ]
        )
        attributed.append(NSAttributedString(
            string: "\nAny time you can choose but We recommend first thing in th morning.",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppStyle.AppFonts.body
            ]
        ))
        label.attributedText = attributed
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .textSecondary
        return datePicker
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "Which day would you like to meditate?\n",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppStyle.AppFonts.titleBold
            ]
        )
        attributed.append(NSAttributedString(
            string: "\nEveryday is best, but we recommend picking at least five.",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppStyle.AppFonts.body
            ]
        ))
        label.attributedText = attributed
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var weekCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(ReminderCell.self, forCellWithReuseIdentifier: "cell")
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndexes = Set(weekLabels.indices)
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        view.backgroundColor = .backgroundSecondary
        view.addSubviews(titleLabel, datePicker, subtitleLabel, weekCollection)
    }
    
    private func setupConstraints() {
        titleLabel
            .top(view.safeAreaLayoutGuide.topAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .width(320)
        
        datePicker
            .top(titleLabel.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(215)
        
        subtitleLabel
            .top(datePicker.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .width(320)
        
        weekCollection
            .top(subtitleLabel.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.buttonHeight.value)
    }
}

extension ReminderViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weekLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as? ReminderCell else {
            return UICollectionViewCell()
        }
        
        var item = weekLabels[indexPath.item]
        item.title = item.title.uppercased()
        item.isSelected = selectedIndexes.contains(indexPath.item)
        
        cell.configure(data: item)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minilineSpacingForSectionAt section: Int) -> CGFloat {
        AppLayout.spacing.value
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: AppLayout.spacing.value,
            bottom: 0,
            right: AppLayout.spacing.value
        )
    }
}
extension ReminderViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexes.contains(indexPath.item) {
            selectedIndexes.remove(indexPath.item)
        } else {
            selectedIndexes.insert(indexPath.item)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}


