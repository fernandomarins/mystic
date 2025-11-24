//
//  CabalaView.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/24.
//

import SwiftUI

struct CabalaView: View {
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
            
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "star.circle.fill") // Placeholder icon
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "FFD700"))
                        .shadow(color: Color(hex: "FFD700").opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("Cabala")
                        .font(.system(size: 42, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("Mistérios da Criação")
                        .font(.system(.body, design: .serif))
                        .italic()
                        .foregroundColor(Color.white.opacity(0.7))
                }
                .padding(.top, 40)
                
                // Options Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    NavigationLink(destination: ElementsView()) {
                        CabalaCell(title: "Elementos", icon: "flame.fill", color: .orange)
                    }
                    
                    NavigationLink(destination: TreeView()) {
                        CabalaCell(title: "Árvore da Vida", icon: "tree.fill", color: .green)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .backButtonStyle()
    }
}

struct CabalaCell: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .blur(radius: 5)
                
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.system(.title3, design: .serif))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "1C1C1E").opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.5), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    CabalaView()
}
