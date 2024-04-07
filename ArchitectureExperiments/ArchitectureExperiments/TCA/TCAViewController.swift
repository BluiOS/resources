//
//  TCAViewController.swift
//  ArchitectureExperiments
//
//  Created by Alireza Asadi on 4/6/24.
//

import Foundation
import UIKit
import SnapKit
import Combine
import ComposableArchitecture

@Reducer
struct TCAFeature {
    @ObservableState
    struct State: Equatable {
        var childState: TCAChildFeature.State?
        var counter: Int = 0
    }

    enum Action {
        case childAction(TCAChildFeature.Action)

        case incrementButtonTapped
        case decrementButtonTapped
        case questionButtonTapped
        case factResponse(String)
    }

    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case showFact(TCAChildFeature.State)
        }
        enum Action {
            case showFact(TCAChildFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.showFact, action: \.showFact) {
                TCAChildFeature()
            }
        }
    }

    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            print("Action Received: \(action)")

            switch action {
            case .childAction:
                return .none

            case .incrementButtonTapped:
                state.counter += 1
                return .none

            case .decrementButtonTapped:
                state.counter -= 1
                return .none

            case .questionButtonTapped:
                return .run { [counter = state.counter] send in
                    let url = URL(string: "http://www.numbersapi.com/\(counter)")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    print("[post] URLSession.shared.data: Thread: \(Thread.current.description)")
                    let fact = String(data: data, encoding: .utf8) ?? ""

                    await send(.factResponse(fact))
                }

            case let .factResponse(fact):
                state.childState = .init(fact: fact)
                return .none
            }
        }
//        .forEach(\.path, action: \.path) {
//            Path()
//        }
    }
}

class TCAViewController: UIViewController {
    typealias State = TCAFeature.State
    typealias Action = TCAFeature.Action

    private var store: Store<State, Action>

    private var cancellables: Set<AnyCancellable> = []

    private lazy var incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .borderedProminent()
        button.configuration?.image = UIImage(systemName: "plus.circle.fill")
        button.configuration?.buttonSize = .large
        return button
    }()

    private lazy var decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .borderedProminent()
        button.configuration?.image = UIImage(systemName: "minus.circle.fill")
        button.configuration?.buttonSize = .large
        return button
    }()

    private lazy var questionButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .borderedProminent()
        button.configuration?.image = UIImage(systemName: "questionmark.circle.fill")
        button.configuration?.buttonSize = .large
        return button
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "\(store.counter)"
        return label
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
        return stack
    }()

    init(store: Store<State, Action>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
                .inset(24)
        }

        stack.addArrangedSubview(decrementButton)
        stack.addArrangedSubview(countLabel)
        stack.addArrangedSubview(incrementButton)
        stack.addArrangedSubview(questionButton)

        countLabel.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)

        let incrementAction = UIAction { [unowned self] _ in
            print("UIAction.handler: Thread: \(Thread.current.description)")
            store.send(.incrementButtonTapped)
        }

        let decrementAction = UIAction { [unowned self] _ in
            store.send(.decrementButtonTapped)
        }

        let questionAction = UIAction { [unowned self] _ in
            store.send(.questionButtonTapped)
        }

        incrementButton.addAction(incrementAction, for: .primaryActionTriggered)
        decrementButton.addAction(decrementAction, for: .primaryActionTriggered)
        questionButton.addAction(questionAction, for: .primaryActionTriggered)

        setupBindings()
    }

    private func setupBindings() {
        store.publisher // Also: store.publisher.counter
            .sink { [unowned self] state in
                print("store.publisher.sink: Thread: \(Thread.current.description)")
                countLabel.text = "\(state.counter)"
            }
            .store(in: &cancellables)

//        store
//            .scope(state: \.childState, action: \.childAction)
//            .ifLet(
//                then: { [weak self] (childStore: StoreOf<TCAChildFeature>) in
//                    let viewController = TCAChildViewController(store: childStore)
//                    self?.navigationController?.pushViewController(viewController, animated: true)
//                },
//                else: { [weak self] in
//                    guard let self else { return }
//                    navigationController?.popToViewController(self, animated: true)
//                }
//            )
//            .store(in: &cancellables)

        store.publisher.childState
            .sink { [weak self] optionalState in
                guard let self else { return }
                if let childStore = store.scope(state: \.childState, action: \.childAction) {
                    let viewController = TCAChildViewController(store: childStore)
                    navigationController?.pushViewController(viewController, animated: true)

                } else {
                    navigationController?.popToViewController(self, animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
