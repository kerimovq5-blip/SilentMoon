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
            string: "Night Island",
            attributes: [
                .foregroundColor: AssetColors.buttonTitle.color,
                .font: AppFonts.title.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "\n\n45 MIN•SLEEP MUSIC\n",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        ))
        
        attributed.append(NSAttributedString(
            string: "\nEase the mind into a restful night’s sleep with these deep, amblent tones.",
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
    
    private lazy var favoritelabel: UILabel = {
        let label = UILabel()
        label.text = "24.234 Favorits"
        label.font = AppFonts.body.font
        label.textColor = AssetColors.buttonTitle.color
        return label
    }()
    
    private lazy var leftstackView: UIStackView = {
        let leftStack = UIStackView(arrangedSubviews: [favoriteImageView, favoritelabel])
        leftStack.axis = .horizontal
        leftStack.spacing = 10
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
        label.text = "34.234 Listening"
        label.font = AppFonts.body.font
        label.textColor = AssetColors.buttonTitle.color
        return label
    }()
    
    private lazy var rightStackView: UIStackView = {
        let rightStack = UIStackView(arrangedSubviews: [headPhonesView, headPhonesLabel])
        rightStack.axis = .horizontal
        rightStack.spacing = 10
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
            leftstackView,
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
            .height(300)
        
        descriptionLabel
            .top(playOptionView.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)
        
        leftstackView
            .top(descriptionLabel.bottomAnchor, AppLayout.xLargeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value)
        
        rightStackView
            .top(descriptionLabel.bottomAnchor, AppLayout.xLargeSpacing.value).0
            .leading(leftstackView.trailingAnchor, AppLayout.largeSpacing.value)
        
        tabSeparatorLine
            .top(rightStackView.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .height(1)
            
        collectionView
            .top(tabSeparatorLine.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            ComposinalLayoutBuilder.horizontalCarousel(
                itemSize: CGSize(width: 165, height: 170),
                hasHeader: true
            )
        }
    }
    
    private func openMusicPage(for item: CourseSessionItem) {
        coordinator?.showMusicPage(item: item.title)
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
   
        header.configure(title: "Related")
        return header
    }
}
