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

    @IBInspectable
    var origin: CGPoint! { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var scale = CGFloat(Constants.Drawing.pointsPerUnit) { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color = UIColor.black { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    
    var dataSource: GraphViewDataSource?
    private let drawer = AxesDrawer(color: UIColor.blueColor())
    
}
