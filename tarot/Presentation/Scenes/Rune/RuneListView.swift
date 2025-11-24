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
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            if viewModel.isLoading {
                LoadingIndicator(
                    animation: .circleBars,
                    color: .white,
                    size: .medium
                )
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 16
                    ) {
                        ForEach(filteredRunes) { rune in
                            NavigationLink(destination: RuneView(rune: rune)) {
                                RuneCell(rune: rune)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Runas")
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
                .fill(Color(hex: "1C1C1E"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
            
            VStack(spacing: 12) {
                // Glowing Rune Image
                Image(uiImage: UIImage(named: rune.name) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .shadow(color: .cyan.opacity(0.6), radius: 10, x: 0, y: 0)
                
                Text(rune.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .frame(height: 160)
    }
}

#Preview {
    RuneListView()
}
