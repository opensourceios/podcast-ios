//
//  PlayerHeaderView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/21/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol PlayerHeaderViewDelegate: class {
    func playerHeaderViewDidTapCollapseButton()
}

class PlayerHeaderView: UIView {
    
    var upNextLabel: UILabel!
    var nextEpisodeLabel: UILabel!
    var playingFromLabel: UILabel!
    
    let topInset: CGFloat = 24
    let spacing: CGFloat = 1.5
    let upNextSpacing: CGFloat = 3
    
    weak var delegate: PlayerHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.colorFromCode(0xf0f1f4)
        self.frame.size.height = 87
        
        upNextLabel = UILabel(frame: .zero)
        upNextLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(upNextLabel)
        
        nextEpisodeLabel = UILabel(frame: .zero)
        nextEpisodeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nextEpisodeLabel.textColor = UIColor.colorFromCode(0xa8a8b4)
        addSubview(nextEpisodeLabel)
        
        playingFromLabel = UILabel(frame: .zero)
        playingFromLabel.textAlignment = .center
        playingFromLabel.textColor = UIColor.colorFromCode(0xa8a8b4)
        playingFromLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(playingFromLabel)
        
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        upNextLabel.text = "Up Next"
        upNextLabel.sizeToFit()
        
        nextEpisodeLabel.text = "E191: Surviving Refugee"
        nextEpisodeLabel.sizeToFit()
        
        let totalWidth = upNextLabel.frame.size.width + upNextSpacing + nextEpisodeLabel.frame.size.width
        upNextLabel.frame.origin = CGPoint(x: (frame.size.width - totalWidth) / 2, y: topInset)
        nextEpisodeLabel.frame.origin = CGPoint(x: upNextLabel.frame.maxX + upNextSpacing, y: topInset)
        
        playingFromLabel.text = "Playing from Bookmarks"
        playingFromLabel.sizeToFit()
        playingFromLabel.center.x = frame.size.width / 2
        playingFromLabel.frame.origin.y = 44.5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.playerHeaderViewDidTapCollapseButton()
    }

}