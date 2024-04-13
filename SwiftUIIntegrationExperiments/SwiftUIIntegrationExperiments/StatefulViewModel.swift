//
//  StatefulViewModel.swift
//  SwiftUIIntegrationExperiments
//
//  Created by Alireza Asadi on 4/8/24.
//

import Foundation
import UIKit
import Combine

protocol BaseViewModel: AnyObject {

}

protocol BaseRouter: AnyObject {

}

protocol BaseSceneBuilder {
    associatedtype Config
    associatedtype SceneView: UIViewController

    @MainActor static func build(with configuration: Config) -> SceneView
}

extension BaseSceneBuilder where Config == Void {
    @MainActor static func build() -> SceneView {
        return Self.build(with: ())
    }
}


protocol StateProtocol {

}

@MainActor
protocol ViewModel<State, Action>: AnyObject, Sendable {
    associatedtype State: StateProtocol
    associatedtype Action

    var state: State { get }
    var statePublisher: AnyPublisher<State, Never> { get }
    func handle(action: Action)
}

@MainActor
protocol SubjectedViewModel<State, Action>: ViewModel {
    var statePublisher: AnyPublisher<State, Never> { get }
}

@MainActor
@dynamicMemberLookup
protocol StatefulViewModel<State, Action, Destination>: ViewModel {
    var statePublisher: AnyPublisher<State, Never> { get }

    associatedtype Destination
    var destinationPublisher: AnyPublisher<Destination, Never> { get }
}

extension StatefulViewModel {
    subscript<V>(dynamicMember keyPath: KeyPath<State, V>) -> V {
        state[keyPath: keyPath]
    }

    func callAsFunction(action: Action) {
        handle(action: action)
    }
}
