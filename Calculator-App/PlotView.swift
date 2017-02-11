//
//  PlotView.swift
//  Calculator-App
//
//  Created by Zsolt Szabo on 2/10/17.
//  Copyright © 2017 Zsolt Szabo. All rights reserved.
//

import UIKit

@IBDesignable
class PlotView: UIView {

    // Paul Hegarty's class for drawing the Descartes coordinate system
    private let axesDrawer = AxesDrawer(color: UIColor.blue)
    
    @IBInspectable
    var origin: CGPoint! { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var scale = CGFloat(Constants.Graphic.pointsPerUnit) { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color = UIColor.black { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    
    // Accessing the viewController as a protocol that provides acces to the function and the bounds
    var dataSource: PlotViewDataSource?
    
    func doubleTap(recognizer: UITapGestureRecognizer) {
        // Double taps sets the origin to the new point that was just tapped
        if recognizer.state == .ended {
            origin = recognizer.location(in: self)
        }
    }
    
    func zoomIn(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
            
            case .changed, .ended:
                // Since the recognizer.scale is accumulative we always want it to be relative to our current size
                scale *= recognizer.scale
                recognizer.scale = 1.0
            
            default: break
        }
    }
    
    func panTo(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case .changed: fallthrough
            case .ended:
                let translation = recognizer.translation(in: self)
                // Since the pan the entire axes model should move
                origin.x += translation.x
                origin.y += translation.y
                // The same accumulative reason
                recognizer.setTranslation(CGPoint.zero, in: self)
            default: break
        }
    }
    
    override func draw(_ rect: CGRect) {
        // If origin is already set it's cool
        // If not then take the view's center as origin (e.g. The)
        print("Fuckoff")
        origin = origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        
        color.set()
        //pathForFunction().stroke()
        
        axesDrawer.drawAxesInRect(bounds: dataSource?.getBounds() ?? bounds, origin: origin, pointsPerUnit: scale)
    }
    
    
}
