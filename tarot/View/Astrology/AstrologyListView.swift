//
//  AstrologyListView.swift
//  tarot
//
//  Created by Fernando Marins on 25/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct AstrologyListView: View {
    @StateObject private var viewModel = ViewModel(service: Service())
    @State private var isSearching: Bool = false
    @State private var hasFetchedData: Bool = false
    
    private let planets = ["Sol", "Lua", "Mercúrio", "Vênus", "Marte", "Júpiter", "Saturno", "Urano", "Netuno", "Plutão"]
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    LoadingIndicator(
                        animation: .circleBars,
                        color: .white,
                        size: .medium
                    )
                } else {
                    if let model = viewModel.astrology {
                        List {
                            ForEach(planets, id: \.self) { planet in
                                let description = getDescription(for: planet, in: model.planets)
                                
                                if let description = description {
                                    NavigationLink(destination: AstrologyView(
                                        planet: description,
                                        name: planet)
                                    ) {
                                        Text(planet)
                                    }
                                }
                            }
                        }
                        .navigationTitle("Planetas")
                        .refreshable {
                            Task {
                                if viewModel.astrology == nil {
                                    await viewModel.fetchAstrology()
                                }
                            }
                        }
                        .textInputAutocapitalization(.never)
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .onAppear {
                if !hasFetchedData {
                    Task {
                        await viewModel.fetchAstrology()
                        hasFetchedData = true
                    }
                }
            }
        }
        .toolbar {
            resultsView
        }
    }
    
    @ToolbarContentBuilder
    private var resultsView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if let model = viewModel.astrology {
                NavigationLink(destination: AstrologyResultView(model: model)) {
                    Text("Leitura")
                }
            }
        }
    }

    private func getDescription(for planet: String, in planets: Planets) -> [String: String]? {
        switch planet {
        case "Sol":
            return planets.sunSigns
        case "Lua":
            return planets.moonSigns
        case "Mercúrio":
            return planets.mercurySigns
        case "Vênus":
            return planets.venusSigns
        case "Marte":
            return planets.marsSigns
        case "Júpiter":
            return planets.jupiterSigns
        case "Saturno":
            return planets.saturnSigns
        case "Urano":
            return planets.uranusSigns
        case "Netuno":
            return planets.neptuneSigns
        case "Plutão":
            return planets.plutoSigns
        default:
            return nil
        }
    }
}

#Preview {
    AstrologyListView()
}
