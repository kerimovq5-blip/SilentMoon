//
//  HomeViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 10.07.26.
//

import UIKit

final class HomeViewController: UIViewController {
    
    weak var coordinator: MainTabBarCoordinator?
    var userName: String = ""
    
    private let courses = CoursesCardItem.mockData
    private let dailyThought = DailyThoughtItem.mockData
    private let recommended = RecommendedItem.mockData
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        
        let silent = NSAttributedString(
            string: "S i l e n t ",
            attributes: [.font: AppFonts.body.font]
        )
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "logo")?
            .withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -6, width: 30, height: 30)
        let logo = NSAttributedString(attachment: attachment)
        
        let moon = NSAttributedString(
            string: " M o o n",
            attributes: [.font: AppFonts.body.font]
        )
        
        let full = NSMutableAttributedString()
        full.append(silent)
        full.append(logo)
        full.append(moon)
        
        label.attributedText = full
        label.textAlignment = .center
        return label
    }()
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        let greeting = NSMutableAttributedString(
            string: "Good Morning, \(userName)\n",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.titleBold.font
            ]
        )
        greeting.append(NSAttributedString(
            string: "We wish you have a good day",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        ))
        label.attributedText = greeting
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
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
        collection.register(CoursesCardCell.self, forCellWithReuseIdentifier: CoursesCardCell.identifier)
        collection.register(DailyThoughtCell.self, forCellWithReuseIdentifier: DailyThoughtCell.identifier)
        collection.register(RecomendedCell.self, forCellWithReuseIdentifier: RecomendedCell.identifier)
        collection.register(
            SectionHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderCell.identifier
        )
        return collection
    }()
    
    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundSecondary
        view.addSubviews(
            logoLabel,
            greetingLabel,
            collectionView
        )
    }
    
    private func setupConstraints() {
        logoLabel
            .bottom(view.safeAreaLayoutGuide.topAnchor).0
            .centerX(view.centerXAnchor).0
            .height(50)
        
        greetingLabel
            .top(logoLabel.bottomAnchor, AppLayout.largeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)
        
        collectionView
            .top(greetingLabel.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch HomeModels(rawValue: sectionIndex) {
            case .courses:
                return Self.coursesSection()
            case .dailyThought:
                return Self.dailyThoughtSection()
            case .recommended:
                return Self.recommendedSection()
            case .none:
                return nil
            }
        }
    }
   
    private static func coursesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10
        )
   
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(210)
            ),
            subitems: [item]
        )
   
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: AppLayout.largeSpacing.value,
            trailing: 10
        )
        return section
    }
   
    private static func dailyThoughtSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(95)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: AppLayout.spacing.value,
            bottom: AppLayout.spacing.value,
            trailing: AppLayout.spacing.value
        )
        return section
    }
   
    private static func recommendedSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(165),
                heightDimension: .absolute(115)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(165),
                heightDimension: .absolute(115)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(AppLayout.spacing.value)
   
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = AppLayout.spacing.value
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: AppLayout.spacing.value,
            bottom: AppLayout.spacing.value,
            trailing: AppLayout.spacing.value
        )
   
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(25)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        header.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 0,
            bottom: -AppLayout.spacing.value,
            trailing: 0
        )
        section.boundarySupplementaryItems = [header]
   
        return section
    }
}

   
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HomeModels.allCases.count
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch HomeModels(rawValue: section) {
        case .courses:
            return courses.count
        case .dailyThought:
            return dailyThought.count
        case .recommended:
            return recommended.count
        case .none:
            return 0
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch HomeModels(rawValue: indexPath.section) {
        case .courses:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CoursesCardCell.identifier, for: indexPath
            ) as? CoursesCardCell else { return UICollectionViewCell() }
            cell.configure(with: courses[indexPath.item])
            return cell
   
        case .dailyThought:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DailyThoughtCell.identifier, for: indexPath
            ) as? DailyThoughtCell else { return UICollectionViewCell() }
            cell.configure(with: dailyThought[indexPath.item])
            return cell
   
        case .recommended:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecomendedCell.identifier, for: indexPath
            ) as? RecomendedCell else { return UICollectionViewCell() }
            cell.configure(with: recommended[indexPath.item])
            return cell
   
        case .none:
            return UICollectionViewCell()
        }
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
                withReuseIdentifier: SectionHeaderCell.identifier,
                for: indexPath
            ) as? SectionHeaderCell
        else { return UICollectionReusableView() }
   
        header.configure(title: "Recomended for you")
        return header
    }
}
   
  
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //  coordinator?.showDetail()
    }
}
