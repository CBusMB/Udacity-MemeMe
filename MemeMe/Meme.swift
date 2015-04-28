//
//  Meme.swift
//  MemeMe
//
//  Created by Matthew Brown on 4/27/15.
//  Copyright (c) 2015 Crest Technologies. All rights reserved.
//


import UIKit

struct Meme
{
    var image: UIImage
    var memeImage: UIImage
    private var topText: String
    private var bottomText: String
    
    init(image: UIImage, memeImage: UIImage, topText: String, bottomText: String) {
        self.image = image
        self.memeImage = memeImage
        self.topText = topText
        self.bottomText = bottomText
    }
}
