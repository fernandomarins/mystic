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
                            .padding(.top, 20)
                        
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
                            
                            // Daath (Hidden Sephirah)
                            Circle()
                                .stroke(Color.purple.opacity(0.5), lineWidth: 2)
                                .frame(width: 60, height: 60)
                                .position(
                                    x: 0.5 * width,
                                    y: 0.3 * availableHeight + padding
                                )
                            
                            // Sephiroth Nodes
                            ForEach(nodes) { node in
                                if node.id == 10 {
                                    // Interactive Malkuth
                                    MalkuthInteractiveNode(node: node, size: 220) { text in
                                        customElementText = text
                                        selectedSephirah = node
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
                                    }) {
                                        ZStack {
                                            SephirahVisual(id: node.id)
                                                .frame(width: 60, height: 60)
                                                .shadow(color: node.color.opacity(0.6), radius: 10, x: 0, y: 0)
                                            
                                            VStack(spacing: 0) {
                                                Text(node.number)
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(textColor(for: node.id))
                                                    .shadow(color: .black, radius: 2)
                                            }
                                        }
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
            
            // Info Modal
            if let selected = selectedSephirah {
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
                .zIndex(1)
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
                    
                case 2: // Chokmah: Blue Circle -> White Crescent
                    Circle().fill(Color.blue)
                    Crescent().fill(Color.white).frame(width: size * 0.6, height: size * 0.6)
                        .rotationEffect(.degrees(90))
                    
                case 3: // Binah: Blue Circle -> Red Triangle
                    Circle().fill(Color.blue)
                    Triangle().fill(Color.red).frame(width: size * 0.6, height: size * 0.6)
                    
                case 4: // Chesed: Red Triangle -> White Crescent
                    Triangle().fill(Color.red)
                    Crescent().fill(Color.white).frame(width: size * 0.4, height: size * 0.4)
                        .rotationEffect(.degrees(90))
                        .offset(y: size * 0.1)
                    
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
                    
                case 7: // Netzach: Crescent -> Crescent
                    Crescent().fill(Color.white)
                        .rotationEffect(.degrees(90))
                    Crescent().fill(Color.white).frame(width: size * 0.5, height: size * 0.5)
                        .rotationEffect(.degrees(90))
                        .overlay(Crescent().stroke(Color.gray, lineWidth: 1).rotationEffect(.degrees(90)))
                    
                case 8: // Hod: Crescent -> Red Triangle
                    Crescent().fill(Color.white)
                        .rotationEffect(.degrees(90))
                    Triangle().fill(Color.red).frame(width: size * 0.4, height: size * 0.4)
                    
                case 9: // Yesod: Crescent -> Blue Circle
                    Crescent().fill(Color.white)
                        .rotationEffect(.degrees(90))
                    Circle().fill(Color.blue).frame(width: size * 0.4)
                    
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
            
            // East: Yellow Square + White Crescent
            TattwaSquare(bgColor: .yellow, innerShape: AnyView(Crescent().fill(Color.white).rotationEffect(.degrees(90))))
                .frame(width: squareSize, height: squareSize)
                .offset(x: squareSize)
            
            // South: Blue Square + Yellow Square
            TattwaSquare(bgColor: .blue, innerShape: AnyView(Rectangle().fill(Color.yellow).padding(squareSize * 0.1)))
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
            
            // East: Yellow Square + White Crescent -> Água de Terra
            Button(action: { onSelect("ÁGUA de TERRA") }) {
                TattwaSquare(bgColor: .yellow, innerShape: AnyView(Crescent().fill(Color.white).rotationEffect(.degrees(90))))
                    .frame(width: squareSize, height: squareSize)
            }
            .offset(x: squareSize)
            
            // South: Blue Square + Yellow Square -> Terra de Terra
            Button(action: { onSelect("TERRA de TERRA") }) {
                TattwaSquare(bgColor: .blue, innerShape: AnyView(Rectangle().fill(Color.yellow).padding(squareSize * 0.1)))
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
