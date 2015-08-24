//
//  Song.swift
//  Fall
//
//  Created by Vincent Budrovich on 8/10/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import Foundation

class Song {
    
    var bpm : Double
    var filePath : String
    var length : Double
    var type : String
    var title : String
    var artist : String
    
    init (filePath: String, type: String, bpm: Double, length: Double, title: String, artist: String) {
        self.filePath = filePath
        self.type = type
        self.bpm = bpm
        self.length = length
        self.artist = artist
        self.title = title
    }
    
    init(artist: String, title: String) {
        self.artist = artist
        self.title = title
        self.bpm = 0.0
        self.filePath = " "
        self.length = 0.0
        self.type = " "
        
    }
}