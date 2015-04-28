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
    private var collection = [Meme]()
    var memeCollection: [Meme] {
        get {
            return collection
        }
    }
    
    func addMemeToCollection(meme: Meme) {
        collection.append(meme)
    }
    
//    func removeMemeFromCollection(meme: Meme) {
//        collection.removeAtIndex(<,#index: Int#>)
//    }

}
