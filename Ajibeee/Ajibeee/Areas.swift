//
//  Areas.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/6/24.
//

import SwiftUI

struct Areas: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        NavigationStack {
            NavigationToAreas()
        }
    }
}

#Preview {
    Areas()
        .environment(ViewModel())
}
