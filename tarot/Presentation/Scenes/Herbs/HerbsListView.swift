//
//  HerbsListView.swift
//  tarot
//
//  Created by Fernando Marins on 27/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators
import SwiftData

struct HerbsListView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel = HerbsViewModel()
    @State private var selectedHerbs = Set<Herb>()
    @State private var isSelectionModeActive = false
    @State private var isShowingHerbSelectView = false
    @State private var isShowingHerbAddView = false
    
    var body: some View {
        ZStack {
            // Forest Background
            LinearGradient(
                colors: [Color(hex: "051A05"), Color(hex: "0A200A"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Fireflies/Magic particles overlay
            GeometryReader { geometry in
                ForEach(0..<25, id: \.self) { _ in
                    Circle()
                        .fill(Color(hex: "CCFF00").opacity(Double.random(in: 0.1...0.3)))
                        .frame(width: CGFloat.random(in: 2...4))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .shadow(color: .green, radius: 4)
                }
            }
            .ignoresSafeArea()
            
            if viewModel.isLoading {
                loadingIndicator
            } else {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Forest Header
                            VStack(spacing: 8) {
                                Text("Grimório Verde")
                                    .font(.system(size: 36, weight: .bold, design: .serif))
                                    .foregroundColor(Color(hex: "90EE90")) // Light Green
                                    .shadow(color: .green.opacity(0.5), radius: 10)
                                
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(hex: "228B22")) // Forest Green
                                    .padding(.top, 4)
                            }
                            .padding(.top, 20)
                            
                            if !viewModel.herbs.isEmpty {
                                herbListView
                            } else {
                                Text("Nenhuma erva encontrada.")
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            }
                        }
                    }
                    .refreshable {
                        Task {
                            await viewModel.fetchHerbs(context: modelContext)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .navigationTitle("Ervas")
        .onAppear {
            loadHerbsIfNeeded()
        }
        .backButtonStyle()
    }
    
    @ToolbarContentBuilder
    private var selectHerbs: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack {
                if !viewModel.herbs.isEmpty {
                    Button(action: {
                        if isSelectionModeActive {
                            isShowingHerbSelectView = true
                        }
                        isSelectionModeActive.toggle()
                    }) {
                        Text(isSelectionModeActive ? "Feito" : "Selecionar")
                            .font(.system(.body, design: .serif))
                            .foregroundStyle(Color(hex: "90EE90"))
                    }
                }
            }
        }
    }
    
    private var herbListView: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
            let hotHerbs = viewModel.getHerbType(type: .hot)
            if !hotHerbs.isEmpty {
                createSection(title: .hot, herbs: hotHerbs)
            }
            
            let warmHerbs = viewModel.getHerbType(type: .warm)
            if !warmHerbs.isEmpty {
                createSection(title: .warm, herbs: warmHerbs)
            }
            
            let coldHerbs = viewModel.getHerbType(type: .cold)
            if !coldHerbs.isEmpty {
                createSection(title: .cold, herbs: coldHerbs)
            }
        }
        .padding()
    }
    
    private var loadingIndicator: some View {
        LoadingIndicator(
            animation: .circleBars,
            color: .white,
            size: .large
        )
    }
    
    @ViewBuilder
    private func createSection(title: HerbType, herbs: [Herb]) -> some View {
        Section(header: 
            Text(title.rawValue)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
        ) {
            ForEach(herbs, id: \.self) { herb in
                if isSelectionModeActive {
                    HerbCell(herb: herb, isSelected: selectedHerbs.contains(herb))
                        .onTapGesture {
                            toggleHerbSelection(herb)
                        }
                } else {
                    NavigationLink(destination: HerbView(herb: herb)) {
                        HerbCell(herb: herb, isSelected: false)
                    }
                }
            }
        }
    }
    
    private func toggleHerbSelection(_ herb: Herb) {
        if selectedHerbs.contains(herb) {
            selectedHerbs.remove(herb)
        } else {
            selectedHerbs.insert(herb)
        }
    }
    
    private func loadHerbsIfNeeded() {
        if viewModel.herbs.isEmpty {
            Task {
                await viewModel.fetchHerbs(context: modelContext)
            }
        }
    }
}

#Preview {
    HerbsListView()
}
