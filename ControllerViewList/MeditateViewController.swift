//
//  MeditateViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 19.07.26.
//

import UIKit

final class MeditateViewController: UIViewController {
    
    private let sectionViews = MeditateSectionModels.dummyData
    private let collectionViews = MeditateCollectionModels.meditateData
    
    private var selectedIndexes: Set<Int> = []
    
    private lazy var meditateLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "Meditate\n",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.title.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "\nwe can learn how to recognize when our minds\n are doing their normal everyday acrobatics.",
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
    
    private lazy var dailyCalmView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
       // view.image = UIImage(named: "daily-calm")
        view.clipsToBounds = true
        view.layer.cornerRadius = AppFonts.AppRaduis.buttonRadiusSmall
        view.backgroundColor = .colorIndigo
        return view
    }()
    
    private lazy var dailyTitle: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "Daily Calm\n",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.semiBold.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "APR 30 • PAUSE PRACTICE.",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.litletitle.font
            ]
        ))
        label.attributedText = attributed
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dailyPlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.tintColor = .dailycolor
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [dailyTitle, dailyPlayButton])
            stack.axis = .horizontal
            stack.alignment = .center
        
            stack.distribution = .equalSpacing
            return stack
        }()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let controller = UICollectionView(frame: .zero, collectionViewLayout: layout)
        controller.backgroundColor = .clear
        controller.showsVerticalScrollIndicator = false
        controller.dataSource = self
        controller.delegate = self
        controller.register(
            ChooseCollectionCell.self,
            forCellWithReuseIdentifier: "cell"
        )
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
//        controller.addGestureRecognizer(tapGesture)
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubviews(
            meditateLabel ,
            sectionCollectionView ,
            dailyCalmView ,
            collectionView)
        
        dailyCalmView.addSubviews(mainStackView)
                         
    }
    
    private func setupConstraints() {
        meditateLabel
            .bottom(view.safeAreaLayoutGuide.topAnchor ,AppLayout.xLargeSpacing.value).0
            .centerX(view.centerXAnchor)
        
        sectionCollectionView
            .top(meditateLabel.bottomAnchor , AppLayout.spacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .height(100)
        
        dailyCalmView
            .top(sectionCollectionView.bottomAnchor, AppLayout.spacing.value).0
                .leading(view.leadingAnchor, AppLayout.spacing.value).0
                .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
                .height(95)
        
        dailyPlayButton
            .height(40).0
            .width(40)
                    
        mainStackView
            .top(dailyCalmView.topAnchor, AppLayout.spacing.value).0
            .leading(dailyCalmView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(dailyCalmView.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(dailyCalmView.bottomAnchor, -AppLayout.spacing.value)
        
        collectionView
            .top(dailyCalmView.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(view.bottomAnchor, -AppLayout.spacing.value)
    }
}

extension MeditateViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == sectionCollectionView else { return }

        if selectedIndexes.contains(indexPath.item) { return }
        
        let previouslySelected = selectedIndexes
       selectedIndexes = [indexPath.item]
      let indexPathsToReload = previouslySelected.union(selectedIndexes).map {
          IndexPath(item: $0, section: 0)
      }
        collectionView.reloadItems(at: indexPathsToReload)
    }
}
extension MeditateViewController: UICollectionViewDataSource {
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
            ) as? ChooseCollectionCell
            else {
                return UICollectionViewCell()
            }
            let model = collectionViews[indexPath.item]
            cell.configure(data: model)
            return cell
        }
    }
}

extension MeditateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == sectionCollectionView {
            let collectionViewWidth = collectionView.bounds.width
            let sectionWidth = collectionViewWidth * 0.20
            let sectionHeight : CGFloat = 100

            return CGSizeMake( sectionWidth, sectionHeight)
        } else {
            let spacing = AppLayout.spacing.value
            let itemWidth = (collectionView.bounds.width - spacing) / 2
            let itemHeight: CGFloat = 210

            return CGSizeMake(itemWidth, itemHeight)
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
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if collectionView == sectionCollectionView {
            return UIEdgeInsets(
                top: 0,
                left: 10 ,
                bottom: 0,
                right: AppLayout.spacing.value
            )
        } else {
            return UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: AppLayout.spacing.value,
                right: 0
            )
        }
    }
}
