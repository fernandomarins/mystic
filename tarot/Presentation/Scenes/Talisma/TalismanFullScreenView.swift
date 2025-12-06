//
//  TalismanFullScreenView.swift
//  tarot
//
//  Created by Fernando Marins on 06/12/25.
//

import SwiftUI

struct TalismanFullScreenView: View {
    let configuration: TalismanConfiguration
    @Binding var isPresented: Bool
    @State private var showSaveAlert = false
    @State private var saveSuccess = false
    @State private var saveError: String?
    
    var body: some View {
        ZStack {
            // Cosmic background
            LinearGradient(
                colors: [Color(hex: "1A0033"), Color(hex: "2A1845"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Animated stars
            GeometryReader { geometry in
                ForEach(0..<100, id: \.self) { _ in
                    Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.2...0.9)))
                    .frame(width: CGFloat.random(in: 1...3))
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 0...geometry.size.height)
                    )
                }
            }
            .ignoresSafeArea()
            
            VStack {
                // Top buttons
                HStack {
                    Spacer()
                    
                    // Export button
                    Button(action: {
                        exportTalismanImage()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.down")
                            Text("Exportar")
                        }
                        .font(.system(.body, design: .serif))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "9D4EDD"))
                        )
                    }
                    .padding(.trailing, 8)
                    
                    // Close button
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 5)
                    }
                    .padding()
                }
                
                Spacer()
                
                // Talisman display
                TalismanImageView(configuration: configuration)
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                
                Spacer()
            }
        }
        .alert(isPresented: $showSaveAlert) {
            if saveSuccess {
                return Alert(
                    title: Text("Sucesso!"),
                    message: Text("Talismã salvo na galeria de fotos."),
                    dismissButton: .default(Text("OK"))
                )
            } else {
                return Alert(
                    title: Text("Erro"),
                    message: Text(saveError ?? "Não foi possível salvar a imagem."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    @MainActor
    private func exportTalismanImage() {
        let size = CGSize(width: 1000, height: 1000)
        let renderer = ImageRenderer(content: TalismanImageView(configuration: configuration)
            .frame(width: size.width, height: size.height)
        )
        renderer.scale = 3.0
        
        if let image = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            saveSuccess = true
            saveError = nil
            showSaveAlert = true
        } else {
            saveSuccess = false
            saveError = "Falha ao gerar a imagem"
            showSaveAlert = true
        }
    }
}

// MARK: - Talisman Image View (for rendering)
struct TalismanImageView: View {
    let configuration: TalismanConfiguration
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Black background for the talisman
                Color.black
                
                // Outer shape (contorno externo) - black stroke
                TattwaShapeView(
                    shape: configuration.outerShape,
                    color: configuration.backgroundColor,
                    strokeColor: .black,
                    strokeWidth: 4
                )
                .padding(60)
                
                // Inner shape (forma central) - no stroke
                if let innerShape = configuration.innerShape {
                    TattwaShapeView(
                        shape: innerShape,
                        color: configuration.innerShapeColor,
                        strokeColor: .clear,
                        strokeWidth: 0
                    )
                    .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.35)
                }
                
                // Placed planetary symbols (using relative positioning)
                ForEach(configuration.placedSymbols) { symbol in
                    Text(symbol.planet.symbol)
                        .font(.system(size: geometry.size.width * 0.12))
                        .foregroundColor(symbol.planet.color)
                        .shadow(color: symbol.planet.color.opacity(0.8), radius: 15, x: 0, y: 0)
                        .position(
                            x: symbol.position.x * geometry.size.width,
                            y: symbol.position.y * geometry.size.height
                        )
                }
                
                // Placed tattwa symbols (using relative positioning)
                ForEach(configuration.placedTattwas) { tattwa in
                    TattwaShapeView(
                        shape: tattwa.shape,
                        color: tattwa.color,
                        strokeColor: .clear,
                        strokeWidth: 0
                    )
                    .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                    .position(
                        x: tattwa.position.x * geometry.size.width,
                        y: tattwa.position.y * geometry.size.height
                    )
                }
            }
        }
    }
}

#Preview {
    TalismanFullScreenView(
        configuration: TalismanConfiguration(
            outerShape: .circle,
            backgroundColor: .purple,
            innerShape: .triangle,
            innerShapeColor: .yellow,
            placedSymbols: [
                PlacedSymbol(planet: .sun, position: CGPoint(x: 0.5, y: 0.3)),
                PlacedSymbol(planet: .moon, position: CGPoint(x: 0.5, y: 0.6))
            ]
        ),
        isPresented: .constant(true)
    )
}
