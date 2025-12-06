//
//  CriarTalismaView.swift
//  tarot
//
//  Created by Fernando Marins on 06/12/25.
//

import SwiftUI

struct CriarTalismaView: View {
    @StateObject private var viewModel = TalismanViewModel()
    
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
                ForEach(0..<50, id: \.self) { _ in
                    Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.2...0.7)))
                    .frame(width: CGFloat.random(in: 1...2))
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 0...geometry.size.height)
                    )
                }
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Mystical Header
                    VStack(spacing: 12) {
                        Text("✨")
                            .font(.system(size: 40))
                            .foregroundColor(Color(hex: "9D4EDD").opacity(0.8))
                            .shadow(color: Color(hex: "9D4EDD"), radius: 10, x: 0, y: 0)
                        
                        Text("Criar Talismã")
                            .font(.system(size: 36, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .shadow(color: Color(hex: "9D4EDD").opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                    .padding(.top, 20)
                    
                    // Talisman Preview with drop zone
                    TalismanPreviewContainer(viewModel: viewModel)
                        .frame(height: 350)
                        .padding()
                    
                    // Customization Options
                    VStack(spacing: 20) {
                        // Outer Shape Selection
                        CustomizationSection(title: "Contorno Externo") {
                            ShapeSelector(
                                selectedShape: $viewModel.configuration.outerShape,
                                label: "Forma"
                            )
                        }
                        
                        // Background Color
                        CustomizationSection(title: "Cor de Fundo") {
                            ColorPicker("Escolher Cor", selection: $viewModel.configuration.backgroundColor)
                                .padding(.horizontal)
                        }
                        
                        // Inner Shape Selection
                        CustomizationSection(title: "Forma Central") {
                            VStack(spacing: 12) {
                                Toggle("Adicionar Forma Central", isOn: Binding(
                                    get: { viewModel.configuration.innerShape != nil },
                                    set: { isOn in
                                        viewModel.configuration.innerShape = isOn ? .circle : nil
                                    }
                                ))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                
                                if viewModel.configuration.innerShape != nil {
                                    ShapeSelector(
                                        selectedShape: Binding(
                                            get: { viewModel.configuration.innerShape ?? .circle },
                                            set: { viewModel.configuration.innerShape = $0 }
                                        ),
                                        label: "Forma"
                                    )
                                    
                                    ColorPicker("Cor da Forma", selection: $viewModel.configuration.innerShapeColor)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Planetary Symbols
                        CustomizationSection(title: "Símbolos Planetários") {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Toque para adicionar ao talismã")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(.horizontal)
                                
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 16) {
                                    ForEach(PlanetSymbol.allCases) { planet in
                                        PlanetSymbolButton(planet: planet, viewModel: viewModel)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Tattwa Symbols
                        CustomizationSection(title: "Símbolos Tattwa") {
                            TattwaSymbolPalette(viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Footer symbol
                    Text("✧")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "FFD700").opacity(0.5))
                        .padding(.bottom, 20)
                }
            }
        }
        .backButtonStyle()
    }
}

// MARK: - Talisman Preview Container
struct TalismanPreviewContainer: View {
    @ObservedObject var viewModel: TalismanViewModel
    @State private var showFullScreen = false
    
    var body: some View {
        VStack(spacing: 16) {
            GeometryReader { geometry in
                ZStack {
                    // Outer shape (contorno externo) - black stroke
                    TattwaShapeView(
                        shape: viewModel.configuration.outerShape,
                        color: viewModel.configuration.backgroundColor,
                        strokeColor: .black,
                        strokeWidth: 3
                    )
                    .padding(40)
                    
                    // Inner shape (forma central) - no stroke
                    if let innerShape = viewModel.configuration.innerShape {
                        TattwaShapeView(
                            shape: innerShape,
                            color: viewModel.configuration.innerShapeColor,
                            strokeColor: .clear,
                            strokeWidth: 0
                        )
                        .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.35)
                    }
                    
                    // Placed planetary symbols
                    ForEach(viewModel.configuration.placedSymbols) { symbol in
                        DraggableSymbolOnTalisman(
                            symbol: symbol,
                            viewModel: viewModel
                        )
                    }
                    
                    // Placed tattwa symbols
                    ForEach(viewModel.configuration.placedTattwas) { tattwa in
                        DraggableTattwaOnTalisman(
                            tattwa: tattwa,
                            viewModel: viewModel
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "9D4EDD").opacity(0.3), lineWidth: 2)
                        )
                )
            }
            
            // Exibir button
            Button(action: {
                showFullScreen = true
            }) {
                Text("Exibir")
                    .font(.system(.headline, design: .serif))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "9D4EDD"))
                    )
            }
            .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            TalismanFullScreenView(configuration: viewModel.configuration, isPresented: $showFullScreen)
        }
    }
}

