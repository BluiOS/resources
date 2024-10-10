import Foundation

/// This function demonstrates the use of `DispatchQueue` to manage and execute concurrent operations using its various features and
/// properties.
///
/// The `DispatchQueue` class is one of the most powerful tools for managing concurrent operations in Swift.
/// It includes default and custom queues, quality of service (QoS) levels, scheduling methods, and synchronization controls.
///
/// - Features and properties:
///   - Default queues:
///     - `main`: The main queue that runs operations on the main thread.
///     - `global()`: Global queues that come with different quality of service levels.
///   - Quality of service (QoS) levels:
///     - `.userInteractive`: The highest QoS level.
///     - `.userInitiated`: For operations initiated by the user and waiting for results.
///     - `.default`: The default QoS level.
///     - `.utility`: For long-running operations.
///     - `.background`: The lowest QoS level.
///   - Scheduling and delays:
///     - `asyncAfter(deadline:execute:)`: For scheduling operations after a specific delay.
///   - Other properties:
///     - `label`: A string label assigned to the queue for identification.
///     - `attributes`: Attributes like `concurrent` which specify whether the queue should run operations concurrently or serially.
///
/// Example usage:
/// ```swift
/// dispatchQueueFeaturesExample()
/// ```
func dispatchQueueFeaturesExample() {
    // Using the main queue
    let mainQueue = DispatchQueue.main
    mainQueue.sync {
        print("Executing on the main queue")
    }

    // Using the global queue with default QoS
    let globalQueue = DispatchQueue.global()
    globalQueue.sync {
        print("Executing on the global queue with default QoS")
    }

    // Using the global queue with background QoS
    let backgroundQueue = DispatchQueue.global(qos: .background)
    backgroundQueue.sync {
        print("Executing on the global queue with background QoS")
    }

    // Using async for serial queue operations
    let serialQueue = DispatchQueue(label: "com.example.serialQueue")
    serialQueue.sync {
        print("Executing async operation on serial queue")
    }

    // Using async for concurrent queue operations
    let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
    concurrentQueue.sync {
        print("Executing async operation on concurrent queue")
    }

    // Using asyncAfter to delay operation execution
    let delayQueue = DispatchQueue(label: "com.example.delayQueue")
    delayQueue.asyncAfter(deadline: .now() + 2) {
        print("Executing operation after delay on delay queue")
    }
}

/// This function demonstrates using `DispatchQueue` to create a serial queue and execute operations sequentially.
///
/// The `DispatchQueue` class is a powerful tool for managing both concurrent and serial operations in Swift.
/// This function creates a serial queue and adds multiple asynchronous operations to it.
///
/// - Functionality:
/// 1. Create a serial queue labeled `my.queue`.
/// 2. Add five operations to the serial queue using `async`.
/// 3. Each operation prints a number and the current thread information.
///
/// Example usage:
/// ```swift
/// dispatchQueueSerialBasics()
/// ```
func dispatchQueueSerialBasics() {
    // Creating a serial queue with label `my.queue`
    let queue = DispatchQueue(label: "my.queue")
    
    queue.sync { print("1", Thread.current) }
    queue.async { print("2", Thread.current) }
    queue.async { print("3", Thread.current) }
    queue.async { print("4", Thread.current) }
    queue.sync { print("5", Thread.current) }
    queue.async { print("6", Thread.current) }

    // print(1)
    // queue.sync {
    //    print("10_000_000-1")
    //    for _ in 0...10_000_000 {}
    //    print("10_000_000-1")
    // }
    // queue.sync {
    //    print("10_000_000-2")
    //    for _ in 0...10_000_000 {}
    //    print("10_000_000-2")
    // }
    // queue.sync {
    //    print("10_000_000-3")
    //    for _ in 0...10_000_000 {}
    //    print("10_000_000-3")
    // }
    // queue.sync {
    //    print("10_000_000-4")
    //    for _ in 0...10_000_000 {}
    //    print("10_000_000-4")
    // }
    // queue.sync {
    //    print("10_000_000-5")
    //    for _ in 0...10_000_000 {}
    //    print("10_000_000-5")
    // }
    // print(2)
    //
}

/// This function demonstrates using `DispatchQueue` to create a concurrent queue and execute operations concurrently.
///
/// The `DispatchQueue` class is a powerful tool for managing both concurrent and serial operations in Swift.
/// This function creates a concurrent queue and adds multiple asynchronous operations to it.
///
/// - Functionality:
/// 1. Create a concurrent queue labeled `my.queue` with the `.concurrent` attribute.
/// 2. Add five operations to the concurrent queue using `async`.
/// 3. Each operation prints a number and the current thread information.
///
/// Example usage:
/// ```swift
/// dispatchQueueConcurrentBasics()
/// ```
func dispatchQueueConcurrentBasics() {
    // Creating a concurrent queue with label `my.queue`
    let queue = DispatchQueue(label: "my.queue", attributes: .concurrent)

    // Adding operations to the concurrent queue
    queue.async {
        Thread.sleep(forTimeInterval: 3)
        print("1", Thread.current)
    }
    queue.sync { print("2", Thread.current) }
    queue.async { print("3", Thread.current) }
    queue.async { print("4", Thread.current) }
    queue.async { print("5", Thread.current) }
    print("here", Thread.current)
}

