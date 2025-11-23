//
//  HoodooListView.swift
//  tarot
//
//  Created by Fernando Marins on 03/10/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct HoodooListView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var hasFetchedData: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    LoadingIndicator(
                        animation: .circleBars,
                        color: .white,
                        size: .large
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let hoodoo = viewModel.hoodoo {
                    List {
                        createSection(
                            title: .spell,
                            items: hoodoo.items.filter { $0.type == .spell }
                        )
                        createSection(
                            title: .oil,
                            items: hoodoo.items.filter { $0.type == .oil }
                        )
                        createSection(
                            title: .jar,
                            items: hoodoo.items.filter { $0.type == .jar }
                        )
                        createSection(
                            title: .mojo,
                            items: hoodoo.items.filter { $0.type == .mojo }
                        )
                    }
                    .listStyle(InsetGroupedListStyle())
                    .scrollIndicators(.hidden)
                    .navigationTitle("Hoodoo")
                    .refreshable {
                        Task {
                            await viewModel.fetchHoodoo()
                        }
                    }
                } else {
                    Text("No data available")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .task {
                if !hasFetchedData {
                    await viewModel.fetchHoodoo()
                    hasFetchedData = true
                }
            }
        }
        .backButtonStyle()
    }
    
    @ViewBuilder
    private func createSection(
        title: HoodooType,
        items: [HoodooItem]
    ) -> some View {
        Section(header: Text(title.rawValue.uppercased())) {
            let sortedItems = items.sorted {
                if $0.categoryType == $1.categoryType {
                    return $0.name < $1.name
                } else {
                    return $0.categoryType < $1.categoryType
                }
            }
            ForEach(sortedItems, id: \.self) { item in
                NavigationLink(destination: HoodooView(item: item)) {
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(item.categoryType)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    HoodooListView()
}
