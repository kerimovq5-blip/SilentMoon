//
//  ExtensionLoading.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 21.08.26.
//

import UIKit

extension UIViewController {

    private var loadingOverlayTag: Int { 999_888 }

    func showBlurLoading() {
        if view.viewWithTag(loadingOverlayTag) != nil { return }

        let overlayView = UIView(frame: view.bounds)
        overlayView.tag = loadingOverlayTag
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = overlayView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .label
        activityIndicator.center = overlayView.center
        activityIndicator.startAnimating()
        activityIndicator.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)

        overlayView.addSubview(blurEffectView)
        overlayView.addSubview(activityIndicator)

        overlayView.isUserInteractionEnabled = true

        view.addSubview(overlayView)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem?.isEnabled = false

        tabBarController?.tabBar.isUserInteractionEnabled = false
    }

    func hideBlurLoading() {
        guard let loadingOverlay = view.viewWithTag(loadingOverlayTag) else { return }

        UIView.animate(withDuration: 0.2, animations: {
            loadingOverlay.alpha = 0
        }) { _ in
            loadingOverlay.removeFromSuperview()
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.hidesBackButton = false
        navigationItem.leftBarButtonItem?.isEnabled = true
        tabBarController?.tabBar.isUserInteractionEnabled = true
    }
}
