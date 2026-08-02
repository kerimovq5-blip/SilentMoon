//
//  SearchPageController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 02.08.26.
//

import UIKit

final class SearchPageController: UIViewController {
    var coordinator: ContentNavigating?

    private var searchDebounceTimer: Timer?
    private var currentRequestID = 0

    private var results: [CourseSummary] = [] {
        didSet { tableView.reloadData() }
    }

    private enum State {
        case idle         
        case loading
        case loaded
        case empty
        case error(String)
    }

    private var state: State = .idle {
        didSet { updateUI(for: state) }
    }

    private lazy var searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.layer.cornerRadius = 12
        textfield.layer.masksToBounds = true
        textfield.backgroundColor = AssetColors.lightGray.color
        textfield.textColor = .black
        textfield.tintColor = AssetColors.textSecondary.color
        textfield.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: AssetColors.lightGray.color]
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

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        
        let search = NSAttributedString(
            string: "we are sorry, We can not find the Search :( ",
            attributes: [
                .foregroundColor: AssetColors.buttonTitle.color,
                .font: AppFonts.title.font
            ]
        )
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "seachicon")?
            .withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -6, width: 30, height: 30)
        let searchicon = NSAttributedString(attachment: attachment)
        
        let categories = NSAttributedString(
            string: " Find your movie by Type title,\n categories, years, etc ",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font]
        )
        
        let full = NSMutableAttributedString()
        full.append(search)
        full.append(searchicon)
        full.append(categories)
        
        label.attributedText = full
        label.textAlignment = .center
        return label
    }()
    private lazy var silentMoonFrame: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SilentMoonFrame")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
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

    private func setupHierarchy() {
        view.addSubviews(
            searchTextField,
            tableView, loadingIndicator, emptyStateLabel)
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

        emptyStateLabel
            .top(tableView.topAnchor, AppLayout.largeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)
    }

    private func searchDidChange() {
        let query = searchTextField.text ?? ""

        searchDebounceTimer?.invalidate()

        guard query.trimmingCharacters(in: .whitespaces).count >= 2 else {
            currentRequestID += 1
            results = []
            state = .idle
            return
        }

        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) {
            [weak self] _ in
            self?.performSearch(query: query)
        }
    }

    private func performSearch(query: String) {
        currentRequestID += 1
        let requestID = currentRequestID
        state = .loading

        SilentMoonApiService.shared.search(query: query) { [weak self] result in
            guard let self, requestID == self.currentRequestID else { return }
            switch result {
            case .success(let response):
                self.results = response.data
                self.state = response.data.isEmpty ? .empty : .loaded
            case .failure(let error):
                self.results = []
                self.state = .error(self.message(for: error))
            }
        }
    }

    private func message(for error: Error) -> String {
        if let apiError = error as? ApiErrorEnvelope {
            return apiError.error.message
        }
        return error.localizedDescription
    }

    private func updateUI(for state: State) {
        switch state {
        case .idle:
            loadingIndicator.stopAnimating()
            emptyStateLabel.isHidden = true
            tableView.isHidden = false
        case .loading:
            loadingIndicator.startAnimating()
            emptyStateLabel.isHidden = true
            tableView.isHidden = true
        case .loaded:
            loadingIndicator.stopAnimating()
            emptyStateLabel.isHidden = true
            tableView.isHidden = false
        case .empty:
            loadingIndicator.stopAnimating()
            emptyStateLabel.text = "Nəticə tapılmadı"
            emptyStateLabel.isHidden = false
            tableView.isHidden = true
        case .error(let message):
            loadingIndicator.stopAnimating()
            emptyStateLabel.text = message
            emptyStateLabel.isHidden = false
            tableView.isHidden = true
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchPageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        let item = results[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.subtitle ?? item.type.capitalized
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
        let item = results[indexPath.row]
        
        print("Seçilən kurs: \(item.title) (id: \(item.id))")
    }
}
