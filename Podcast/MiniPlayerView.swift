
import UIKit

protocol MiniPlayerViewDelegate: class {
    func miniPlayerViewDidTapPlayPauseButton()
    func miniPlayerViewDidTapExpandButton()
}

class MiniPlayerView: UIView {
    
    let miniPlayerHeight: CGFloat = 60.5
    let marginSpacing: CGFloat = 17
    let buttonSize: CGSize = CGSize(width: 15, height: 18)
    let buttonTrailingInset: CGFloat = 18
    let arrowYValue: CGFloat = 19.5
    let arrowSize: CGSize = CGSize(width: 14, height: 7)
    let titleLabelYValue: CGFloat = 14
    let labelLeadingOffset: CGFloat = 17
    let labelTrailingInset: CGFloat = 60.5
    let labelHeight: CGFloat = 18
    let miniPlayerSliderHeight: CGFloat = 3.5
    
    var arrowButton: UIButton!
    var playPauseButton: UIButton!
    var episodeTitleLabel: UILabel!
    var seriesTitleLabel: UILabel!
    var miniPlayerSlider: UISlider!
    
    var transparentMiniPlayerEnabled: Bool = true
    
    weak var delegate: MiniPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size.height = miniPlayerHeight
        backgroundColor = .gradientWhite
        
        if !UIAccessibilityIsReduceTransparencyEnabled() && transparentMiniPlayerEnabled {
            
            backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            addSubview(blurEffectView)
        }
        
        miniPlayerSlider = UISlider(frame: .zero)
        miniPlayerSlider.minimumTrackTintColor = .sea
        miniPlayerSlider.maximumTrackTintColor = .silver
        miniPlayerSlider.thumbTintColor = .clear
        addSubview(miniPlayerSlider)
        miniPlayerSlider.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(miniPlayerSliderHeight)
        }
        
        arrowButton = UIButton()
        arrowButton.setBackgroundImage(#imageLiteral(resourceName: "backArrowDown"), for: .normal)
        arrowButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        arrowButton.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        addSubview(arrowButton)
        arrowButton.snp.makeConstraints { make in
            make.size.equalTo(arrowSize)
            make.leading.equalToSuperview().offset(marginSpacing)
            make.top.equalToSuperview().offset(arrowYValue)
        }
        
        playPauseButton = UIButton()
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.trailing.equalToSuperview().inset(buttonTrailingInset)
            make.top.equalToSuperview().offset(buttonTrailingInset)
        }

        episodeTitleLabel = UILabel()
        episodeTitleLabel.numberOfLines = 2
        episodeTitleLabel.textAlignment = .left
        episodeTitleLabel.lineBreakMode = .byWordWrapping
        episodeTitleLabel.textColor = .charcoalGrey
        episodeTitleLabel.font = ._14SemiboldFont()
        addSubview(episodeTitleLabel)
        episodeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(titleLabelYValue)
            make.leading.equalTo(arrowButton.snp.trailing).offset(labelLeadingOffset)
            make.trailing.equalTo(playPauseButton.snp.leading).inset(labelTrailingInset)
            make.height.equalTo(labelHeight)
        }
        
        seriesTitleLabel = UILabel()
        seriesTitleLabel.textAlignment = .left
        seriesTitleLabel.textColor = .slateGrey
        seriesTitleLabel.font = ._12RegularFont()
        addSubview(seriesTitleLabel)
        seriesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom)
            make.leading.equalTo(arrowButton.snp.trailing).offset(labelLeadingOffset)
            make.trailing.equalTo(playPauseButton.snp.leading).inset(labelTrailingInset)
            make.height.equalTo(labelHeight)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    func updateUIForPlayback(isPlaying: Bool) {
        if isPlaying {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play_feed_icon_selected"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
        }
        miniPlayerSlider.value = Float(Player.sharedInstance.getProgress())
    }
    
    func updateUIForEpisode(episode: Episode) {
        episodeTitleLabel.text = episode.title
        seriesTitleLabel.text = episode.seriesTitle
    }
    
    func updateUIForEmptyPlayer() {
        episodeTitleLabel.text = "No Episode"
        seriesTitleLabel.text = "No Series"
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
    }
    
    @objc func viewTapped() {
        delegate?.miniPlayerViewDidTapExpandButton()
    }
    
    @objc func playPauseButtonTapped() {
        delegate?.miniPlayerViewDidTapPlayPauseButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
