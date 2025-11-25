//
//  TreeOfLifeView.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/24.
//

import SwiftUI

struct TreeOfLifeView: View {
    let sephirothData: [FluxoDeManifestacao]
    @State private var selectedSephirah: SephirahNode?
    @State private var customElementText: String?
    @State private var showFullScreen = false
    @State private var showInfo = false
    
    // Relative positions (0.0 to 1.0+)
    private let nodes: [SephirahNode] = [
        SephirahNode(id: 1, name: "Kether", number: "1", color: .white, position: CGPoint(x: 0.5, y: 0.1)),
        SephirahNode(id: 2, name: "Chokmah", number: "2", color: .gray, position: CGPoint(x: 0.85, y: 0.2)),
        SephirahNode(id: 3, name: "Binah", number: "3", color: .black, position: CGPoint(x: 0.15, y: 0.2)),
        SephirahNode(id: 4, name: "Chesed", number: "4", color: .blue, position: CGPoint(x: 0.85, y: 0.4)),
        SephirahNode(id: 5, name: "Geburah", number: "5", color: .red, position: CGPoint(x: 0.15, y: 0.4)),
        SephirahNode(id: 6, name: "Tiphareth", number: "6", color: .yellow, position: CGPoint(x: 0.5, y: 0.55)),
        SephirahNode(id: 7, name: "Netzach", number: "7", color: .green, position: CGPoint(x: 0.85, y: 0.7)),
        SephirahNode(id: 8, name: "Hod", number: "8", color: .orange, position: CGPoint(x: 0.15, y: 0.7)),
        SephirahNode(id: 9, name: "Yesod", number: "9", color: .purple, position: CGPoint(x: 0.5, y: 0.8)),
        SephirahNode(id: 10, name: "Malkuth", number: "10", color: Color(hex: "8B4513"), position: CGPoint(x: 0.5, y: 0.95))
    ]
    
    // Connections between IDs (Lightning Flash order)
    private let paths: [(Int, Int)] = [
        (1, 2),
        (2, 3),
        (3, 4),
        (4, 5),
        (5, 6),
        (6, 7),
        (7, 8),
        (8, 9),
        (9, 10)
    ]
    
