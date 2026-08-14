//
//  ReminderViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 08.07.26.
//

import UIKit

final class ReminderViewController: UIViewController {
    var coordinator: AuthCoordinator?
    private let stateModel: ReminderStateModels
    private let weekLabels = ReminderDayItem.weeknames
    private var selectedIndexes: Set<Int> = []

    init(stateModel: ReminderStateModels) {
        self.stateModel = stateModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "What time would you like to meditate?\n",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.titleBold.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "\nAny time you can choose but We recommend first thing in th morning.",
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

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .datepicker
        datePicker.layer.cornerRadius = AppFonts.AppRaduis.buttonRadiusMedium
        datePicker.clipsToBounds = true
        return datePicker
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "Which day would you like to meditate?\n",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.titleBold.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "\nEveryday is best, but we recommend picking at least five.",
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

    private lazy var weekCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 44, height: AppLayout.buttonHeight.value)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(ReminderCell.self, forCellWithReuseIdentifier: "cell")
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    private lazy var saveButton: AppButton = {
        let button = AppButton(title: "Save")
        button.onTap = { [weak self] in self?.saveTapped() }
        return button
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var thankslabel: UILabel = {
        let label = UILabel()
        label.text = "NO THANKS"
        label.textColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(skipTapped))
        )
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndexes = Set(weekLabels.indices)
        setupHierarchy()
        setupConstraints()
        bindStateModel()
    }

    private func bindStateModel() {
        stateModel.onStateChange = { [weak self] in
            self?.render()
        }
    }

    private func render() {
        switch stateModel.state {
        case .idle:
            setLoading(false)
        case .loading:
            setLoading(true)
        case .success, .deleted:
            setLoading(false)
            coordinator?.finishAuth()
        case .invalidInput(let message):
            setLoading(false)
            showAlert(message: message)
        case .requestFailed(let appError):
            setLoading(false)
            showAlert(message: appError.errorDescription ?? "Naməlum xəta baş verdi.")
        }
    }

    private func setLoading(_ isLoading: Bool) {
        saveButton.isUserInteractionEnabled = !isLoading
        saveButton.alpha = isLoading ? 0.6 : 1.0
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func setupHierarchy() {
        view.backgroundColor = .backgroundSecondary
        view.addSubviews(
            titleLabel,
            datePicker,
            subtitleLabel,
            weekCollection,
            saveButton,
            loadingIndicator,
            thankslabel
        )
    }

    private func setupConstraints() {
        titleLabel
            .top(view.safeAreaLayoutGuide.topAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)

        datePicker
            .top(titleLabel.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(215)

        subtitleLabel
            .top(datePicker.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)

        weekCollection
            .top(subtitleLabel.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor ).0
            .trailing(view.trailingAnchor).0
            .height(AppLayout.buttonHeight.value)

        saveButton
            .top(weekCollection.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        loadingIndicator
            .centerX(saveButton.centerXAnchor).0
            .centerY(saveButton.centerYAnchor)

        thankslabel
            .top(saveButton.bottomAnchor , AppLayout.spacing.value).0
            .centerX(view.centerXAnchor)
    }

    private func saveTapped() {
        stateModel.selectedDate = datePicker.date
        // ReminderDayItem.weeknames[0] == Sunday → Foundation's DateComponents.weekday
        // convention is 1...7 with Sunday = 1, so the stored day is (index + 1).
        stateModel.selectedDays = Set(selectedIndexes.map { $0 + 1 })
        stateModel.saveReminder()
    }

    @objc private func skipTapped() {
        coordinator?.finishAuth()
    }
}



extension ReminderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weekLabels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as? ReminderCell else {
            return UICollectionViewCell()
        }

        var item = weekLabels[indexPath.item]
        item.title = String(item.title.uppercased().prefix(2))
        item.isSelected = selectedIndexes.contains(indexPath.item)

        cell.configure(data: item)
        return cell
    }
}


extension ReminderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexes.contains(indexPath.item) {
            selectedIndexes.remove(indexPath.item)
        } else {
            selectedIndexes.insert(indexPath.item)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}


extension ReminderViewController: UICollectionViewDelegateFlowLayout {
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
        UIEdgeInsets(
            top: 0,
            left: AppLayout.spacing.value,
            bottom: 0,
            right: AppLayout.spacing.value
        )
    }
}
