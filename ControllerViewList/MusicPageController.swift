//
//  MusicPageController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.07.26.
//

import UIKit
import AVFoundation

final class MusicPageController: UIViewController {
    var coordinator: ContentNavigating?

    var titleLabel: String = ""
    var subtitleText: String = "7 DAYS OF CALM"
    var audioURL: URL?
    var totalDuration: TimeInterval = 45 * 60

    private var player: AVPlayer?
    private var timeObserverToken: Any?
    private var isSeeking = false

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Ellipses")?
            .withRenderingMode(.alwaysTemplate)
        imageView.tintColor = AssetColors.ellipsesColor.color
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var closeButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = AssetColors.textPrimary.color
        button.backgroundColor = .white
        button.layer.cornerRadius = 22
        button.addAction(UIAction { [weak self] _ in
            self?.closeTapped()
        }, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    private lazy var favoriteButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = AssetColors.textSecondary.color
        button.backgroundColor = UIColor.textSecondary.withAlphaComponent(0.15)
        button.layer.cornerRadius = 22
        button.addAction(UIAction { [weak self] _ in
            self?.favoriteTapped()
        }, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    private lazy var downloadButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        button.tintColor = AssetColors.textSecondary.color
        button.backgroundColor = UIColor.textSecondary.withAlphaComponent(0.15)
        button.layer.cornerRadius = 22
        return UIBarButtonItem(customView: button)
    }()

    private lazy var daysLabel: UILabel = makeMusicLabel()

    private lazy var back15Button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gobackward.15"), for: .normal)
        button.tintColor = AssetColors.textSecondary.color
        button.addAction(UIAction { [weak self] _ in
            self?.seek(by: -15)
        }, for: .touchUpInside)
        return button
    }()

    private lazy var forward15Button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "goforward.15"), for: .normal)
        button.tintColor = AssetColors.textSecondary.color
        button.addAction(UIAction { [weak self] _ in
            self?.seek(by: 15)
        }, for: .touchUpInside)
        return button
    }()

    private lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = AssetColors.textPrimary.color
        button.layer.cornerRadius = 40
        button.addAction(UIAction { [weak self] _ in
            self?.playPauseTapped()
        }, for: .touchUpInside)
        return button
    }()

    private lazy var controlsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [back15Button, playPauseButton, forward15Button])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()

    private lazy var progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.tintColor = AssetColors.textPrimary.color
        slider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchUp), for: [.touchUpInside, .touchUpOutside])
        return slider
    }()

    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = AssetColors.textPrimary.color
        label.text = "00:00"
        return label
    }()

    private lazy var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = AssetColors.textPrimary.color
        label.text = formattedTime(totalDuration)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupConstraints()
        configurePlayer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }

    deinit {
        if let timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
        }
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItems = [downloadButton, favoriteButton]
    }

    private func makeMusicLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let focusLabel = NSAttributedString(
            string: "\(titleLabel)\n",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.title.font
            ]
        )
        let days = NSAttributedString(
            string: subtitleText,
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        )
        let full = NSMutableAttributedString()
        full.append(focusLabel)
        full.append(days)
        label.attributedText = full
        return label
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(
            imageView,
            daysLabel,
            controlsStack,
            progressSlider,
            currentTimeLabel,
            totalTimeLabel
        )
    }

    private func setupConstraints() {
        imageView
            .top(view.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)

        daysLabel
            .centerX(view.centerXAnchor).0
            .centerY(view.centerYAnchor).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20)

        controlsStack
            .bottom(progressSlider.topAnchor, -60).0
            .centerX(view.centerXAnchor).0
            .leading(view.leadingAnchor, 40).0
            .trailing(view.trailingAnchor, -40)

        playPauseButton
            .width(80).0
            .height(80)

        back15Button
            .width(44).0
            .height(44)

        forward15Button
            .width(44).0
            .height(44)

        progressSlider
            .bottom(currentTimeLabel.topAnchor, -8).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20)

        currentTimeLabel
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, -24).0
            .leading(view.leadingAnchor, 20)

        totalTimeLabel
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, -24).0
            .trailing(view.trailingAnchor, -20)
    }

    private func configurePlayer() {
        progressSlider.maximumValue = Float(totalDuration)
        totalTimeLabel.text = formattedTime(totalDuration)

        guard let audioURL else { return }

        let playerItem = AVPlayerItem(url: audioURL)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player

        let asset = playerItem.asset
        Task.detached {
            let seconds = try? await asset.load(.duration).seconds
            guard let seconds, seconds.isFinite, seconds > 0 else { return }

            await MainActor.run { [weak self] in
                guard let self else { return }
                self.totalDuration = seconds
                self.progressSlider.maximumValue = Float(seconds)
                self.totalTimeLabel.text = self.formattedTime(seconds)
            }
        }

        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self, !self.isSeeking else { return }
            let seconds = time.seconds
            self.progressSlider.value = Float(seconds)
            self.currentTimeLabel.text = self.formattedTime(seconds)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playbackDidFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }

    private func playPauseTapped() {
        guard let player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    private func seek(by seconds: Double) {
        guard let player else { return }
        let newTime = max(0, min(totalDuration, player.currentTime().seconds + seconds))
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
    }

    @objc private func sliderTouchDown() {
        isSeeking = true
    }

    @objc private func sliderValueChanged() {
        currentTimeLabel.text = formattedTime(Double(progressSlider.value))
    }

    @objc private func sliderTouchUp() {
        isSeeking = false
        player?.seek(to: CMTime(seconds: Double(progressSlider.value), preferredTimescale: 600))
    }

    @objc private func playbackDidFinish() {
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        player?.seek(to: .zero)
    }

    private func formattedTime(_ seconds: Double) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "00:00" }
        let total = Int(seconds)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
    
    private func closeTapped() {
        player?.pause()
        coordinator?.dismissMusicPage()
    }

    private func favoriteTapped() {
        guard let button = favoriteButton.customView as? UIButton else { return }
        let isSelected = button.tintColor == .systemRed
        button.setImage(
            UIImage(systemName: isSelected ? "heart" : "heart.fill"),
            for: .normal
        )
        button.tintColor = isSelected ? AssetColors.textSecondary.color : .systemRed
    }
}
