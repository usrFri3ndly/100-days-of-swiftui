//
//  ContentView.swift
//  project9
//
//  Created by Sc0tt on 12/03/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // arrow head
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + 30, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - 10.5, y: rect.minY + 40))
        path.addLine(to: CGPoint(x: rect.midX - 10.5, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + 10.5, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + 10.5, y: rect.minY + 40))
       //path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + 30))
        path.addLine(to: CGPoint(x: rect.maxX - 30, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        
        /* original code separating arrow head and body
         
        // arrow head
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + 30, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + 30))
        path.addLine(to: CGPoint(x: rect.maxX - 30, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        // arrow body
        path.move(to: CGPoint(x: rect.midX - 10, y: rect.minY + 30))
        path.addLine(to: CGPoint(x: rect.midX - 10, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + 10, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + 10, y: rect.minY + 30))
        path.addLine(to: CGPoint(x: rect.midX - 10, y: rect.minY + 30))
        */
       
        return path
    }
}

struct ContentView: View {
    
    @State private var lineWidth: CGFloat = 2
    
    var body: some View {
    
        VStack {
            Arrow()
                .stroke(Color.red, lineWidth: lineWidth)
                .frame(width: 300, height: 300)
            
            Slider(value: $lineWidth, in: 2...25)
            
            Arrow()
            .stroke(Color.blue, lineWidth: lineWidth)
            .frame(width: 300, height: 300)
            .onTapGesture {
                withAnimation {
                    self.lineWidth = CGFloat.random(in: 2...25)
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
