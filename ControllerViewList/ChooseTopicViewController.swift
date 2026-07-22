import UIKit

final class ChooseTopicViewController: UIViewController {
    private let topicItemHeight: CGFloat = 260
    
    var coordinator: AuthCoordinator?
    private let topics = ChooseTopicModel.all
    
    
    private lazy var unionview :UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Union")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "What Brings you",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.title.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "\nto Silent Moon?",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.titleRegular.font
            ]
        ))
        label.attributedText = attributed
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a topic to focus on:"
        label.font = AppFonts.body.font
        label.textColor = AssetColors.textSecondary.color
        label.textAlignment = .left
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let controller = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeMasonryLayout()
        )
        controller.backgroundColor = .clear
        controller.showsVerticalScrollIndicator = false
        controller.dataSource = self
        controller.delegate = self
        controller.register(
            ChooseCollectionCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        return controller
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    
    
    private func setupHierarchy() {
        view.backgroundColor = .backgroundSecondary
        view.addSubviews(
            titleLabel,
            subtitleLabel,
            unionview ,
            collectionView
        )
    }
    
    private func setupLayout() {
        
        titleLabel
            .top(view.safeAreaLayoutGuide.topAnchor, 10).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)
        
        subtitleLabel
            .top(titleLabel.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)
        
        unionview
            .top(titleLabel.bottomAnchor ).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor)
        
        collectionView
            .top(subtitleLabel.bottomAnchor, AppLayout.largeSpacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.safeAreaLayoutGuide.bottomAnchor)
        
    }

    
    private func isBigCard(at index: Int) -> Bool {
        (index % 4 == 0) || (index % 4 == 3)
    }

    private func itemHeight(at index: Int) -> CGFloat {
        isBigCard(at: index) ? AppLayout.leftCardHeight.value : AppLayout.rightCardHeight.value
    }

    
    private func makeMasonryLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.makeTopicsSection()
        }
    }

    private func makeTopicsSection() -> NSCollectionLayoutSection {
        let spacing = AppLayout.spacing.value
        let itemCount = topics.count

        var leftItems: [NSCollectionLayoutItem] = []
        var rightItems: [NSCollectionLayoutItem] = []
        var leftHeight: CGFloat = 0
        var rightHeight: CGFloat = 0

        for index in 0..<itemCount {
            let height = itemHeight(at: index)
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
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        return section
    }
}

extension ChooseTopicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as? ChooseCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(model: topics[indexPath.item])
        return cell
    }
}

extension ChooseTopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showReminder()
    }
}
