//
//  Favourites.swift
//  project19
//
//  Created by Sc0tt on 18/04/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

class Favourites: ObservableObject {
    // resorts the user has favourited
    private var resorts: Set<String>
    
    // read/write key
    private let saveKey = "Favourites"
    
    init() {
        // load saved data
        
        self.resorts = []
    }
    
    // does set contain resort?
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    // add resort to set, update views and save changes
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        // write data
    }

}
