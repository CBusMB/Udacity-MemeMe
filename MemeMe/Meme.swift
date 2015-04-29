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
    private(set) var image: UIImage
    private(set) var memeImage: UIImage
    private(set) var topText: String
    private(set) var bottomText: String
    
    init(image: UIImage, memeImage: UIImage, topText: String, bottomText: String) {
        self.image = image
        self.memeImage = memeImage
        self.topText = topText
        self.bottomText = bottomText
    }
}