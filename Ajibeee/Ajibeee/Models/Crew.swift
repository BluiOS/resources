//
//  Crew.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/6/24.
//

import Foundation

enum Crew: String, Identifiable, CaseIterable, Equatable {
    case jared, sian, haley, chris

    var id: Self { self }
    var name: String { rawValue.lowercased() }

    var fullName: String {
        switch self {
        case .jared:
            return "Jared"
        case .sian:
            return "Sian"
        case .haley:
            return "Haley"
        case .chris:
            return "Chris"
        }
    }

    var about: String {
        switch self {
        case .jared:
            return "detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail"
        case .sian:
            return "detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail"
        case .haley:
            return "detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail"
        case .chris:
            return "detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail detail"
        }
    }
}
