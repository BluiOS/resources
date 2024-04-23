//
//  ViewModel.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/6/24.
//

import Foundation

@Observable
final class ViewModel {
    var navigationPath: [Area] = []
    var isShowingRocketCapsule: Bool = false
    var isShowingFullRocket: Bool = false
}
