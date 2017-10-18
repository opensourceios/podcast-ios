//
//  PlayerControlsView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol PlayerControlsDelegate: class {
    func playerControlsDidTapPlayPauseButton()
    func playerControlsDidTapSkipForward()
    func playerControlsDidTapSkipBackward()
    func playerControlsDidScrub()
    func playerControlsDidEndScrub()
    func playerControlsDidTapMoreButton()
    func playerControlsDidTapRecommendButton()
}

class PlayerControlsView: UIView {
    
    let sliderHeight: CGFloat = 1.5
    let marginSpacing: CGFloat = 24.5
    
    let playerControlsViewHeight: CGFloat = 192
    
    let playPauseButtonSize: CGSize = CGSize(width: 96, height: 96.5)
    let playPauseButtonTopOffset: CGFloat = 30.0
    let skipButtonSize: CGSize = CGSize(width: 56.5, height: 20)
    let skipButtonSpacing: CGFloat = 40.5
    let skipForwardSpacing: CGFloat = 17.5
    let skipBackwardSpacing: CGFloat = 15
    let skipButtonTopOffset: CGFloat = 56
    let sliderTopOffset: CGFloat = 26.5
    let sliderYInset: CGFloat = 132
    let timeLabelSpacing: CGFloat = 8
    let buttonsYInset: CGFloat = 181.5
    let nextButtonSize: CGSize = CGSize(width: 12.5, height: 13)
    let nextButtonLeftOffset: CGFloat = 29
    let nextButtonTopOffset: CGFloat = 65.1
    
    let recommendButtonSize: CGSize = CGSize(width: 80, height: 18)
    let moreButtonSize: CGSize = CGSize(width: 25, height: 18)
    let speedButtonSize: CGSize = CGSize(width: 14, height: 18)
    
    var slider: UISlider!
    var playPauseButton: UIButton!
    var forwardsButton: UIButton!
    var backwardsButton: UIButton!
    var rightTimeLabel: UILabel!
    var leftTimeLabel: UILabel!
    var recommendButton: RecommendButton!
    var moreButton: MoreButton!
    var nextButton: UIButton!
    var speedButton: UIButton!
    
    weak var delegate: PlayerControlsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = playerControlsViewHeight
        backgroundColor = .clear
        
