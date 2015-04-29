//
//  MemeCollection.swift
//  MemeMe
//
//  Created by Matthew Brown on 4/28/15.
//  Copyright (c) 2015 Crest Technologies. All rights reserved.
//

import Foundation

class MemeCollection
{
    static let collection = MemeCollection()
    
    private var memes = [Meme]()
    
    var memeCollection: [Meme] {
        get {
            return memes
        }
    }
    
    func addMemeToCollection(meme: Meme) {
        memes.append(meme)
    }
    
//    func removeMemeFromCollection(meme: Meme) {
//        collection.removeAtIndex(<,#index: Int#>)
//    }

}
