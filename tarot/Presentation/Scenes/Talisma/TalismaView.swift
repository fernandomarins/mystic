//
//  TalismaView.swift
//  tarot
//
//  Created by Fernando Marins on 06/12/25.
//

import SwiftUI

struct TalismaView: View {
    private let options: [TalismaOption] = [
        .init(title: "Criar Talismã", subtitle: "Crie seu próprio talismã personalizado", icon: "✨", color: Color(hex: "9D4EDD"))
    ]
    
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
                VStack(spacing: 32) {
                    // Mystical Header
                    VStack(spacing: 12) {
                        Text("✦")
                            .font(.system(size: 40))
                            .foregroundColor(Color(hex: "9D4EDD").opacity(0.8))
                            .shadow(color: Color(hex: "9D4EDD"), radius: 10, x: 0, y: 0)
                        
                        Text("Talismã")
                            .font(.system(size: 42, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .shadow(color: Color(hex: "9D4EDD").opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                    .padding(.top, 40)
                    
                    // Options List
                    VStack(spacing: 20) {
                        ForEach(options) { option in
                            NavigationLink(destination: destinationView(for: option)) {
                                TalismaOptionCell(option: option)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Footer symbol
                    Text("✧")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "9D4EDD").opacity(0.5))
                        .padding(.bottom, 20)
                }
            }
        }
        .backButtonStyle()
    }
    
    @ViewBuilder
    private func destinationView(for option: TalismaOption) -> some View {
        if option.title == "Criar Talismã" {
            CriarTalismaView()
        } else {
            Text("Detalhes do \(option.title)")
        }
    }
}

struct TalismaOption: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

struct TalismaOptionCell: View {
    let option: TalismaOption
    @State private var isGlowing = false
    
    var body: some View {
        ZStack {
            // Outer glow
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    RadialGradient(
                        colors: [option.color.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .blur(radius: 15)
                .opacity(isGlowing ? 0.8 : 0.4)
            
            // Card Background
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [option.color.opacity(0.3), Color.black.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.3), .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: option.color.opacity(0.3), radius: 10, x: 0, y: 5)
            
            HStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(option.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(option.icon)
                        .font(.system(size: 30))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .font(.system(.title3, design: .serif))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(option.subtitle)
                        .font(.system(.subheadline, design: .serif))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding()
        }
        .frame(height: 100)
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: true)
            ) {
                isGlowing = true
            }
        }
    }
}

#Preview {
    NavigationView {
        TalismaView()
    }
}
