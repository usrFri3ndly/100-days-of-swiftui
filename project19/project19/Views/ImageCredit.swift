//
//  ImageCredit.swift
//  project19
//
//  Created by Sc0tt on 19/04/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

struct ImageCredit: View {
    let resort: Resort
    
    var body: some View {
        Text("Credit: \(resort.imageCredit)")
           .font(.caption)
           .foregroundColor(.white)
           .padding(5)
           .background(Color.black)
           .opacity(0.75)
           .cornerRadius(5)
           .padding(5)
    }
}
