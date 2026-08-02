//
//  MusicListViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 31.07.26.
//

import UIKit

final class MusicListViewController: UIViewController {

    var coordinator: ContentNavigating?

    private enum MusicSegment: Int, CaseIterable {
        case allSounds
        case allMusic
        case favorite
        case download
    }

    private var selectedSegment: MusicSegment = .allSounds {
        didSet { musicCollectionView.reloadData() }
    }

    private let allItems = SleepyStoryModels.storyData
//    private var searchText: String = "" {
//        didSet { musicCollectionView.reloadData() }
//    }

    
    private var filteredItems: [SleepyStoryModels] {
        let bySegment: [SleepyStoryModels]
        switch selectedSegment {
        case .allSounds, .allMusic, .favorite, .download:
            bySegment = allItems
        }

//        guard !searchText.isEmpty else { return bySegment }
//        return bySegment.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        return bySegment
    }

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.keyboardDismissMode = .onDrag
        return scroll
    }()

    private lazy var contentView: UIView = UIView()

    
    private lazy var broccoliview :UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Union")?
            .withRenderingMode(.alwaysTemplate)
        imageView.tintColor = AssetColors.iceBlueColor.color
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    private lazy var soundLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "Meditate Music \n",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.title.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "\n What Kind Of Sound Do You Want To Hear?",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        ))
        label.attributedText = attributed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var searchIconView: UIImageView = {
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = AssetColors.sectionColor.color
        iconView.contentMode = .scaleAspectFit
        return iconView
    }()
//
//    private lazy var searchTextField: UITextField = {
//        let textfield = UITextField()
//        textfield.layer.cornerRadius = 12
//        textfield.layer.masksToBounds = true
//        textfield.layer.borderColor = AssetColors.textSecondary.color.cgColor
//        textfield.layer.borderWidth = 2
//        textfield.backgroundColor = .clear
//        textfield.textColor = AssetColors.textPrimary.color
//        textfield.attributedPlaceholder = NSAttributedString(
//            string: "Search",
//            attributes: [.foregroundColor: AssetColors.textSecondary.color]
//        )
//        textfield.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
//
//        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
//        searchIconView.frame = CGRect(x: 12, y: 0, width: 20, height: 20)
//        iconContainer.addSubview(searchIconView)
//        textfield.leftView = iconContainer
//        textfield.leftViewMode = .always
//
//        return textfield
//    }()

    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            "All Sounds", "All Music", "Favorites", "Downloads"
        ])
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes(
            [.foregroundColor: AssetColors.textPrimary.color],
            for: .normal
        )
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()

    private lazy var musicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let controller = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        controller.backgroundColor = .clear
        controller.isScrollEnabled = false
        controller.showsVerticalScrollIndicator = false
        controller.dataSource = self
        controller.delegate = self
        controller.register(
            MusicListViewCell.self,
            forCellWithReuseIdentifier: MusicListViewCell.identifier
        )
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupLayout()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        musicCollectionView.layoutIfNeeded()
        let height = musicCollectionView.collectionViewLayout.collectionViewContentSize.height
        if height > 0 {
            musicCollectionView.height(height)
        }
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            broccoliview,
            soundLabel,
         //   searchTextField,
            segmentControl,
            musicCollectionView
        )
    }

    private func setupLayout() {
        scrollView
            .top(view.safeAreaLayoutGuide.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)

        contentView
            .top(scrollView.topAnchor).0
            .leading(scrollView.leadingAnchor).0
            .trailing(scrollView.trailingAnchor).0
            .bottom(scrollView.bottomAnchor).0
            .width(scrollView.widthAnchor)

        soundLabel
            .top(contentView.topAnchor).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value)
        broccoliview
            .top(soundLabel.bottomAnchor ).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor)

//        searchTextField
//            .top(soundLabel.bottomAnchor, AppLayout.largeSpacing.value).0
//            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
//            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
//            .height(AppLayout.buttonHeight2.value)

        segmentControl
            .top(soundLabel.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(40)

        musicCollectionView
            .top(segmentControl.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(contentView.bottomAnchor, -AppLayout.spacing.value)
    }

    @objc private func segmentChanged() {
        guard let segment = MusicSegment(rawValue: segmentControl.selectedSegmentIndex) else { return }
        selectedSegment = segment
    }

//    @objc private func searchTextChanged() {
//        searchText = searchTextField.text ?? ""
//    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MusicListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            
            guard indexPath.item < filteredItems.count else {
                print("❌ Index xətası: \(indexPath.item) filteredItems aralığında deyil.")
                return
            }
            
            let story = filteredItems[indexPath.item]
            print("🎵 Seçilən element: \(story.title)")
            
            guard let coordinator = coordinator else {
                print("❌ Coordinator nil-dir! MusicListViewController yaradılan yerdə coordinator mənimsədilməyib.")
                return
            }
            
            coordinator.showMusicPage(item: story.title)
        }
    }

extension MusicListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MusicListViewCell.identifier,
            for: indexPath
        ) as? MusicListViewCell else {
            return UICollectionViewCell()
        }
        let item = filteredItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}

extension MusicListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spacing = AppLayout.spacing.value
        let itemWidth = (collectionView.bounds.width - spacing) / 2
        let itemHeight: CGFloat = 170
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        AppLayout.spacing.value
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        AppLayout.spacing.value
    }
}
