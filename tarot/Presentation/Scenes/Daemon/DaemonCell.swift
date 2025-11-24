//
//  DaemonCell.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import SwiftUI

struct DaemonCell: View {
    let daemon: DaemonModel
    
    var body: some View {
        ZStack {
            // Background (Dark Stone/Metal look)
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.clear, Color.gray.opacity(0.5)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
            
            VStack(spacing: 12) {
                // Rank/Number
                HStack {
                    Spacer()
                    Text("#\(daemon.id)")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                }
                .padding(.top, 12)
                .padding(.trailing, 12)
                
                // Sigil/Image
                Image(daemon.name) // Assuming asset name matches daemon name
                    .resizable()
                    .renderingMode(.template) // Make it white/glowing
                    .foregroundColor(.white.opacity(0.9))
                    .scaledToFit()
                    .frame(height: 60)
                    .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 0) // Mystical glow
                
                Spacer()
                
                // Name
                Text(daemon.name)
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 8)
            }
        }
        .frame(height: 160)
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        DaemonCell(daemon: DaemonModel(id: 1, name: "Bael", enn: "Ayer Secore On Ca Ba'al", description: "First Principal Spirit...", planet: "Sun", direction: "East", pathworking: "Path", houses: []))
            .frame(width: 160)
    }
}
