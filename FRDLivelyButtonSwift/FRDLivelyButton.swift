//
//  FRDLivelyButton.swift
//  FRDLivelyButtonSwift
//
//  Created by Calios on 8/18/17.
//  Copyright © 2017 Calios. All rights reserved.
//

import UIKit

class FRDLivelyButton: UIButton {
	enum FRDLivelyButtonStyle: Int {
		case hamburger
		case close
		case circlePlus
		case circleClose
		case caretUp
		case caretDown
		case caretLeft
		case caretRight
		case arrowLeft
		case arrowRight
	}
	
	enum FRDLiveButtonOption: String {
		case color
		case lineWidth
		case animationDuration
	}
	
	open var options: Dictionary<String, Any>? {
		get {
			return nil	// ????
		}
		set {
			[line2Layer, line3Layer].forEach { element in
				// TODO:
				element.lineWidth = defaultOptions[FRDLiveButtonOption.lineWidth.rawValue] as! CGFloat
				element.strokeColor = (defaultOptions[FRDLiveButtonOption.color.rawValue] as! CGColor)
			}
		}
	}
	
	open let defaultOptions: [String : Any] = [ FRDLiveButtonOption.color.rawValue: UIColor.white.cgColor,
	                            FRDLiveButtonOption.lineWidth.rawValue: CGFloat(3.0),
	                            FRDLiveButtonOption.animationDuration.rawValue: 0.3]
	
	open var buttonStyle: FRDLivelyButtonStyle = .caretUp
	open func setStyle(_ style: FRDLivelyButtonStyle, animated: Bool) {
		buttonStyle = style
		
//		var newCirclePath = CGMutablePath()
//		var newLine1Path  = CGMutablePath()
		var newLine2Path  = CGMutablePath()
		var newLine3Path  = CGMutablePath()
		
//		var newCircleAlpha = 0.0
//		var newLineAlpha = 0.0
		
		if style == .caretUp {
			newLine2Path = createCenteredLine(with: dimension/4.0 - line2Layer.lineWidth/2.0, angle: .pi/4, offset: CGPoint(x: dimension/6.0, y: 0.0))
			newLine3Path = createCenteredLine(with: dimension/4.0 - line3Layer.lineWidth/2.0, angle: 3 * .pi/4, offset: CGPoint(x: -dimension/6.0, y: 0.0))
		} else if style == .caretDown {
			newLine2Path = createCenteredLine(with: dimension/4.0 - line2Layer.lineWidth/2.0, angle: -.pi/4, offset: CGPoint(x: dimension/6.0, y: 0.0))
			newLine3Path = createCenteredLine(with: dimension/4.0 - line3Layer.lineWidth/2.0, angle: -3 * .pi/4, offset: CGPoint(x: -dimension/6.0, y: 0.0))
		}
		
		let duration = defaultOptions[FRDLiveButtonOption.animationDuration.rawValue]
		
		// add animation for line2
		let line2Anim = CABasicAnimation(keyPath: "path")
		line2Anim.isRemovedOnCompletion = false
		line2Anim.duration = (duration as? Double)!
		line2Anim.fromValue = line2Layer.path
		line2Anim.toValue = newLine2Path
		line2Anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
		line2Layer.add(line2Anim, forKey: "animateLine2Path")
		
		// add animation for line3
		let line3Anim = CABasicAnimation(keyPath: "path")
		line3Anim.isRemovedOnCompletion = false
		line3Anim.duration = (duration as? Double)!
		line3Anim.fromValue = line3Layer.path
		line3Anim.toValue = newLine3Path
		line3Anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
		line3Layer.add(line3Anim, forKey: "animateLine3Path")

		line2Layer.path = newLine2Path
		line3Layer.path = newLine3Path
	}
	
	// MARK: private
	private var dimension: CGFloat = 0
	private var offset = CGPoint()
	private var centerPoint = CGPoint()
	
	private var line1Layer = CAShapeLayer()
	private var line2Layer = CAShapeLayer()
	private var line3Layer = CAShapeLayer()
	
	private var shapeLayers: [CAShapeLayer]? {
		return [line1Layer, line2Layer, line3Layer]
	}
	
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInitializer()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInitializer()
	}
	
	deinit {
		layer.sublayers?.forEach { sub in
			sub.removeAllAnimations()
		}
		layer.removeAllAnimations()
	}
	
	private func commonInitializer() {
		
		options = defaultOptions
		
		[line2Layer, line3Layer].forEach { element in
			element.fillColor = UIColor.blue.cgColor
			element.anchorPoint = CGPoint(x: 0.0, y: 0.0)
			element.lineJoin = kCALineJoinRound
			element.lineCap = kCALineCapRound
			element.contentsScale = layer.contentsScale
			
			let dummyPath = CGMutablePath()
			element.path = dummyPath
			layer.addSublayer(element)
		}
		
		// TODO: add highlight and unhighlight
		
		let width = frame.width - (contentEdgeInsets.left + contentEdgeInsets.right)
		let height = frame.height - (contentEdgeInsets.top + contentEdgeInsets.bottom)
		
		dimension = min(width, height)
		offset = CGPoint(x: (frame.width - dimension)/2.0, y: (frame.height - dimension)/2.0)
		centerPoint = CGPoint(x: width/2.0, y: height/2.0)//CGPoint(x: self.bounds.minX, y: self.bounds.minY)
	}
	
	// MARK: transform
	private func createCenteredLine(with radius: CGFloat, angle: CGFloat, offset: CGPoint) -> CGMutablePath {
		let path = CGMutablePath()
		
		let c = cos(angle)
		let s = sin(angle)
		
		path.move(to: CGPoint(x: centerPoint.x + offset.x + radius * c,
		                      y: centerPoint.y + offset.y + radius * s))
		path.addLine(to: CGPoint(x: centerPoint.x + offset.x - radius * c,
		                         y: centerPoint.y + offset.y - radius * s))
		return path
	}
	
}
