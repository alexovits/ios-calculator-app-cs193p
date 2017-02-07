//
//  CalculatorService.swift
//  Calculator-App
//
//  Created by Zsolt Szabo on 2/5/17.
//  Copyright © 2017 Zsolt Szabo. All rights reserved.
//

import Foundation

class CalculatorService {
    
    private var acc = 0.0
    
    private var descriptionAcc = " "
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String)
        case Equals
    }
    
    // When doing binary ops the operation function and the first operand have to be remembered
    struct PendingBinaryOpeartionInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descFunction: (String,String) -> String
        var descOperand: String
    }
    
    // This has to be optional because if there's no pending operation I want to be able to handle if it is not set
    private var pending : PendingBinaryOpeartionInfo?
    
    private var operationDict: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "±": Operation.UnaryOperation({-$0}, { "-(\($0))"}),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt, { "√(\($0))"}),
        "cos" : Operation.UnaryOperation(cos, { "cos(\($0))"}),
        "✕" : Operation.BinaryOperation({$0 * $1}, { "\($0) × \($1)"}),
        "÷" : Operation.BinaryOperation({$0 / $1}, { "\($0) / \($1)"}),
        "+" : Operation.BinaryOperation({$0 + $1}, { "\($0) + \($1)"}),
        "-" : Operation.BinaryOperation({$0 - $1}, { "\($0) - \($1)"}),
        "=" : Operation.Equals
    ]
    
    func performOperation(symbol: String){
        // Only if the symbol has an associated Operation in the dictionary
        if let operation = operationDict[symbol] {
            switch operation {
            // Using let value as a pattern matching for the enum
            case .Constant(let value):
                acc = value
                // Make sure special constants like π are shown as symbols
                descriptionAcc = symbol
                
            case .UnaryOperation(let function, let descriptionFunction):
                acc = function(acc)
                descriptionAcc = descriptionFunction(descriptionAcc)
               
            case .BinaryOperation(let function, let descriptionFunction):
                executePendingBinaryOperation()
                // Saving information about the pending operation
                pending = PendingBinaryOpeartionInfo(binaryFunction: function, firstOperand: acc, descFunction: descriptionFunction, descOperand: descriptionAcc)
                
            case .Equals:
                executePendingBinaryOperation()
                
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if(pending != nil){
            acc = pending!.binaryFunction(pending!.firstOperand, acc)
            descriptionAcc = pending!.descFunction(pending!.descOperand, descriptionAcc)
            pending = nil
        }
    }
    
    // Publicly available methods
    
    func setOperand(operand: Double){
        acc = operand
        descriptionAcc = String(operand)
    }
    
    // Setting everything to the defaults
    func clear(){
        acc = 0.0
        pending = nil
        descriptionAcc = " "
    }
    
    // Instead of var result: Double { get { return acc; } }
    func getResult() -> (Double){
        return acc
    }
    
    func getDescription() -> (String){
        var temporaryAppend = "..."
        if descriptionAcc != pending?.descOperand{
            temporaryAppend = String(descriptionAcc)
        }
        return (pending != nil) ? pending!.descFunction(pending!.descOperand, temporaryAppend) : descriptionAcc + " ="
    }
    
}
