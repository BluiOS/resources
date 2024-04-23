//
//  FirstReallityArea.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/6/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct FirstReallityArea: View {
    var body: some View {
        RealityView { content in
            guard let entity = try? await Entity(named: "violin2", in: realityKitContentBundle) else {
                fatalError("Could not found 'violin2' entity.")
            }

            content.add(entity)
        }
    }
}

#Preview {
    FirstReallityArea()
}
