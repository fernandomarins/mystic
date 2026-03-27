//
//  LuciferianView.swift
//  tarot
//
//  Created by Fernando Marins on 04/12/25.
//

import SwiftUI

struct LuciferianView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentStepIndex = 0
    private let steps = LuciferianModel.steps
    
    var currentStep: LuciferianStep {
        steps[currentStepIndex]
    }
    
    var progress: Double {
        Double(currentStepIndex + 1) / Double(steps.count)
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "0A0000"), Color(hex: "1A0000"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Bar - Fixed at top
                VStack(spacing: 12) {
                    ProgressView(value: progress)
                        .tint(.purple)
                        .padding(.horizontal)
                    
                    // Part Title
                    Text(currentStep.part.rawValue)
                        .font(.system(.title3, design: .serif))
                        .foregroundColor(.purple.opacity(0.8))
                }
                .padding(.top)
                .frame(height: 80)
                
                // Main Content - Scrollable
                ScrollView {
                    VStack(spacing: 32) {
                        // Instruction
                        Text(currentStep.instruction)
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity)
                        
                        // Compass (if needed)
                        if currentStep.isCompassStep {
                            CompassView(targetDirection: currentStep.direction)
                                .frame(height: 250)
                        }
                        
                        // Mantra & Visualization
                        if let mantra = currentStep.mantra {
                            VStack(spacing: 8) {
                                Text("Mantra")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(mantra)
                                    .font(.system(size: 32, weight: .bold, design: .serif))
                                    .foregroundColor(.purple)
                                    .multilineTextAlignment(.center)
                                    .shadow(color: .purple, radius: 10)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        // Show Black Cross for blackCross part
                        if currentStep.part == .blackCross && currentStep.mantra != nil {
                            BlackCrossView(mantra: currentStep.mantra)
                                .frame(width: 200, height: 200)
                        }
                        
                        if let visualization = currentStep.visualization {
                            if visualization == "Pentagrama invertido de fogo" {
                                PentagramView(inverted: true, showVowels: false)
                                    .frame(width: 300, height: 300)
                            } else if visualization.contains("Cruz") || visualization.contains("cruz") {
                                BlackCrossView(mantra: currentStep.mantra)
                                    .frame(width: 300, height: 300)
                            } else {
                                VStack(spacing: 8) {
                                    Text("Visualização")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(visualization)
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
                
                // Navigation Controls - Fixed at bottom
                HStack {
                    if currentStepIndex > 0 {
                        Button(action: {
                            withAnimation {
                                currentStepIndex -= 1
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.white.opacity(0.1)))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if currentStepIndex < steps.count - 1 {
                            withAnimation {
                                currentStepIndex += 1
                            }
                        } else {
                            dismiss()
                        }
                    }) {
                        Text(currentStepIndex < steps.count - 1 ? "Próximo" : "Concluir")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .fill(Color.purple.opacity(0.6))
                                    .shadow(color: .purple.opacity(0.4), radius: 10)
                            )
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                .frame(height: 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LuciferianView()
}