// MARK: - Draggable Symbol on Talisman
struct DraggableSymbolOnTalisman: View {
    let symbol: PlacedSymbol
    @ObservedObject var viewModel: TalismanViewModel
    @State private var offset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                // Planet symbol - removed circle background
                Text(symbol.planet.symbol)
                    .font(.system(size: 36))
                    .foregroundColor(symbol.planet.color)
                    .shadow(color: symbol.planet.color.opacity(0.8), radius: 10, x: 0, y: 0)
                    .padding(8)
                
                // Remove button
                Button(action: {
                    viewModel.removeSymbol(symbol)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .background(Circle().fill(Color.white))
                        .font(.system(size: 18))
                }
                .offset(x: 6, y: -6)
            }
            .position(
                x: symbol.position.x * geometry.size.width,
                y: symbol.position.y * geometry.size.height
            )
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        let absoluteX = symbol.position.x * geometry.size.width + value.translation.width
                        let absoluteY = symbol.position.y * geometry.size.height + value.translation.height
                        
                        // Convert back to relative coordinates (0-1)
                        let newPosition = CGPoint(
                            x: max(0, min(1, absoluteX / geometry.size.width)),
                            y: max(0, min(1, absoluteY / geometry.size.height))
                        )
                        viewModel.updateSymbolPosition(symbol, to: newPosition)
                        offset = .zero
                    }
            )
        }
    }
}

// MARK: - Customization Section
struct CustomizationSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(.headline, design: .serif))
                .foregroundColor(Color(hex: "C77DFF"))
                .padding(.horizontal)
            
            content
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "9D4EDD").opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Shape Selector
struct ShapeSelector: View {
    @Binding var selectedShape: TattwaShape
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(TattwaShape.allCases) { shape in
                        ShapeButton(
                            shape: shape,
                            isSelected: selectedShape == shape
                        ) {
                            selectedShape = shape
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Shape Button
struct ShapeButton: View {
    let shape: TattwaShape
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                TattwaShapeView(shape: shape, color: .white)
                    .frame(width: 50, height: 50)
                
                Text(shape.rawValue)
                    .font(.caption2)
                    .foregroundColor(.white)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(hex: "9D4EDD").opacity(0.3) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color(hex: "9D4EDD") : Color.white.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
    }
}

// MARK: - Planetary symbols section
struct SectionCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(.headline, design: .serif))
                .foregroundColor(Color(hex: "C77DFF"))
                .padding(.horizontal)
            
            content
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "9D4EDD").opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Planet Symbol Palette (This struct is being replaced by SectionCard usage in the main view)
// The content of PlanetSymbolPalette is now directly integrated into the main view's body using SectionCard.

// MARK: - Planet Symbol Button
struct PlanetSymbolButton: View {
    let planet: PlanetSymbol
    @ObservedObject var viewModel: TalismanViewModel
    
