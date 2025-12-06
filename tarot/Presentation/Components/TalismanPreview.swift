//
//  TalismanPreview.swift
//  tarot
//
//  Created by Fernando Marins on 06/12/25.
//

import SwiftUI

struct TalismanPreview: View {
    let configuration: TalismanConfiguration
    @State private var symbolPositions: [UUID: CGPoint] = [:]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Outer shape (contorno externo)
                TattwaShapeView(
                    shape: configuration.outerShape,
                    color: configuration.backgroundColor,
                    strokeColor: Color(hex: "FFD700"),
                    strokeWidth: 3
                )
                .shadow(color: Color(hex: "FFD700").opacity(0.5), radius: 15, x: 0, y: 0)
                .padding(20)
                
                // Inner shape (forma central)
                if let innerShape = configuration.innerShape {
                    TattwaShapeView(
                        shape: innerShape,
                        color: configuration.innerShapeColor,
                        strokeColor: .white,
                        strokeWidth: 2
                    )
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.4)
                    .shadow(color: configuration.innerShapeColor.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                
                // Placed planetary symbols
                ForEach(configuration.placedSymbols) { symbol in
                    PlacedPlanetSymbol(
                        symbol: symbol,
                        onPositionChange: { newPosition in
                            // Update position in parent view model
                        },
                        onRemove: {
                            // Remove symbol from parent view model
                        }
                    )
                    .position(
                        symbolPositions[symbol.id] ?? CGPoint(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "FFD700").opacity(0.3), lineWidth: 2)
                    )
            )
            .onAppear {
                // Initialize symbol positions
                for symbol in configuration.placedSymbols {
                    if symbolPositions[symbol.id] == nil {
                        symbolPositions[symbol.id] = CGPoint(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                    }
                }
            }
        }
    }
}

struct PlacedPlanetSymbol: View {
    let symbol: PlacedSymbol
    let onPositionChange: (CGPoint) -> Void
    let onRemove: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var isDragging = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Planet symbol
            Text(symbol.planet.symbol)
                .font(.system(size: 40))
                .foregroundColor(symbol.planet.color)
                .shadow(color: symbol.planet.color.opacity(0.8), radius: 10, x: 0, y: 0)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.5))
                        .overlay(
                            Circle()
                                .stroke(symbol.planet.color.opacity(0.5), lineWidth: 2)
                        )
                )
                .scaleEffect(isDragging ? 1.2 : 1.0)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            offset = value.translation
                        }
                        .onEnded { value in
                            isDragging = false
                            onPositionChange(value.location)
                            offset = .zero
                        }
                )
            
            // Remove button (appears when not dragging)
            if !isDragging {
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .background(Circle().fill(Color.white))
                        .font(.system(size: 20))
                }
                .offset(x: 8, y: -8)
            }
        }
    }
}

#Preview {
    TalismanPreview(configuration: TalismanConfiguration(
        outerShape: .circle,
        backgroundColor: .purple,
        innerShape: .triangle,
        innerShapeColor: .yellow,
        placedSymbols: [
            PlacedSymbol(planet: .sun, position: CGPoint(x: 100, y: 100)),
            PlacedSymbol(planet: .moon, position: CGPoint(x: 200, y: 150))
        ]
    ))
    .frame(height: 300)
    .padding()
    .background(Color.black)
}
