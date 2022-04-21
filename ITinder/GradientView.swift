//
//  GradientView.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 08.10.2021.
//

import Foundation
import UIKit

class GradientView: UIButton {
    
    enum Point {
        case topLeading
        case leading
        case bottomLeading
        case top
        case center
        case bottom
        case topTrailing
        case trailing
        case bottomTrailing

        var point: CGPoint {
            switch self {
            case .topLeading:
                return CGPoint(x: 0, y: 0)
            case .leading:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeading:
                return CGPoint(x: 0, y: 1.0)
            case .top:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottom:
                return CGPoint(x: 0.5, y: 1.0)
            case .topTrailing:
                return CGPoint(x: 1.0, y: 0.0)
            case .trailing:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomTrailing:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
//    @IBInspectable private var startColor: UIColor? {
//        didSet {
//            setupGradientColors()
//        }
//    }
//
//    @IBInspectable private var endColor: UIColor? {
//        didSet {
//            setupGradientColors()
//        }
//    }
    
    private let gradientLayer = CAGradientLayer()
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupGradient()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 28    }
    
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        
        
        setupGradientColors()
        gradientLayer.startPoint = Point.leading.point
        gradientLayer.endPoint = Point.trailing.point
        
        
    }
    
    private func setupGradientColors() {
        gradientLayer.colors = [UIColor(named: "PinkColor")?.cgColor as Any,UIColor(named: "PurpleColor")?.cgColor as Any]

//        if let startColor = startColor, let endColor = endColor {
//            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//        }
    }

    
    private func setup(){
        layer.cornerRadius = 16
        setTitleColor( .white, for: .normal)
        
    }
    
}
