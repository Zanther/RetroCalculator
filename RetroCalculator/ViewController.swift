//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Steven Lattenhauer 2nd on 6/22/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var btnSound: AVAudioPlayer!
    
    // Calculator Variables
    var runningNumber = ""
    var currentOperation = Operation.Empty
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    enum Operation: String {
       case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Addition = "+"
        case Empty = "Empty"
        case Clear = "Clear"
    }
    
    @IBOutlet var outputLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf:soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLbl.text = "0"
        
        
    }

    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender:Any) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender:Any) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender:Any) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAdditionPressed(sender:Any) {
        processOperation(operation: .Addition)
    }
    
    @IBAction func onEqualPress(sender:Any) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClearPress(_ sender: Any) {
        currentOperation = .Clear
        processOperation(operation: .Clear)
    }
    
    
    func playSound () {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation: Operation){
        playSound()
        if currentOperation != Operation.Empty{
            // A user selected an operator, but then selected another operator without Frist entering a number
            if currentOperation == Operation.Clear {
                print("clear pressed")
                runningNumber = ""
                leftValStr = ""
                result = ""
                outputLbl.text = "0"
                currentOperation = Operation.Empty
                return
            }
            
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                    
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                    
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                    
                } else if currentOperation == Operation.Addition {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
            
                leftValStr = result
                outputLbl.text = result
        
            }
            currentOperation = operation
        } else {
            //This is the first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
        
    }


}

