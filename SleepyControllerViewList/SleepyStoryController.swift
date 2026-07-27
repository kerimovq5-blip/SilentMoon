//
//  SleepyStoryController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 19.07.26.
//

import UIKit

final class SleepyStoryController: UIViewController {
    
    var coordinator : ContentNavigating?
    
    private let sectionViews = MeditateSectionModels.dummyData
    private let collectionViews = SleepyStoryModels.storyData
    
    private var selectedIndexes: Set<Int> = []
    
    private lazy var sleepyStoryLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "Sleep Stories\n",
            attributes: [
                .foregroundColor: AssetColors.buttonTitle.color,
                .font: AppFonts.title.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "\nSoothing bedtime stories to help you fall\ninto a deep and natural sleep",
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
    
    private lazy var sectionCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MeditateSectionCell.self, forCellWithReuseIdentifier: MeditateSectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var theOceanMoon : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        // view.image = UIImage(named: "daily-calm")
        view.clipsToBounds = true
        view.layer.cornerRadius = AppFonts.AppRaduis.buttonRadiusSmall
        view.backgroundColor = .colorIndigo
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(oceanMoonTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var theOceanTitle: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "The Ocean Moon\n",
            attributes: [
                .foregroundColor: AssetColors.buttonTitle.color,
                .font: AppFonts.title.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "Non-stop 8- hour mixes of our\nmost popular sleep audio",
            attributes: [
                .foregroundColor: AssetColors.buttonTitle.color,
                .font: AppFonts.litletitle.font
            ]
        ))
        label.attributedText = attributed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var oceanStartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = AppFonts.litletitle.font
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = AppFonts.AppRaduis.buttonRadiusLarge
        button.frame.size.height = 35
        button.frame.size.width = 70
        button.addAction(UIAction { [weak self] _ in
            self?.openOceanMoonStory()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [theOceanTitle, oceanStartButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = AppLayout.spacing.value
        stack.distribution = .fill
        return stack
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let controller = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        controller.backgroundColor = .clear
        controller.showsVerticalScrollIndicator = false
        controller.dataSource = self
        controller.delegate = self
        controller.register(
            SleepyStoryCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    @objc private func oceanMoonTapped() {
        openOceanMoonStory()
    }
    
    private func openOceanMoonStory() {
        coordinator?.showMusicPage(item: "The Ocean Moon")
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubviews(
            sleepyStoryLabel ,
            sectionCollectionView ,
            theOceanMoon ,
            collectionView)
        
        theOceanMoon.addSubviews(mainStackView)
        
    }
    
    private func setupConstraints() {
        sleepyStoryLabel
            .bottom(view.safeAreaLayoutGuide.topAnchor ,AppLayout.xLargeSpacing.value).0
            .centerX(view.centerXAnchor)
        
        sectionCollectionView
            .top(sleepyStoryLabel.bottomAnchor , AppLayout.spacing.value).0
            .leading(view.leadingAnchor , AppLayout.spacing.value).0
            .trailing(view.trailingAnchor).0
            .height(100)
        
        theOceanMoon
            .top(sectionCollectionView.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(235)
        
        mainStackView
            .top(theOceanMoon.topAnchor, AppLayout.spacing.value).0
            .leading(theOceanMoon.leadingAnchor, AppLayout.spacing.value).0
            .trailing(theOceanMoon.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(theOceanMoon.bottomAnchor, -AppLayout.spacing.value)
        
        collectionView
            .top(theOceanMoon.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(view.bottomAnchor, -AppLayout.spacing.value)
    }
}

extension SleepyStoryController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == sectionCollectionView {
                if selectedIndexes.contains(indexPath.item) { return }

                let previouslySelected = selectedIndexes
                selectedIndexes = [indexPath.item]
                let indexPathsToReload = previouslySelected.union(selectedIndexes).map {
                    IndexPath(item: $0, section: 0)
                }
                collectionView.reloadItems(at: indexPathsToReload)
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
                let story = collectionViews[indexPath.item]
                coordinator?.showMusicPage(item: story.title)
            }
        }
    }

    extension SleepyStoryController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == sectionCollectionView {
                return sectionViews.count
            } else {
                return collectionViews.count
            }
        }
                
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == sectionCollectionView {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MeditateSectionCell.identifier,
                    for: indexPath
                ) as? MeditateSectionCell
                else {
                    return UICollectionViewCell()
                }
                var model = sectionViews[indexPath.item]
                
                model.isSelected = selectedIndexes.contains(indexPath.item)
                
                cell.configure(data: model)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                ) as? SleepyStoryCell
                else {
                    return UICollectionViewCell()
                }
                let model = collectionViews[indexPath.item]
                cell.configure(with: model)
                return cell
            }
        }
    }
    

    extension SleepyStoryController: UICollectionViewDelegateFlowLayout {
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            if collectionView == sectionCollectionView {
                let collectionViewWidth = collectionView.bounds.width
                let sectionWidth = collectionViewWidth * 0.16
                let sectionHeight: CGFloat = 100
                return CGSizeMake(sectionWidth, sectionHeight)
            } else {
                let spacing = AppLayout.spacing.value
                let itemWidth = (collectionView.bounds.width - spacing) / 2
                let itemHeight: CGFloat = 170
                return CGSize(width: itemWidth, height: itemHeight)
            }
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
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt section: Int
        ) -> UIEdgeInsets {
            if collectionView == sectionCollectionView {
                return UIEdgeInsets(
                    top: 0,
                    left: 10,
                    bottom: 0,
                    right: AppLayout.spacing.value
                )
            } else {
                // collectionView already has AppLayout.spacing.value leading/trailing
                // from its own Auto Layout constraints — adding it again here
                // would double the margin, so this stays at 0.
                return .zero
            }
        }
    }
