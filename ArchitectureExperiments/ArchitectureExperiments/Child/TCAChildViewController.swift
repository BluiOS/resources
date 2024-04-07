//
//  TCAChildViewController.swift
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
struct TCAChildFeature {
    @ObservableState
    struct State: Equatable {
        var fact: String = ""
    }

    enum Action {
        case resetButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .resetButtonTapped:
                state.fact = ""
                return .none
            }
        }
    }
}

class TCAChildViewController: UIViewController {
    typealias State = TCAChildFeature.State
    typealias Action = TCAChildFeature.Action

    private var store: Store<State, Action>

    private var cancellables: Set<AnyCancellable> = []

    private var factLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .borderedProminent()
        button.configuration?.image = UIImage(systemName: "minus.circle.fill")
        button.configuration?.buttonSize = .large
        return button
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
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

        stack.addArrangedSubview(factLabel)
        stack.addArrangedSubview(resetButton)

        let resetAction = UIAction { [unowned self] _ in
            store.send(.resetButtonTapped)
        }

        resetButton.addAction(resetAction, for: .primaryActionTriggered)

        stack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.center.equalTo(view.safeAreaLayoutGuide)
        }

        setupBindings()
    }

    private func setupBindings() {
        store.publisher.fact
            .sink { [weak self] fact in
                self?.factLabel.text = fact
            }
            .store(in: &cancellables)
    }
}
