import UIKit

final class ChooseTopicViewController: UIViewController {
    private let topicItemHeight: CGFloat = 260
    
    var coordinator: AuthCoordinator?
    private let viewModel: ChooseTopicViewModel
    private let topics = ChooseTopicModel.all
    private var selectedTopicIds: Set<String> = []
    
    init(viewModel: ChooseTopicViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        controller.allowsMultipleSelection = true
        controller.dataSource = self
        controller.delegate = self
        controller.register(
            ChooseCollectionCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        return controller
    }()
    private lazy var continueButton = AppBuilders.continueButton()

//    private lazy var continueButton: AppButton = {
//        let button = AppButton(
//            title: "CONTINUE",
//            backgroundColor: .accent,
//            titleColor: .buttonTitle
//        )
//        button.onTap = { [weak self] in self?.continueTapped() }
//        return button
//    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        bindViewModel()
        updateContinueButton()
        continueButton.onTap = { [weak self] in self?.continueTapped() }
           }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            self?.render()
        }
    }

    private func render() {
        switch viewModel.state {
        case .idle:
            setLoading(false)
        case .loading:
            setLoading(true)
        case .success:
            setLoading(false)
            coordinator?.showReminder()
        case .invalidInput(let message):
            setLoading(false)
            showAlert(message: message)
        case .requestFailed(let appError):
            setLoading(false)
            showAlert(message: appError.errorDescription ?? "Naməlum xəta baş verdi.")
        }
    }

    private func setLoading(_ isLoading: Bool) {
        continueButton.isUserInteractionEnabled = !isLoading
        continueButton.alpha = isLoading ? 0.6 : 1.0
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }

    private func updateContinueButton() {
        let count = selectedTopicIds.count
        continueButton.setTitle(count > 0 ? "CONTINUE (\(count))" : "CONTINUE")
        continueButton.setIsEnabled(count > 0)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func continueTapped() {
        viewModel.choose(topicIds: Array(selectedTopicIds))
    }
    
    private func setupHierarchy() {
        view.backgroundColor = .backgroundSecondary
        view.addSubviews(
            titleLabel,
            subtitleLabel,
            unionview ,
            collectionView,
            continueButton,
            loadingIndicator
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
            .bottom(continueButton.topAnchor, -AppLayout.spacing.value)

        continueButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, AppLayout.bottomInset.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        loadingIndicator
            .centerX(continueButton.centerXAnchor).0
            .centerY(continueButton.centerYAnchor)
        
    }
    
    private func isBigCard(at index: Int) -> Bool {
        (index % 4 == 0) || (index % 4 == 3)
    }

    private func itemHeight(at index: Int) -> CGFloat {
        isBigCard(at: index) ? AppLayout.leftCardHeight.value : AppLayout.rightCardHeight.value
    }
    
    private func makeMasonryLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self else { return nil }
            return ComposinalLayoutBuilder.twoColumnMasonry(
                itemCount: self.topics.count,
                itemHeight: { self.itemHeight(at: $0) }
            )
        }
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
        selectedTopicIds.insert(topics[indexPath.item].id)
        updateContinueButton()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedTopicIds.remove(topics[indexPath.item].id)
        updateContinueButton()
    }
}
