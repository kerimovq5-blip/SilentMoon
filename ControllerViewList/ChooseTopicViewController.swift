import UIKit

final class ChooseTopicViewController: UIViewController {

    weak var coordinator: AuthCoordinator?
    private var all = ChooseTopicModel.topics

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
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppStyle.AppFonts.body
            ]
        ))
        label.attributedText = attributed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a topic to focus on:"
        label.font = AppStyle.AppFonts.body
        label.textColor = AssetColors.textSecondary.color
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var collectionview : UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .clear
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(ChooseCollectionCell.self, forCellWithReuseIdentifier: " cell")
        return collectionview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }


    private func setupHierarchy() {
        view.backgroundColor = AssetColors.background.color
        view.addSubviews(
            titleLabel,
            subtitleLabel,
            collectionview
        )
    }

    private func setupLayout() {
        titleLabel
                  .top(view.safeAreaLayoutGuide.topAnchor, ChooseTopicLayout.titleTopSpacing).0
                  .leading(view.leadingAnchor, ChooseTopicLayout.horizontalInset).0
                  .trailing(view.trailingAnchor, -ChooseTopicLayout.horizontalInset).0
                  .height(ChooseTopicLayout.titleHeight)
       
              subtitleLabel
                  .top(titleLabel.bottomAnchor, ChooseTopicLayout.subtitleTopSpacing).0
                  .leading(view.leadingAnchor, ChooseTopicLayout.horizontalInset).0
                  .trailing(view.trailingAnchor, -ChooseTopicLayout.horizontalInset).0
                  .height(ChooseTopicLayout.subtitleHeight)
       
              collectionview
                  .top(subtitleLabel.bottomAnchor, ChooseTopicLayout.topicGridTopSpacing).0
                  .leading(view.leadingAnchor).0
                  .trailing(view.trailingAnchor).0
                  .bottom(view.safeAreaLayoutGuide.bottomAnchor)
    }
}
extension ChooseTopicViewController : UICollectionViewDelegate {
        
}
extension ChooseTopicViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        all.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
            for: indexPath) as? ChooseCollectionCell else {
            return UICollectionViewCell()
            
        }
        cell.configure(model: all[indexPath.row])
        return cell

    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
    }
func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets( top: 0,
                             left: ChooseTopicLayout.horizontalInset,
                             bottom: 0,
                             right: ChooseTopicLayout.horizontalInset)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let imageWidth : CGFloat = (collectionView.frame.width - 32) / 2
        let imageHeight : CGFloat = imageWidth * 0.7
        return CGSizeMake( imageWidth,  imageHeight)
    }
    
}
