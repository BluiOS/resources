//
//  CrewArea.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/6/24.
//

import SwiftUI

struct CrewArea: View {
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                ForEach(Crew.allCases) { item in
                    VStack(alignment: .center) {
                        Image("crew-\(item.name)")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                        Text(item.fullName)
                            .font(.title)
                            .monospaced()
                        Text(item.about)
                            .font(.body)
                            .monospaced()
                    }
                    .padding(32)
                    .glassBackgroundEffect()
                }
            }
        }
        .monospaced()
        .navigationTitle("Information")
    }
}

#Preview {
    Areas()
}
