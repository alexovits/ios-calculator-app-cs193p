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
    private var internalProgram = [AnyObject]()
    private var descriptionAcc = " "
    private var variableValues = Dictionary<String, Double>()
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
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
    
    typealias PropertyList = AnyObject
    
    // This doesn't return the internal data structure since Array is value type it sends a copy of itself
    var program: PropertyList {
        get {
            return internalProgram as CalculatorService.PropertyList
        }
        
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps {
                    if let operand = op as? Double{
                        setOperand(operand: operand)
                    }else if let operand = op as? String{
                        // If the saved symbol is a variable symbol existing in out dictionary
                        if variableValues[operand] != nil{
                            setOperand(variable: operand)
                        }else{
                            performOperation(symbol: operand)
                        }
                    }
                }
            }
        }
    }
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
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
    func setOperand(variable: String){
        // If it's not a new variable just keep it's value
        variableValues[variable] = variableValues[variable] ?? 0.0
        acc = variableValues[variable]!
        descriptionAcc = variable
        internalProgram.append(variable as AnyObject)
    }
    
    func setOperand(operand: Double){
        acc = operand
        descriptionAcc = String(operand)
        internalProgram.append(operand as AnyObject)
    }
    
    // Setting everything to the defaults
    func clear(){
        acc = 0.0
        pending = nil
        descriptionAcc = " "
        internalProgram.removeAll()
    }
    
    // Instead of var result: Double { get { return acc; } }
    func getResult() -> (Double){
        return acc
    }
    
    func getDescription() -> (String){
        var temporaryAppend = "..."
        //print(descriptionAcc)
        //print(pending?.descOperand)
        if descriptionAcc != pending?.descOperand{
            temporaryAppend = String(descriptionAcc)
        }
        return isPartialResult ? pending!.descFunction(pending!.descOperand, temporaryAppend) : descriptionAcc + " ="
    }
    
    func setVariable(variable: String, value: Double){
        guard variableValues[variable] != nil else {
            return
        }
        
        variableValues[variable]! = value
    }
    
    func executeProgram(){
        for op in internalProgram {
            if let operand = op as? Double{
                setOperand(operand: operand)
            }else if let operand = op as? String{
                // If the saved symbol is a variable symbol existing in out dictionary
                if variableValues[operand] != nil{
                    setOperand(variable: operand)
                }else{
                    performOperation(symbol: operand)
                }
            }
        }
    }
    
    // For an undo function just delete tha last element from internalProgram...
    
}