    var body: some View {
        ZStack {
            // Cosmic background
            LinearGradient(
                colors: [Color(hex: "0F0F20"), Color(hex: "1A0033"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            GeometryReader { geometry in
                ScrollView {
                    let width = geometry.size.width
                    let minHeight = geometry.size.height
                    let contentHeight = minHeight * 1.6
                    let padding: CGFloat = 40
                    let availableHeight = contentHeight - (padding * 2)
                    
                    VStack {
                        Text("LEI DA CRIAÇÃO")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 0)
                            .padding(.top, 5)
                        
                        ZStack {
                            // Paths
                            ForEach(0..<paths.count, id: \.self) { index in
                                let path = paths[index]
                                if let start = nodes.first(where: { $0.id == path.0 }),
                                   let end = nodes.first(where: { $0.id == path.1 }) {
                                    Path { p in
                                        p.move(to: CGPoint(
                                            x: start.position.x * width,
                                            y: start.position.y * availableHeight + padding
                                        ))
                                        p.addLine(to: CGPoint(
                                            x: end.position.x * width,
                                            y: end.position.y * availableHeight + padding
                                        ))
                                    }
                                    .stroke(Color.white.opacity(0.3), lineWidth: 8)
                                }
                            }
                            
//                            // Daath (Hidden Sephirah)
//                            Circle()
//                                .stroke(Color.purple.opacity(0.5), lineWidth: 2)
//                                .frame(width: 60, height: 60)
//                                .position(
//                                    x: 0.5 * width,
//                                    y: 0.3 * availableHeight + padding
//                                )
                            
                            // Sephiroth Nodes
                            ForEach(nodes) { node in
                                if node.id == 10 {
                                    // Interactive Malkuth
                                    MalkuthInteractiveNode(node: node, size: 200) { text in
                                        customElementText = text
                                        selectedSephirah = node
                                        showFullScreen = true
                                        showInfo = false
                                    }
                                    .position(
                                        x: node.position.x * width,
                                        y: node.position.y * availableHeight + padding
                                    )
                                } else {
                                    // Standard Node
                                    Button(action: {
                                        customElementText = nil
                                        selectedSephirah = node
                                        showFullScreen = true
                                        showInfo = false
                                    }) {
                                        SephirahVisual(id: node.id)
                                            .frame(width: 75, height: 75)
//                                                .shadow(color: [7, 8, 9].contains(node.id) ? .clear : node.color.opacity(0.6), radius: 10, x: 0, y: 0)
                                    }
                                    .position(
                                        x: node.position.x * width,
                                        y: node.position.y * availableHeight + padding
                                    )
                                }
                            }
                        }
                        .frame(height: contentHeight)
                    }
                }
            }
            .padding(.bottom, 0)
            
            // Full-Screen Sephirah View
            if showFullScreen, let selected = selectedSephirah {
                ZStack {
                    Color.black.opacity(0.95)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 40) {
                        Spacer()
                        
                        // Enlarged Sephirah
                        Button(action: {
                            showInfo = true
                        }) {
                            if selected.id == 10 {
                                MalkuthVisual(size: 300)
                                    .frame(width: 300, height: 300)
                            } else {
                                SephirahVisual(id: selected.id)
                                    .frame(width: 300, height: 300)
                            }
                        }
                        
                        Spacer()
                        
                        // Close button
                        Button(action: {
                            showFullScreen = false
                            showInfo = false
                            selectedSephirah = nil
                            customElementText = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.bottom, 40)
                    }
                }
                .transition(.opacity)
                .zIndex(2)
            }
            
            // Info Modal (shown after clicking enlarged Sephirah)
            if showInfo, let selected = selectedSephirah {
                VStack {
                    Spacer()
                    VStack(spacing: 16) {
                        Text(selected.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        if let customText = customElementText {
                            // Custom text for Malkuth quadrants
                            VStack(spacing: 4) {
                                Text("Elemento Combinado:")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                Text(customText)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 8)
                        } else if let sephirahData = sephirothData.first(where: { $0.sephirah.contains("#\(selected.id)") }),
                           let elemento = sephirahData.elementoCombinado {
                            // Standard data from JSON
                            VStack(spacing: 4) {
                                Text("Elemento Combinado:")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                Text(elemento)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 8)
                        }
                        
                        Button("Fechar") {
                            showInfo = false
                            showFullScreen = false
                            selectedSephirah = nil
                            customElementText = nil
                        }
                        .foregroundColor(.red)
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "1C1C1E"))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                }
                .transition(.move(edge: .bottom))
                .zIndex(3)
            }
        }
    }
    
    private func textColor(for id: Int) -> Color {
        return .white
    }
}

struct SephirahVisual: View {
    let id: Int
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            ZStack {
                switch id {
                case 1: // Kether: Blue Circle -> Yellow Circle -> Blue Circle
                    Circle().fill(Color.blue)
                    Circle().fill(Color.yellow).frame(width: size * 0.7)
                    Circle().fill(Color.blue).frame(width: size * 0.4)
                    
                case 2: // Chokmah: Blue Circle with inner circle with black intersection
                    Circle().fill(Color.blue)
                    
                    // Inner white circle (smaller)
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.35, height: size * 0.35)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: size * 0.35, height: size * 0.35)
                        )
                    
                    // Inner black circle creating intersection (masked)
                    Circle()
                        .fill(Color.black)
                        .frame(width: size * 0.5, height: size * 0.5)
                        .offset(y: -size * 0.25)
                        .mask(
                            Circle()
                                .fill(Color.white)
                                .frame(width: size * 0.35, height: size * 0.35)
                        )
                    
                case 3: // Binah: Blue Circle -> Red Triangle
                    Circle().fill(Color.blue)
                    Triangle().fill(Color.red).frame(width: size * 0.45, height: size * 0.45)
                    
                case 4: // Chesed: Red Triangle with inner circle with black intersection
                    Triangle().fill(Color.red)
                    
                    // Inner white circle (smaller)
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.35, height: size * 0.35)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: size * 0.35, height: size * 0.35)
                        )
                        .offset(y: size * 0.15)
                    
                    // Inner black circle creating intersection (masked)
                    Circle()
                        .fill(Color.black)
                        .frame(width: size * 0.35, height: size * 0.35)
                        .offset(y: 0)
                        .mask(
                            Circle()
                                .fill(Color.white)
                                .frame(width: size * 0.35, height: size * 0.35)
                                .offset(y: size * 0.15)
                        )
                    
                case 5: // Geburah: Red Triangle -> Green Triangle -> Red Triangle
                    Triangle().fill(Color.red)
                    Triangle().fill(Color.green).frame(width: size * 0.6, height: size * 0.6)
                        .offset(y: size * 0.1)
                    Triangle().fill(Color.red).frame(width: size * 0.3, height: size * 0.3)
                        .offset(y: size * 0.15)
                    
                case 6: // Tiphareth: Red Triangle -> Blue Circle
                    Triangle().fill(Color.red)
                    Circle().fill(Color.blue).frame(width: size * 0.4)
                        .offset(y: size * 0.1)
                    
                case 7: // Netzach: Circle with black intersection + inner circle with black intersection
                    // Outer white circle
                    Circle()
                        .fill(Color.white)
                    
                    // Black circle creating intersection (masked to show only overlap)
                    Circle()
                        .fill(Color.black)
                        .offset(y: -size * 0.5)
                        .mask(
                            Circle()
                                .fill(Color.white)
                        )
                    
                    // Inner white circle (smaller)
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.35, height: size * 0.35)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: size * 0.35, height: size * 0.35)
                        )
                        .offset(y: size * 0.25)
                    
                    // Inner black circle creating intersection (masked)
                    Circle()
                        .fill(Color.black)
                        .frame(width: size * 0.35, height: size * 0.35)
                        .offset(y: size * 0.1)
                        .mask(
                            Circle()
                                .fill(Color.white)
                                .frame(width: size * 0.35, height: size * 0.35)
                                .offset(y: size * 0.25)
                        )
                    
                case 8: // Hod: Circle with black intersection + red triangle
                    // Outer white circle
                    Circle()
                        .fill(Color.white)
                    
                    // Black circle creating intersection (masked to show only overlap)
                    Circle()
                        .fill(Color.black)
                        .offset(y: -size * 0.5)
                        .mask(
                            Circle()
                                .fill(Color.white)
                        )
                    
                    // Red triangle in the white crescent area
                    Triangle()
                        .fill(Color.red)
                        .frame(width: size * 0.35, height: size * 0.35)
                        .offset(y: size * 0.25)
                    
                case 9: // Yesod: Circle with black intersection + blue circle
                    // Outer white circle
                    Circle()
                        .fill(Color.white)
                    
                    // Black circle creating intersection (masked to show only overlap)
                    Circle()
                        .fill(Color.black)
                        .offset(y: -size * 0.5)
                        .mask(
                            Circle()
                                .fill(Color.white)
                        )
                    
                    // Blue circle in the white crescent area
                    Circle()
                        .fill(Color.blue)
                        .frame(width: size * 0.35)
                        .offset(y: size * 0.25)
                    
                case 10: // Malkuth: 4 Drawings (N, E, S, W)
                    MalkuthVisual(size: size)
                    
                default:
                    Circle().fill(Color.gray)
                }
            }
            .frame(width: size, height: size)
        }
    }
}

