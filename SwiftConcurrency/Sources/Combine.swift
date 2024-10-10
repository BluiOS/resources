import Foundation
import Combine

private var cancellables = Set<AnyCancellable>()
private struct AppError: Error {}

// Combining Merge and Sorting Publishers
/// This function merges multiple publishers and sorts the emitted values based on their order in the array of publishers.
/// It collects the values and sorts them based on the original publisher index.
/// - Returns: A publisher that emits an array of sorted results.
extension Array where Element: Publisher {
    func mergeAndSort() -> AnyPublisher<[Element.Output], Element.Failure> {
        let indexedPublishers = self.enumerated()
            .map { index, publisher in
                publisher
                    .map { (index, $0) }
                    .eraseToAnyPublisher()
            }

        return Publishers.MergeMany(indexedPublishers)
            .collect(self.count)
            .map { results in
                results.sorted { $0.0 < $1.0 }.map { $0.1 }
            }
            .eraseToAnyPublisher()
    }
}

// Combining Zipping Publishers and Sorting
/// This function zips multiple publishers and sorts the emitted values based on their order in the array.
/// The function ensures the publishers emit values simultaneously and combines the results.
/// - Returns: A publisher that emits an array of zipped results.
extension Array where Element: Publisher {
    func zipAndSort() -> AnyPublisher<[Element.Output], Element.Failure> {
        guard let first = self.first else {
            return Empty().eraseToAnyPublisher()
        }

        return self.dropFirst().reduce(first.map { [$0] }.eraseToAnyPublisher()) { acc, publisher in
            acc.zip(publisher) { array, element in
                array + [element]
            }
            .eraseToAnyPublisher()
        }
    }
}

// Combining Latest Publishers and Sorting
/// This function combines the latest values from multiple publishers and sorts the emitted values.
/// It ensures that the latest value from each publisher is included in the result.
/// - Returns: A publisher that emits an array of combined latest results.
extension Array where Element: Publisher {
    func combineLatestAndSort() -> AnyPublisher<[Element.Output], Element.Failure> {
        guard let first = self.first else {
            return Empty().eraseToAnyPublisher()
        }

        return self.dropFirst().reduce(first.map { [$0] }.eraseToAnyPublisher()) { acc, publisher in
            acc.combineLatest(publisher) { array, element in
                array + [element]
            }
            .eraseToAnyPublisher()
        }
    }
}

// Collecting All Results Including Failures
/// This function collects results from multiple publishers, capturing successes and failures.
/// Each result is stored as either a success or failure, preserving the order of the original publishers.
/// - Returns: A publisher that emits an array of results, including both successes and failures.
extension Array where Element: Publisher {
    func collectAllResults() -> AnyPublisher<[Result<Element.Output, Element.Failure>], Never> {
        let indexedPublishers = self.enumerated().map { index, publisher in
            publisher
                .map { .success($0) }
                .catch { Just(Result.failure($0)) }
                .map { (index, $0) }
                .eraseToAnyPublisher()
        }

        return Publishers.MergeMany(indexedPublishers)
            .collect(indexedPublishers.count)
            .map { results in
                results.sorted { $0.0 < $1.0 }.map { $0.1 }
            }
            .eraseToAnyPublisher()
    }
}

// Simple Combine Example
/// This function provides a basic example of using Combine to create a publisher and print emitted values.
/// - Example: It uses the `Just` publisher to emit a simple string.
func combineExamples() {
    let publisher = Just("Hello, Combine!")
    publisher.sink { value in
        print(value)
    }.store(in: &cancellables)
}

// Combining Serial Operations
/// This function demonstrates how to use Combine to execute a sequence of operations serially.
/// It uses a sequence of integers as the input, and each value is emitted one at a time in sequence.
/// - Example: Serial execution of operations using Combine.
func combineSerialBasics() {
    let publisher = [1, 2, 3, 4, 5].publisher
    publisher.sink { value in
        print(value, Thread.current)
    }.store(in: &cancellables)
}

