//
//  HerbsListView.swift
//  tarot
//
//  Created by Fernando Marins on 27/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct HerbsListView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var selectedHerbs = Set<Herb>()
    @State private var isSelectionModeActive = false
    @State private var isShowingHerbSelectView = false
    @State private var isShowingHerbAddView = false
    
    var body: some View {
        NavigationStack {
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
        }
        .toolbar {
            selectHerbs
        }
        .sheet(isPresented: $isShowingHerbSelectView) {
            HerbsSelectView(herbs: Array(selectedHerbs))
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
                        Text(isSelectionModeActive ? "Feito" : "Selecine as ervas")
                            .foregroundStyle(.purple)
                    }
                }
            }
        }
    }
    
    private var herbListView: some View {
        List(selection: $selectedHerbs) {
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
        .refreshable {
            Task {
                await viewModel.fetchHerbs()
            }
        }
        .textInputAutocapitalization(.never)
        .scrollIndicators(.hidden)
        .environment(\.editMode, .constant(isSelectionModeActive ? .active : .inactive))
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
        Section(header: Text(title.rawValue)) {
            ForEach(herbs, id: \.self) { herb in
                NavigationLink(destination: HerbView(herb: herb)) {
                    Text(herb.name)
                }
                .onTapGesture {
                    toggleHerbSelection(herb)
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
