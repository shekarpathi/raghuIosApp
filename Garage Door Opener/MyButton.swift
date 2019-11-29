//
//  MyButton.swift
//  IOT
//
//  Created by Lakshmipathi, Shekar on 5/27/18.
//  Copyright © 2018 Lakshmipathi, Shekar. All rights reserved.
//
import UIKit

@IBDesignable class MyButton: UIButton
{
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
            self.backgroundColor = UIColor.orange
        }
    }
    /*
     @IBInspectable var backgroundColor: CGColor = UIColor.orange as! CGColor{
     didSet{
     self.layer.borderWidth = borderWidth
     self.backgroundColor = UIColor.orange
     }
     test
     }*/
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
