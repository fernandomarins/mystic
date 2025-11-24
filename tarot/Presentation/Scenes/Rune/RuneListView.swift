//
//  RuneListView.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators
import SwiftData

struct RuneListView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel = RuneViewModel()
    @State private var searchQuery: String = ""
    
    private var filteredRunes: [RuneModel] {
        if searchQuery.isEmpty {
            return viewModel.runes
        } else {
            return viewModel.runes.filter { rune in
                rune.name.lowercased().contains(searchQuery.lowercased())
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Nordic Background
            LinearGradient(
                colors: [Color(hex: "1A2332"), Color(hex: "0F141E"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Snow/Ash particles overlay
            GeometryReader { geometry in
                ForEach(0..<40, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.1...0.3)))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            .ignoresSafeArea()
            
            if viewModel.isLoading {
                LoadingIndicator(
                    animation: .circleBars,
                    color: .cyan,
                    size: .medium
                )
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        // Nordic Header
                        VStack(spacing: 8) {
                            Text("ᚱᚢᚾᛅᛦ") // "Runar" in runes
                                .font(.system(size: 40))
                                .foregroundColor(.cyan.opacity(0.6))
                                .shadow(color: .cyan.opacity(0.3), radius: 10)
                            
                            Text("Runas")
                                .font(.system(size: 36, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                                .shadow(color: .cyan.opacity(0.3), radius: 5)
                            
                            Text("Sabedoria Ancestral")
                                .font(.system(.subheadline, design: .serif))
                                .foregroundColor(.gray)
                                .italic()
                        }
                        .padding(.top, 20)
                        
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 20
                        ) {
                            ForEach(filteredRunes) { rune in
                                NavigationLink(destination: RuneView(rune: rune)) {
                                    RuneCell(rune: rune)
                                }
                            }
                        }
                        .padding()
                        
                        // Footer rune
                        Text("ᛉ")
                            .font(.system(size: 30))
                            .foregroundColor(.cyan.opacity(0.4))
                            .padding(.bottom, 20)
                    }
                }
                .refreshable {
                    await viewModel.fetchRunes(context: modelContext)
                }
                .searchable(text: $searchQuery, prompt: "Buscar Runa")
            }
        }
        .onAppear {
            if viewModel.runes.isEmpty {
                Task {
                    await viewModel.fetchRunes(context: modelContext)
                }
            }
        }
        .backButtonStyle()
    }
}

struct RuneCell: View {
    let rune: RuneModel
    
    var body: some View {
        ZStack {
            // Stone Background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "2C3E50"), Color(hex: "1C2833")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.cyan.opacity(0.3), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.6), radius: 6, x: 0, y: 4)
            
            VStack(spacing: 12) {
                // Glowing Rune Image
                ZStack {
                    // Glow effect
                    Image(uiImage: UIImage(named: rune.name) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .blur(radius: 10)
                        .opacity(0.5)
                        .foregroundColor(.cyan)
                    
                    // Sharp image
                    Image(uiImage: UIImage(named: rune.name) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                }
                
                Text(rune.name)
                    .font(.system(.headline, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.8), radius: 2)
                
                // Decorative line
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .cyan.opacity(0.5), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
                    .frame(width: 60)
            }
            .padding()
        }
        .frame(height: 170)
    }
}

#Preview {
    RuneListView()
}
