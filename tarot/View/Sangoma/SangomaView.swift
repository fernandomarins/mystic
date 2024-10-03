//
//  SangomaView.swift
//  tarot
//
//  Created by Fernando Marins on 20/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct SangomaView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingIndicator(
                    animation: .circleBars,
                    color: .white,
                    size: .medium
                )
            } else {
                List {
                    Section(
                        header: Text("Sangoma")
                    ) {
                        ForEach(viewModel.sangoma.bones, id: \.self) { bone in
                            VStack(alignment: .leading) {
                                Text(bone.name)
                                    .bold()
                                    .font(.title3)
                                Text(bone.description)
                            }
                        }
                    }
                    Section(
                        header: Text("4 Búzios")
                    ) {
                        ForEach(viewModel.sangoma.buzios, id: \.self) { buzio in
                            VStack(alignment: .leading) {
                                Text(buzio.name)
                                    .bold()
                                    .font(.title3)
                                Text(buzio.description)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
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

#Preview {
    SangomaView()
}
