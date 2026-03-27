//
//  TattwaShapes.swift
//  tarot
//
//  Created by Fernando Marins on 06/12/25.
//

import SwiftUI

// MARK: - Triangle Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Crescent Shape
struct Crescent: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
        path.addArc(center: CGPoint(x: rect.midX - rect.width * 0.2, y: rect.midY), radius: rect.width / 2.2, startAngle: .degrees(270), endAngle: .degrees(90), clockwise: false)
        path.closeSubpath()
        return path
    }
}
