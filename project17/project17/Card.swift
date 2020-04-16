//
//  Card.swift
//  project17
//
//  Created by Sc0tt on 14/04/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String
    
    static var example: Card {
        Card(prompt: "Who played the 13th Doctor?", answer: "Jodie Whittaker")
    }
}
