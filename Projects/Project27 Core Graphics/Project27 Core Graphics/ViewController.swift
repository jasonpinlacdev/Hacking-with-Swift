//
//  ViewController.swift
//  Project27 Core Graphics
//
//  Created by Jason Pinlac on 3/15/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentDrawType = -1 {
        didSet {
            drawTypeLabel.text = "Current draw type: \(currentDrawType)"
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var drawTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        drawTypeLabel.textColor = UIColor.black
    }
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            drawTwin()
        default:
            break
        }
        
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 414, height: 414))
        let renderedImage = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 414, height: 414)
            ctx.cgContext.setFillColor(UIColor.systemRed.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: CGPathDrawingMode.fillStroke)
        }
        imageView.image = renderedImage
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 414, height: 414))
        let renderedImage = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 414, height: 414).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = renderedImage
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 414, height: 414))
        let renderedImage = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            for row in 0..<8 {
                for column in 0..<8 {
                    if (row + column) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: CGFloat(column) * 51.75, y: CGFloat(row) * 51.75, width: 51.75, height: 51.75))
                    }
                }
            }
        }
        imageView.image = renderedImage
    }
    
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 414, height: 414))
        let renderedImaged = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 207, y: 207)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -103.5, y: -103.5, width: 207, height: 207))
                ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                ctx.cgContext.strokePath()
            }
        }
        imageView.image = renderedImaged
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 414, height: 414))
        let renderedImage = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 207, y: 207)
            var first = true
            var length: CGFloat = 207.0
            
            for _ in 0 ..< 207 {
                ctx.cgContext.rotate(by: .pi/2)
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50.0))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50.0))
                }
                length *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
           }
        imageView.image = renderedImage
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 414, height: 414))
        let renderedImage = renderer.image { ctx in
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 150, y: 100))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.center
        
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 350, height: 350), options: .usesLineFragmentOrigin, context: nil)
            
        }
        imageView.image = renderedImage
    }
    
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 414, height: 414))
        let renderedImage = renderer.image { ctx in
            
            let faceRectangle = CGRect(x: 0, y: 0, width: 414, height: 414).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(2)
            ctx.cgContext.addEllipse(in: faceRectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let leftEyeRectangle = CGRect(x: 207 - 100, y: 100, width: 50, height: 75)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: leftEyeRectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            

            let rightEyeRectangle = CGRect(x: 207 + 50, y: 100, width: 50, height: 75)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: rightEyeRectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let firstPoint = CGPoint(x: 107, y: 250)
            ctx.cgContext.move(to: firstPoint)
            let secondPoint = CGPoint(x: 307, y: 250)
            let controlPoint = CGPoint(x: 207, y: 350)
            ctx.cgContext.addQuadCurve(to: secondPoint, control: controlPoint)
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.strokePath()
        }
        imageView.image = renderedImage
    }
    
    func drawTwin() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 414, height: 414))
        let renderedImage = renderer.image { ctx in
            // T
            ctx.cgContext.move(to: CGPoint(x: 50, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 50))
            
            ctx.cgContext.move(to: CGPoint(x: 75, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 75, y: 125))
            
            // W
            ctx.cgContext.move(to: CGPoint(x: 110, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 122.5, y: 120))
            ctx.cgContext.addLine(to: CGPoint(x: 132.5, y: 65))
            ctx.cgContext.addLine(to: CGPoint(x: 142.5, y: 120))
            ctx.cgContext.addLine(to: CGPoint(x: 152.5, y: 50))
            
            // I
            ctx.cgContext.move(to: CGPoint(x: 162.5, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 212.5, y: 50))
            
            ctx.cgContext.move(to: CGPoint(x: 187.5, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 187.5, y: 125))
            
            ctx.cgContext.move(to: CGPoint(x: 162.5, y: 125))
            ctx.cgContext.addLine(to: CGPoint(x: 212.5, y: 125))
            
            // N
            ctx.cgContext.move(to: CGPoint(x: 222.5, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 222.5, y: 125))
            
            ctx.cgContext.move(to: CGPoint(x: 222.5, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 272.5, y: 125))
            
            ctx.cgContext.move(to: CGPoint(x: 272.5, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 272.5, y: 125))
            
            ctx.cgContext.setLineWidth(2)
            ctx.cgContext.strokePath()
        }
        imageView.image = renderedImage
    }
}

