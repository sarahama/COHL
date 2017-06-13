//
//  TableSection.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 6/12/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import Foundation

struct Section {
    var genre: String!
    var movies: [String]!
    var expanded: Bool!
    
    init(genre: String, movies: [String], expanded: Bool) {
        self.genre = genre
        self.movies = movies
        self.expanded = expanded
        
    }
}
