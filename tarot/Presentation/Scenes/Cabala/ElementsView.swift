//
//  ElementsView.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/24.
//

import SwiftUI

struct ElementsView: View {
    @StateObject private var viewModel = ElementsViewModel()
    
    var body: some View {
        ZStack {
            // Cosmic background
            LinearGradient(
                colors: [Color(hex: "0F0F20"), Color(hex: "1A0033"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Stars overlay
            GeometryReader { geometry in
                ForEach(0..<50, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.3...0.8)))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            } else if let elements = viewModel.elements {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Forças Elementares")
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                                .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 0)
                            
                            Text("Tattwas")
                                .font(.system(.title3, design: .serif))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        .padding(.top, 20)
                        
                        // Elements List
                        ForEach(elements.forcasElementares, id: \.nome) { element in
                            ElementCell(element: element)
                        }
                        
                        // Additional Observation
                        if !elements.observacaoAdicional.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Observação Adicional")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text(elements.observacaoAdicional)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "1C1C1E").opacity(0.8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchElements()
        }
        .backButtonStyle()
    }
}

struct ElementCell: View {
    let element: ForcasElementares
    @State private var isExpanded = false
    @State private var showFullScreen = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                // Symbol Shape
                Button(action: {
                    if element.nome.uppercased() != "AKASHA" {
                        showFullScreen = true
                    }
                }) {
                    ElementShape(shapeName: element.simbolo.forma, color: elementColor(element.simbolo.cor))
                        .frame(width: 50, height: 50)
                        .shadow(color: elementColor(element.simbolo.cor).opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .buttonStyle(PlainButtonStyle())
                .fullScreenCover(isPresented: $showFullScreen) {
                    ElementFullScreenView(elementName: element.nome, isPresented: $showFullScreen)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(element.nome)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(element.nomeHindu)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // Details
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(title: "Qualidade Básica", value: element.qualidadeBasica)
                    DetailRow(title: "Sentido", value: element.sentidoCorrespondente)
                    DetailRow(title: "Princípio Oculto", value: element.principioOculto)
                    
                    if let naipes = element.naipes {
                        DetailRow(title: "Naipes", value: naipes)
                    }
                    
                    if let uso = element.usoEmMagia {
                        DetailRow(title: "Uso em Magia", value: uso)
                    }
                    
                    HStack(alignment: .top) {
                        Text("Símbolo:")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .frame(width: 100, alignment: .leading)
                        
                        VStack(alignment: .leading) {
                            Text("Forma: \(element.simbolo.forma)")
                            Text("Cor: \(element.simbolo.cor)")
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E").opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(elementColor(element.simbolo.cor).opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
    
    private func elementColor(_ colorString: String) -> Color {
        if colorString.contains("Vermelho") { return .red }
        if colorString.contains("Azul") { return .blue }
        if colorString.contains("Amarelo") { return .yellow }
        if colorString.contains("Índigo") { return Color(hex: "4B0082") } // Indigo
        if colorString.contains("Branco") || colorString.contains("Cinza") { return .black }
        return .gray
    }
}

struct ElementShape: View {
    let shapeName: String
    let color: Color
    
    var body: some View {
        Group {
            if shapeName.contains("Triângulo") {
                Triangle()
                    .fill(color)
                    .overlay(Triangle().stroke(Color.white.opacity(0.5), lineWidth: 2))
            } else if shapeName.contains("Círculo") {
                Circle()
                    .fill(color)
                    .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 2))
            } else if shapeName.contains("Quadrado") {
                Rectangle()
                    .fill(color)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(Rectangle().stroke(Color.white.opacity(0.5), lineWidth: 2))
            } else if shapeName.contains("Meia-lua") || shapeName.contains("Crescente") {
                Crescent()
                    .fill(color)
                    .overlay(Crescent().stroke(Color.white.opacity(0.5), lineWidth: 2))
                    .rotationEffect(Angle(degrees: 90))
            } else if shapeName.contains("Ovo") {
                Ellipse()
                    .fill(color)
                    .frame(width: 40, height: 50)
                    .overlay(Ellipse().stroke(Color.white.opacity(0.5), lineWidth: 2))
            } else {
                Circle()
                    .fill(color)
                    .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 2))
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Crescent: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
        path.addArc(center: CGPoint(x: rect.midX - rect.width * 0.2, y: rect.midY), radius: rect.width / 2.2, startAngle: .degrees(270), endAngle: .degrees(90), clockwise: false)
        path.closeSubpath()
        return path
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}
