//
//  ViewController.swift
//  incrementalBoi
//
//  Created by David Chilton on 03/03/2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    var numberOfTapsSaved: [Int]? = UserDefaults.standard.object(forKey: "taps") as? [Int] //saved tap value
    var numberOfTaps = 0
    // 3 different methods i have tried to save / recall local data
    
//    var numberOfTaps : Int {
//           get {
//            return numberOfTapsSaved
//           }
//       }
    
    
    //lazy var numberOfTaps = numberOfTapsSaved
    
    
    
//    var numberOfTaps : Int //TAP COUNTER
//    init() {
//            numberOfTaps = numberOfTapsSaved
//        }
    
    var health = 100 //prog bar test??
    
    var shatter = 0 //check for shatter
    
    var poly = 0
    
    //nova cooldown
    var countTimer:Timer!
    var countTimerPoly:Timer!
    
     var counter = 25 //nova cooldown
    var polyCounter = 5 //poly timer
    
    //tap counter function to do shit idk dont matter
    func tapCounter() {
        if numberOfTaps == 10 {
            buffsLabel.text = "You've unlucked +5 taps!"
        }
    }
    
    
    
    //test function
    func testFunc() {
        print("working")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        polyDebuff.alpha = 0
        novaDebuff.alpha = 0
        
        //Data storage
        UserDefaults.standard.set(numberOfTaps, forKey: "taps")
        //UserDefaults.standard.integer(forKey: "taps")
        
    }
    @IBOutlet weak var healthBar: UIProgressView!
    
    @IBOutlet weak var frostNovaOutlet: UIButton!
    @IBOutlet weak var novaDebuff: UIImageView!
    @IBOutlet weak var tapLabel: UILabel! //NUMBER OF TAPS
    
    @IBOutlet weak var buffsLabel: UILabel! //OTHER TEXT (mid screen)
    @IBOutlet weak var polyDebuff: UIImageView!
    
    @IBAction func tapButton(_ sender: Any) {
        //tap increases var +1 also label "string"

        //if statement to figure out how many increments per tap
        if poly == 0 {
        if true {
            if shatter > 0 {  //if shatter is TRUE
                if poly == 1 {
                countTimerPoly.invalidate()
                    poly = 0
                    polyDebuff.alpha = 0
                }
                numberOfTaps+=2
                tapLabel.text  = String(numberOfTaps)
                shatter-=1
                healthBar.progress -= 0.02
                polyDebuff.alpha = 0
                
        
                
                if shatter == 0 {
                    novaDebuff.alpha = 0
                }
            }
            else {
                numberOfTaps+=1
                tapLabel.text = String(numberOfTaps)
                healthBar.progress -= 0.01
                polyDebuff.alpha = 0
            //buff check etc
            tapCounter() }
        }
        
            else {
                tapLabel.text = String("Enemy dead. Nice shatter!") }
            }
    
    else { //ELSE IF TARGET IS POLY
        poly = 0
    }
    }
    @objc func novaCooldown() {
        if counter != 0
             {
                 
                 counter -= 1
            
            frostNovaOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 46)
        frostNovaOutlet.setTitle(String(counter), for: .normal)
            
            
             }
             else
             {
                  countTimer.invalidate()
                 frostNovaOutlet.alpha = 1
                 counter = 25
             }

    }
    
    @IBAction func frostNova(_ sender: UIButton) {
        print(counter)
        
        
        
        if counter == 25 {
        shatter = 5
        novaDebuff.alpha = 1
        self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                                      target: self,
                                                      selector: #selector(self.novaCooldown),
                                                      userInfo: nil,
                                                      repeats: true)
        sender.alpha = 1
        sender.setTitle(String(counter), for: .normal)
        }
        else {
            frostNovaOutlet.setTitle("", for: .normal)
        }
    }
    
    @objc func polyTimer() {
        if polyCounter != 0 {
            if poly == 1 {
            polyCounter -= 1
            healthBar.progress += 0.2
            }
        }
        else {
            countTimerPoly.invalidate()
           polyCounter = 5
            polyDebuff.alpha = 0
            poly = 0
        }
    }
    
    @IBAction func polymorph(_ sender: UIButton) {
        poly = 1
        polyDebuff.alpha = 1
        self.countTimerPoly = Timer.scheduledTimer(timeInterval: 1 ,
                                                      target: self,
                                                      selector: #selector(self.polyTimer),
                                                      userInfo: nil,
                                                      repeats: true)
    }
    
    
    
    //end of uiViewController
}
    

// ---- out of scope ---
    //leave this one for now
//    func autoTap() {
        
        
        //FIX THIS, TRYNA SLEEP PER INCREMENT _----------------------------------_
//        while true {
//            if numberOfTaps > 10 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    print("SLEEPING")
//                    self.numberOfTaps+=2
//
//            }
////                numberOfTaps+=2
////                tapLabel.text = String(numberOfTaps)
////                print(numberOfTaps)
////                sleep(1)
//            }
//
//    }
//}
//
//
//
//}
