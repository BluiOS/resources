//
//  Created by Alireza Asadi on 4/8/24.
//

import Combine
import Foundation

final class ChildViewModel: StatefulViewModel {
    typealias State = Child.State
    typealias Action = Child.Action
    typealias Destination = Child.Destination

    let stateSubject: CurrentValueSubject<State, Never>
    let destinationSubject: PassthroughSubject<Destination, Never>

    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }

    var destinationPublisher: AnyPublisher<Destination, Never> {
        destinationSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }

    var state: State {
        _read { yield stateSubject.value }
        _modify { yield &stateSubject.value }
    }

    init(configuration: Child.Configuration) {
        stateSubject = .init(.init())
        destinationSubject = .init()
    }

    func handle(action: Action) {
        print("Action Received: \(action)")

        switch action {
        case .incrementButtonTapped:
            state.count += 1

        case .decrementButtonTapped:
            state.count -= 1

        case .questionButtonTapped:
            state.count = .random(in: 0...100)

        case let .setText(text):
            state.count = Int(text) ?? 0
        }
    }
}
