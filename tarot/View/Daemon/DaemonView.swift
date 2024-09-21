//
//  DaemonView.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI

struct DaemonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let daemon: DaemonModel
    
    private var sectionColor: Color {
        Color.primary
    }
    
    private func daemonSection(
        title: String,
        content: String?,
        contents: [String]?
    ) -> some View {
        Group {
            if let contents {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .bold()
                    ForEach(contents, id: \.self) { house in
                        let parts = house.split(separator: ":", maxSplits: 1)
                        if parts.count == 2 {
                            Text("\(parts[0]):")
                                .fontWeight(.bold) +
                            Text("\(parts[1])")
                        } else {
                            Text(house)
                        }
                    }
                    Divider()
                        .background(sectionColor)
                }
            }
            if let content = content, !content.isEmpty {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .bold()
                    Text(content)
                    Divider()
                        .background(sectionColor)
                }
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text("\(daemon.id) - \(daemon.name)")
                .font(.title)
                .bold()
            Rectangle()
                .fill(sectionColor)
                .frame(height: 4)
                .frame(maxWidth: .infinity)
            VStack(alignment: .leading, spacing: 16) {
                Image(uiImage: UIImage(named: daemon.name) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .background(colorScheme == .dark ? Color.white : Color.clear)
                
                
                LazyVStack(
                    alignment: .leading,
                    spacing: 16
                ) {
                    daemonSection(title: "Enn", content: daemon.enn, contents: nil)
                    daemonSection(title: "Descrição", content: daemon.description, contents: nil)
                    daemonSection(title: "Planeta", content: daemon.planet, contents: nil)
                    daemonSection(title: "Direção", content: daemon.direction, contents: nil)
                    daemonSection(title: "Pathworking", content: daemon.pathworking, contents: nil)
                    daemonSection(title: "Casas Astrológicas", content: nil, contents: daemon.houses)
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
}

#Preview {
    DaemonView(daemon: .init(id: 1, name: "Baal", enn: "Ayer Secore On Ca Ba al", description: "", planet: "Sol", direction: "Sul", pathworking: "", houses: nil))
}
