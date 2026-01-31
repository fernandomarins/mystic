//
//  GeomanciaSquareChartView.swift
//  tarot
//
//  Created by Antigravity on 16/01/26.
//

import SwiftUI

struct GeomanciaSquareChartView: View {
    let reading: GeomanciaReading
    let viewModel: GeomanciaReadingViewModel
    
    // Fixed size for PDF export consistency, or scalable
    // We will use GeometryReader for flexibility
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let s = min(w, h)
            let center = CGPoint(x: w/2, y: h/2)
            let rect = CGRect(x: (w-s)/2, y: (h-s)/2, width: s, height: s)
            
            ZStack {
                // 1. Background (Parchment-like)
                Rectangle()
                    .fill(Color(hex: "F9F5EC")) // Light parchment
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                
                // 2. The Main Cross (Diagonals)
                Path { path in
                    path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                    path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                }
                .stroke(Color.black, lineWidth: 1)
                
                // 3. The Inner Diamond (Rhombus)
                Path { path in
                    path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // Top
                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY)) // Right
                    path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY)) // Bottom
                    path.addLine(to: CGPoint(x: rect.minX, y: rect.midY)) // Left
                    path.closeSubpath()
                }
                .stroke(Color.black, lineWidth: 1)
                
                // 4. House Labels & Figures
                // We need to position 12 houses.
                // Standard Layout:
                // H10: Top Center (Inside Top Triangle?) No, usually 10 is Top.
                // Let's use the layout:
                // Top Triangle: 10
                // Right Triangle: 7
                // Bottom Triangle: 4
                // Left Triangle: 1
                // Top-Left Corner splits into 11 & 12
                // Top-Right Corner splits into 8 & 9
                // Bottom-Right Corner splits into 5 & 6
                // Bottom-Left Corner splits into 2 & 3
                
                // Draw dividers for corners
                Path { path in
                    // Top-Left (11/12)
                    // Midpoint of Top-Left diagonal to where?
                    // Inner square side midpoint? Or corner to inner square corner?
                    // Often it's a line from the outer frame to the inner diamond "parallel" to the cross.
                    // Let's approximate standard: Line from (25%, 25%) to... well, usually it cuts the corner.
                    
                    // Simple approximation: A small square rotated
                    // Let's just place items coordinates for simplicity first.
                }
                
                // Borders for the corner splitters (Houses 11|12, 8|9, 5|6, 2|3)
                // Midpoints of outer sides to midpoints of inner diamond sides
                // No, that's effectively the inner diamond lines.
                // The diagonal crosses the corner. To split 11 and 12, we need a line from the Center of the quadrant?
                // Visual reference: The diagonal splits the square into 4 triangles.
                // The Inner Diamond cuts those triangles in half (tip to base).
                // The REMAINING corner triangles (outside diamond) are split in two.
                // Line from Outer Corner to Inner Diamond Corner? No, that's the main diagonal.
                // Line from midpoint of Outer Side to corresponding corner of Diamond?
                // YES. This creates the "Kite" shapes.
                
                // Vertical and Horizontal lines from Diamond points to Outer Frame?
                Path { path in
                    // Top (10) is bounded by Top-Left-Mid-Diamond-Top-Right.
                    // 9 and 11 are adjacent.
                    
                    // Let's draw the lines to split the corners:
                    // Top-Left Corner Quadrant: 11 & 12. Split by a line from Top-Left Corner to... ?
                    // actually, the diagonal IS the split between 11/12? No.
                    
                    // Let's use coordinate geometry for placements.
                }
                
                // Rendering Houses
                
                // House 1 (Vita) - Left Triangle (East)
                houseView(id: 1, rect: rect, pos: .left)
                
                // House 4 (Genitor) - Bottom Triangle (North)
                houseView(id: 4, rect: rect, pos: .bottom)
                
                // House 7 (Uxor) - Right Triangle (West)
                houseView(id: 7, rect: rect, pos: .right)
                
                // House 10 (Regnum) - Top Triangle (South)
                houseView(id: 10, rect: rect, pos: .top)
                
                // Corners
                // Top-Left: 12 (Right of diag), 11 (Left of diag)?
                // Standard: 12 is above Ascendant (1). So 12 is "Lower Top-Left". 11 is "Upper Top-Left"?
                // Let's look at the sequence counter-clockwise from 1.
                // 1 (Left), 2 (Bottom-Left-Lower), 3 (Bottom-Left-Upper/Right?), 4 (Bottom).
                
                // Let's defined positions based on percentages of width/height
                // Center is 0.5, 0.5
                // H1 Center: 0.15, 0.5
                // H7 Center: 0.85, 0.5
                // H10 Center: 0.5, 0.15
                // H4 Center: 0.5, 0.85
                
                // H12 (Above H1): 0.25, 0.35
                // H11 (Left of H10): 0.35, 0.25
                // H9 (Right of H10): 0.65, 0.25
                // H8 (Above H7): 0.75, 0.35
                // H6 (Below H7): 0.75, 0.65
                // H5 (Right of H4): 0.65, 0.75
                // H3 (Left of H4): 0.35, 0.75
                // H2 (Below H1): 0.25, 0.65
                
                Group {
                    houseView(id: 12, rect: rect, align: .center)
                        .position(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.35)
                    houseView(id: 11, rect: rect, align: .center)
                        .position(x: rect.minX + rect.width * 0.35, y: rect.minY + rect.height * 0.2)
                    
                    houseView(id: 9, rect: rect, align: .center)
                        .position(x: rect.minX + rect.width * 0.65, y: rect.minY + rect.height * 0.2)
                    houseView(id: 8, rect: rect, align: .center)
                        .position(x: rect.minX + rect.width * 0.8, y: rect.minY + rect.height * 0.35)
                    
                    houseView(id: 6, rect: rect, align: .center)
                        .position(x: rect.minX + rect.width * 0.8, y: rect.minY + rect.height * 0.65)
                    houseView(id: 5, rect: rect, align: .center)
                        .position(x: rect.minX + rect.width * 0.65, y: rect.minY + rect.height * 0.8)
                    
                    houseView(id: 3, rect: rect, align: .center)
                        .position(x: rect.minX + rect.width * 0.35, y: rect.minY + rect.height * 0.8)
                    houseView(id: 2, rect: rect, align: .center)
                        .position(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.65)
                }
                
                // Center Court (Witnesses & Judge)
                // In the diamond
                VStack(spacing: 8) {
                    Text("O TRIBUNAL")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.black.opacity(0.5))
                    
                    HStack(spacing: 15) {
                        miniFigure(id: 14, label: "T14") // Left Witness
                        miniFigure(id: 13, label: "T13") // Right Witness
                    }
                    
                    miniFigure(id: 15, label: "JUIZ") // Judge
                    
                    miniFigure(id: 16, label: "RECONC.") // Reconciler
                }
                .position(x: rect.midX, y: rect.midY)
            }
            // Draw extra lines for the corners
            .overlay(
                Path { path in
                    // Divide corners
                    // Top Left (11/12): Line from (0,0) to center? No, main diag does that.
                    // We need a line perpendicular to main diagonal?
                    // Usually it's straight vertical/horizontal or angled.
                    // Let's draw lines from inner diamond corners to outer square sides matching the house splits.
                    // H11/H12 border is often the diagonal.
                    // Wait, standard chart:
                    // H12 is adjacent to H1. H11 is adjacent to H10.
                    // So layout is 12, 11 between 1 and 10.
                    // The divider between 11 and 12 is the Diagonal from Top-Left to Center.
                    // The divider between 12 and 1 is the Diamond line.
                    // The divider between 11 and 10 is the Diamond line.
                    // Wait, 1, 4, 7, 10 are the TRIANGLES touching the diamond matching the sides?
                    // Or are they the CORNERS?
                    // In "Square Chart", 1, 10, 7, 4 are usually the TRIANGLES.
                    // 1 = Left Triangle. 10 = Top. 7 = Right. 4 = Bottom.
                    // Then the corners are split.
                    // Top-Left Corner: 11 & 12.
                    // Divider between 11 & 12 is the diagonal line.
                    // H12 is the lower half (touching H1), H11 is the upper half (touching H10).
                    
                    // So we need to draw nothing extra if the main X is there?
                    // The main X splits the corner into 2 triangles.
                    // But one triangle is 11, one is 12?
                    // Wait. Corner is 90 deg. Diagonal splits into 45/45.
                    // So 12 is below diagonal, 11 is above? Yes.
                    // But we also have the Diamond blocking the center.
                    // So H12 region is bound by: Outer Left Edge, Diagonal, Inner Diamond Edge (Top-Left side).
                    // This seems correct.
                }
                    .stroke(Color.black, lineWidth: 1)
            )
        }
    }
    
    // MARK: - Helpers
    
    enum HousePos { case top, bottom, left, right, center }
    
    func houseView(id: Int, rect: CGRect, pos: HousePos = .center, align: Alignment = .center) -> some View {
        let pattern = viewModel.figurePattern(forHouse: id)
        
        return ZStack {
            // House Number (Top/Center)
            Text("\(id)")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.black)
                .padding(3)
                .background(Circle().stroke(Color.black, lineWidth: 1))
                .offset(y: -25) // Move up
            
            // Zodiac Sign (Corner/Background)
            Text(zodiacForHouse(id))
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.3))
                .offset(x: 20, y: -20)
            
            // Role Label (M1, F1...)
            Text(roleForHouse(id))
                .font(.system(size: 6, weight: .bold))
                .foregroundColor(.black.opacity(0.6))
                .offset(x: -20, y: -20)
            
            // Figure (Center)
            GeomanticSymbolView(pattern: pattern, color: .black, dotSize: 4, spacing: 3)
                .frame(height: 30)
                .offset(y: 5)
        }
        .frame(width: 50, height: 60)
        .position(posFromEnum(pos, rect: rect))
    }
    
    func zodiacForHouse(_ id: Int) -> String {
        let signs = ["♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓"]
        return signs[(id - 1) % 12]
    }
    
    func roleForHouse(_ id: Int) -> String {
        switch id {
        case 1: return "M1"
        case 2: return "M2"
        case 3: return "M3"
        case 4: return "M4"
        case 5: return "F1"
        case 6: return "F2"
        case 7: return "F3"
        case 8: return "F4"
        case 9: return "S1"
        case 10: return "S2"
        case 11: return "S3"
        case 12: return "S4"
        default: return ""
        }
    }
    
    func posFromEnum(_ pos: HousePos, rect: CGRect) -> CGPoint {
        switch pos {
        case .top: return CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.15)
        case .bottom: return CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.15)
        case .left: return CGPoint(x: rect.minX + rect.width * 0.15, y: rect.midY)
        case .right: return CGPoint(x: rect.maxX - rect.width * 0.15, y: rect.midY)
        case .center: return CGPoint(x: rect.midX, y: rect.midY)
        }
    }
    
    func miniFigure(id: Int, label: String) -> some View {
        let pattern: [Int]
        if id == 13 { pattern = reading.rightWitness }
        else if id == 14 { pattern = reading.leftWitness }
        else if id == 15 { pattern = reading.judge }
        else { pattern = reading.reconciler }
        
        return VStack(spacing: 1) {
            Text(label)
                .font(.system(size: 6, weight: .bold))
            GeomanticSymbolView(pattern: pattern, color: .black, dotSize: 3, spacing: 2)
        }
    }
}
