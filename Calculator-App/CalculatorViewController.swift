//
//  ViewController.swift
//  Calculator-App
//
//  Created by Zsolt Szabo on 2/4/17.
//  Copyright © 2017 Zsolt Szabo. All rights reserved.
//
import UIKit

class CalculatorViewController: UIViewController {

    // Implicitly unwrapped optional
    // Instead of using ? we force it to unwrap the optional's value
    @IBOutlet private weak var displayWindow: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var userIsInTheMiddleOfTyping = false;
    
    private var calculatorService = CalculatorService()
    
    // In order to avoid constantly converting values to String in orderd to be displayed
    // Using a computed property a bridge is created between the Label and the code
    private var displayValue: Double {
        get {
            // The conversion result is an optional since some string are not convertable (e.g. "Food" -> Well try to convert this...)
            return Double(displayWindow.text!)!;
        }
        set {
            displayWindow.text = String(newValue);
            print(calculatorService.getDescription())
            descriptionLabel.text = calculatorService.getDescription()
        }
    }

    @IBAction func backSpace(_ sender: Any) {
        
        // If there was no typing then there's nothing to delete
        guard userIsInTheMiddleOfTyping == true else {
            return
        }
        
        // Just for safety, if the label has no text the code returns
        guard let currentText = displayWindow.text else {
            return
        }
        
        displayWindow.text = currentText.substring(to: currentText.index(before: currentText.endIndex))
        //If there's nothing in the new text we set it to a default "0" in order for the label to keep it's size
        if(displayWindow.text?.isEmpty)!{
            displayWindow.text = "0"
            userIsInTheMiddleOfTyping = false;
        }
    }
    
    @IBAction func clearWindow(_ sender: UIButton) {
        displayWindow.text = "0"
        userIsInTheMiddleOfTyping = false
        calculatorService.clear()
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!;
        // If there's already a number being constructed let's not wipe it by overwriting
        if userIsInTheMiddleOfTyping {
            let textCurrentlyDisplayed = displayWindow.text!;
            displayWindow.text = textCurrentlyDisplayed + digit;
        } else {
            displayWindow.text = digit;
        }
        userIsInTheMiddleOfTyping = true;
    }

    // Handles decimal number creation
    @IBAction func touchDecimal(_ sender: UIButton) {
        if(displayWindow.text?.range(of: ".") == nil){
            displayWindow.text = userIsInTheMiddleOfTyping ? displayWindow.text! + "." : "0."
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        // After an operation is requested the display can be overwritten and the accumulator will be set
        if(userIsInTheMiddleOfTyping){
            calculatorService.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        // Instead of mathematicalSymbol = sender.currentTitle!
        // Make sure the sender has a title set
        if let mathematicalSymbol = sender.currentTitle {
            calculatorService.performOperation(symbol: mathematicalSymbol)
        }
        updateUI()
    }
    
    @IBAction func setVariable() {
        calculatorService.setVariable(variable: "M", value: displayValue)
        // Since the last continuing operation chain has been saved
        // We can simply execute the operations again with a new value for M
        // Triggers set: calculatorService.program = calculatorService.program
        calculatorService.executeProgram()
        userIsInTheMiddleOfTyping = false
        updateUI()
    }

    @IBAction func insertVariable() {
        calculatorService.setOperand(variable: "M")
        updateUI()
    }
    
    func updateUI(){
        displayValue = calculatorService.getResult()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "Draw Function":
                    print("faszom1")
                    // If the computations are fully specified (e.g. 3 + M x ...)
                    guard !calculatorService.isPartialResult else {
                        print(Constants.Error.partialResult)
                        return
                    }
                    
                    // Following the practice from the class
                    
                    // If the destination can be interpreted as a UINavigationController
                    // This case is for the case when the segue points to a NavigationController not the actual PlotViewController
                    var destinationVC = segue.destination
                    if let nvc = destinationVC as? UINavigationController {
                        destinationVC = nvc.visibleViewController ?? destinationVC
                    }
                    
                    // If the destination can be interpreted as a PlotViewController
                    if let vc = destinationVC as? PlotViewController {
                        // Set the title of the new view in the Nav Controller
                        vc.navigationItem.title = calculatorService.getDescription()
                        vc.function = {
                            (x: CGFloat) -> Double in
                            self.calculatorService.setVariable(variable: "M", value: Double(x))
                            self.calculatorService.executeProgram()
                            return self.calculatorService.getResult()
                        }
                    }
                    print("faszom")
                
                default: break
            }
        }
    }
    
}

