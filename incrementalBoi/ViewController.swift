//
//  ViewController.swift
//  incrementalBoi
//
//  Created by David Chilton on 03/03/2022.
//

import UIKit


class ViewController: UIViewController {
    
    //icon fx
    var pulseLayers = [CAShapeLayer]() //pulse CAShapeLayerarray
    
    //data storage
    let defaults = UserDefaults.standard
    var savedNumberOfTaps = ""
    var savedLevel = ""
    var savedCounterCheck = ""
    
    
    var numberOfTaps = 0
    var level = 1
    var health = 100 //prog bar test??
    var shatter = 0 //check for shatter
    var poly = 0 //check for poly
    
    //nova cooldown
    var countTimer:Timer!
    var countTimerPoly:Timer!
    var counter = 25 //nova cooldown
    var polyCounter = 5 //poly timer
    //taps
    var tapCounterIncrement = 1
    var tapCounterCheck: Double = 10
    //fof proc
    var proc: Int = 0
    var randomNumber: Int = 0
    
    
    //tap number is incremented 1*level / 9*level (shatter)
    func tapCounter() {
        
        
        // TO IMPLEMENT SLOWER START HARDCODED THEN MOVE TO MATH BASED
        //        else if numberOfTaps >= 20 {
        //                level = 3
        //                buffsLabel.text = "Level \(level)"
        //        }
        //        else if numberOfTaps >= 40 {
        //                level = 4
        //                buffsLabel.text = "Level \(level)"
        //        }
        //        else if numberOfTaps >= 80 {
        //                level = 5
        //                buffsLabel.text = "Level \(level)"
        //        }
        //        else if numberOfTaps >= 160 {
        //                level = 6
        //                buffsLabel.text = "Level \(level)"
        //        }
        //        else if numberOfTaps >= 320 {
        //                level = 7
        //                buffsLabel.text = "Level \(level)"
        //        }
        
        if numberOfTaps >= Int(tapCounterCheck) {
            level+=1
            buffsLabel.text = "Level \(level)"
            tapCounterCheck = tapCounterCheck*1.25
            //print(tapCounterCheck)
            
            Animations.shake(on: buffsLabel)
            
            //storing level
            defaults.set(level, forKey: "level")
            defaults.set(tapCounterCheck, forKey: "counterCheck")
        }
    }
        
    //test function -----
    func testFunc() {
        print("working")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fofProc.layer.cornerRadius = fofProc.frame.size.width/4.0
        createPulse()
        
        polyDebuff.alpha = 0
        novaDebuff.alpha = 0
        
        savedNumberOfTaps = defaults.string(forKey: "taps") ?? "1"
        numberOfTaps = Int(savedNumberOfTaps)!
        
        savedLevel = defaults.string(forKey: "level") ?? "1"
        level = Int(savedLevel)!
        
        savedCounterCheck = defaults.string(forKey: "counterCheck") ?? "10"
        tapCounterCheck = Double(savedCounterCheck)!
        
        buffsLabel.text = "Level \(level)"
        tapLabel.text = String(numberOfTaps)
        
        UIView.transition(with: buffsLabel,
                              duration: 2,
                              options: [.transitionCrossDissolve],
                              animations: {
            //self.buffsLabel.text = "Ding"
        }, completion: nil)
        
        
        //HANDLING SWIPE GESTURES
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        upSwipe.direction = .up
        downSwipe.direction = .down
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
    }
    
