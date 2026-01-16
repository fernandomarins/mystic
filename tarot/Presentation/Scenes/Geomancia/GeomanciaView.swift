//
//  GeomanciaView.swift
//  tarot
//
//  Created by Antigravity on 15/01/26.
//

import SwiftUI

struct GeomanciaView: View {
    @StateObject private var viewModel = GeomanciaViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingReading = false
    
    // Premium Earthy Color Palette
    private let bgGradient = LinearGradient(
        colors: [Color(hex: "1B1212"), Color(hex: "3D2B1F"), Color(hex: "2D1B10")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ZStack {
            // Background
            bgGradient.ignoresSafeArea()
            
            // Earthy light glows
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(Color(hex: "D4AF37").opacity(0.1))
                        .frame(width: 400, height: 400)
                        .blur(radius: 80)
                        .offset(x: -100, y: geo.size.height - 200)
                    
                    Circle()
                        .fill(Color(hex: "8B4513").opacity(0.15))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: geo.size.width - 200, y: -50)
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(Color(hex: "D4AF37"))
                        .scaleEffect(1.5)
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    errorStateView(error)
                } else {
                    contentView
                }
            }
        }
        .overlay(
            VStack {
                Spacer()
                Button(action: { isShowingReading = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "sparkles")
                        Text("Iniciar Leitura")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 30)
                    .height(60)
                    .background(
                        Capsule()
                            .fill(Color(hex: "D4AF37"))
                            .shadow(color: Color(hex: "D4AF37").opacity(0.4), radius: 10, y: 5)
                    )
                }
                .padding(.bottom, 30)
            }
        )
        .sheet(isPresented: $isShowingReading) {
            GeomanciaReadingView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchForms()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(.ultraThinMaterial))
                    .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 0.5))
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("Geomancia")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .shadow(color: Color(hex: "D4AF37").opacity(0.3), radius: 10)
                
                HStack(spacing: 6) {
                    Circle().fill(Color(hex: "D4AF37")).frame(width: 4, height: 4)
                    Rectangle().fill(Color(hex: "D4AF37").opacity(0.5)).frame(width: 60, height: 1)
                    Circle().fill(Color(hex: "D4AF37")).frame(width: 4, height: 4)
                }
            }
            
            Spacer()
            
            Rectangle()
                .fill(.clear)
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var contentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                Text("As 16 Figuras da Terra")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(Color(hex: "E0E0E0").opacity(0.8))
                    .padding(.horizontal, 20)
                
                // Anatomy Legend (O Zigurate)
                VStack(alignment: .leading, spacing: 12) {
                    Text("ANATOMIA DAS LINHAS")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "D4AF37").opacity(0.5))
                        .tracking(2)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            anatomyItem(label: "1. Cabeça", element: "Fogo")
                            anatomyItem(label: "2. Ombros", element: "Ar")
                            anatomyItem(label: "3. Ventre", element: "Água")
                            anatomyItem(label: "4. Pernas", element: "Terra")
                        }
                    }
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.03)))
                .padding(.horizontal, 20)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.forms) { item in
                        GeomanciaGridCell(item: item)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
    
    private func errorStateView(_ error: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "D4AF37"))
            Text(error)
                .font(.system(.body, design: .serif))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
    
    private func anatomyItem(label: String, element: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
            Text(element)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "D4AF37").opacity(0.7))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "D4AF37").opacity(0.2), lineWidth: 1))
    }
}

struct GeomanciaGridCell: View {
    let item: GeomanciaMeaning
    @State private var isShowingDetail = false
    