// Combining Concurrent Operations
/// This function demonstrates how to execute multiple publishers concurrently using Combine.
/// The operations are run in parallel, with each operation potentially executing on a different thread.
/// - Example: Concurrent execution using Combine.
func combineConcurrentBasics() {
    let publishers = [Just("1").setFailureType(to: AppError.self), Just("2").setFailureType(to: AppError.self)]
    publishers.zipAndSort().sink(receiveCompletion: { completion in
        print("Completed: \(completion)")
    }, receiveValue: { values in
        print("Received values: \(values)")
    }).store(in: &cancellables)
}

// Combining Priority and Cancellation
/// This function demonstrates how to use Combine with cancellation and priority handling.
/// The subscription is cancelled after emitting the second value, so the third value is not processed.
/// - Example: Shows how to cancel Combine subscriptions.
func combinePriorityAndCancellation() {
    let subject = PassthroughSubject<Int, Never>()
    let cancellable = subject.sink { value in
        print("Received value \(value)")
    }
    subject.send(1)
    subject.send(2)
    cancellable.cancel()
    subject.send(3)
}

// Combining Identification
/// This function demonstrates how to identify the thread on which a Combine publisher is executing.
/// It prints the thread information for each operation.
/// - Example: Checking the thread where Combine publishers are running.
func combineIdentification() {
    let publisher = Just("Test Combine Identification")
    publisher.map { _ in Thread.current }.sink { thread in
        print("Executing on \(thread)")
    }.store(in: &cancellables)
}

// Combining Hierarchy
/// This function demonstrates the use of multiple publishers with different Quality of Service (QoS) levels in Combine.
/// Each publisher runs on a different QoS level and prints its value.
/// - Example: Combining publishers with different priorities.
func combineHierarchy() {
    let firstPublisher = Just("First").subscribe(on: DispatchQueue.global(qos: .utility))
    let secondPublisher = Just("Second").subscribe(on: DispatchQueue.global(qos: .background))
    let thirdPublisher = Just("Third").subscribe(on: DispatchQueue.global(qos: .userInteractive))

    firstPublisher.sink { value in
        print("First Publisher Value: \(value)")
    }.store(in: &cancellables)

    secondPublisher.sink { value in
        print("Second Publisher Value: \(value)")
    }.store(in: &cancellables)

    thirdPublisher.sink { value in
        print("Third Publisher Value: \(value)")
    }.store(in: &cancellables)
}

// Combining Serial Test Case
/// This function demonstrates using Combine for serial execution of tasks with delays.
/// It simulates processing each item sequentially and prints the thread where each item is processed.
/// - Example: Serial execution using Combine publishers.
func combineSerialTestCase() {
    let publishers = (1...5).map { Just($0) }
    Publishers.Sequence<[Just<Int>], AppError>(sequence: publishers).sink(receiveCompletion: { completion in
        print("Sequence completion: \(completion)")
    }, receiveValue: { value in
        print("Sequence value: \(value)")
    }).store(in: &cancellables)
}

// Combining Group Test Case
/// This function demonstrates how to collect results in batches using Combine.
/// It collects a specified number of elements from a range of integers and prints the results in groups.
/// - Example: Batch collection of values using Combine.
func combineGroupTestCase() {
    let publishers = 1...10
    Publishers.Sequence<ClosedRange<Int>, AppError>(sequence: publishers).collect(3).sink(receiveCompletion: { completion in
        print("MergeMany completion: \(completion)")
    }, receiveValue: { value in
        print("MergeMany value: \(value)")
    }).store(in: &cancellables)
}

