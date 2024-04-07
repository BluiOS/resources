//
//  ViewController.swift
//  ArchitectureExperiments
//
//  Created by Alireza Asadi on 4/6/24.
//

import UIKit
import Combine
import SnapKit

enum Home {
    struct State: StateProtocol {
        var count: Int = 0
    }

    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case questionButtonTapped
    }

    enum Destination {

    }
}

@MainActor class HomeViewModel: StatefulViewModel, @unchecked Sendable {
    typealias State = Home.State
    typealias Action = Home.Action
    typealias Destination = Home.Destination

    private var stateSubject: CurrentValueSubject<State, Never>
    private var destinationSubject: PassthroughSubject<Destination, Never>

    var statePublisher: AnyPublisher<State, Never> { stateSubject.eraseToAnyPublisher() }
    var destinationPublisher: AnyPublisher<Destination, Never> { destinationSubject.eraseToAnyPublisher() }
    var state: State {
        _read { yield stateSubject.value }
        _modify { yield &stateSubject.value }
    }

    init() {
        self.stateSubject = .init(State())
        self.destinationSubject = .init()
    }

    func handle(action: Action) async {
        print("handle(action: \(action)): Thread: \(Thread.current.description)")

        switch action {
        case .incrementButtonTapped:
            await incrementCount()

        case .decrementButtonTapped:
            state.count -= 1

        case .questionButtonTapped:
            await randomizeCount()
        }
    }

    func incrementCount() async {
        print("incrementCount(): Thread: \(Thread.current.description)")
        state.count += 1
    }

    nonisolated func randomizeCount() async {
        print("randomizeCount(): Thread: \(Thread.current.description)")
        let resultNumber: Int

        do {
            let url = URL(string: "https://www.randomnumberapi.com/api/v1.0/random?min=0&max=100")!
            let (data, _) = try await URLSession.shared.data(from: url)
            print("[post] URLSession.shared.data: Thread: \(Thread.current.description)")
            let number = try JSONDecoder().decode([Int].self, from: data).first!

            resultNumber = number
        } catch {
            print(error)
            resultNumber = -1
        }

        await Task { @MainActor in
            print("randomizeCount() Task: Thread: \(Thread.current.description)")
            self.state.count = resultNumber
        }.value
    }
}

@MainActor
class ViewController: UIViewController {
    typealias State = Home.State
    typealias Action = Home.Action
    typealias Destination = Home.Destination

    private var viewModel: any StatefulViewModel<State, Action, Destination>

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
        label.text = "Value is: \(viewModel.state.count)"
        return label
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
        return stack
    }()

    init(viewModel: any StatefulViewModel<State, Action, Destination>) {
        self.viewModel = viewModel
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
            Task.detached {
                print("UIAction.handler Task: Thread: \(Thread.current.description)")
                await viewModel.handle(action: .incrementButtonTapped)
            }
        }

        let decrementAction = UIAction { [unowned self] _ in
            Task {
                await viewModel.handle(action: .decrementButtonTapped)
            }
        }

        let questionAction = UIAction { [unowned self] _ in
            Task {
                await viewModel.handle(action: .questionButtonTapped)
            }
        }

        incrementButton.addAction(incrementAction, for: .primaryActionTriggered)
        decrementButton.addAction(decrementAction, for: .primaryActionTriggered)
        questionButton.addAction(questionAction, for: .primaryActionTriggered)

        setupBindings()
    }

    private func setupBindings() {
        viewModel.statePublisher
            .sink { [unowned self] state in
                print("UIAction.handler: Thread: \(Thread.current.description)")
                countLabel.text = "Value is: \(state.count)"
            }
            .store(in: &cancellables)
    }
}

