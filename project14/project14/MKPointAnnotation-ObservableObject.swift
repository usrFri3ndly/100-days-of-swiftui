//
//  MKPointAnnotation-ObservableObject.swift
//  project14
//
//  Created by Sc0tt on 06/04/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }
        
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }
         
        set {
            subtitle = newValue
        }
    }
}
