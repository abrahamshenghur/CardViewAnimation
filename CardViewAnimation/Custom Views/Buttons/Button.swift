//
//  Button.swift
//  CardViewAnimation
//
//  Created by John on 7/18/21.
//  Copyright © 2021 Brian Advent. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
    }
}