// Demonstrating Schedulers
/// This function demonstrates how to use different schedulers in Combine, such as `DispatchQueue`, `OperationQueue`, and
/// `ImmediateScheduler`.
/// It shows how to schedule publishers on different threads and observe the execution.
/// - Example: Combine execution using multiple schedulers.
func demonstrateSchedulers() {
    let dispatchQueuePublisher = Just("Hello from DispatchQueue")
        .delay(for: 5.0, scheduler: DispatchQueue.global()).eraseToAnyPublisher()

    dispatchQueuePublisher.subscribe(on: DispatchQueue.global()).receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            print("DispatchQueue - Execute Completion on thread: \(Thread.current)")
        }, receiveValue: { value in
            print("DispatchQueue - Execute value \(value) on thread: \(Thread.current)")
        }).store(in: &cancellables)

    // 2. OperationQueue
    let operationQueuePublisher = Just("Hello from OperationQueue")
        .delay(for: 5.0, scheduler: DispatchQueue.global()).eraseToAnyPublisher()

    operationQueuePublisher
        .subscribe(on: OperationQueue())
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            print("OperationQueue - Execute Completion on thread: \(Thread.current)")
        }, receiveValue: { value in
            print("OperationQueue - Execute value \(value) on thread: \(Thread.current)")
        }).store(in: &cancellables)

    // 3. ImmediateScheduler
    let immediatePublisher = Just("Immediate Execution")
        .delay(for: 5.0, scheduler: DispatchQueue.global()).eraseToAnyPublisher()

    immediatePublisher
        .subscribe(on: ImmediateScheduler.shared)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            print("ImmediateScheduler - Execute Completion on thread: \(Thread.current)")
        }, receiveValue: { value in
            print("ImmediateScheduler - Execute value \(value) on thread: \(Thread.current)")
        }).store(in: &cancellables)
}

// Coordination between Publishers
/// This function demonstrates the coordination between publishers in Combine.
/// It creates a chain of dependencies, where each subsequent publisher depends on the result of the previous one.
/// - Example: Sequential coordination using Combine publishers.
func combineCoordination() {
    let publisherA = Future<Void, Never> { promise in
        print("A")
        Thread.sleep(forTimeInterval: 1)
        promise(.success(()))
    }.eraseToAnyPublisher()

    func bPublisher(_ input: Void) -> AnyPublisher<String, Never> {
        Deferred {
            Future<String, Never> { promise in
                print("B")
                promise(.success("B completed"))
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }

    func cPublisher(_ input: Void) -> AnyPublisher<String, Never> {
        Deferred {
            Future<String, Never> { promise in
                print("C")
                promise(.success("C completed"))
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }

    func dPublisher(_ inputB: String, _ inputC: String) -> AnyPublisher<String, Never> {
        Deferred {
            Future<String, Never> { promise in
                print("D")
                promise(.success("D received: \(inputB), \(inputC)"))
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }

    publisherA
        .flatMap { a in
            Publishers.Zip(bPublisher(a), cPublisher(a))
        }
        .flatMap { b, c in
            dPublisher(b, c)
        }
        .sink(receiveCompletion: { completion in
            print("Completion: \(completion)")
        }, receiveValue: { value in
            print("Final Output: \(value)")
        })
        .store(in: &cancellables)
}

// Preventing Data Races in Combine
/// This function demonstrates how to prevent data races in Combine using concurrent queues with a barrier flag.
/// The barrier ensures that shared data is accessed safely even when multiple tasks are executed concurrently.
/// - Example: Using Combine to prevent data race conditions.
func combineDataRace() {
    class Counter {
        private let queue = DispatchQueue(label: "counter", attributes: .concurrent)
        private(set) var count = 0
        func increment() {
            queue.sync(flags: .barrier) {
                self.count += 1
            }
        }
    }

    let counter = Counter()
    let publishers = (1...10).map { Just($0) }

    Publishers.MergeMany(publishers)
        .handleEvents(receiveOutput: { _ in
            counter.increment()
        })
        .sink(receiveCompletion: { completion in
            print("Counter value: \(counter.count)")
        }, receiveValue: { _ in })
        .store(in: &cancellables)
}

// Evaluating Performance of Operations in Combine
/// This function evaluates the performance of executing a large number of operations using Combine.
/// It repeatedly executes a long-running task on multiple threads using Combine publishers and logs the current thread information.
/// - Example: Measuring performance of concurrent operations using Combine.
func combineQueuePerformance() {
    let publisher = (0..<10).publisher

    publisher
        .flatMap { _ in
            Future<Void, Never> { promise in
                DispatchQueue.global().async {
                    print(Thread.current)
                    while true {}
                }
            }
        }
        .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &cancellables)
}
