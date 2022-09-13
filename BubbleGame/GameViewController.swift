//
//  GameViewController.swift
//  BubbleGame
//
//  Created by Tran Dam Trung Thai on 15/5/20.
//  Copyright © 2020 Tran Dam Trung Thai. All rights reserved.
//

import UIKit


class GameViewController: UIViewController {
    
    @IBOutlet weak var highScoreLabelDisplay: UILabel!
    @IBOutlet weak var scoreLabelDisplay: UILabel!
    @IBOutlet weak var nameLabelDisplay: UILabel!
    @IBOutlet weak var timeLabelDisplay: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var gameTime: Int = 5 //adjust using slider
    
    var gameTimer: Timer?
    var bubbleButton = BubbleButton()
    var bubbleArray = [BubbleButton]()
    var score: Double = 0
    var maxBubble = 15 //adjust using slider
//    var currentScore: Double = 0
    var rankingDictionary = [String : Double]()
    var highScoreArray = [Double]()
    var lastBubbleValue: Double = 0
    var highScore = Double()
    var player = String()
    var previousRankingDict: Dictionary? = [String: Double]()
    var sortedHighScoreArray = [(key: String, value: Double)]()
    
    var screenWidth: UInt32 {
        return UInt32(UIScreen.main.bounds.width)
    }
    var screenHeight: UInt32 {
        return UInt32(UIScreen.main.bounds.height)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabelDisplay.text = player
        
        previousRankingDict = UserDefaults.standard.dictionary(forKey: "ranking") as? Dictionary<String, Double>
        
        if (previousRankingDict != nil) {
            rankingDictionary = previousRankingDict!
            sortedHighScoreArray = rankingDictionary.sorted(by: {$0.value > $1.value})
        }
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in
            self.timeFired()
            self.removeBubble()
            self.createBubble()
        }
        // Do any additional setup after loading the view.
    }
    
    func isOverlapped(newBubble: BubbleButton) -> Bool {
        for existingBubble in bubbleArray {
            if (newBubble.frame.intersects(existingBubble.frame)) {
                return true
            }
        }
        return false
    }
    
    func updateHighScore() {
        if (score > highScore) {
            highScore = score
        }
    }
    
    func displayHighScore() {
        self.highScoreLabelDisplay.text = String(highScore)
    }
    
    func startTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.timeFired), userInfo: nil, repeats: true)
        self.timeLabelDisplay.text = String(gameTime)
    }
    
    @objc func timeFired() {
        self.timeLabelDisplay.text = String(gameTime)
        
        if (gameTime <= 0) {
            if let time = gameTimer {
                time.invalidate()
                
                //save high score
                
                saveRanking(player, score)
                
                let destinationView = AfterGameViewController()
                self.navigationController?.pushViewController(destinationView, animated: true)
            }
        } else {
            gameTime -= 1
        }
    }

    
    func createBubble() {
        let numBubbleToCreate = arc4random_uniform(UInt32(maxBubble - bubbleArray.count)) + 1
        
        var i = 0
        while i < numBubbleToCreate {
            bubbleButton = BubbleButton()
            bubbleButton.frame = createRect()
            if (!isOverlapped(newBubble: bubbleButton)) {
                bubbleButton.addTarget(self, action: #selector(bubblePop), for: UIControl.Event.touchUpInside)
                
                bubbleButton.SpringAnimation()
                self.view.addSubview(bubbleButton)
                
                i += 1
                
                bubbleArray += [bubbleButton]
            }
            
        }
       
    }
    
    func removeBubble() {
        var i = 0
        
        while i < bubbleArray.count {
            if arc4random_uniform(100) < 33 {
                let bubbleToBeRemoved = bubbleArray[i]
                bubbleToBeRemoved.removeFromSuperview()
                bubbleArray.remove(at: i)
                
                i += 1
            }
        }
    }
    
    func createRect() -> CGRect {
        let diameter = 2 * bubbleButton.radius
        let randomX = CGFloat(10 + arc4random_uniform(screenWidth - diameter - 20))
        let randomY = CGFloat(160 + arc4random_uniform(screenHeight - diameter - 180))
        return CGRect(x: randomX, y: randomY, width: CGFloat(diameter), height: CGFloat(diameter))
    }
    
    @objc func bubblePop(_ bubbleButton: BubbleButton) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
             bubbleButton.removeFromSuperview()
        })
        bubbleButton.SpringAnimation()
        CATransaction.commit()
        
        
        if lastBubbleValue == bubbleButton.value {
            score += bubbleButton.value * 1.5
        } else {
            score += bubbleButton.value
        }
        lastBubbleValue = bubbleButton.value
        
        scoreLabelDisplay.text = String(score)
        
        if previousRankingDict == nil {
            self.highScoreLabelDisplay.text = String(score)
        } else if sortedHighScoreArray[0].value < score {
            self.highScoreLabelDisplay.text = String(score)
        } else if sortedHighScoreArray[0].value >= score {
            self.highScoreLabelDisplay.text = String(sortedHighScoreArray[0].value)
        }
    }
    
    func saveRanking(_ name: String, _ score: Double) {
        
        if name == "" {
            rankingDictionary["unknown"] = score
        } else {
            rankingDictionary[name] = score
        }
        highScoreArray.append(score)
        UserDefaults.standard.set(rankingDictionary, forKey: "ranking")
    }
}
