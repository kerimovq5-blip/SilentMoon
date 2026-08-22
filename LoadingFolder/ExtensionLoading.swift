//
//  ExtensionLoading.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 21.08.26.
//

import UIKit
import ObjectiveC

extension UIViewController {

    private var loadingOverlayTag: Int { 999_888 }

    private enum LoadingOverlayMetrics {
        static let cardSize: CGFloat = 88
        static let cardCornerRadius: CGFloat = 20
        static let spinnerScale: CGFloat = 1.2
        static let fadeDuration: TimeInterval = 0.25
    }

    private final class LoadingOverlayState {
        var refCount = 0
        var wasBackButtonHidden = false
        var wasLeftBarItemEnabled = true
        var wasPopGestureEnabled = true
        var wasTabBarInteractive = true
    }

    private static var stateKey: UInt8 = 0

    private var loadingState: LoadingOverlayState {
        if let existing = objc_getAssociatedObject(self, &Self.stateKey) as? LoadingOverlayState {
            return existing
        }
        let created = LoadingOverlayState()
        objc_setAssociatedObject(self, &Self.stateKey, created, .OBJC_ASSOCIATION_RETAIN)
        return created
    }

    var isBlurLoadingActive: Bool {
        loadingState.refCount > 0
    }

    func showBlurLoading(message: String? = nil) {
        dispatchPrecondition(condition: .onQueue(.main))

        loadingState.refCount += 1
        guard loadingState.refCount == 1 else { return }

        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

        loadingState.wasBackButtonHidden = navigationItem.hidesBackButton
        loadingState.wasLeftBarItemEnabled = navigationItem.leftBarButtonItem?.isEnabled ?? true
        loadingState.wasPopGestureEnabled = navigationController?.interactivePopGestureRecognizer?.isEnabled ?? true
        loadingState.wasTabBarInteractive = tabBarController?.tabBar.isUserInteractionEnabled ?? true

        let overlayView = UIView(frame: view.bounds)
        overlayView.tag = loadingOverlayTag
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.alpha = 0
        overlayView.isAccessibilityElement = true
        overlayView.accessibilityLabel = message ?? AppStrings.loadingAccessibilityLabel.letters
        overlayView.accessibilityTraits = .updatesFrequently

        if UIAccessibility.isReduceTransparencyEnabled {
            overlayView.backgroundColor = UIColor.black
        } else {
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
            blurEffectView.frame = overlayView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayView.addSubview(blurEffectView)
        }

        let card = UIView()
        card.backgroundColor = UIColor.lightGray
        card.layer.cornerRadius = LoadingOverlayMetrics.cardCornerRadius

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        if !UIAccessibility.isReduceMotionEnabled {
            activityIndicator.transform = CGAffineTransform(
                scaleX: LoadingOverlayMetrics.spinnerScale,
                y: LoadingOverlayMetrics.spinnerScale
            )
        }
        activityIndicator.startAnimating()

        overlayView.addSubview(card)
        card.addSubview(activityIndicator)

        card
            .centerX(overlayView.centerXAnchor).0
            .centerY(overlayView.centerYAnchor).0
            .width(LoadingOverlayMetrics.cardSize).0
            .height(LoadingOverlayMetrics.cardSize)

        activityIndicator
            .centerX(card.centerXAnchor).0
            .centerY(card.centerYAnchor)

        overlayView.isUserInteractionEnabled = true
        view.addSubview(overlayView)
        view.accessibilityElementsHidden = true
        UIAccessibility.post(notification: .screenChanged, argument: overlayView)

        let animationsEnabled = !UIAccessibility.isReduceMotionEnabled
        UIView.animate(withDuration: animationsEnabled ? LoadingOverlayMetrics.fadeDuration : 0) {
            overlayView.alpha = 1
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem?.isEnabled = false
        tabBarController?.tabBar.isUserInteractionEnabled = false
    }

    func hideBlurLoading() {
        dispatchPrecondition(condition: .onQueue(.main))

        guard loadingState.refCount > 0 else { return }
        loadingState.refCount -= 1
        guard loadingState.refCount == 0 else { return }

        view.accessibilityElementsHidden = false
        UIAccessibility.post(notification: .screenChanged, argument: view)

        guard let loadingOverlay = view.viewWithTag(loadingOverlayTag) else { return }

        let animationsEnabled = !UIAccessibility.isReduceMotionEnabled
        UIView.animate(withDuration: animationsEnabled ? LoadingOverlayMetrics.fadeDuration : 0, animations: {
            loadingOverlay.alpha = 0
        }) { _ in
            loadingOverlay.removeFromSuperview()
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = loadingState.wasPopGestureEnabled
        navigationItem.hidesBackButton = loadingState.wasBackButtonHidden
        navigationItem.leftBarButtonItem?.isEnabled = loadingState.wasLeftBarItemEnabled
        tabBarController?.tabBar.isUserInteractionEnabled = loadingState.wasTabBarInteractive
    }
}
