//
//  Slider.swift
//  StarburstCamera
//
//  Created by leo on 2017/11/15.
//  Copyright © 2017年 ltebean. All rights reserved.
//

import UIKit

@IBDesignable
class Slider: UISlider {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    
    open func load() {
        setThumbImage(UIImage(named: "icon-slider"), for: .normal)
        setThumbImage(UIImage(named: "icon-slider"), for: .highlighted)
    }
}
