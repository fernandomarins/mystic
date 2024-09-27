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
                    LoadingIndicator(
                        animation: .circleBars,
                        color: .white,
                        size: .medium
                    )
                } else {
                    if !viewModel.herbs.isEmpty {
                        List {
                            ForEach(viewModel.herbs, id: \.self) { herb in
                                HStack {
                                    Text(herb.name)
                                    Spacer()
                                    addCircle(for: herb.type)
                                }
                            }
                        }
                        .navigationTitle("Ervas")
                        .refreshable {
                            Task {
                                if viewModel.alphabet.isEmpty {
                                    await viewModel.fetchHerbs()
                                }
                            }
                        }
                        .textInputAutocapitalization(.never)
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .onAppear {
                if viewModel.alphabet.isEmpty {
                    Task {
                        await viewModel.fetchHerbs()
                    }
                }
            }
        }
        //        .toolbar {
        //            resultsView
        //        }
    }
    
    //    @ToolbarContentBuilder
    //    private var resultsView: some ToolbarContent {
    //        ToolbarItem(placement: .topBarTrailing) {
    //            if let model = viewModel.astrology {
    //                NavigationLink(destination: AstrologyResultView(model: model)) {
    //                    Text("Leitura")
    //                }
    //            }
    //        }
    //    }
    
    private func addCircle(for type: String) -> some View {
        switch type {
        case "Quente":
            return Circle()
                .fill(Color.red)
                .frame(width: 20, height: 20)
        case "Morno":
            return Circle()
                .fill(Color.yellow)
                .frame(width: 20, height: 20)
        case "Frio":
            return Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
        default:
            return Circle()
                .fill(Color.gray) // Default color if no match
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    HerbsListView()
}
