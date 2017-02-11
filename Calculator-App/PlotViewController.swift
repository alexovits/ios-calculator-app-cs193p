//
//  PlotViewController.swift
//  Calculator-App
//
//  Created by Zsolt Szabo on 2/10/17.
//  Copyright © 2017 Zsolt Szabo. All rights reserved.
//

import UIKit

protocol PlotViewDataSource {
    func getBounds() -> CGRect
    func getFunctionValue(x: CGFloat) -> CGFloat?
}

class PlotViewController: UIViewController, PlotViewDataSource {

    @IBOutlet weak var plotView: PlotView!{
        didSet {
            plotView.addGestureRecognizer(UIPinchGestureRecognizer(target: plotView, action: #selector(plotView.zoom(_:))))
            plotView.addGestureRecognizer(UIPanGestureRecognizer(target: plotView, action: #selector(plotView.pan(_:))))
            
            let recognizer = UITapGestureRecognizer(target: plotView, action: #selector(plotView.doubleTap(_:)))
            recognizer.numberOfTapsRequired = 2 // single tap, double tap, etc.
            plotView.addGestureRecognizer(recognizer)
        }
    }
    
    func getBounds() -> CGRect {
        return navigationController?.view.bounds ?? view.bounds
    }
    
    func getFunctionValue(x: CGFloat) -> CGFloat? {
        if let function = function {
            return CGFloat(function(x))
        }
        return nil
    }
    
    var function: ((CGFloat) -> Double)?
}
