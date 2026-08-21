//
//  ComposinalLayoutBuilder.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 11.08.26.
//
import UIKit

enum ComposinalLayoutBuilder {

    static func twoColumnMasonry(
        itemCount: Int,
        spacing: CGFloat = AppLayout.spacing.value,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        itemHeight: (Int) -> CGFloat
    ) -> NSCollectionLayoutSection {

        var leftItems: [NSCollectionLayoutItem] = []
        var rightItems: [NSCollectionLayoutItem] = []
        var leftHeight: CGFloat = 0
        var rightHeight: CGFloat = 0

        for index in 0..<itemCount {
            let height = itemHeight(index)
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(height)
                )
            )

            if index % 2 == 0 {
                leftItems.append(item)
                leftHeight += height + (leftItems.count > 1 ? spacing : 0)
            } else {
                rightItems.append(item)
                rightHeight += height + (rightItems.count > 1 ? spacing : 0)
            }
        }

        let leftColumn = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(leftHeight)
            ),
            subitems: leftItems
        )
        leftColumn.interItemSpacing = .fixed(spacing)

        let rightColumn = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(rightHeight)
            ),
            subitems: rightItems
        )
        rightColumn.interItemSpacing = .fixed(spacing)

        let columnsGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(max(leftHeight, rightHeight))
            ),
            subitems: [leftColumn, rightColumn]
        )
        columnsGroup.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: columnsGroup)
        section.contentInsets = contentInsets ?? NSDirectionalEdgeInsets(
            top: 0,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        return section
    }

   
    static func horizontalCarousel(
        itemSize: CGSize,
        interItemSpacing: CGFloat = AppLayout.spacing.value,
        interGroupSpacing: CGFloat = AppLayout.spacing.value,
        contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: AppLayout.spacing.value,
            bottom: 0,
            trailing: AppLayout.spacing.value
        ),
        hasHeader: Bool = false
    ) -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(itemSize.width),
                heightDimension: .absolute(itemSize.height)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = contentInsets

        if hasHeader {
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(30)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            header.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 0,
                bottom: AppLayout.spacing.value,
                trailing: 0
            )
            section.boundarySupplementaryItems = [header]
        }

        return section
    }
}
