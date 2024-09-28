//
//  HerbsListView.swift
//  tarot
//
//  Created by Fernando Marins on 27/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct HerbsListView: View {
    @StateObject private var viewModel = ViewModel(service: Service())
    
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
                }
            }
            .navigationTitle("Ervas")
            .onAppear {
                loadHerbsIfNeeded()
            }
        }
    }
    
    private var herbListView: some View {
        List {
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
            }
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