struct MalkuthVisual: View {
    let size: CGFloat
    
    var body: some View {
        let squareSize = size / 3
        
        ZStack {
            // North: Yellow Square + Blue Circle
            TattwaSquare(bgColor: .yellow, innerShape: AnyView(Circle().fill(Color.blue)))
                .frame(width: squareSize, height: squareSize)
                .offset(y: -squareSize)
            
            // East: Yellow Square + Circle with black intersection
            ZStack {
                Rectangle().fill(Color.yellow)
                
                // Inner white circle (smaller)
                Circle()
                    .fill(Color.white)
                    .frame(width: squareSize * 0.6, height: squareSize * 0.6)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 1.5)
                            .frame(width: squareSize * 0.6, height: squareSize * 0.6)
                    )
                
                // Inner black circle creating intersection (masked)
                Circle()
                    .fill(Color.black)
                    .frame(width: squareSize * 0.6, height: squareSize * 0.6)
                    .offset(y: -squareSize * 0.2)
                    .mask(
                        Circle()
                            .fill(Color.white)
                            .frame(width: squareSize * 0.6, height: squareSize * 0.6)
                    )
            }
            .frame(width: squareSize, height: squareSize)
                .offset(x: squareSize)
            
            // South: Yellow Square + Blue Square + Yellow Square
            ZStack {
                Rectangle().fill(Color.yellow)
                Rectangle().fill(Color.blue).padding(squareSize * 0.15)
                Rectangle().fill(Color.yellow).padding(squareSize * 0.3)
            }
            .frame(width: squareSize, height: squareSize)
                .offset(y: squareSize)
            
