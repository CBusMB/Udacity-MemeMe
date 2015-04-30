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
    // Singleton.  MemeCollectionTableViewController and MemeCollectionCollectionViewController both
	// use sharedCollection as their data source
    static let sharedCollection = MemeCollection()
    
    private var memes = [Meme]()
    
    var memeCollection: [Meme] {
        get {
            return memes
        }
    }
    
    func addMemeToCollection(meme: Meme) {
        memes.append(meme)
    }
    
    /// :param: index The index of the meme to be removed from the collection
    func removeMemeAtIndexFromCollection(index: Int) {
        memes.removeAtIndex(index)
    }

}
