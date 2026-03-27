//
//  SangomaView.swift
//  tarot
//
//  Created by Fernando Marins on 20/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct SangomaView: View {
    @StateObject private var viewModel = SangomaViewModel()
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1B0000"), Color(hex: "2D1B18"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Dust/Bone particles overlay
            GeometryReader { geometry in
                ForEach(0..<30, id: \.self) { _ in
                    Circle()
                        .fill(Color(hex: "D7CCC8").opacity(Double.random(in: 0.05...0.15)))
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
                    color: Color(hex: "D7CCC8"),
                    size: .large
                )
            } else {
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "skull.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color(hex: "D7CCC8"))
                                .shadow(color: Color(hex: "3E2723").opacity(0.8), radius: 10, x: 0, y: 0)
                            
                            Text("Sangoma")
                                .font(.system(size: 42, weight: .bold, design: .serif))
                                .foregroundColor(Color(hex: "EFEBE9"))
                                .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 2)
                            
                            Text("A Sabedoria dos Ossos")
                                .font(.system(.body, design: .serif))
                                .italic()
                                .foregroundColor(Color(hex: "BCAAA4"))
                        }
                        .padding(.top, 40)
                        
                        // Bones Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Ossos Sagrados", icon: "cross.case.fill")
                            
                            ForEach(viewModel.sangoma.bones, id: \.self) { bone in
                                SangomaCell(
                                    title: bone.name,
                                    description: bone.description,
                                    type: .bone
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Buzios Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Leitura de Búzios", icon: "eye.fill")
                            
                            ForEach(viewModel.sangoma.buzios, id: \.self) { buzio in
                                SangomaCell(
                                    title: buzio.name,
                                    description: buzio.description,
                                    type: .buzio
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchSangoma()
            }
        }
        .backButtonStyle()
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "8D6E63"))
            Text(title)
                .font(.system(.title2, design: .serif))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "D7CCC8"))
            
            VStack {
                Divider()
                    .background(Color(hex: "5D4037"))
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    SangomaView()
}
