//
//  Section.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import Foundation
import SwiftUI

enum SectionName: String {
    case tarot = "Tarot"
    case runes = "Runas"
    case daemons = "Daemons"
    case bones = "Ossos"
    case alphabet = "Alfabeto"
    case astrology = "Astrologia"
    case herbs = "Ervas"
}

struct Main: Identifiable {
    let id: Int
    let name: SectionName
}
