//
//  HerbsListView.swift
//  tarot
//
//  Created by Fernando Marins on 27/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct HerbsListView: View {
    @StateObject private var viewModel = HerbsViewModel()
    @State private var selectedHerbs = Set<Herb>()
    @State private var isSelectionModeActive = false
    @State private var isShowingHerbSelectView = false
    @State private var isShowingHerbAddView = false
    
    var body: some View {
            VStack {
                if viewModel.isLoading {
                    loadingIndicator
                } else if !viewModel.herbs.isEmpty {
                    herbListView
                } else {
                    Text("Nenhuma erva encontrada.")
                        .foregroundColor(.gray)
//                }
//                if !viewModel.herbs.isEmpty {
//                    Button(action: {
//                        isShowingHerbAddView.toggle()
//                    }) {
//                        Text("Adicionar Erva")
//                            .fontWeight(.bold)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.purple)
//                            .foregroundColor(.white)
//                            .cornerRadius(16)
//                    }
//                    .padding()
//                    .sheet(isPresented: $isShowingHerbAddView) {
//                        HerbsAddView()
//                    }
                }
            }
            .navigationTitle("Ervas")
            .onAppear {
                loadHerbsIfNeeded()
            }
//        .toolbar {
//            selectHerbs
//        }
//        .sheet(isPresented: $isShowingHerbSelectView) {
//            HerbsSelectView(herbs: Array(selectedHerbs))
//        }
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
                        Text(isSelectionModeActive ? "Feito" : "Selecione as ervas")
                            .foregroundStyle(.purple)
                    }
                }
            }
        }
    }
    
    private var herbListView: some View {
        ScrollView {
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
        .refreshable {
            Task {
                await viewModel.fetchHerbs()
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.black)
    }
    
    private var loadingIndicator: some View {
        LoadingIndicator(
            animation: .circleBars,
            color: .white,
            size: .medium
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
                await viewModel.fetchHerbs()
            }
        }
    }
}

#Preview {
    HerbsListView()
}
