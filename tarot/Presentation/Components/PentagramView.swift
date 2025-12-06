//
//  PentagramView.swift
//  tarot
//
//  Created by Fernando Marins on 04/12/25.
//

import SwiftUI

struct PentagramView: View {
    @State private var progress: CGFloat = 0
    @State private var visibleVowels: Set<Int> = []
    var inverted: Bool = false
    var showVowels: Bool = true
    
    // Points for a standard pentagram (star)
    // Standard: 1 point up.
    // Inverted: 2 points up.
    
    private var points: [CGPoint] {
        let standardPoints = [
            CGPoint(x: 0.2, y: 0.9), // 1. Bottom Left
            CGPoint(x: 0.5, y: 0.1), // 2. Top
            CGPoint(x: 0.8, y: 0.9), // 3. Bottom Right
            CGPoint(x: 0.1, y: 0.4), // 4. Top Left
            CGPoint(x: 0.9, y: 0.4), // 5. Top Right
            CGPoint(x: 0.2, y: 0.9)  // 6. Bottom Left (Close)
        ]
        
        if inverted {
            // Flip Y coordinates around 0.5
            return standardPoints.map { CGPoint(x: $0.x, y: 1.0 - $0.y) }
        } else {
            return standardPoints
        }
    }
    
    private let vowels = ["I", "E", "A", "O", "U"]
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                // Background Pentagram (faint)
                Path { path in
                    let scaledPoints = points.map {
                        CGPoint(x: $0.x * width, y: $0.y * height)
                    }
                    path.addLines(scaledPoints)
                }
                .stroke(Color.red.opacity(0.3), lineWidth: 2)
                
                // Animated Path
                Path { path in
                    let scaledPoints = points.map {
                        CGPoint(x: $0.x * width, y: $0.y * height)
                    }
                    path.addLines(scaledPoints)
                }
                .trim(from: 0, to: progress)
                .stroke(Color.red, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .shadow(color: .red, radius: 5)
                
                // Vowels Labels
                if showVowels {
                    ForEach(0..<5) { index in
                        let start = points[index]
                        let end = points[index + 1]
                        let midPoint = CGPoint(
                            x: (start.x + end.x) / 2 * width,
                            y: (start.y + end.y) / 2 * height
                        )
                        
                        Text(vowels[index])
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .position(midPoint)
                            .opacity(visibleVowels.contains(index) ? 1 : 0)
                            .scaleEffect(visibleVowels.contains(index) ? 1 : 0.5)
                            .animation(.easeOut(duration: 0.3), value: visibleVowels)
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            progress = 0
            visibleVowels = []
            
            // Start animation after a small delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.linear(duration: 10)) {
                    progress = 1.0
                }
                
                // Show each vowel at specific times (2 seconds apart)
                for index in 0..<5 {
                    let delay = Double(index) * 2.0 + 0.1 // 0.1s, 2.1s, 4.1s, 6.1s, 8.1s
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        visibleVowels.insert(index)
                    }
                }
            }
        }
        .onDisappear {
            progress = 0
            visibleVowels = []
        }
    }
}

#Preview {
    PentagramView()
        .frame(width: 300, height: 300)
        .background(Color.black)
}
