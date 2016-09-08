//
//  CustomAnnotationView.swift
//  
//
//  Created by Michael Gerasimov on 9/3/16.
//
//

import UIKit
import MapKit


// Annotation Shape Constants
struct ASC {
    static let height:CGFloat = width * 3
    static let width:CGFloat = 20
    static let center = CGPointMake(width/2, height/2)
    static let bottomMiddlePoint = CGPointMake(center.x, height)
    static var controlPoint1 = CGPointMake(0, (ASC.height / 4) * 3)
    static let controlPoint2 = CGPointMake(center.x, (ASC.height / 8) * 5)
}

class CustomAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        print("init.annotation")
        frame = CGRectMake(0, 0, ASC.width, ASC.height)
        backgroundColor = UIColor.clearColor()
        canShowCallout = true
        centerOffset = CGPointMake(0, -ASC.height / 2)
        calloutOffset = CGPointMake(0, ASC.height / 4)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init.frame")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let leftSidePath = UIBezierPath(arcCenter: ASC.center, radius: ASC.width/2, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI), clockwise: false)
        
        leftSidePath.addCurveToPoint(ASC.bottomMiddlePoint, controlPoint1: ASC.controlPoint1, controlPoint2: ASC.controlPoint2)

        leftSidePath.closePath()
        
        UIColor(r: 249, g: 107, b: 96, alpha: 1.0).setFill()
        leftSidePath.fill()
        
        let rightSidePath = leftSidePath
        CGContextTranslateCTM(context,ASC.width,0)
        CGContextScaleCTM (context,-1.0, 1.0)
        
        rightSidePath.fill()
        
        let smallCirclePath = UIBezierPath(arcCenter:ASC.center, radius: ASC.width/4, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        UIColor(r: 130, g: 31, b: 14, alpha: 1.0).setFill()
        UIColor.init(white: 0.5, alpha: 0.5).setStroke()
        smallCirclePath.fill()
        smallCirclePath.stroke()
        
    }
}

extension UIColor{
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat)
    {
      self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}
