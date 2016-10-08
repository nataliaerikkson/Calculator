//
//  ViewController.swift
//  Calculator
//
//  Created by Natalia on 29/09/16.
//  Copyright © 2016 NataliaSoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    private var calc = CalculatorModel()
    private var isTyping: Bool = false
    private var wasSeparator: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayValue = 0
        history.text = ""
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let buffer = display.text!
        
        if digit == "." {
            if !wasSeparator {
                wasSeparator = true
            }
            else {
                return
            }
        }

        if isTyping {
            display.text = buffer + digit
        } else {
            display.text = digit
        }
        
        isTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = calc.formatValue(value: newValue)
        }
    }

    @IBAction func touchOperation(_ sender: UIButton) {
        if isTyping {
            calc.setOperand(operand: displayValue)
            isTyping = false
        }

        if let operationSymbol = sender.currentTitle {
            calc.performOperation(symbol: operationSymbol)
        }
        
        displayValue = calc.result
        history.text = calc.history
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        isTyping = false
        wasSeparator = false
        calc.reset()
        displayValue = calc.result
        history.text = ""
        
    }
    
}

