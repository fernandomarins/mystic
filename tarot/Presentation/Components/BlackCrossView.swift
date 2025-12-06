//
//  BlackCrossView.swift
//  tarot
//
//  Created by Fernando Marins on 04/12/25.
//

import SwiftUI

struct BlackCrossView: View {
    let mantra: String?
    @State private var progress: CGFloat = 0
    
    // Determine which parts to show based on mantra
    private var showTopPoint: Bool {
        mantra == "OIAD" || mantra == "MOLAP" || mantra == "BAEOUIB" || mantra == "IEHUSOZ"
    }
    
    private var showVerticalLine: Bool {
        mantra == "MOLAP" || mantra == "BAEOUIB" || mantra == "IEHUSOZ"
    }
    
    private var showLeftPoint: Bool {
        mantra == "BAEOUIB" || mantra == "IEHUSOZ"
    }
    
    private var showHorizontalLine: Bool {
        mantra == "IEHUSOZ"
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                // Background Cross (very faint)
                Path { path in
                    path.move(to: CGPoint(x: width / 2, y: 0))
                    path.addLine(to: CGPoint(x: width / 2, y: height))
                }
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height / 2))
                    path.addLine(to: CGPoint(x: width, y: height / 2))
                }
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                
                // Top Point (OIAD)
                if showTopPoint {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 12, height: 12)
                        .position(x: width / 2, y: 0)
                        .shadow(color: .white, radius: 8)
                        .shadow(color: .white, radius: 4)
                        .opacity(progress > 0.1 ? 1 : 0)
                }
                
                // Animated Vertical Line (MOLAP)
                if showVerticalLine {
                    Path { path in
                        path.move(to: CGPoint(x: width / 2, y: 0))
                        path.addLine(to: CGPoint(x: width / 2, y: height))
                    }
                    .trim(from: 0, to: mantra == "MOLAP" ? progress : 1)
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .shadow(color: .white, radius: 8)
                    .shadow(color: .white, radius: 4)
                }
                
                // Left Point (BAEOUIB)
                if showLeftPoint {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 12, height: 12)
                        .position(x: 0, y: height / 2)
                        .shadow(color: .white, radius: 8)
                        .shadow(color: .white, radius: 4)
                        .opacity(progress > 0.1 ? 1 : 0)
                }
                
                // Animated Horizontal Line (IEHUSOZ)
                if showHorizontalLine {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: height / 2))
                        path.addLine(to: CGPoint(x: width, y: height / 2))
                    }
                    .trim(from: 0, to: progress)
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .shadow(color: .white, radius: 8)
                    .shadow(color: .white, radius: 4)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                progress = 1.0
            }
        }
    }
}

#Preview {
    BlackCrossView(mantra: nil)
        .frame(width: 300, height: 300)
        .background(Color.black)
}
