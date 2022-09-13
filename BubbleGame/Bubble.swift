//
//  Bubble.swift
//  BubbleGame
//
//  Created by Tran Dam Trung Thai on 17/5/20.
//  Copyright © 2020 Tran Dam Trung Thai. All rights reserved.
//

import UIKit

class BubbleButton : UIButton {
    
    var value: Double = 0
    var radius: UInt32 {
        return UInt32(UIScreen.main.bounds.width / 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = CGFloat(radius)
        
        let possibility = Int(arc4random_uniform(100))
        switch possibility {
        case 0...39:
            self.backgroundColor = UIColor.systemRed
            self.value = 1
        case 40...69:
            self.backgroundColor = UIColor.systemPink
            self.value = 2
        case 70...84:
            self.backgroundColor = UIColor.systemGreen
            self.value = 5
        case 85...94:
            self.backgroundColor = UIColor.systemBlue
            self.value = 8
        case 95...100:
            self.backgroundColor = .black
            self.value = 10
        default:
            print("error")
        }
    }
    
    func BasicAnimation() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 0
        animation.repeatCount = 0
        animation.autoreverses = false
        
        layer.add(animation, forKey: nil)
    }
    
    func SpringAnimation() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 0.4
        animation.fromValue = 1
        animation.toValue = 0.8
        animation.repeatCount = 1
        animation.initialVelocity = 0.5
        animation.damping = 1
        
        layer.add(animation, forKey: nil)
    }
}