    var body: some View {
        Button(action: { isShowingDetail = true }) {
            VStack(spacing: 15) {
                // Dot Pattern
                GeomanticSymbolView(pattern: item.pattern, color: Color(hex: "D4AF37"))
                    .frame(height: 80)
                    .scaleEffect(0.8)
                
                VStack(spacing: 8) {
                    Text(item.name)
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    
                    
                    Text(item.answer)
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.white.opacity(0.05)))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.15), .white.opacity(0.05), Color(hex: "D4AF37").opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .sheet(isPresented: $isShowingDetail) {
            GeomanciaDetailView(item: item)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

// Special component to draw the dots
struct GeomanticSymbolView: View {
    let pattern: [Int] // [Line1, Line2, Line3, Line4]
    let color: Color
    var dotSize: CGFloat = 10
    var spacing: CGFloat = 12
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<4) { index in
                HStack(spacing: spacing) {
                    if pattern[index] == 1 {
                        // Single dot
                        dot
                    } else {
                        // Double dots
                        dot
                        dot
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var dot: some View {
        Circle()
            .fill(color)
            .frame(width: dotSize, height: dotSize)
            .shadow(color: color.opacity(0.5), radius: 2)
    }
}

struct GeomanciaDetailView: View {
    let item: GeomanciaMeaning
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "2D1B10"), Color(hex: "0F0C08")],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            // Decorative elements
            VStack {
                Spacer()
                Image(systemName: "globe.americas.fill")
                    .foregroundColor(Color(hex: "8B4513").opacity(0.05))
                    .font(.system(size: 300))
                    .offset(y: 150)
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 35) {
                    // Pull indicator
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .frame(width: 36, height: 5)
                        .padding(.top, 12)
                    
                    // Card Layout
                    VStack(spacing: 0) {
                        // Top Section with Dot Pattern
                        VStack(spacing: 25) {
                            GeomanticSymbolView(pattern: item.pattern, color: Color(hex: "D4AF37"), dotSize: 14, spacing: 20)
                                .padding(30)
                                .background(
                                    Circle()
                                        .fill(Color(hex: "D4AF37").opacity(0.05))
                                        .overlay(Circle().stroke(Color(hex: "D4AF37").opacity(0.2), lineWidth: 1))
                                )
                                .shadow(color: Color(hex: "D4AF37").opacity(0.3), radius: 20)
                            
                            VStack(spacing: 8) {
                                Text(item.name)
                                    .font(.system(size: 32, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                
                                
                                HStack(spacing: 8) {
                                    if let planet = item.planet {
                                        BadgeView(text: planet, icon: "sparkles", color: .white.opacity(0.6))
                                    }
                                    
                                    if let zodiac = item.zodiac {
                                        BadgeView(text: zodiac, icon: "star.fill", color: .white.opacity(0.6))
                                    }
                                }
                                
                                HStack(spacing: 8) {
                                    BadgeView(text: item.parity, icon: "equal.circle", color: .white.opacity(0.6))
                                    BadgeView(text: item.period, icon: item.period == "Diurna" ? "sun.max.fill" : "moon.fill", color: .white.opacity(0.6))
                                }
                                
                                HStack(spacing: 8) {
                                    BadgeView(text: item.element, icon: "drop.fill", color: Color(hex: "D4AF37").opacity(0.8))
                                    BadgeView(text: item.nature, icon: "scope", color: Color(hex: "D4AF37").opacity(0.8))
                                }
                                .padding(.top, 5)
                            }
                        }
                        .padding(.vertical, 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.03))
                        
                        // Content
                        VStack(spacing: 30) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("SENTIDO TRADICIONAL")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "D4AF37").opacity(0.6))
                                    .tracking(2)
                                
                                Text(item.meaning)
                                    .font(.system(size: 18, weight: .medium, design: .serif))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(6)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Answer
                            VStack(spacing: 12) {
                                Text("O ORÁCULO DIZ:")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.4))
                                    .tracking(2)
                                
                                Text(item.answer)
                                    .font(.system(size: 28, weight: .black, design: .serif))
                                    .foregroundColor(Color(hex: "D4AF37"))
                                    .shadow(color: Color(hex: "D4AF37").opacity(0.5), radius: 10)
                            }
                            .padding(.vertical, 20)
                        }
                        .padding(30)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color(hex: "D4AF37").opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    // Close button
                    Button(action: { dismiss() }) {
                        Text("Voltar ao Grimório")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .height(56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "D4AF37"))
                            )
                            .shadow(color: Color(hex: "D4AF37").opacity(0.4), radius: 10)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct BadgeView: View {
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        Label(text, systemImage: icon)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Capsule().fill(.white.opacity(0.05)))
            .overlay(Capsule().stroke(color.opacity(0.2), lineWidth: 0.5))
    }
}
