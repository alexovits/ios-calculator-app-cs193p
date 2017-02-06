//
//  CalculatorService.swift
//  Calculator-App
//
//  Created by Zsolt Szabo on 2/5/17.
//  Copyright © 2017 Zsolt Szabo. All rights reserved.
//

import Foundation

class CalculatorService {
    
    private var acc = 0.0;
    
    var result: Double {
        get {
            return acc;
        }
    }
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    // When doing binary ops the operation function and the first operand have to be remembered
    struct PendingBinaryOpeartionInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    // This has to be optional because if there's no pending operation I want to be able to handle if it is not set
    private var pending : PendingBinaryOpeartionInfo?
    
    private var operationDict: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "±": Operation.UnaryOperation({-$0}),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "✕" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals
    ]
    
    func setOperand(operand: Double){
        acc = operand
    }
    
    func performOperation(symbol: String){
        // Only if the symbol has an associated Operation in the dictionary
        if let operation = operationDict[symbol] {
            switch operation {
            // Using let value as a pattern matching for the enum
            case .Constant(let value):
                acc = value
                
            case .UnaryOperation(let function):
                acc = function(acc)
               
            case .BinaryOperation(let function):
                pending = PendingBinaryOpeartionInfo(binaryFunction: function, firstOperand: acc)
            
            case .Equals:
                executePendingBinaryOperation()
                
            default:
                break
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if(pending != nil){
            acc = pending!.binaryFunction(pending!.firstOperand, acc)
            pending = nil
        }
    }
    
    
}
