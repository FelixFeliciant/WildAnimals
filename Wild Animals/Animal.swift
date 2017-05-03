//
//  Animal.swift
//  Wild Animals
//
//  Created by Felix Feliciant on 4/30/17.
//  Copyright © 2017 FelixFeliciant. All rights reserved.
//

import UIKit

class Animal: NSObject {
    
    var caption: String?
    var text: String?
    var images: [[String: String]]?
    
    
    func hasMultipleImages() -> Bool {
        return (self.images?.count)! > 1
    }
    
}