            // West: Yellow Square + Red Triangle
            TattwaSquare(bgColor: .yellow, innerShape: AnyView(Triangle().fill(Color.red)))
                .frame(width: squareSize, height: squareSize)
                .offset(x: -squareSize)
        }
    }
}

struct MalkuthInteractiveNode: View {
    let node: SephirahNode
    let size: CGFloat
    let onSelect: (String) -> Void
    
    var body: some View {
        let squareSize = size / 3
        
        ZStack {
            // Center Text (Non-interactive or triggers main)
            VStack(spacing: 0) {
                Text(node.number)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2)
            }
            .zIndex(1)
            
            // North: Yellow Square + Blue Circle -> Ar de Terra
            Button(action: { onSelect("AR de TERRA") }) {
                TattwaSquare(bgColor: .yellow, innerShape: AnyView(Circle().fill(Color.blue)))
                    .frame(width: squareSize, height: squareSize)
            }
            .offset(y: -squareSize)
            
            // East: Yellow Square + Circle with black intersection -> Água de Terra
            Button(action: { onSelect("ÁGUA de TERRA") }) {
                ZStack {
                    Rectangle().fill(Color.yellow)
                    
                    // Inner white circle (smaller)
                    Circle()
                        .fill(Color.white)
                        .frame(width: squareSize * 0.6, height: squareSize * 0.6)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1.5)
                                .frame(width: squareSize * 0.6, height: squareSize * 0.6)
                        )
                    
                    // Inner black circle creating intersection (masked)
                    Circle()
                        .fill(Color.black)
                        .frame(width: squareSize * 0.6, height: squareSize * 0.6)
                        .offset(y: -squareSize * 0.2)
                        .mask(
                            Circle()
                                .fill(Color.white)
                                .frame(width: squareSize * 0.6, height: squareSize * 0.6)
                        )
                }
                .frame(width: squareSize, height: squareSize)
            }
            .offset(x: squareSize)
            
            // South: Yellow Square + Blue Square + Yellow Square -> Terra de Terra
            Button(action: { onSelect("TERRA de TERRA") }) {
                ZStack {
                    Rectangle().fill(Color.yellow)
                    Rectangle().fill(Color.blue).padding(squareSize * 0.15)
                    Rectangle().fill(Color.yellow).padding(squareSize * 0.3)
                }
                .frame(width: squareSize, height: squareSize)
            }
            .offset(y: squareSize)
            
            // West: Yellow Square + Red Triangle -> Fogo de Terra
            Button(action: { onSelect("FOGO de TERRA") }) {
                TattwaSquare(bgColor: .yellow, innerShape: AnyView(Triangle().fill(Color.red)))
                    .frame(width: squareSize, height: squareSize)
            }
            .offset(x: -squareSize)
        }
        .frame(width: size, height: size)
        .shadow(color: node.color.opacity(0.6), radius: 10, x: 0, y: 0)
    }
}

struct TattwaSquare: View {
    let bgColor: Color
    let innerShape: AnyView
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(bgColor)
            innerShape
                .scaleEffect(0.6)
        }
    }
}

struct SephirahNode: Identifiable {
    let id: Int
    let name: String
    let number: String
    let color: Color
    let position: CGPoint
}

#Preview {
    TreeOfLifeView(sephirothData: [])
}
