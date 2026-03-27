//
//  GeomanciaPDFView.swift
//  tarot
//
//  Created by Antigravity on 16/01/26.
//

import SwiftUI

struct GeomanciaPDFView: View {
    let reading: GeomanciaReading
    let viewModel: GeomanciaReadingViewModel
    
    // PDF Standard Width (A4 at 72dpi is approx 595x842)
    // We design for a fixed width container
    private let pdfWidth: CGFloat = 595
    private let pdfHeight: CGFloat = 842
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Text("Leitura Geomântica")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(.black)
                
                Text(Date(), style: .date)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .padding(.top, 40)
            
            Divider().padding(20)
            
            // Question Section
            if !reading.question.isEmpty {
                VStack(spacing: 8) {
                    Text("CONSULTA")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.gray)
                        .tracking(2)
                    
                    Text("\"\(reading.question)\"")
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .italic()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 20)
            }
            
            // The Square Chart
            GeomanciaSquareChartView(reading: reading, viewModel: viewModel)
                .frame(width: 400, height: 400)
                .padding(.bottom, 20)
            
            // List of Figures Footer
            VStack(alignment: .leading, spacing: 10) {
                Text("RESUMO DAS FIGURAS")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
                    .tracking(2)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)
                
                HStack(alignment: .top, spacing: 20) {
                    // Mothers
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mães").font(.system(size: 10, weight: .bold))
                        ForEach(0..<4) { i in
                            figureRow(label: "M\(i+1)", pattern: reading.mothers[i])
                        }
                    }
                    
                    // Daughters
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Filhas").font(.system(size: 10, weight: .bold))
                        ForEach(0..<4) { i in
                            figureRow(label: "F\(i+1)", pattern: reading.daughters[i])
                        }
                    }
                    
                    // Nieces
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sobrinhas").font(.system(size: 10, weight: .bold))
                        ForEach(0..<4) { i in
                            figureRow(label: "S\(i+1)", pattern: reading.nieces[i])
                        }
                    }
                    
                    // Court
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tribunal").font(.system(size: 10, weight: .bold))
                        figureRow(label: "TE", pattern: reading.leftWitness)
                        figureRow(label: "TD", pattern: reading.rightWitness)
                        figureRow(label: "Juiz", pattern: reading.judge)
                        figureRow(label: "Rec.", pattern: reading.reconciler)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(20)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(width: pdfWidth, height: pdfHeight)
        .background(Color(hex: "F9F5EC")) // Background paper color
    }
    
    private func figureRow(label: String, pattern: [Int]) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.gray)
                .frame(width: 25, alignment: .leading)
            
            if let meaning = viewModel.meaning(for: pattern) {
                Text(meaning.latinName.capitalized)
                    .font(.system(size: 9))
                    .foregroundColor(.black)
            }
        }
    }
}
