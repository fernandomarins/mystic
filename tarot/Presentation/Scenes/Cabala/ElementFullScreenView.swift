//
//  ElementFullScreenView.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/24.
//

import SwiftUI

struct ElementFullScreenView: View {
    let elementName: String
    @Binding var isPresented: Bool
    @State private var showInverse: Bool = false
    @State private var showCloseButton: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showCloseButton.toggle()
                    }
                }
            
            // Close Button
            if showCloseButton {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    Spacer()
                }
                .zIndex(1)
                .transition(.opacity)
            }
            
            // Image
            if let imageName = currentImageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        showInverse.toggle()
                    }
            } else {
                Text("Imagem não encontrada")
                    .foregroundColor(.white)
            }
        }
    }
    
    private var currentImageName: String? {
        let normalizedName = elementName.lowercased()
        
        // Base name mapping
        let baseName: String
        if normalizedName == "água" || normalizedName == "agua" {
            baseName = "água" // Note: using the specific character from file system if needed, but standard 'água' usually works. 
                             // The file system listing showed 'água' which might be NFD normalized.
                             // Let's try standard 'água' first, or just map based on the input name.
        } else {
            baseName = normalizedName
        }
        
        if showInverse {
            // Handle specific naming conventions found in assets
            switch baseName {
            case "ar":
                return "ar-inverso"
            case "fogo":
                return "fogo - inverso"
            case "terra":
                return "terra - inverso"
            case "água", "água":
                return "água - inverso" // Copying the likely NFD form just in case, or relying on asset catalog matching
            default:
                return "\(baseName) - inverso"
            }
        } else {
            return baseName
        }
    }
}
