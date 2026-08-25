//
//  CoursesDetailViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 16.07.26.
//

import UIKit
final class CoursesDetailViewController: UIViewController {
    var coordinator : ContentNavigating?
    private enum VoiceTab : Int , CaseIterable {
        case male , female
        var title: String {
            switch self {
            case .male:
                return "Male Voice"
            case .female:
                return "Female Voice"
            }
        }
    }
    
    private var selectedVoice: VoiceTab = .male
    private var tabButtons: [UIButton] = []
    private var tabLineleading: NSLayoutConstraint?
    
    private let sessions = CourseSessionItem.mockData

    private lazy var sunShineView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "sunShine")
        
        return view
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "Happy Morning ",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.title.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "\n\nCOURSE \n",
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
    
    private lazy var favoriteImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart.fill")
        view.tintColor = .red
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var favoritelabel : UILabel = {
        let label = UILabel()
        label.text = AppStrings.favoritesCount.letters
        label.font = AppFonts.body.font
        label.textColor = AssetColors.textSecondary.color
        return label
    }()
    private lazy var leftstackView : UIStackView = {
        let leftStack = UIStackView(arrangedSubviews: [favoriteImageView,favoritelabel])
        leftStack.axis = .horizontal
        leftStack.spacing = AppLayout.stackSpacing.value
        leftStack.alignment = .center
        return leftStack
    }()
    private lazy var headPhonesView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "headPhones")
        
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var headPhonesLabel : UILabel = {
        let label = UILabel()
        label.text = AppStrings.listeningCount.letters
        label.font = AppFonts.body.font
        label.textColor = AssetColors.textSecondary.color
        return label
    }()
    private lazy var rightStackView : UIStackView = {
        let rightStack = UIStackView(arrangedSubviews: [headPhonesView,headPhonesLabel])
        rightStack.axis = .horizontal
        rightStack.spacing = AppLayout.stackSpacing.value
        rightStack.alignment = .center
        return rightStack
    }()
    
    private lazy var narratorlabel : UILabel = {
        let label = UILabel()
        label.text = " Pick a Narrator"
        label.font = AppFonts.titleBold.font
        label.textColor = AssetColors.textPrimary.color
        return label
    }()
    
    private lazy var tabStackView: UIStackView = {
          let stack = UIStackView()
          stack.axis = .horizontal
          stack.distribution = .fillEqually
          return stack
      }()
   
      private lazy var tabUnderlineView: UIView = {
          let view = UIView()
          view.backgroundColor = .colorIndigo
          return view
      }()
   
      private lazy var tabSeparatorLine: UIView = {
          let view = UIView()
          view.backgroundColor = UIColor.textSecondary.withAlphaComponent(0.2)
          return view
      }()
   
      private lazy var scrollView: UIScrollView = {
          let scroll = UIScrollView()
          scroll.showsVerticalScrollIndicator = false
          return scroll
      }()
   
      private lazy var itemsStackView: UIStackView = {
          let stack = UIStackView()
          stack.axis = .vertical
          stack.spacing = 0
          return stack
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupTabs()
        populateSessions()
    }

    private func setupTabs() {
           VoiceTab.allCases.forEach { tab in
               let button = UIButton(type: .system)
               button.setTitle(tab.title, for: .normal)
               button.titleLabel?.font = AppFonts.titleBold.font
               button.tag = tab.rawValue
               button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
               tabButtons.append(button)
               tabStackView.addArrangedSubview(button)
           }
           updateTabAppearance()
       }
    
    
    private func setupHierarchy() {
        view.backgroundColor = .white
        view.addSubviews(
            sunShineView ,
            descriptionLabel,
            leftstackView,
            rightStackView,
            narratorlabel,
            tabStackView,
            tabSeparatorLine,
            scrollView
            
        )
        tabSeparatorLine.addSubview(tabUnderlineView)
        scrollView.addSubview(itemsStackView)
    }
    
    private func setupLayout() {
        sunShineView
            .top(view.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .height(300)
        
        descriptionLabel
            .top(sunShineView.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)
        
        leftstackView
            .top(descriptionLabel.bottomAnchor, AppLayout.xLargeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value)
        
        rightStackView
            .top(descriptionLabel.bottomAnchor, AppLayout.xLargeSpacing.value).0
            .leading(leftstackView.trailingAnchor, AppLayout.largeSpacing.value)
            
        narratorlabel
            .top(leftstackView.bottomAnchor, AppLayout.xLargeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value)

        tabStackView
            .top(narratorlabel.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(30)

        tabSeparatorLine
            .top(tabStackView.bottomAnchor, AppLayout.smallSpacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .height(1)

//        let (_, underlineLeading) = tabUnderlineView
//            .leading(tabStackView.leadingAnchor)
//        tabLineleading = underlineLeading
//        tabUnderlineView
//            .top(tabSeparatorLine.topAnchor).0
//            .height(2).0
//            .width(tabStackView.widthAnchor)

        scrollView
            .top(tabSeparatorLine.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.safeAreaLayoutGuide.bottomAnchor)

        itemsStackView
            .top(scrollView.topAnchor).0
            .leading(scrollView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(scrollView.trailingAnchor, -AppLayout.spacing.value).0
            .bottom(scrollView.bottomAnchor)
    }

    private func populateSessions() {
        itemsStackView.arrangedSubviews.forEach {
            itemsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        for (index, session) in sessions.enumerated() {
            let isLast = index == sessions.count - 1
            itemsStackView.addArrangedSubview(makeSessionRow(session, showsDivider: !isLast))
        }
    }

    private func makeSessionRow(_ item: CourseSessionItem, showsDivider: Bool) -> UIView {
        let container = UIView()

        let playButton = UIButton(type: .system)
        playButton.layer.cornerRadius = 25
        playButton
            .addAction(
                UIAction { [weak self] _ in self?.openMusicPage(for: item)
                },
                for: .touchUpInside)

        if item.isHighlighted {
            playButton.backgroundColor = .colorIndigo
        } else {
            playButton.backgroundColor = .clear
            playButton.layer.borderWidth = 1
            playButton.layer.borderColor = UIColor.textSecondary.withAlphaComponent(0.3).cgColor
        }

        let playIcon = UIImageView(image: UIImage(systemName: "play.fill"))
        playIcon.tintColor = item.isHighlighted ? .white : UIColor.textSecondary.withAlphaComponent(0.6)
        playIcon.contentMode = .scaleAspectFit
        playIcon.isUserInteractionEnabled = false

        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = AppFonts.body.font
        titleLabel.textColor = AssetColors.textPrimary.color

        let durationLabel = UILabel()
        durationLabel.text = item.duration
        durationLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        durationLabel.textColor = AssetColors.textSecondary.color

        container.addSubviews(playButton, playIcon, titleLabel, durationLabel)

        playButton
            .top(container.topAnchor, AppLayout.spacing.value).0
            .leading(container.leadingAnchor).0
            .bottom(container.bottomAnchor, -AppLayout.spacing.value).0
            .width(50).0
            .height(50)

        playIcon
            .centerX(playButton.centerXAnchor, 2).0
            .centerY(playButton.centerYAnchor).0
            .width(16).0
            .height(16)

        titleLabel
            .top(playButton.topAnchor, 2).0
            .leading(playButton.trailingAnchor, AppLayout.spacing.value).0
            .trailing(container.trailingAnchor)

        durationLabel
            .top(titleLabel.bottomAnchor, 4).0
            .leading(playButton.trailingAnchor, AppLayout.spacing.value).0
            .trailing(container.trailingAnchor)

        if showsDivider {
            let divider = UIView()
            divider.backgroundColor = UIColor.textSecondary.withAlphaComponent(0.15)
            container.addSubview(divider)
            divider
                .leading(container.leadingAnchor).0
                .trailing(container.trailingAnchor).0
                .bottom(container.bottomAnchor).0
                .height(1)
        }

        return container
    }

    private func openMusicPage(for item: CourseSessionItem) {
           coordinator?.showMusicPage(item: item.title)
       }

    @objc private func tabTapped(_ sender: UIButton) {
        guard let tab = VoiceTab(rawValue: sender.tag) else { return }
        selectedVoice = tab
        updateTabAppearance()

        tabLineleading?.isActive = false
        let newLeading = tabUnderlineView
            .leading( sender.leadingAnchor).1
        
        tabLineleading = newLeading

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    private func updateTabAppearance() {
        tabButtons.forEach { button in
            let isSelected = button.tag == selectedVoice.rawValue
            button.setTitleColor(isSelected ? .colorIndigo : AssetColors.textSecondary.color, for: .normal)
        }
    }
}
