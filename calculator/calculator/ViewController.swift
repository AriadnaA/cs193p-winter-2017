//
//  ViewController.swift
//  calculator
//
//  Created by Kateryna Arapova on 31.03.17.
//  Copyright © 2017 cs193p. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTyping = false

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if textCurrentlyInDisplay.range(of: ".") == nil || digit != "."{
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            if digit == "." {
                display.text = "0\(digit)"
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTyping = true
        }
        if brain.resultIsPending {
            //print("resultIsPending = \(digit)")
            history.text! += digit
        } else {
            //print("second = \(digit)")
            history.text! += digit
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if(userIsInTheMiddleOfTyping) {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        history.text = brain.description ?? " "
    }
    
    
    
}
