//
//  Area.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/6/24.
//

import Foundation

enum Area: String, CaseIterable, Identifiable, Equatable {
    case people, fun, game

    var id: Self { self }
    var name: String { rawValue.lowercased() }

    var title: String {
        switch self {
        case .people:
            return "People"
        case .fun:
            return "Fun"
        case .game:
            return "Immersive Game"
        }
    }
}
