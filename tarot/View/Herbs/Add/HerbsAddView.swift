//
//  HerbsAddView.swift
//  tarot
//
//  Created by Fernando Marins on 28/09/24.
//

import SwiftUI

struct HerbsAddView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var name: String = ""
    @State private var type: HerbType = .cold
    @State private var scientificName: String = ""
    @State private var description: String = ""
    @State private var isSubmitting: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Herb Details")) {
                    TextField("Nome", text: $name)
                        .autocapitalization(.words)
                    TextField("Nome Científico", text: $scientificName)
                        .autocapitalization(.sentences)
                    
                    Picker("Tipo", selection: $type) {
                        ForEach(HerbType.allCases, id: \.self) { herbType in
                            Text(herbType.rawValue).tag(herbType)
                        }
                    }
                    
                    TextField("Descrição", text: $description)
                        .autocapitalization(.sentences)
                }
                
                Button(action: postHerb) {
                    if isSubmitting {
                        ProgressView() // Show a loading indicator while submitting
                    } else {
                        Text("Adicionar erva")
                            .foregroundStyle(.purple)
                    }
                }
                .disabled(name.isEmpty || description.isEmpty || isSubmitting) // Disable if fields are empty or submitting
            }
            .navigationTitle("Adicionar erva")
            .alert(item: $viewModel.errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func postHerb() {
        let newHerb = Herb(name: name, scientificName: scientificName, type: type, description: description)
        isSubmitting = true
        
        Task {
            await viewModel.postHerb(newHerb)
            isSubmitting = false
            
            name = ""
            description = ""
            type = .cold
        }
    }
}

#Preview {
    HerbsAddView()
}
