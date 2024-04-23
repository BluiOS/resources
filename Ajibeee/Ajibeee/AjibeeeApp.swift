//
//  AjibeeeApp.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/6/24.
//

import SwiftUI

@main
struct AjibeeeApp: App {
    @State private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            Areas()
                .environment(viewModel)
        }

        WindowGroup(id: "FirstReallityArea") {
            FirstReallityArea()
                .environment(viewModel)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.6, height: 0.6, depth: 0.6, in: .meters)

        ImmersiveSpace(id: "BallRealityArea") {
            BallRealityArea()
        }

        ImmersiveSpace(id: "FullReallityArea") {
            FullReallityArea()
                .environment(viewModel)
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
