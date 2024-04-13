//
//  Created by Alireza Asadi on 4/8/24.
//

import Combine
import Foundation
import SnapKit
import UIKit
import SwiftUI

//protocol SceneView: View {
//    associatedtype Content: View
//    associatedtype SceneState
//
//    var state: SceneState { get set }
//    var statePublisher: AnyPublisher<SceneState, Never> { get }
//
//    @MainActor @ViewBuilder var content: Content { get }
//}
//
//extension SceneView {
//    @MainActor var body: some View {
//        content
//            .onReceive(statePublisher) { state in
//                self.state = state
//            }
//    }
//}

@MainActor
@propertyWrapper
struct SceneViewModel<S, A>: DynamicProperty {
    @State private var _state: S

    var wrappedValue: S {
        get { _state }
        nonmutating set { _state = newValue }
    }

    init(viewModel: some ViewModel<S, A>) {
        self._state = viewModel.state
    }
}

extension ViewModel {

}

final class ChildViewController: UIHostingController<ChildViewController.ContentView> {
    // MARK: - Variables

    private let router: ChildRouterProtocol
    private let viewModel: any StatefulViewModel<Child.State, Child.Action, Child.Destination>

    // MARK: - UI Components

    @MainActor
    struct ContentView: View {
        var viewModel: ObservableViewModelAdapter<Child.State, Child.Action>
        var state: Child.State { viewModel.state }

        init(viewModel: any ViewModel<Child.State, Child.Action>) {
            self.viewModel = ObservableViewModelAdapter(viewModel: viewModel)
        }

        var body: some View {
            if #available(iOS 15.0, *) {
                let _ = Self._printChanges()
            }

            VStack {
                TextField(
                    "Count",
                    text: viewModel.binding(
                        get: { "\($0.count)" }, 
                        handle: { .setText($0) }
                    )
                )

                Text("\(state.count)")

                HStack {
                    Button("", systemImage: "plus.circle.fill") {
                        viewModel.handle(action: .incrementButtonTapped)
                    }

                    Button("", systemImage: "minus.circle.fill") {
                        viewModel.handle(action: .decrementButtonTapped)
                    }

                    Button("", systemImage: "questionmark.circle.fill") {
                        viewModel.handle(action: .questionButtonTapped)
                    }
                }
            }
        }
    }

    // MARK: - Initialization

    init(viewModel: some StatefulViewModel<Child.State, Child.Action, Child.Destination>, router: ChildRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(rootView: ContentView(viewModel: viewModel))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

@MainActor
final class ObservableViewModelAdapter<State: StateProtocol, Action>: ObservableObject {
    private let viewModel: any ViewModel<State, Action>
    private var stateCancellable: AnyCancellable?

    var state: State {
        viewModel.state
    }

    init(viewModel: some ViewModel<State, Action>) {
        self.viewModel = viewModel
        setupBindings()
    }

    func handle(action: Action) {
        viewModel.handle(action: action)
    }

    func binding<Value>(
        get stateToValue: @escaping (_ state: State) -> Value,
        handle valueToAction: @escaping (_ newValue: Value) -> Action
    ) -> Binding<Value> {
        Binding(
            get: { [unowned self] in stateToValue(state) },
            set: { [unowned self] n in handle(action: valueToAction(n)) }
        )
    }

    private func setupBindings() {
        stateCancellable = viewModel.statePublisher
            .sink { [weak self] _ in self?.objectWillChange.send() }
    }
}
