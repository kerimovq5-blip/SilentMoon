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
        didSet { musicTableView.reloadData() }
    }

    private let allItems = SleepyStoryModels.storyData

    private var filteredItems: [SleepyStoryModels] {
        switch selectedSegment {
        case .allSounds,
             .allMusic,
             .favorite,
             .download:
            return allItems
        }
    }

    private lazy var broccoliview: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Union")?
            .withRenderingMode(.alwaysTemplate)
        imageView.tintColor = AssetColors.colorIndigo.color
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    private lazy var headerContainerView: UIView = {
        let view = UIView()
        return view
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

    private lazy var musicTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = AssetColors.backgroundSecondary.color
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = true
        table.dataSource = self
        table.delegate = self
        table.register(MusicListViewCell.self, forCellReuseIdentifier: MusicListViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupLayout()
        setupTableHeaderView()
    }

    private func setupHierarchy() {
        view.addSubviews(broccoliview, musicTableView)
        
        headerContainerView.addSubviews(soundLabel, segmentControl)
    }

    private func setupLayout() {
        broccoliview
            .top(view.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)

        musicTableView
            .top(view.safeAreaLayoutGuide.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)
    }

    private func setupTableHeaderView() {
        soundLabel
            .top(headerContainerView.topAnchor, AppLayout.spacing.value).0
            .leading(headerContainerView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(headerContainerView.trailingAnchor, -AppLayout.spacing.value)

        segmentControl
            .top(soundLabel.bottomAnchor, AppLayout.spacing.value).0
            .leading(headerContainerView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(headerContainerView.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(headerContainerView.bottomAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.secondaryButtonHeight.value)

        headerContainerView.setNeedsLayout()
        headerContainerView.layoutIfNeeded()
        let targetSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = headerContainerView.systemLayoutSizeFitting(targetSize).height
        headerContainerView.frame.size.height = height

        musicTableView.tableHeaderView = headerContainerView
    }

    @objc private func segmentChanged() {
        guard let segment = MusicSegment(rawValue: segmentControl.selectedSegmentIndex) else { return }
        selectedSegment = segment
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MusicListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MusicListViewCell.identifier,
            for: indexPath
        ) as? MusicListViewCell else {
            return UITableViewCell()
        }
        let item = filteredItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

extension MusicListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard indexPath.row < filteredItems.count else { return }
        let story = filteredItems[indexPath.row]

        coordinator?.showMusicPage(item: story.title)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
