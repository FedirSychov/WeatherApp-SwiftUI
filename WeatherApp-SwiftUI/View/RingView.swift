//
//  RingView.swift
//  WeatherApp-SwiftUI
//
//  Created by Fedor Sychev on 17.02.22.
//

import SwiftUI

struct RingView: View {
    var color1 = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    var color2 = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    var width: CGFloat = 40
    var height: CGFloat = 40
    var percent = 0
    
    @Binding var show: Bool
    
    var body: some View {
        let multiplier = width / 44
        
        return ZStack {
            Circle()
                .stroke(Color.black.opacity(0.1), style: StrokeStyle(lineWidth: 5 * multiplier))
                .frame(width: width, height: height, alignment: .center)
                
            
            Circle()
                .trim(from: show ? (1.0 - CGFloat(percent) / 100) : 1, to: 1.0)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(color1), Color(color2)]), startPoint: .topTrailing, endPoint: .bottomLeading),
                    style: StrokeStyle(lineWidth: 5 * multiplier, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20, 0], dashPhase: 0)
                )
                .rotationEffect(.degrees(90))
                .rotation3DEffect(
                    .degrees(180),
                    axis: (x: 1.0, y: 0.0, z: 0.0)
                )
                .frame(width: width, height: height, alignment: .center)
                .shadow(color: Color(color2).opacity(0.3), radius: 3, x: 0.0, y: 3.0 * multiplier)
        }
    }
}
