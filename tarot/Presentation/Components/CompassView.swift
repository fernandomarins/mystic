//
//  CompassView.swift
//  tarot
//
//  Created by Fernando Marins on 04/12/25.
//

import SwiftUI
import CoreLocation

class CompassViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var heading: Double = 0
    private var previousHeading: Double = 0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let newValue = newHeading.magneticHeading
        
        // Normalize the angle difference to prevent full rotations
        var diff = newValue - previousHeading
        if diff > 180 {
            diff -= 360
        } else if diff < -180 {
            diff += 360
        }
        
        self.heading = previousHeading + diff
        self.previousHeading = self.heading
    }
}

struct CompassView: View {
    @StateObject private var viewModel = CompassViewModel()
    let targetDirection: Double? // 0-360, nil if no target
    
    var body: some View {
        VStack {
            ZStack {
                // Compass Rose (rotates with heading)
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 200, height: 200)
                    
                    // Cardinal Points
                    ForEach(0..<4) { index in
                        VStack {
                            Text(cardinalPoint(for: index))
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.bottom, 160)
                        }
                        .rotationEffect(.degrees(Double(index) * 90))
                    }
                    
                    // Needle (Always points North)
                    Image(systemName: "location.north.fill")
                        .resizable()
                        .frame(width: 30, height: 60)
                        .foregroundColor(.red)
                        .shadow(color: .red, radius: 5)
                }
                .rotationEffect(.degrees(-viewModel.heading))
                .animation(.easeInOut, value: viewModel.heading)
                
                // Target Indicator (shows where to turn)
                if let target = targetDirection {
                    Rectangle()
                        .fill(Color.red.opacity(0.5))
                        .frame(width: 4, height: 100)
                        .offset(y: -50)
                        .rotationEffect(.degrees(target - viewModel.heading))
                }
            }
            
            if let target = targetDirection {
                Text(directionDescription(for: target))
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 20)
            }
        }
    }
    
    private func cardinalPoint(for index: Int) -> String {
        switch index {
        case 0: return "N"
        case 1: return "L" // Leste
        case 2: return "S"
        case 3: return "O" // Oeste
        default: return ""
        }
    }
    
    private func directionDescription(for degrees: Double) -> String {
        let diff = abs(degrees - viewModel.heading)
        if diff < 10 || diff > 350 {
            return "Alinhado!"
        } else {
            return "Gire para alinhar"
        }
    }
}
