//
//  CustomButton.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 08.10.2021.
//

import Foundation
import UIKit

class CustomButton : UIButton{
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 343, height: 56))
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    private func setup(){
        backgroundColor = .white
        layer.cornerRadius = 28
        setTitleColor(UIColor(named: "PinkColor"), for: .normal)
        
        
        layer.shadowColor = UIColor(named: "ShadowForButton")?.cgColor
        layer.shadowRadius = 24
        
        layer.shadowOpacity = 1
        layer.shadowOffset  = CGSize(width: 0, height: 4)
        
    }
    
    
}
