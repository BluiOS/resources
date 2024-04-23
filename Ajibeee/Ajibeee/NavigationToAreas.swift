//
//  NavigationToAreas.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/6/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct NavigationToAreas: View {

    @State private var baseYaw: Double = 0
    @State private var yaw: Double = 0
    @State private var basePitch: Double = 0
    @State private var pitch: Double = 0

    var body: some View {
        VStack {
            Text("Welcome!")
                .monospaced()
                .font(.system(size: 48))
                .padding(.top, 40)
            Spacer()
            Spacer()
            Spacer()
            HStack(alignment: .center, spacing: 32) {
                ForEach(Area.allCases) { item in
                    NavigationLink {
                        makeDestinationView(with: item)
                            .padding()
                    } label: {
                        HStack {
                            Text(item.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Image(systemName: "chevron.right")
                                .imageScale(.small)
                        }
                        .monospaced()
                    }
                    .controlSize(.extraLarge)
                }
                Spacer()
            }
            .padding(100)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background() {
            Image("londonBack2")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .overlay(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Model3D(named: "Dice", bundle: realityKitContentBundle) { model in
                model.resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            .dragRotation(yawLimit: .degrees(90), axRotateClockwise: true, axRotateCounterClockwise: true)
            .offset(x: 300)
        }
    }

    @ViewBuilder
    private func makeDestinationView(with area: Area) -> some View {
        switch area {
        case .people:
            CrewArea()
        case .fun:
            EquipmentArea()
        case .game:
            GameArea()
        }
    }
}

#Preview {
    Areas()
}


extension View {
    /// Enables people to drag an entity to rotate it, with optional limitations
    /// on the rotation in yaw and pitch.
    func dragRotation(
        yawLimit: Angle? = nil,
        pitchLimit: Angle? = nil,
        sensitivity: Double = 10,
        axRotateClockwise: Bool = false,
        axRotateCounterClockwise: Bool = false
    ) -> some View {
        self.modifier(
            DragRotationModifier(
                yawLimit: yawLimit,
                pitchLimit: pitchLimit,
                sensitivity: sensitivity,
                axRotateClockwise: axRotateClockwise,
                axRotateCounterClockwise: axRotateCounterClockwise
            )
        )
    }
}

/// A modifier converts drag gestures into entity rotation.
private struct DragRotationModifier: ViewModifier {
    var yawLimit: Angle?
    var pitchLimit: Angle?
    var sensitivity: Double
    var axRotateClockwise: Bool
    var axRotateCounterClockwise: Bool

    @State private var baseYaw: Double = 0
    @State private var yaw: Double = 0
    @State private var basePitch: Double = 0
    @State private var pitch: Double = 0

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(.radians(yaw == 0 ? 0.01 : yaw), axis: .y)
            .rotation3DEffect(.radians(pitch == 0 ? 0.01 : pitch), axis: .x)
            .gesture(DragGesture(minimumDistance: 0.0)
                .targetedToAnyEntity()
                .onChanged { value in
                    // Find the current linear displacement.
                    let location3D = value.convert(value.location3D, from: .local, to: .scene)
                    let startLocation3D = value.convert(value.startLocation3D, from: .local, to: .scene)
                    let delta = location3D - startLocation3D

                    // Use an interactive spring animation that becomes
                    // a spring animation when the gesture ends below.
                    withAnimation(.interactiveSpring) {
                        yaw = spin(displacement: Double(delta.x), base: baseYaw, limit: yawLimit)
                        pitch = spin(displacement: Double(delta.y), base: basePitch, limit: pitchLimit)
                    }
                }
                .onEnded { value in
                    // Find the current and predicted final linear displacements.
                    let location3D = value.convert(value.location3D, from: .local, to: .scene)
                    let startLocation3D = value.convert(value.startLocation3D, from: .local, to: .scene)
                    let predictedEndLocation3D = value.convert(value.predictedEndLocation3D, from: .local, to: .scene)
                    let delta = location3D - startLocation3D
                    let predictedDelta = predictedEndLocation3D - location3D

                    // Set the final spin value using a spring animation.
                    withAnimation(.spring) {
                        yaw = finalSpin(
                            displacement: Double(delta.x),
                            predictedDisplacement: Double(predictedDelta.x),
                            base: baseYaw,
                            limit: yawLimit)
                        pitch = finalSpin(
                            displacement: Double(delta.y),
                            predictedDisplacement: Double(predictedDelta.y),
                            base: basePitch,
                            limit: pitchLimit)
                    }

                    // Store the last value for use by the next gesture.
                    baseYaw = yaw
                    basePitch = pitch
                }
            )
            .onChange(of: axRotateClockwise) {
                withAnimation(.spring) {
                    yaw -= (.pi / 6)
                    baseYaw = yaw
                }
            }
            .onChange(of: axRotateCounterClockwise) {
                withAnimation(.spring) {
                    yaw += (.pi / 6)
                    baseYaw = yaw
                }
            }
            .onAppear {
                withAnimation(.spring.repeatForever(autoreverses: true)) {
                    yaw += (.pi / 6)
                    pitch += (.pi / 3)
                }
            }
    }

    /// Finds the spin for the specified linear displacement, subject to an
    /// optional limit.
    private func spin(
        displacement: Double,
        base: Double,
        limit: Angle?
    ) -> Double {
        if let limit {
            return atan(displacement * sensitivity) * (limit.degrees / 90)
        } else {
            return base + displacement * sensitivity
        }
    }

    /// Finds the final spin given the current and predicted final linear
    /// displacements, or zero when the spin is restricted.
    private func finalSpin(
        displacement: Double,
        predictedDisplacement: Double,
        base: Double,
        limit: Angle?
    ) -> Double {
        // If there is a spin limit, always return to zero spin at the end.
        guard limit == nil else { return 0 }

        // Find the projected final linear displacement, capped at 1 more revolution.
        let cap = .pi * 2.0 / sensitivity
        let delta = displacement + max(-cap, min(cap, predictedDisplacement))

        // Find the final spin.
        return base + delta * sensitivity
    }
}
