//
//  ViewController.swift
//  MyTimer
//
//  Created by 吉田雄紀 on 2020/06/28.
//  Copyright © 2020 oremimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer : Timer?
    
    var count = 0
    
    let settingKey = "timer_value"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let settings = UserDefaults.standard
        settings.register(defaults: [settingKey:10])
    }

    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBAction func settingButtonAction(_ sender: Any) {
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
        
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                return
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(self.timerInterrupt(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
    }
    
    func displayUpdate() -> Int {
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        let remainCount = timerValue - count
        countDownLabel.text = "残り\(remainCount)秒"
        return remainCount
    }
    
    @objc func timerInterrupt(_ timer:Timer) {
        count += 1
        if displayUpdate() <= 0 {
            count = 0
            timer.invalidate()
            
            let aleartController = UIAlertController(title: "終了", message: "タイマー終了時間です", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            aleartController.addAction(defaultAction)
            present(aleartController, animated: true,completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        count = 0
        _ = displayUpdate()
    }
}

