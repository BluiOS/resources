//
//  StatefulViewModel.swift
//  ArchitectureExperiments
//
//  Created by Alireza Asadi on 4/6/24.
//

import Foundation
import UIKit
import Combine

protocol BaseViewModel: AnyObject {

}

protocol BaseRouter: AnyObject {

}

// MARK: - ViewModel Protocols

protocol StateProtocol {
//    func updated(_ handler: (inout Self) -> Void) -> Self
}
//
//extension StateProtocol {
//    func updated(_ handler: (inout Self) -> Void) -> Self {
//        var result = self
//        handler(&result)
//        return result
//    }
//
//    mutating func update(_ handler: (inout Self) -> Void) {
//        var result = self
//        handler(&result)
//        self = result
//    }
//
//    mutating func update<Value>(_ keyPath: WritableKeyPath<Self,Value>, to value: Value) {
//        self[keyPath: keyPath] = value
//    }
//}

@MainActor
protocol ViewModel<State, Action>: AnyObject, Sendable {
    associatedtype State: StateProtocol
    associatedtype Action

    var state: State { get }
    var statePublisher: AnyPublisher<State, Never> { get }
    func handle(action: Action) async
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

    func callAsFunction(action: Action) async {
        await handle(action: action)
    }
}
