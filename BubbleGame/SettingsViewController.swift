//
//  SettingsViewController.swift
//  BubbleGame
//
//  Created by Tran Dam Trung Thai on 17/5/20.
//  Copyright © 2020 Tran Dam Trung Thai. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bubbleLabel: UILabel!
    
    @IBOutlet weak var bubbleSlider: UISlider!
    
    @IBOutlet weak var nameTextField: UITextField!
    var time: Int = 35
    var numBubble: Int = 10
    
    var gameController: GameViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            let svc: GameViewController = segue.destination as! GameViewController
            svc.gameTime = time
            svc.player = nameTextField.text ?? ""
            svc.maxBubble = numBubble
        }
    }
    
 
    @IBAction func timeSlider(_ sender: UISlider) {
        time = Int(sender.value)
        self.timeLabel.text = String(time)
    }
    
    @IBAction func bubbleSlider(_ sender: UISlider) {
        numBubble = Int(sender.value)
        self.bubbleLabel.text = String(numBubble)
    }
}
