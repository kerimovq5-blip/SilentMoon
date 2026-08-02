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
    
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var sleepmodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named : "sleepymode")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
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
        collectionView.isScrollEnabled = false
        collectionView.register(MeditateSectionCell.self, forCellWithReuseIdentifier: MeditateSectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var theOceanMoon : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = AppFonts.AppRaduis.buttonRadiusSmall
        view.backgroundColor = .colorIndigo
        view.isUserInteractionEnabled = true
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
        button.layer.cornerRadius = AppFonts.AppRaduis.buttonRadiusSmall
        button.backgroundColor = .white
        button.tintColor = .black
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
        stack.distribution = .equalSpacing
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
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           tabBarController?.tabBar.isHidden = false
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    
    @objc  private func openOceanMoonStory() {
        coordinator?.playOptionPage()
    }
    
    private func setupView() {
        view.backgroundColor = AssetColors.sleepModeColor.color
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
            
    contentView.addSubviews(
                sleepmodeImage,
                sleepyStoryLabel,
                sectionCollectionView,
                theOceanMoon,
                collectionView
            )
        
        theOceanMoon.addSubviews(mainStackView)
        
    }
    
    private func setupConstraints() {
        scrollView
            .top(view.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)
            
        contentView
            .top(scrollView.topAnchor).0
            .leading(scrollView.leadingAnchor).0
            .trailing(scrollView.trailingAnchor).0
            .bottom(scrollView.bottomAnchor).0
            .width(scrollView.widthAnchor)
        sleepmodeImage
            .top(view.topAnchor).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor)
        
        sleepyStoryLabel
            .bottom(contentView.safeAreaLayoutGuide.topAnchor ,AppLayout.xLargeSpacing.value).0
            .centerX(contentView.centerXAnchor)
        
        sectionCollectionView
            .top(sleepyStoryLabel.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor).0
            .trailing(contentView.trailingAnchor).0
            .height(100)
            
        oceanStartButton
            .height(35).0
            .width(70)
            
        theOceanMoon
            .top(sectionCollectionView.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(235)
        
        mainStackView
            .top(theOceanMoon.topAnchor, AppLayout.spacing.value).0
            .leading(theOceanMoon.leadingAnchor, AppLayout.spacing.value).0
            .trailing(theOceanMoon.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(theOceanMoon.bottomAnchor, -AppLayout.spacing.value)
        
        collectionView
            .top(theOceanMoon.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(contentView.bottomAnchor, -AppLayout.spacing.value)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        if height > 0 {
            collectionView.height(height)
        }
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
                coordinator?.showMusicPage2(item: story.title)
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
                return .zero
            }
        }
    }