/// This function demonstrates setting priority and canceling an operation using `DispatchWorkItem`.
///
/// The `DispatchQueue` class is a powerful tool for managing both concurrent and serial operations in Swift.
/// This function creates a queue with background priority, adds an operation using `DispatchWorkItem`, and cancels it.
///
/// - Functionality:
/// 1. Create a queue with the label `my.queue` and the `.background` priority.
/// 2. Define a `DispatchWorkItem` to execute an operation.
/// 3. Add the operation to the queue using `async`.
/// 4. Cancel the operation after 0.5 seconds.
///
/// Example usage:
/// ```swift
/// dispatchPriorityAndCancellation()
/// ```
func dispatchPriorityAndCancellation() {
    let queue = DispatchQueue(label: "my.queue", qos: .background)

    var item: DispatchWorkItem?
    item = DispatchWorkItem {
        print("start")
        defer { item = nil }
        let start = Date()
        defer { print("Finished in", Date().timeIntervalSince(start)) }
        Thread.sleep(forTimeInterval: 1)
        guard !(item?.isCancelled == true) else {
            print("Cancelled!")
            return
        }
        print(Thread.current)
    }

    queue.async(execute: item!)
    item?.cancel()

    Thread.sleep(forTimeInterval: 0.5)
}

/// This function demonstrates using `DispatchSpecificKey` to identify which queue is executing the block of code.
func dispatchQueueIdentification() {
    // Define keys to identify queues
    let queueLabelKey = DispatchSpecificKey<String>()

    let main = DispatchQueue.main
    main.setSpecific(key: queueLabelKey, value: "main")

    // Create the first queue and set a specific value
    let queue1 = DispatchQueue(label: "queue1")
    queue1.setSpecific(key: queueLabelKey, value: "queue1")

    // Create the second queue and set a specific value
    let queue2 = DispatchQueue(label: "queue2")
    queue2.setSpecific(key: queueLabelKey, value: "queue2")

    // Function to print the current queue
    func printCurrentQueue() {
        if let label = DispatchQueue.getSpecific(key: queueLabelKey) {
            print("Executing on \(label)")
            print(Thread.current)
        } else {
            print("Executing on an unknown queue")
        }
    }

    // Execute block on the first queue
    queue1.async {
        printCurrentQueue()
    }

    // Execute block on the second queue
    queue2.async {
        printCurrentQueue()
    }

    // Execute block on the main queue
    DispatchQueue.main.async {
        printCurrentQueue()
    }
}

/// This function demonstrates creating a hierarchy of queues using `DispatchQueue`.
///
/// - Functionality:
/// 1. Create a target queue with the `.utility` quality of service.
/// 2. Create three queues with different quality of service levels and set the target queue.
/// 3. Execute code blocks on different queues and print their QoS and current thread information.
///
/// Example usage:
/// ```swift
/// dispatchHierarchy()
/// ```
func dispatchHierarchy() {
    // Create the target queue with QoS `.utility`
    let targetQueue = DispatchQueue(label: "com.test.targetQueue", qos: .utility, attributes: .concurrent)

    // Create three queues with different QoS and set the target queue
    let queue1 = DispatchQueue(label: "com.test.queue1", target: targetQueue)
    let queue2 = DispatchQueue(label: "com.test.queue2", qos: .background, target: targetQueue)
    let queue3 = DispatchQueue(label: "com.test.queue3", qos: .default, target: targetQueue)

    // Execute block on the target queue
    targetQueue.async {
        print("Target Queue QoS: \(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)")
        print("Target Queue Thread: \(Thread.current)")
    }

    // Execute block on queue1
    queue1.async {
        print("Queue1 QoS: \(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)")
        print("Queue1 Thread: \(Thread.current)")
    }

    // Execute block on queue2
    queue2.async {
        print("Queue2 QoS: \(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)")
        print("Queue2 Thread: \(Thread.current)")
    }

    // Execute block on queue3
    queue3.async {
        print("Queue3 QoS: \(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)")
        print("Queue3 Thread: \(Thread.current)")
    }
}

