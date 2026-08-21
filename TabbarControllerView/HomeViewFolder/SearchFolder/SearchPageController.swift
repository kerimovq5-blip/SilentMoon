//
//  SearchPageController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 02.08.26.
//

import UIKit
import SilentMoonDomain
final class SearchPageController: UIViewController {
    var coordinator: ContentNavigating?

    private let viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.layer.cornerRadius = 12
        textfield.layer.masksToBounds = true
        textfield.backgroundColor = AssetColors.lightGray.color
        textfield.textColor = .black
        textfield.tintColor = AssetColors.textSecondary.color
        textfield.attributedPlaceholder = NSAttributedString(
            string: "Search in Meditate",

            attributes: [.foregroundColor: AssetColors.textSecondary.color]
        )

        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textfield.leftView = leftPadding
        textfield.leftViewMode = .always

        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = AssetColors.textSecondary.color
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 8, y: 10, width: 20, height: 20)

        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightContainer.addSubview(iconView)
        textfield.rightView = rightContainer
        textfield.rightViewMode = .always
        textfield.addAction(UIAction(handler: { [weak self] _ in
            self?.searchDidChange()
        }), for: .editingChanged)
        return textfield
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.keyboardDismissMode = .onDrag
        table.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
        return table
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var silentMoonFrame: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SilentMoonFrame")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()


    private lazy var emptyStateIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass.circle"))
        imageView.tintColor = AssetColors.buttonTitle.color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var emptyStateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.title.font
        label.textColor = AssetColors.buttonTitle.color
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var emptyStateSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body.font
        label.textColor = AssetColors.textSecondary.color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Find your movie by title, category, year, etc."
        return label
    }()

    private lazy var emptyStateStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            emptyStateIcon,
            emptyStateTitleLabel,
            emptyStateSubtitleLabel
        ])
        stack.axis = .vertical
        stack.spacing = AppLayout.smallSpacing.value
        stack.alignment = .center
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupLayout()
        bindViewModel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            guard let self else { return }
            self.updateUI(for: self.viewModel.state)
        }
        viewModel.onResultsChange = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func setupHierarchy() {
        view.addSubviews(
            searchTextField,
            tableView,
            loadingIndicator,
            silentMoonFrame,
            emptyStateStack
        )
    }

    private func setupLayout() {
        searchTextField
            .top(view.safeAreaLayoutGuide.topAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.buttonHeight2.value)

        tableView
            .top(searchTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)

        loadingIndicator
            .top(tableView.topAnchor, AppLayout.largeSpacing.value).0
            .centerX(view.centerXAnchor)

        silentMoonFrame
            .top(searchTextField.bottomAnchor, AppLayout.largeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.xLargeSpacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.xLargeSpacing.value).0
            .height(140)

        emptyStateIcon
            .height(44).0
            .width(44)

        emptyStateStack
            .top(silentMoonFrame.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)
    }

    private func searchDidChange() {
        viewModel.search(query: searchTextField.text ?? "")
    }

    private func updateUI(for state: SearchViewModelState) {
        switch state {
        case .idle:
            loadingIndicator.stopAnimating()
            emptyStateStack.isHidden = true
            silentMoonFrame.isHidden = true
            tableView.isHidden = false
        case .loading:
            loadingIndicator.startAnimating()
            emptyStateStack.isHidden = true
            silentMoonFrame.isHidden = true
            tableView.isHidden = true
        case .loaded:
            loadingIndicator.stopAnimating()
            emptyStateStack.isHidden = true
            silentMoonFrame.isHidden = true
            tableView.isHidden = false
        case .empty:
            loadingIndicator.stopAnimating()
            emptyStateTitleLabel.text = "we are sorry, we can't find the search :("
            emptyStateSubtitleLabel.text = "Find your movie by title, category, year, etc."
            emptyStateStack.isHidden = false
            silentMoonFrame.isHidden = false
            tableView.isHidden = true
        case .requestFailed(let appError):
            loadingIndicator.stopAnimating()
            emptyStateTitleLabel.text = "Something went wrong"
            emptyStateSubtitleLabel.text = appError.errorDescription ?? "Naməlum xəta baş verdi."
            emptyStateStack.isHidden = false
            silentMoonFrame.isHidden = true
            tableView.isHidden = true
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchPageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        let item = viewModel.results[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.subtitle.isEmpty ? item.type.capitalized : item.subtitle
        content.textProperties.color = AssetColors.textPrimary.color
        content.secondaryTextProperties.color = AssetColors.textSecondary.color
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        return cell
    }
}

extension SearchPageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.results[indexPath.row]

        print("Seçilən kurs: \(item.title) (id: \(item.id))")
    }
}