        // todo: change thumb image to smaller circle
        slider = UISlider(frame: .zero)
        slider.minimumTrackTintColor = .sea
        slider.maximumTrackTintColor = .silver
        addSubview(slider)
        slider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(marginSpacing)
            make.top.equalToSuperview().offset(sliderTopOffset)
            make.height.equalTo(sliderHeight)
        }
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpOutside)
        
        leftTimeLabel = UILabel(frame: .zero)
        leftTimeLabel.font = ._12RegularFont()
        leftTimeLabel.textColor = .slateGrey
        leftTimeLabel.textAlignment = .left
        addSubview(leftTimeLabel)
        
        rightTimeLabel = UILabel(frame: .zero)
        rightTimeLabel.font = ._12RegularFont()
        rightTimeLabel.textColor = .slateGrey
        rightTimeLabel.textAlignment = .right
        addSubview(rightTimeLabel)
        
        playPauseButton = UIButton(frame: .zero)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPress), for: .touchUpInside)
        addSubview(playPauseButton)
        
        playPauseButton.snp.makeConstraints { make in
            make.size.equalTo(playPauseButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(playPauseButtonTopOffset)
        }
        
        forwardsButton = UIButton(frame: .zero)
        forwardsButton.setBackgroundImage(#imageLiteral(resourceName: "forward30"), for: .normal)
        forwardsButton.adjustsImageWhenHighlighted = false
        forwardsButton.addTarget(self, action: #selector(forwardButtonPress), for: .touchUpInside)
        addSubview(forwardsButton)
        forwardsButton.snp.makeConstraints { make in
            make.size.equalTo(skipButtonSize)
            make.top.equalTo(slider.snp.bottom).offset(skipButtonTopOffset)
            make.leading.equalTo(playPauseButton.snp.trailing).offset(skipForwardSpacing)
        }
        
        backwardsButton = UIButton(frame: .zero)
        backwardsButton.setBackgroundImage(#imageLiteral(resourceName: "back30"), for: .normal)
        backwardsButton.adjustsImageWhenHighlighted = false
        backwardsButton.addTarget(self, action: #selector(backwardButtonPress), for: .touchUpInside)
        addSubview(backwardsButton)
        backwardsButton.snp.makeConstraints { make in
            make.size.equalTo(skipButtonSize)
            make.top.equalTo(slider.snp.bottom).offset(skipButtonTopOffset)
            make.trailing.equalTo(playPauseButton.snp.leading).offset(-1 * skipForwardSpacing)
        }
        
        // TODO: add recommend feature to "more"
        recommendButton = RecommendButton(frame: CGRect(x: marginSpacing, y: self.frame.maxY - buttonsYInset, width: recommendButtonSize.width, height: recommendButtonSize.height))
        recommendButton.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        
        nextButton = UIButton(frame: .zero)
        nextButton.setBackgroundImage(#imageLiteral(resourceName: "next"), for: .normal)
        nextButton.adjustsImageWhenHighlighted = false
        // TODO: add target to skip to next track
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerY.equalTo(forwardsButton.snp.centerY)
            make.trailing.equalTo(slider.snp.trailing)
        }
        
        speedButton = UIButton(frame: .zero)
        speedButton.setTitle("1x", for: .normal)
        speedButton.titleLabel?.font = ._12RegularFont()
        speedButton.setTitleColor(.slateGrey, for: .normal)
        addSubview(speedButton)
        speedButton.snp.makeConstraints { make in
            make.size.equalTo(speedButtonSize)
            make.leading.equalToSuperview().offset(marginSpacing)
            make.centerY.equalTo(forwardsButton.snp.centerY)
        }
        
        moreButton = MoreButton(frame: .zero)
        moreButton.frame.size = moreButtonSize
        moreButton.frame.origin = CGPoint(x: frame.maxX - marginSpacing - moreButtonSize.width, y: self.frame.maxY - buttonsYInset)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        updateUI(isPlaying: false, elapsedTime: "0:00", timeLeft: "0:00", progress: 0.0, isScrubbing: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(isPlaying: Bool, elapsedTime: String, timeLeft: String, progress: Float, isScrubbing: Bool) {
        if isPlaying {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
        if !isScrubbing {
            slider.value = progress
        }
        leftTimeLabel.text = elapsedTime
        rightTimeLabel.text = timeLeft
        leftTimeLabel.sizeToFit()
        rightTimeLabel.sizeToFit()
        leftTimeLabel.frame.origin = CGPoint(x: marginSpacing, y: slider.frame.maxY + timeLabelSpacing)
        rightTimeLabel.frame.origin = CGPoint(x: frame.maxX - marginSpacing - rightTimeLabel.frame.width, y: slider.frame.maxY + timeLabelSpacing)
    }
    
    @objc func playPauseButtonPress() {
        delegate?.playerControlsDidTapPlayPauseButton()
    }
    
    @objc func forwardButtonPress() {
        delegate?.playerControlsDidTapSkipForward()
    }
    
    @objc func backwardButtonPress() {
        delegate?.playerControlsDidTapSkipBackward()
    }
    
    @objc func endScrubbing() {
        delegate?.playerControlsDidEndScrub()
    }
    
    @objc func sliderValueChanged() {
        delegate?.playerControlsDidScrub()
    }
    
    @objc func moreButtonTapped() {
        delegate?.playerControlsDidTapMoreButton()
    }
    
    @objc func recommendButtonTapped() {
        delegate?.playerControlsDidTapRecommendButton()
    }
    
    func setRecommendButtonToState(isRecommended: Bool) {
        recommendButton.isSelected = isRecommended
    }
    
    func setNumberRecommended(numberRecommended: Int) {
        recommendButton.setNumberRecommended(numberRecommended: numberRecommended)
    }


}