    //outlets
    @IBOutlet weak var healthBar: UIProgressView!
    @IBOutlet weak var frostNovaOutlet: UIButton!
    @IBOutlet weak var novaDebuff: UIImageView!
    @IBOutlet weak var tapLabel: UILabel! //NUMBER OF TAPS
    @IBOutlet weak var buffsLabel: UILabel! //OTHER TEXT (mid screen)
    @IBOutlet weak var polyDebuff: UIImageView!
    @IBOutlet weak var dingLabel: UILabel!
    @IBOutlet weak var fofProc: UIImageView!
    @IBAction func tapButton(_ sender: Any) { //MAIN function to damage
        
        damageFunc()
        
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
                 //remove CD number from button
                 frostNovaOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 46)
             frostNovaOutlet.setTitle(String(""), for: .normal)
             }

    }
    
    @IBAction func frostNova(_ sender: UIButton) {
        
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
            tapLabel.text = String(numberOfTaps)
        }
        else {
            countTimerPoly.invalidate()
           polyCounter = 5
            polyDebuff.alpha = 0
            poly = 0
            Animations.shake(on: polyDebuff)
        }
    }
    
    @IBAction func polymorph(_ sender: UIButton) {
        tapLabel.text = "Target Polymorphed"
        poly = 1
        polyDebuff.alpha = 1
        self.countTimerPoly = Timer.scheduledTimer(timeInterval: 1 ,
                                                      target: self,
                                                      selector: #selector(self.polyTimer),
                                                      userInfo: nil,
                                                      repeats: true)
    }
    //HANDLE SWIPES FUNC
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) { //UP SWIPE   Fingers of frost
        if (sender.direction == .up) {
                //print("Swipe up")      //testing swipe

            if poly == 0 {
                if proc > 0 { // check fof proc
                if healthBar.progress != 0 {
                
                    if poly == 1 {
                    countTimerPoly.invalidate()
                        poly = 0
                        polyDebuff.alpha = 0
                    }
                    //****AFFECTED BY LEVEL MULTIPLYER
                    if healthBar.progress != 0 { //make sure mob is alive before adding damage
                    numberOfTaps+=(9*level)
                        tapCounter()
                    }
                    //****
                    tapLabel.text  = String(numberOfTaps)
                    shatter-=1
                    healthBar.progress -= 0.05
                    polyDebuff.alpha = 0
                    defaults.set(numberOfTaps, forKey: "taps")
                    
                    if shatter == 0 {
                        novaDebuff.alpha = 0
                        tapCounter()
                    }
                
                 //if shatter is false
                    //*** AFFECTED BY LEVEL MULTIPLYER
                    if healthBar.progress != 0 { //make sure mob is alive before adding damage
                    numberOfTaps+=(9*level)
                    }
                    //***
                    tapLabel.text = String(numberOfTaps)
                    healthBar.progress -= 0.05
                    polyDebuff.alpha = 0
                //buff check etc
                tapCounter()
                    if proc == 1 {
                        fofProc.alpha = 0
                    }
                }

                    else {
                        tapLabel.text = String("Enemy dead. Nice shatter!")
                    }
                    defaults.set(numberOfTaps, forKey: "taps")
            
            }
            
                else {
                    tapLabel.text = String("no proc")
                    
                }
                
                }
        
        else { //ELSE IF TARGET IS POLY
            poly = 0
        }
            proc -= 1
        }
        else if (sender.direction == .down) { //SWIPE DOWN (BARRIER)
            iceBarrier()
        }
    } //swipe end
    
    func fingersOfFrost() {
        proc = 2
        randomNumber = 0
        //print("FROST PROC!!!")      //testing proc
    }
    
    func damageFunc() {
        
        //if statement to figure out how many increments per tap
        if poly == 0 {
            if healthBar.progress != 0 {
            if shatter > 0 {  //if shatter is TRUE
                if poly == 1 {
                countTimerPoly.invalidate()
                    poly = 0
                    polyDebuff.alpha = 0
                }
                //****AFFECTED BY LEVEL MULTIPLYER
                if healthBar.progress != 0 { //make sure mob is alive before adding damage
                numberOfTaps+=(9*level)
                    tapCounter()
                }
                //****
                tapLabel.text  = String(numberOfTaps)
                shatter-=1
                healthBar.progress -= 0.05
                polyDebuff.alpha = 0
                defaults.set(numberOfTaps, forKey: "taps")
                
                if shatter == 0 {
                    novaDebuff.alpha = 0
                    tapCounter()
                }
            }
            else { //if shatter is false
                //*** AFFECTED BY LEVEL MULTIPLYER
                if healthBar.progress != 0 { //make sure mob is alive before adding damage
                numberOfTaps+=(1*level)
                }
                //***
                tapLabel.text = String(numberOfTaps)
                healthBar.progress -= 0.01
                polyDebuff.alpha = 0
                
                randomNumber = Int.random(in: 0...100) //rng number to determine procs
                if (randomNumber >= 70 && randomNumber <= 80) {
                    fingersOfFrost()
                    fofProc.alpha = 0.4
                }
            //buff check etc
            tapCounter() }
                defaults.set(numberOfTaps, forKey: "taps")
        }
        
            else {
                tapLabel.text = String("Enemy dead. Nice shatter!") }
            }
    
    else { //ELSE IF TARGET IS POLY
        poly = 0
    }
    }
    
    //ICE BARRIER ??
    func iceBarrier() {
        let opacity:CGFloat = 0.2
        let borderColor = UIColor.blue
        view.layer.borderWidth = 5
        view.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
    }
    

    func createPulse() {
            for _ in 0...2 {
                let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.size.width/2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
                let pulseLayer = CAShapeLayer()
                pulseLayer.path = circularPath.cgPath
                pulseLayer.lineWidth = 2.0
                pulseLayer.fillColor = UIColor.clear.cgColor
                pulseLayer.lineCap = CAShapeLayerLineCap.round
                pulseLayer.position = CGPoint(x: fofProc.frame.size.width/2.0, y: fofProc.frame.size.width/2.0)
                fofProc.layer.addSublayer(pulseLayer)
                pulseLayers.append(pulseLayer)
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.animatePulsatingLayerAt(index: 0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        self.animatePulsatingLayerAt(index: 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.animatePulsatingLayerAt(index: 2)
                        })
                    })
                })
      }
    func animatePulsatingLayerAt(index:Int) {
            
            //Giving color to the layer
            pulseLayers[index].strokeColor = UIColor.darkGray.cgColor
            
            //Creating scale animation for the layer, from and to value should be in range of 0.0 to 1.0
            // 0.0 = minimum
            //1.0 = maximum
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.0
            scaleAnimation.toValue = 0.9
            
            //Creating opacity animation for the layer, from and to value should be in range of 0.0 to 1.0
            // 0.0 = minimum
            //1.0 = maximum
            let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            opacityAnimation.fromValue = 0.9
            opacityAnimation.toValue = 0.0
           
           //Grouping both animations and giving animation duration, animation repat count
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [scaleAnimation, opacityAnimation]
            groupAnimation.duration = 2.3
            groupAnimation.repeatCount = .greatestFiniteMagnitude
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            //adding groupanimation to the layer
            pulseLayers[index].add(groupAnimation, forKey: "groupanimation")
        }
    

    //end of uiViewController
}

