import Foundation


/// This function demonstrates the use of `OperationQueue` to manage and execute concurrent operations.
///
/// The `OperationQueue` class allows you to queue multiple operations and control how they are executed.
///
/// - Parameters:
///   - maxConcurrentOperationCount: The maximum number of operations that can run simultaneously. By default, this parameter depends on the
/// system resources.
///   - isSuspended: A boolean that indicates whether the operation queue is suspended. If `true`, new operations will not execute until the
/// queue is resumed.
///   - operations: An array of the current operations in the queue.
///   - operationCount: The number of operations currently in the queue.
///
/// - Methods:
///   - addOperation(_:): Adds an `Operation` to the queue.
///   - addOperations(_:waitUntilFinished:): Adds multiple operations to the queue and can wait until all operations finish.
///   - addOperation(_:) (using a closure): Adds an operation to the queue using a closure.
///   - cancelAllOperations(): Cancels all operations in the queue.
///   - waitUntilAllOperationsAreFinished(): Waits until all operations in the queue finish executing.
///
/// Functionality:
/// 1. A new `OperationQueue` is created.
/// 2. Five different operations are added to the queue, each printing a message and sleeping for one second.
/// 3. The maximum number of concurrent operations is set to 2.
/// 4. The operation queue is suspended and then resumed.
/// 5. After all operations finish, a message is printed.
///
/// Example usage:
/// ```swift
/// operationQueue()
/// ```
func operationQueue() {
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 2
    operationQueue.name = "Example Operation Queue"
    operationQueue.qualityOfService = .userInteractive

    for i in 1...5 {
        operationQueue.addOperation {
            print("Operation \(i) started")
            Thread.sleep(forTimeInterval: 1)
            print("Operation \(i) finished")
        }
    }

    operationQueue.isSuspended = true
    print("Operation queue is suspended")

    DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
        operationQueue.isSuspended = false
        print("Operation queue is resumed")
    }

    operationQueue.waitUntilAllOperationsAreFinished()

    print("All operations are finished")
}

/// This function demonstrates the use of `OperationQueue` for managing concurrent operations.
///
/// The `operationQueueExample` function creates an operation queue and adds multiple operations to it.
/// Each operation prints a message and sleeps for a while to simulate a time-consuming task.
///
/// Functionality:
/// 1. An `OperationQueue` is created.
/// 2. Three `Operation`s are added to the operation queue.
/// 3. Each operation prints a message and sleeps for 2 seconds.
/// 4. The operations run concurrently.
///
/// Example usage:
/// ```swift
/// operationQueueExample()
/// ```
func operationQueueExample() {
    let operationQueue = OperationQueue()

    let operation1 = BlockOperation {
        Thread.sleep(forTimeInterval: 2)
        print("1", Thread.current)
    }

    let operation2 = BlockOperation {
        Thread.sleep(forTimeInterval: 2)
        print("2", Thread.current)
    }

    let operation3 = BlockOperation {
        Thread.sleep(forTimeInterval: 2)
        print("3", Thread.current)
    }

    operationQueue.addOperation(operation1)
    operationQueue.addOperation(operation2)
    operationQueue.addOperation(operation3)

    operationQueue.waitUntilAllOperationsAreFinished()
    print("All operations completed")
}

/// This function demonstrates using `OperationQueue` to set priority and cancel an operation.
///
/// The `operationPriorityAndCancellation` function creates an `OperationQueue` and adds a `BlockOperation` to it.
/// This operation measures the execution time, and after a short delay, checks whether the operation was canceled.
/// If the operation was canceled, it prints "Cancelled!"; otherwise, it prints the current thread information.
///
/// - Functionality:
/// 1. Create a new `OperationQueue`.
/// 2. Define and add an operation to the queue.
/// 3. Set the quality of service of the operation to `.background`.
/// 4. Cancel the operation after 0.1 seconds.
///
/// Example usage:
/// ```swift
/// operationPriorityAndCancellation()
/// ```
func operationPriorityAndCancellation() {
    let queue = OperationQueue()

    let operation = BlockOperation()
    operation.addExecutionBlock { [weak operation] in
        let start = Date()
        defer { print("Finished in", Date().timeIntervalSince(start)) }

        Thread.sleep(forTimeInterval: 1)
        guard operation?.isCancelled == false else {
            print("Cancelled!")
            return
        }
        print(Thread.current)
    }
    operation.qualityOfService = .background
    queue.addOperation(operation)

    Thread.sleep(forTimeInterval: 0.1)
    operation.cancel()
}

/// This function demonstrates the use of `OperationQueue` to coordinate between operations using dependencies.
///
/// The `operationQueueCoordination` function creates an `OperationQueue` and adds four `BlockOperation`s to it.
/// Using the `addDependency` method, dependencies between the operations are created to determine the order in which the operations must
/// execute.
///
/// - Functionality:
/// 1. Create a new `OperationQueue`.
/// 2. Define and add four operations to the queue.
/// 3. Create dependencies between the operations:
///    - Operations B and C must run after operation A completes.
///    - Operation D must run after both operations B and C complete.
/// 4. Add the operations to the queue.
///
/// Example usage:
/// ```swift
/// operationQueueCoordination()
/// ```
///
/// Dependency diagram:
/// ```
/// A ➡️ B
/// ⬇️   ⬇️
/// C ➡️ D
/// ```
func operationQueueCoordination() {
    let queue = OperationQueue()

    let operationA = BlockOperation {
        print("A")
        Thread.sleep(forTimeInterval: 1)
    }
    let operationB = BlockOperation { [weak operationA] in
        print(operationA?.isCancelled)
        print("B")
    }
    let operationC = BlockOperation {
        print("C")
    }
    let operationD = BlockOperation {
        print("D")
    }

    // Create dependencies
    operationB.addDependency(operationA)
    operationC.addDependency(operationA)
    operationD.addDependency(operationB)
    operationD.addDependency(operationC)

    // Add operations to the queue
    queue.addOperation(operationA)
    queue.addOperation(operationB)
    queue.addOperation(operationC)
    queue.addOperation(operationD)

    // Optional: Cancel operation A
}

/// This function evaluates thread performance by creating multiple concurrent operations in an `OperationQueue`.
func operationPerformance() {
    let queue = OperationQueue()
    print(queue.maxConcurrentOperationCount)

    for n in 0..<10 {
        queue.addOperation {
            print(queue.maxConcurrentOperationCount, Thread.current)
            while true {}
        }
    }
}
