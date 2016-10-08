//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Natalia on 03/10/16.
//  Copyright © 2016 NataliaSoftware. All rights reserved.
//

import Foundation

class CalculatorModel {

    private var accumulator = 0.0
    private var pending: PendingBinaryOperationInfo?
    private var historyBuffer = ""

    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var history: String {
        get {
            return historyBuffer
        }
    }
    
    func setOperand(operand: Double)
    {
        accumulator = operand
    }
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinnaryOperation((Double, Double) -> Double)
        case Equals
    }

    private var operations: Dictionary<String, Operation> = [
        "π"  : Operation.Constant(M_PI),
        "e"  : Operation.Constant(M_E),
        "±"  : Operation.UnaryOperation( {-$0} ),
        "√"  : Operation.UnaryOperation( sqrt ),
        "sin": Operation.UnaryOperation( sin ),
        "cos": Operation.UnaryOperation( cos ),
        "tan": Operation.UnaryOperation( tan ),
        "1/x": Operation.UnaryOperation( {1 / $0} ),
        "+"  : Operation.BinnaryOperation( {$0 + $1} ),
        "−"  : Operation.BinnaryOperation( {$0 - $1} ),
        "×"  : Operation.BinnaryOperation( {$0 * $1} ),
        "÷"  : Operation.BinnaryOperation( {$0 / $1} ),
        "="  : Operation.Equals
    ]

    private func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                case .Constant(let value):
                    accumulator = value
                    historyBuffer += symbol
                case .UnaryOperation(let function):
                    accumulator = function(accumulator)
                    historyBuffer = symbol + "(" + historyBuffer + ")"
                case .BinnaryOperation(let function):
                    historyBuffer += formatValue(value: accumulator)
                    historyBuffer += symbol
                    executePendingBinaryOperation()
                    pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                case .Equals:
                    historyBuffer += formatValue(value: accumulator)
                    executePendingBinaryOperation()
                    historyBuffer += symbol
            }
        }
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }

    func reset()
    {
        accumulator = 0.0
        historyBuffer = ""
        pending = nil
    }
    
    func formatValue(value: Double) -> String {
        let v = value - round(value)
        
        if v == 0 {
            return String(Int(round(value)))
        }
        
        return String(value)
    }

}
