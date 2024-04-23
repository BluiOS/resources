//
//  BallRealityArea.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct BallRealityArea: View {
    @State private var entity: Entity = .init()

    var body: some View {
        RealityView { content in
            let floor = ModelEntity(mesh: .generatePlane(width: 50, depth: 50), materials: [OcclusionMaterial()])
            floor.generateCollisionShapes(recursive: false)
            floor.components[PhysicsBodyComponent.self] = .init(
                massProperties: .default,
                mode: .static
            )
            content.add(floor)

            for item in 0..<5 {
                let boxMesh = MeshResource.generateBox(size: 0.3)
                let material = SimpleMaterial(color: .random(), isMetallic: true)
                let box = ModelEntity(mesh: boxMesh, materials: [material])

                box.position.y = 0.5
                box.position.z = -1 * Float(item / 2)

                box.generateCollisionShapes(recursive: false)
                box.components.set(InputTargetComponent())
                box.components.set(GroundingShadowComponent(castsShadow: true))

                box.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
                    massProperties: .default,
                    material: .generate(staticFriction: 0.8, dynamicFriction: 0.5, restitution: 0.1),
                    mode: .dynamic
                ))
                box.components[PhysicsMotionComponent.self] = .init()

                content.add(box)
            }
        }
        .gesture(gesture)
    }

    var gesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged({ value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
            })
            .onEnded({ value in
                value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
            })
    }
}

#Preview {
    BallRealityArea()
}


public extension Color {
    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}


extension UIColor {
    static func random(hue: CGFloat = CGFloat.random(in: 0...1),
                       saturation: CGFloat = CGFloat.random(in: 0.5...1), // from 0.5 to 1.0 to stay away from white
                       brightness: CGFloat = CGFloat.random(in: 0.5...1), // from 0.5 to 1.0 to stay away from black
                       alpha: CGFloat = 1) -> UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
