//
//  LoginBackgroundGradientView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 4/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class LoginBackgroundGradientView: UIView {
    
    var gradient: CAGradientLayer!
    var podcastLogo: UIImageView!
    var podcastTitle: UILabel!
    var podcastDescription: UILabel!
    
    //Constants
    var podcastLogoWidth: CGFloat = 35
    var podcastLogoHeight: CGFloat = 35
    var paddingLogoTitle: CGFloat = 30
    var paddingTitleDescription: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .podcastTeal
        gradient = CAGradientLayer()
        let charcolGray = UIColor.charcolGray.withAlphaComponent(0.60).cgColor
        let white = UIColor.podcastWhite.withAlphaComponent(0.60).cgColor
        gradient.colors = [white,UIColor.podcastTeal.cgColor,charcolGray]
        gradient.startPoint = CGPoint(x: 0.60,y: 0)
        gradient.endPoint = CGPoint(x: 0.40,y: 1)
        gradient.frame = frame
        layer.insertSublayer(gradient, at: 0)
        
        podcastLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: podcastLogoWidth, height: podcastLogoHeight))
        podcastLogo.center.x = center.x
        podcastLogo.center.y = 1/4 * frame.height
        podcastLogo.image = #imageLiteral(resourceName: "podcast_logo")
        addSubview(podcastLogo)
        
        podcastTitle = UILabel(frame: CGRect.zero)
        let titleString = NSMutableAttributedString(string: "CAST", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: UIFontWeightLight), NSKernAttributeName: 3.0])
        let podsString = NSMutableAttributedString(string: "PODS", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: UIFontWeightSemibold), NSKernAttributeName: 0.9])
        titleString.append(podsString)
        podcastTitle.attributedText = titleString
        podcastTitle.textColor = .podcastWhite
        podcastTitle.sizeToFit()
        podcastTitle.center.x = podcastLogo.center.x
        podcastTitle.frame.origin.y = podcastLogo.frame.maxY + paddingLogoTitle
        addSubview(podcastTitle)
        
        podcastDescription = UILabel(frame: CGRect.zero)
        podcastDescription.text = "Listen, learn, connect."
        podcastDescription.font = UIFont.systemFont(ofSize: 16)
        podcastDescription.textColor = .podcastWhite
        podcastDescription.sizeToFit()
        podcastDescription.center.x = podcastTitle.center.x
        podcastDescription.frame.origin.y = podcastTitle.frame.maxY + paddingTitleDescription
        addSubview(podcastDescription)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
