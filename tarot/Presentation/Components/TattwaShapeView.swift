//
//  TattwaShapeView.swift
//  tarot
//
//  Created by Fernando Marins on 06/12/25.
//

import SwiftUI

struct TattwaShapeView: View {
    let shape: TattwaShape
    let color: Color
    var strokeColor: Color = .white
    var strokeWidth: CGFloat = 2
    
    var body: some View {
        Group {
            switch shape {
            case .triangle:
                Triangle()
                    .fill(color)
                    .overlay(Triangle().stroke(strokeColor.opacity(0.5), lineWidth: strokeWidth))
            case .circle:
                Circle()
                    .fill(color)
                    .overlay(Circle().stroke(strokeColor.opacity(0.5), lineWidth: strokeWidth))
            case .square:
                Rectangle()
                    .fill(color)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(Rectangle().stroke(strokeColor.opacity(0.5), lineWidth: strokeWidth))
            case .invertedTriangle:
                Triangle()
                    .fill(color)
                    .overlay(Triangle().stroke(strokeColor.opacity(0.5), lineWidth: strokeWidth))
                    .rotationEffect(Angle(degrees: 180))
            case .oval:
                Ellipse()
                    .fill(color)
                    .aspectRatio(0.8, contentMode: .fit)
                    .overlay(Ellipse().stroke(strokeColor.opacity(0.5), lineWidth: strokeWidth))
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            TattwaShapeView(shape: .triangle, color: .red)
                .frame(width: 60, height: 60)
            TattwaShapeView(shape: .circle, color: .blue)
                .frame(width: 60, height: 60)
            TattwaShapeView(shape: .square, color: .yellow)
                .frame(width: 60, height: 60)
        }
        HStack(spacing: 20) {
            TattwaShapeView(shape: .invertedTriangle, color: .purple)
                .frame(width: 60, height: 60)
            TattwaShapeView(shape: .oval, color: .green)
                .frame(width: 60, height: 60)
        }
    }
    .padding()
    .background(Color.black)
}
