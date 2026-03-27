//
//  DadomanciaView.swift
//  tarot
//
//  Created by Antigravity on 12/01/26.
//

import SwiftUI

struct DadomanciaView: View {
    @StateObject private var viewModel = DadomanciaViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    // Premium Color Palette
    private let bgGradient = LinearGradient(
        colors: [Color(hex: "0F0C29"), Color(hex: "302B63"), Color(hex: "24243E")],
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
            
            // Subtle cosmic overlay
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(Color(hex: "5D3FD3").opacity(0.15))
                        .frame(width: 400, height: 400)
                        .blur(radius: 80)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(Color(hex: "D4AF37").opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: geo.size.width - 150, y: geo.size.height - 150)
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
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchMeanings()
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
                Text("Dadomancia")
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
            
            // Spacer to balance the back button
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
                Text("A Divinação pelos Dados")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(Color(hex: "E0E0E0").opacity(0.8))
                    .padding(.horizontal, 20)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.meanings) { item in
                        DadomanciaGridCell(item: item)
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
            Image(systemName: "sparkles.rectangle.stack.fill")
                .font(.system(size: 60))
                .foregroundStyle(.linearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom))
            Text(error)
                .font(.system(.body, design: .serif))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
}

struct DadomanciaGridCell: View {
    let item: DadomanciaMeaning
    @State private var isShowingDetail = false
    
    var body: some View {
        Button(action: { isShowingDetail = true }) {
            VStack(spacing: 15) {
                // Icon
                diceIcon
                    .frame(height: 80)
                    .shadow(color: Color(hex: "D4AF37").opacity(0.4), radius: 8)
                
                VStack(spacing: 8) {
                    Text(item.positiveMeaning)
                        .font(.system(size: 14, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(height: 40)
                    
                    HStack {
                        Spacer()
                        Text(item.answer)
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(item.answer == "SIM" ? .green : (item.answer == "NÃO" ? .red : .purple))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(.white.opacity(0.1)))
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.2), .white.opacity(0.05), Color(hex: "D4AF37").opacity(0.1)],
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
            DadomanciaDetailView(item: item)
        }
    }
    
    @ViewBuilder
    private var diceIcon: some View {
        if item.number <= 6 {
            Image(systemName: "die.face.\(item.number).fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(hex: "D4AF37")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        } else {
            ZStack {
                Circle()
                    .stroke(Color(hex: "D4AF37").opacity(0.5), lineWidth: 2)
                    .frame(width: 60, height: 60)
                
                Image(systemName: "dice.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color(hex: "D4AF37").opacity(0.2))
                
                Text("\(item.number)")
                    .font(.system(size: 24, weight: .black, design: .serif))
                    .foregroundColor(.white)
            }
        }
    }
}

struct DadomanciaDetailView: View {
    let item: DadomanciaMeaning
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1F005C"), Color(hex: "0A0015")],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            // Decorative elements
            VStack {
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(Color(hex: "D4AF37").opacity(0.05))
                    .font(.system(size: 200))
                    .rotationEffect(.degrees(45))
                    .offset(y: 100)
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
                        // Top Section
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "D4AF37").opacity(0.1))
                                    .frame(width: 120, height: 120)
                                    .blur(radius: 10)
                                
                                if item.number <= 6 {
                                    Image(systemName: "die.face.\(item.number).fill")
                                        .font(.system(size: 70))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.white, Color(hex: "D4AF37")],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                } else {
                                    Text("\(item.number)")
                                        .font(.system(size: 60, weight: .black, design: .serif))
                                        .foregroundColor(Color(hex: "D4AF37"))
                                }
                            }
                            .shadow(color: Color(hex: "D4AF37").opacity(0.3), radius: 20)
                            
                            Text("A Sabedoria do Número \(item.number)")
                                .font(.system(size: 24, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 40)
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.white.opacity(0.05)
                        )
                        
                        // Content
                        VStack(spacing: 30) {
                            interpretationSection(
                                title: "Significado Positivo",
                                content: item.positiveMeaning,
                                icon: "sun.max.fill",
                                color: .green
                            )
                            
                            interpretationSection(
                                title: "Significado Negativo",
                                content: item.negativeMeaning,
                                icon: "moon.stars.fill",
                                color: .red
                            )
                            
                            // Oracle Answer
                            VStack(spacing: 12) {
                                Text("O ORÁCULO DIZ:")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white.opacity(0.4))
                                    .tracking(2)
                                
                                Text(item.answer)
                                    .font(.system(size: 40, weight: .black, design: .serif))
                                    .foregroundColor(Color(hex: "D4AF37"))
                                    .shadow(color: Color(hex: "D4AF37").opacity(0.5), radius: 15)
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
                        Text("Fechar Oráculo")
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
    
    private func interpretationSection(title: String, content: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color.opacity(0.8))
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color.opacity(0.8))
            }
            
            Text(content)
                .font(.system(size: 18, weight: .medium, design: .serif))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(color.opacity(0.15), lineWidth: 1)
                        )
                )
        }
    }
}

// Custom ButtonStyle for scaling effect without blocking scroll
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// Extension to handle view helpers
extension View {
    func height(_ value: CGFloat) -> some View {
        self.frame(height: value)
    }
}

#Preview {
    NavigationView {
        DadomanciaView()
    }
}
