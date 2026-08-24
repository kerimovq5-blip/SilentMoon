//
//  PlayOptionViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 29.07.26.
//

import UIKit

final class PlayOptionViewController: UIViewController {
    var coordinator: ContentNavigating?
    
    private let relatedData = RelatedCollectionModel.relatedData
    
    private lazy var playOptionView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "playOption")
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: AppStrings.nightIslandTitle.letters,
            attributes: [
                .foregroundColor: AssetColors.buttonTitle.color,
                .font: AppFonts.title.font
            ]
        )
        attributed.append(NSAttributedString(
            string: AppStrings.nightIslandSubtitle.letters,
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        ))
        
        attributed.append(NSAttributedString(
            string: AppStrings.nightIslandDescription.letters,
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        ))
        label.attributedText = attributed
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var favoriteImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart.fill")
        view.tintColor = .red
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = AppStrings.favoritesCount.letters
        label.font = AppFonts.body.font
        label.textColor = AssetColors.buttonTitle.color
        return label
    }()
    
    private lazy var leftStackView: UIStackView = {
        let leftStack = UIStackView(arrangedSubviews: [favoriteImageView, favoriteLabel])
        leftStack.axis = .horizontal
        leftStack.spacing = AppLayout.stackSpacing.value
        leftStack.alignment = .center
        return leftStack
    }()
    
    private lazy var headPhonesView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "headPhones")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var headPhonesLabel: UILabel = {
        let label = UILabel()
        label.text = AppStrings.listeningCount.letters
        label.font = AppFonts.body.font
        label.textColor = AssetColors.buttonTitle.color
        return label
    }()
    
    private lazy var rightStackView: UIStackView = {
        let rightStack = UIStackView(arrangedSubviews: [headPhonesView, headPhonesLabel])
        rightStack.axis = .horizontal
        rightStack.spacing = AppLayout.stackSpacing.value
        rightStack.alignment = .center
        return rightStack
    }()
    
    private lazy var tabSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = AssetColors.textSecondary.color
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeLayout()
        )
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(
            RelatedCollectionCell.self,
            forCellWithReuseIdentifier: RelatedCollectionCell.identifier
        )
        collection.register(
            RelatedHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: RelatedHeaderCell.identifier
        )
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.backgroundColor = AssetColors.sleepModeColor.color
        view.addSubviews(
            playOptionView,
            descriptionLabel,
            leftStackView,
            rightStackView,
            tabSeparatorLine,
            collectionView
        )
    }
    
    private func setupLayout() {
        playOptionView
            .top(view.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .height(AppLayout.playOptionHeaderHeight.value)
        
        descriptionLabel
            .top(playOptionView.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)
        
        leftStackView
            .top(descriptionLabel.bottomAnchor, AppLayout.xLargeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value)
        
        rightStackView
            .top(descriptionLabel.bottomAnchor, AppLayout.xLargeSpacing.value).0
            .leading(leftStackView.trailingAnchor, AppLayout.largeSpacing.value)
        
        tabSeparatorLine
            .top(rightStackView.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .height(AppLayout.separatorHeight.value)
            
        collectionView
            .top(tabSeparatorLine.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            ComposinalLayoutBuilder.horizontalCarousel(
                itemSize: CGSize(
                    width: AppLayout.relatedCardWidth.value,
                    height: AppLayout.rightCardHeight.value
                ),
                hasHeader: true
            )
        }
    }
}

extension PlayOptionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RelatedCollectionCell.identifier,
            for: indexPath
        ) as? RelatedCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: relatedData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = relatedData[indexPath.item]
        coordinator?.showMusicPage(item: item.title)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RelatedHeaderCell.identifier,
                for: indexPath
            ) as? RelatedHeaderCell
        else { return UICollectionReusableView() }
   
        header.configure(title: AppStrings.relatedTitle.letters)
        return header
    }
}
