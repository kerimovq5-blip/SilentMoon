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
                .font: AppStyle.AppFonts.title
            ]
        )
        attributed.append(NSAttributedString(
            string: "\nto Silent Moon?",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppStyle.AppFonts.titleregular
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
        label.font = AppStyle.AppFonts.body
        label.textColor = AssetColors.textSecondary.color
        label.textAlignment = .left
        return label
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        controller.addGestureRecognizer(tapGesture)
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
                .top(
                    view.safeAreaLayoutGuide.topAnchor, 10).0
                .leading(view.leadingAnchor, AppLayout.spacing.value).0
                .trailing(view.trailingAnchor, -AppLayout.spacing.value)

            subtitleLabel
                .top(titleLabel.bottomAnchor, AppLayout.spacing.value).0
                .leading(view.leadingAnchor, AppLayout.spacing.value).0
                .trailing(view.trailingAnchor, -AppLayout.spacing.value)
                
        unionview
            .top(subtitleLabel.bottomAnchor , AppLayout.spacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor)

            collectionView
                .top(subtitleLabel.bottomAnchor, AppLayout.largeSpacing.value).0
                .leading(view.leadingAnchor).0
                .trailing(view.trailingAnchor).0
                .bottom(view.safeAreaLayoutGuide.bottomAnchor)
        }
    @objc private func didTapImage() {
        coordinator?.showReminder()
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


extension ChooseTopicViewController: UICollectionViewDelegateFlowLayout {

   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
       let itemWidth = ((collectionView.bounds.width - AppLayout.spacing.value * 2) - AppLayout.spacing.value) / 2
       let isLongCard = (indexPath.item % 4 == 0) || (indexPath.item % 4 == 3)
    let itemHeight = isLongCard ? AppLayout.leftCardHeight : AppLayout.rightCardHeight
       return CGSizeMake( itemWidth, itemHeight.value)
   }

   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       AppLayout.spacing.value
   }

  

   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       insetForSectionAt section: Int) -> UIEdgeInsets {
       UIEdgeInsets(
           top: 0,
           left: AppLayout.spacing.value,
           bottom: 0,
           right: AppLayout.spacing.value
       )
   }
}
