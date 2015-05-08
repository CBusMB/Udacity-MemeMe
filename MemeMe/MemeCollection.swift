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
  /* Singleton. Use let xxx = MemeCollection.sharedCollection to access MemeCollection
  public properties and methods */
  class var sharedCollection: MemeCollection {
    struct MemeSingleton {
      static let instance: MemeCollection = MemeCollection()
    }
    return MemeSingleton.instance
  }
  
  private var memes = [Meme]()
  
  var currentlySelectedIndex: Int?
  
  var memeCollection: [Meme] {
    get {
      return memes
    }
  }
  
  func addMemeToCollection(#meme: Meme) {
    memes.append(meme)
  }
  
  /// :param: index The index of the meme to be removed from the collection
  func removeMemeFromCollection(#atIndex: Int) {
    memes.removeAtIndex(index)
  }
}
