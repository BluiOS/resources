//
//  FullReallityArea.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/6/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct FullReallityArea: View {
    @State private var audioController: AudioPlaybackController?

    var body: some View {
        RealityView { content in
            guard let entity = try? await Entity(named: "Full", in: realityKitContentBundle) else {
                fatalError("Could not found 'Full' entity.")
            }

            guard 
                let londonEntity = try? await Entity(named: "bigBenEdited2", in: realityKitContentBundle),
                let bigBen = londonEntity.children.first?.children.first
            else {
                fatalError("Could not found 'bigBenEdited2' entity.")
            }

            guard let resource = try? await AudioFileResource(named: "/Root/Jalal_Hemmati___Parish___128_mp3", from: "FullImmersive.usdz", in: realityKitContentBundle) else {
                fatalError("Could not found ambientAudio.")
            }

            let ambientAudioEntity = entity.findEntity(named: "AmbientAudio")

            audioController = ambientAudioEntity?.prepareAudio(resource)
            audioController?.play()

//            bigBen.scale = [0.1, 0.1, 0.1]
//            bigBen.position.y = -0.5
            content.add(londonEntity)
            content.add(entity)
        }
        .onDisappear {
            audioController?.stop()
        }
    }
}

#Preview {
    FullReallityArea()
}
