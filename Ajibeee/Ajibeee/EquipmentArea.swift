//
//  EquipmentArea.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/6/24.
//

import SwiftUI

struct EquipmentArea: View {
    @Environment(ViewModel.self) private var viewModel

    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        @Bindable var viewModel = viewModel
        HStack {
            VStack(alignment: .center) {
                Image("Back")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .padding()

                Button {
                    Task {
                        if viewModel.isShowingRocketCapsule {
                            dismissWindow(id: "FirstReallityArea")
                        } else {
                            openWindow(id: "FirstReallityArea")
                        }

                        viewModel.isShowingRocketCapsule.toggle()
                    }
                } label: {
                    Text(viewModel.isShowingRocketCapsule ? "Hide" : "Show")
                        .font(.title)
                }
            }
            .padding()
            .glassBackgroundEffect()

            VStack(alignment: .center) {
                Image("Back")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .padding()

                Button {
                    Task {
                        if viewModel.isShowingFullRocket {
                           await dismissImmersiveSpace()
                        } else {
                           await openImmersiveSpace(id: "FullReallityArea")
                        }

                        viewModel.isShowingFullRocket.toggle()
                    }
                } label: {
                    Text(viewModel.isShowingFullRocket ? "Hide" : "Show")
                        .font(.title)
                }
            }
            .padding()
            .glassBackgroundEffect()
        }
        .monospaced()
    }
}

#Preview {
    EquipmentArea()
        .environment(ViewModel())
}
