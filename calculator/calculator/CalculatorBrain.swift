//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Kateryna Arapova on 15.04.17.
//  Copyright © 2017 cs193p. All rights reserved.
//

import Foundation


struct CalculatorBrain {
    
    private var accumulator: Double?
    private var descriptionAccumulator: String?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "C" : Operation.constant(0),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "±" : Operation.unaryOperation({ -$0 }),
        "%" : Operation.unaryOperation({ $0 / 100 }),
        "10ˣ" : Operation.unaryOperation({ $0 * 10 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                descriptionAccumulator = String(value)
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    //print(descriptionAccumulator)
                    descriptionAccumulator = "\(symbol)(\(descriptionAccumulator!))"
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                print("binary")
                if accumulator != nil {
                    //descriptionAccumulator = "\(descriptionAccumulator!) \(symbol)"
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!, descriptionFunction: {$0 + " " + symbol + " " + $1}, descriptionOperand: descriptionAccumulator!)
                    accumulator = nil
                    descriptionAccumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            descriptionAccumulator = pendingBinaryOperation!.show(with: accumulator!)
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        func show(with secondOperand: Double) -> String {
            print("=")
            return descriptionFunction(descriptionOperand, String(secondOperand))
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        descriptionAccumulator = String(operand)
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var description: String? {
        get {
            if resultIsPending {
                return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand, descriptionAccumulator ?? " ")
            } else {
                return descriptionAccumulator
            }
        }
    }
}
