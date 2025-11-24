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
            // Hell Card Background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "1A0505"), Color(hex: "0A0000")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "FF4500").opacity(0.6), Color(hex: "8B0000").opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: Color(hex: "FF0000").opacity(0.3), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 12) {
                // Rank/Number
                HStack {
                    Spacer()
                    Text("#\(daemon.id)")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "FF4500").opacity(0.7))
                }
                .padding(.top, 12)
                .padding(.trailing, 12)
                
                // Sigil/Image with Fire Glow
                ZStack {
                    Image(daemon.name)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(hex: "FF4500"))
                        .scaledToFit()
                        .frame(height: 60)
                        .blur(radius: 6)
                        .opacity(0.6)
                    
                    Image(daemon.name)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(height: 60)
                }
                
                Spacer()
                
                // Name
                Text(daemon.name)
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "FFE5B4")) // Pale gold/flesh
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 8)
                    .shadow(color: .red.opacity(0.5), radius: 2)
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
