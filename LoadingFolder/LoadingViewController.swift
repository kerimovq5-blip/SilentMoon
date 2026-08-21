//
//  LoadingViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 19.08.26.
//

import UIKit

final class LoadingViewController: UIViewController {
    private let viewModel: LoadingViewModel

    var onFinished: (() -> Void)?

    init(viewModel: LoadingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        bindViewModel()
        viewModel.load()
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            DispatchQueue.main.async {
                self?.render()
            }
        }
    }

    private func render() {
        switch viewModel.state {
        case .idle:
            hideBlurLoading()
            
        case .loading:
            showBlurLoading()
            
        case .loaded:
            hideBlurLoading()
            onFinished?()
            
        case .requestFailed(let appError):
            hideBlurLoading()
            showAlert(
                message: appError.errorDescription ?? AppStrings.unknownErrorAlert.letters
            )
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Xəta", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yenidən cəhd et", style: .default) { [weak self] _ in
            self?.viewModel.load()
        })
        present(alert, animated: true)
    }
}