/// This function demonstrates the use of `DispatchQueue` with different `autoreleaseFrequency` values.
///
/// - Functionality:
/// 1. Create a parent queue using `DispatchQueue` with `autoreleaseFrequency` set to `.workItem`.
/// 2. Create a child queue that inherits the parent's settings (`.inherit` mode).
/// 3. Create a queue with `autoreleaseFrequency` set to `.never`.
/// 4. Create another queue with `autoreleaseFrequency` set to `.workItem`.
/// 5. Run blocks of code in each of these queues.
///
/// Example usage:
/// ```swift
/// demonstrateAutoreleaseFrequencies()
/// ```
func demonstrateAutoreleaseFrequencies() {
    class SomeObject {
        func doSomething() {}
    }

    // Creating a parent queue with `autoreleaseFrequency` set to `.workItem`
    let parentQueue = DispatchQueue(label: "com.example.parentQueue", autoreleaseFrequency: .workItem)

    // Creating a child queue that inherits from the parent queue
    let childQueue = DispatchQueue(label: "com.example.childQueue", target: parentQueue)

    // Creating a queue with `autoreleaseFrequency` set to `.never`
    let neverQueue = DispatchQueue(label: "com.example.neverQueue", autoreleaseFrequency: .never)

    // Creating a queue with `autoreleaseFrequency` set to `.workItem`
    let workItemQueue = DispatchQueue(label: "com.example.workItemQueue", autoreleaseFrequency: .workItem)

    // Test the child queue (using `.inherit` mode)
    func testInheritQueue() {
        childQueue.sync {
            let object = SomeObject()
            print("Executing task in child queue with .inherit autorelease")
            // Memory is released automatically after this block
        }
    }

    // Test the queue with `autoreleaseFrequency` set to `.never`
    func testNeverQueue() {
        neverQueue.sync {
            let object = SomeObject()
            print("Executing task in queue with .never autorelease")
            // Memory is not automatically released, manual memory management is needed
            object.doSomething()
        }
    }

    // Test the queue with `autoreleaseFrequency` set to `.workItem`
    func testWorkItemQueue() {
        workItemQueue.sync {
            let object = SomeObject()
            print("Executing task in queue with .workItem autorelease")
            // Memory is released automatically after the block ends
            object.doSomething()
        }
    }

    // Call test functions for each queue type
    testInheritQueue()
    testNeverQueue()
    testWorkItemQueue()
}

/// This function demonstrates using `DispatchGroup` to manage and coordinate multiple concurrent tasks.
///
/// - Functionality:
/// 1. Create a queue for displaying results.
/// 2. Create a dispatch group to manage tasks.
/// 3. Define the `performTask` function to simulate a task.
/// 4. Start tasks and add them to the group.
/// 5. Notify when all tasks are completed.
/// 6. Wait for all tasks to complete, then print "Done".
///
/// Example usage:
/// ```swift
/// dispatchGroupTestCase()
/// ```
func dispatchGroupTestCase() {
    // Create a queue for displaying results
    let resultQueue = DispatchQueue(label: "queue.result")
    // Create a dispatch group to manage tasks
    let dispatchGroup = DispatchGroup()

    // Define a function to simulate a task
    func performTask(taskNumber: Int) {
        dispatchGroup.enter()
        DispatchQueue.global().async {
            print("Task \(taskNumber) is starting")
            // Simulate doing some work
//            sleep(UInt32(arc4random_uniform(4)))
            print("Task \(taskNumber) is completed")
            print(Thread.current)
            dispatchGroup.leave()
        }
    }

    performTask(taskNumber: 1)
    performTask(taskNumber: 2)
    performTask(taskNumber: 3)

    // Notify when all tasks are completed
    dispatchGroup.notify(queue: resultQueue) {
        print("All tasks are finished. Display the results here.")
    }

    // Wait for all tasks to complete
    dispatchGroup.wait()
    print("Done.")
}

/// This function demonstrates using `DispatchSemaphore` to manage concurrent access to a shared resource.
///
/// Example usage:
/// ```swift
/// dispatchSemaphore()
/// ```
func dispatchSemaphore() {
    let semaphore = DispatchSemaphore(value: 0)
    var number: Int = 0

    print("Thread 1 starts")

    // Simulate asynchronous events like fetching data from an API
    DispatchQueue.global(qos: .background).async {
        print("Thread 2 starts")
        number = 123
        sleep(2)
        print("Thread 2 ends")
        semaphore.signal()
    }

    semaphore.wait()
    print(number)
    print("Thread 1 ends")
}

/// This function demonstrates preventing data race conditions using `DispatchQueue` and its barrier flag.
///
/// - Functionality:
/// 1. Define a `Counter` class that includes a concurrent queue to manage operations safely.
/// 2. Create an instance of `Counter`.
/// 3. Create a concurrent queue to execute tasks.
/// 4. Begin tasks to increment the counter concurrently.
/// 5. Wait for all tasks to complete, then print the counter's value.
///
/// Example usage:
/// ```swift
/// dispatchDataRace()
/// ```
func dispatchDataRace() {
    class Counter {
        let queue = DispatchQueue(label: "counter", attributes: .concurrent)
        var count = 0

        // Increment function with a barrier to ensure safe execution
        func increment() -> Int {
            self.queue.sync(flags: .barrier) {
                self.count += 1
                return count
            }
        }
    }

    let counter = Counter()
    let queue = DispatchQueue(label: "concurrent-queue", attributes: .concurrent)

    for _ in 0..<10 {
        let t = queue.sync {
            counter.increment()
        }
        print(t)
    }

    Thread.sleep(forTimeInterval: 1)
    print("counter.count", counter.count)
}

func dispatchQueuePerformance() {
    let queue = DispatchQueue(label: "concurrent-queue", attributes: .concurrent)
    for _ in 0..<10 {
        queue.async {
            print(Thread.current)
            while true {}
        }
    }
}