    var body: some View {
        Button(action: {
            // Add symbol to center of talisman (using relative position 0.5, 0.5)
            viewModel.addSymbolAtCenter(planet: planet)
        }) {
            VStack(spacing: 4) {
                Text(planet.symbol)
                    .font(.system(size: 32))
                    .foregroundColor(planet.color)
                    .shadow(color: planet.color.opacity(0.5), radius: 5)
                
                Text(planet.rawValue)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .frame(height: 60)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(planet.color.opacity(0.5), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Tattwa Symbol Palette
struct TattwaSymbolPalette: View {
    @ObservedObject var viewModel: TalismanViewModel
    @State private var selectedColor: Color = .white
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Escolha a cor e toque para adicionar")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal)
            
            // Color picker for tattwa
            ColorPicker("Cor do Símbolo", selection: $selectedColor)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
                ForEach(TattwaShape.allCases) { shape in
                    TattwaSymbolButton(shape: shape, color: selectedColor, viewModel: viewModel)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Tattwa Symbol Button
struct TattwaSymbolButton: View {
    let shape: TattwaShape
    let color: Color
    @ObservedObject var viewModel: TalismanViewModel
    
    var body: some View {
        Button(action: {
            viewModel.addTattwaAtCenter(shape: shape, color: color)
        }) {
            VStack(spacing: 4) {
                TattwaShapeView(shape: shape, color: color, strokeColor: .clear, strokeWidth: 0)
                    .frame(width: 40, height: 40)
                
                Text(shape.rawValue)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 70)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(color.opacity(0.5), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Draggable Tattwa on Talisman
struct DraggableTattwaOnTalisman: View {
    let tattwa: PlacedTattwa
    @ObservedObject var viewModel: TalismanViewModel
    @State private var offset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                // Tattwa shape - no stroke
                TattwaShapeView(
                    shape: tattwa.shape,
                    color: tattwa.color,
                    strokeColor: .clear,
                    strokeWidth: 0
                )
                .frame(width: 40, height: 40)
                
                // Remove button
                Button(action: {
                    viewModel.removeTattwa(tattwa)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .background(Circle().fill(Color.white))
                        .font(.system(size: 18))
                }
                .offset(x: 6, y: -6)
            }
            .position(
                x: tattwa.position.x * geometry.size.width,
                y: tattwa.position.y * geometry.size.height
            )
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        let absoluteX = tattwa.position.x * geometry.size.width + value.translation.width
                        let absoluteY = tattwa.position.y * geometry.size.height + value.translation.height
                        
                        // Convert back to relative coordinates (0-1)
                        let newPosition = CGPoint(
                            x: max(0, min(1, absoluteX / geometry.size.width)),
                            y: max(0, min(1, absoluteY / geometry.size.height))
                        )
                        viewModel.updateTattwaPosition(tattwa, to: newPosition)
                        offset = .zero
                    }
            )
        }
    }
}

// MARK: - View Model
class TalismanViewModel: ObservableObject {
    @Published var configuration = TalismanConfiguration()
    
    func addSymbol(planet: PlanetSymbol, at position: CGPoint) {
        let symbol = PlacedSymbol(planet: planet, position: position)
        configuration.placedSymbols.append(symbol)
    }
    
    func addSymbolAtCenter(planet: PlanetSymbol) {
        // Use relative position (0.5, 0.5) for center
        let symbol = PlacedSymbol(planet: planet, position: CGPoint(x: 0.5, y: 0.5))
        configuration.placedSymbols.append(symbol)
    }
    
    func removeSymbol(_ symbol: PlacedSymbol) {
        configuration.placedSymbols.removeAll { $0.id == symbol.id }
    }
    
    func updateSymbolPosition(_ symbol: PlacedSymbol, to position: CGPoint) {
        if let index = configuration.placedSymbols.firstIndex(where: { $0.id == symbol.id }) {
            configuration.placedSymbols[index].position = position
        }
    }
    
    // Tattwa methods
    func addTattwaAtCenter(shape: TattwaShape, color: Color) {
        let tattwa = PlacedTattwa(shape: shape, color: color, position: CGPoint(x: 0.5, y: 0.5))
        configuration.placedTattwas.append(tattwa)
    }
    
    func removeTattwa(_ tattwa: PlacedTattwa) {
        configuration.placedTattwas.removeAll { $0.id == tattwa.id }
    }
    
    func updateTattwaPosition(_ tattwa: PlacedTattwa, to position: CGPoint) {
        if let index = configuration.placedTattwas.firstIndex(where: { $0.id == tattwa.id }) {
            configuration.placedTattwas[index].position = position
        }
    }
}

#Preview {
    NavigationView {
        CriarTalismaView()
    }
}
