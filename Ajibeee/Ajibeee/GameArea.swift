//
//  GameArea.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/9/24.
//

import SwiftUI

struct GameArea: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        Text("👻")
            .font(.system(size: 64))
            .task {
                await openImmersiveSpace(id: "BallRealityArea")
            }
            .onDisappear {
                Task {
                    await dismissImmersiveSpace()
                }
            }
    }
}

#Preview {
    GameArea()
}
