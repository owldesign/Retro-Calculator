//
//  ViewController.swift
//  Retro Calculator
//
//  Created by Vadim Goncharov on 11/30/15.
//  Copyright © 2015 Vadim Goncharov. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    // Sounds
    var btnSound: AVAudioPlayer!
    var clearSound: AVAudioPlayer!
    
    // Numbers
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        let clearPath = NSBundle.mainBundle().pathForResource("clear", ofType: "wav")
        let clearUrl = NSURL(fileURLWithPath: clearPath!)
        
        // Initial Number set to 0
        runningNumber = "0"
        
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
            btnSound.prepareToPlay()
            
            try clearSound = AVAudioPlayer(contentsOfURL: clearUrl)
            clearSound.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
    
    // Clear Pressed
    @IBAction func clearPressed(sender: AnyObject) {
        clearSound.play()
        runningNumber = "0"
        leftValStr = ""
        rightValStr = ""
        outputLbl.text = "0"
        currentOperation = Operation.Empty
    }
    
    // Number Pressed
    @IBAction func numberPressed(btn: UIButton!) {
        playSound()
        
        runningNumber += "\(btn.tag)"
        outputLbl.text = runningNumber
    }

    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }

    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }

    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    // Process Operation
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            // Run some math
            
            // A user selected operator but then selected another 
            // operator without fist entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            
            currentOperation = op
            
        } else {
            // This is first time operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    // Play Sounds
    func playSound() {
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
}

