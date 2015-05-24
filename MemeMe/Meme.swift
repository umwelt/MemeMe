//
//  Meme.swift
//  MemeMe
//
//  Created by Hugo Adolfo Perez Solorzano on 22/05/15.
//  Copyright (c) 2015 bmgh. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText: String = ""
    var bottomText: String = ""
    var originalImage: UIImage
    var memedImage: UIImage
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    
}
