//
//  MusicClass.swift
//  Fall
//
//  Created by Vincent Budrovich on 8/9/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import Foundation

class MusicClass {
    
    var songSelector = [Int:Song]()
    
    struct Constants {
        static let song1 = Song(filePath: "Maccary Bay", type: "mp3", bpm: 80.0, length: 240.0, title: "Maccary Bay", artist: "Kevin Macleod")
        static let song2 = Song(filePath: "Blue Circles (ft. CSoul)-unreal_dm", type: "mp3", bpm: 80.0, length: 157.0, title: "Blue Circles", artist: "Unreal DM")
        static let song3 = Song(filePath: "beeKoo mix (ft. Forensic)-Lasswell", type: "mp3", bpm: 92.0, length: 255.0, title: "beeKoo", artist: "Lasswell")
        static let song4 = Song(filePath: "Urbana-Metronica (ft. Morusque, Jeris, CSoul, Alex Beroza)-spinningmerkaba", type: "mp3", bpm: 100.0, length: 207.0, title: "Urbana-Metronica", artist: "Spinningmerkaba")
        static let song5 = Song(filePath: "The Long Goodbye-John Pazdan", type: "mp3", bpm: 112.0, length: 134.0, title: "The Long Goodbye", artist: "John Pazdan")
        static let song6 = Song(filePath: "Disco Medusae", type: "mp3", bpm: 115.0, length: 221.0, title: "Disco Medusae", artist: "Kevin Macleod")
        static let song7 = Song(filePath: "Your Call", type: "mp3", bpm: 120.0, length: 224.0, title: "Your Call", artist: "Kevin Macleod")
        static let song8 = Song(filePath: "Latin Industries", type: "mp3", bpm: 122.0, length: 201.0, title: "Latin Industries", artist: "Kevin Macleod")
        static let song9 = Song(filePath: "Shebbe_-_Could_Be_(Shebbe_Remix)", type: "mp3", bpm: 126.0, length: 339.0, title: "Could Be", artist: "Shebbe")
        static let song10 = Song(filePath: "On the Bean (Petite Fleur Remix) - Coleman Hawkins, Bean & The Boys", type: "mp3", bpm: 128.0, length: 228.0, title: "On the Bean", artist: "Coleman Hawkins")
        static let song11 = Song(filePath: "smeerch_-_Ophelia_s_Song_(Smeerch_Club_Remix)", type: "mp3", bpm: 128.0, length: 340.0, title: "Ophelias Song Club Mix", artist: "Smeerch")
        static let song12 = Song(filePath: "AlexBeroza_-_Spinnin_", type: "mp3", bpm: 153.7, length: 212.0, title: "Spinnin'", artist: "Alex")
        
    }
    
    init(){
        songSelector[0] = Constants.song1
        songSelector[1] = Constants.song2
        songSelector[2] = Constants.song3
        songSelector[3] = Constants.song4
        songSelector[4] = Constants.song5
        songSelector[5] = Constants.song6
        songSelector[6] = Constants.song7
        songSelector[7] = Constants.song8
        songSelector[8] = Constants.song9
        songSelector[9] = Constants.song10
        songSelector[10] = Constants.song11
        songSelector[11] = Constants.song12
    }

    
}