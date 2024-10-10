import Foundation

/// This function provides details about the `Thread` class and its features in Swift.
///
/// The `Thread` class is one of the fundamental classes for managing threads in multi-threaded applications.
/// This class allows you to run various operations simultaneously, without needing to use more advanced queues like `DispatchQueue` or
/// `OperationQueue`.
///
/// Features and methods of the `Thread` class:
/// 1. **Creating a thread**: A new thread can be created using `Thread { ... }` or `Thread(target:selector:object:)`.
/// 2. **Starting a thread**: Use `start()` to start a thread.
/// 3. **Canceling a thread**: Use `cancel()` to cancel a thread. Note that this operation does not immediately stop the thread but sets a
/// cancel flag that should be checked manually within the thread's code.
/// 4. **Thread priority**: You can adjust the execution priority of a thread using `threadPriority`.
/// 5. **Thread-local storage**: You can use `threadDictionary` to store and access thread-specific local data.
///
/// Example:
/// ```swift
/// let thread = Thread {
///     print("This is a new thread.")
/// }
/// thread.start()
/// ```
///
/// This method is suitable for simple applications, but for more complex scenarios, it is generally recommended to use `DispatchQueue` or
/// `OperationQueue`.
func explainThreadClass() {
    print("""
    The `Thread` class is one of the fundamental classes for managing threads in multi-threaded applications.
    It allows you to run various operations concurrently without needing more advanced queues like `DispatchQueue` or `OperationQueue`.

    Features and methods of the `Thread` class:
    1. Create a thread: Use `Thread { ... }` or `Thread(target:selector:object:)` to create a new thread.
    2. Start the thread: Use `start()` to begin the thread execution.
    3. Cancel the thread: Use `cancel()` to cancel a thread. Note that the thread won't stop immediately. You must manually check the cancel flag.
    4. Thread priority: Adjust the execution priority of the thread with `threadPriority`.
    5. Thread-local storage: Use `threadDictionary` to store and access thread-specific local data.

    Example:
    let thread = Thread {
        print("This is a new thread.")
    }
    thread.start()

    This method works well for simple apps, but for more complex use cases, `DispatchQueue` or `OperationQueue` is recommended.
    """)
}

/// This function demonstrates a simple example of using the `Thread` class to create and manage threads.
///
/// The `exampleThreadUsage` function creates a new thread that prints a counter.
/// Meanwhile, the main thread is also running and printing a separate counter simultaneously.
///
/// Functionality:
/// 1. Create a new thread using the `Thread` class.
/// 2. Set the priority of the new thread.
/// 3. Start the new thread.
/// 4. Run a counter in the main thread.
///
/// Example output:
/// ```
/// Count 1 from main thread.
/// This is a new thread.
/// Count 1 from thread.
/// Count 2 from main thread.
/// Count 2 from thread.
/// Count 3 from main thread.
/// Count 3 from thread.
/// Count 4 from main thread.
/// Count 4 from thread.
/// Count 5 from main thread.
/// Count 5 from thread.
/// Thread is exiting.
/// Main thread is exiting.
/// ```
/// The output may vary depending on thread scheduling.
func exampleThreadUsage() {
    // Create a new thread
    let thread = Thread {
        print("This is a new thread.")
        for i in 1...5 {
            print("Count \(i) from thread.")
            Thread.sleep(forTimeInterval: 1) // Puts the thread to sleep for 1 second
        }
        print("Thread is exiting.")
    }

    // Set the thread priority
    thread.threadPriority = 0.8

    // Start the thread
    thread.start()

    // Print from the main thread
    for i in 1...5 {
        print("Count \(i) from main thread.")
        Thread.sleep(forTimeInterval: 1)
    }

    print("Main thread is exiting.")
}

/// This function creates five new threads, each of which prints a unique number and current thread information.
///
/// The `threadBasics` function showcases the simplest way to use the `Thread` class in Swift to create new threads.
/// Five new threads are created, and each one prints a number from 1 to 5 along with the current thread's information.
/// This is the simplest way to manually create threads, but it is no longer recommended as there are more modern and efficient ways to
/// manage threads.
///
/// Usage:
/// ```swift
/// threadBasics()
/// ```
///
/// Output:
/// Each thread prints its own number and thread information. The order of the output may vary depending on thread scheduling.
///
/// Example output:
/// ```
/// 1 <NSThread: 0x600003d40380>{number = 5, name = (null)}
/// 2 <NSThread: 0x600003d40740>{number = 6, name = (null)}
/// 3 <NSThread: 0x600003d40900>{number = 7, name = (null)}
/// 4 <NSThread: 0x600003d40ac0>{number = 8, name = (null)}
/// 5 <NSThread: 0x600003d40c80>{number = 9, name = (null)}
/// ```
func threadBasics() {
    Thread.detachNewThread {
        print("1", Thread.current)
    }
    Thread.detachNewThread {
        print("2", Thread.current)
    }
    Thread.detachNewThread {
        print("3", Thread.current)
    }
    Thread.detachNewThread {
        print("4", Thread.current)
    }
    Thread.detachNewThread {
        print("5", Thread.current)
    }
}

/// This function demonstrates thread priority and cancellation.
///
/// The `threadPriorityAndCancellation` function creates a new thread with a specified priority and checks if the thread is canceled during
/// its execution.
/// It also creates an inner thread that prints its cancellation status.
///
/// Usage:
/// ```swift
/// threadPriorityAndCancellation()
/// ```
///
/// Functionality:
/// 1. A new thread is created using a closure.
/// 2. The start time of the thread is recorded, and the time taken is printed at the end.
/// 3. The thread sleeps for 1 second.
/// 4. An inner thread is created to check and print its cancellation status.
/// 5. The cancellation status of the main thread is checked. If canceled, a message is printed, and the thread stops.
/// 6. The main thread's priority is set to 0.75, and it is started.
/// 7. The main thread sleeps for 0.01 seconds and then gets canceled.
///
/// Example output:
/// ```
/// Cancelled!
/// Inner thread canceled? false
/// Finished in 1.01 seconds
/// ```
/// The output may vary depending on thread scheduling.
///
/// Warning:
/// This example is for educational purposes only. In practice, more sophisticated and efficient methods are used to manage and cancel
/// threads.
func threadPriorityAndCancellation() {
    let thread = Thread {
        let start = Date()
        defer { print("Finished in", Date().timeIntervalSince(start)) }
        Thread.sleep(forTimeInterval: 1)
        Thread.detachNewThread {
            print("Inner thread canceled?", Thread.current.isCancelled)
        }
        guard !Thread.current.isCancelled else {
            print("Cancelled!")
            return
        }
        print(Thread.current)
    }
    thread.threadPriority = 0.75
    thread.start()
    Thread.sleep(forTimeInterval: 2.0)
    thread.cancel()
}

/// This function demonstrates the use of thread storage and coordination between threads.
///
/// The `threadStorageAndCoordination` function creates multiple threads that perform parallel network and database requests.
/// `threadDictionary` is used to store and retrieve request IDs across different threads.
///
/// Usage:
/// ```swift
/// threadStorageAndCoordination()
/// ```
///
/// Functionality:
/// 1. Two inner functions `makeDatabaseQuery` and `makeNetworkRequest` are defined, each retrieving a request ID from `threadDictionary`
/// and performing their respective operations.
/// 2. The `response(for:)` function returns a mock HTTP response, creating two threads to handle network and database requests.
/// 3. The request ID is added to the new threads' `threadDictionary`, allowing data sharing between threads.
/// 4. The main thread sends ten different requests in parallel, with each request assigned a unique ID.
///
/// Example output:
/// ```
/// 2D4FC2A7-8A9D-4A5E-8265-A1B8F1E89B42 Making network request
/// 2D4FC2A7-8A9D-4A5E-8265-A1B8F1E89B42 Making database query
/// 2D4FC2A7-8A9D-4A5E-8265-A1B8F1E89B42 Finished network request
/// 2D4FC2A7-8A9D-4A5E-8265-A1B8F1E89B42 Finished database query
/// 2D4FC2A7-8A9D-4A5E-8265-A1B8F1E89B42 Finished in 0.51 seconds
/// ```
/// The output may vary depending on thread scheduling.
func threadStorageAndCoordination() {
    func makeDatabaseQuery() {
        let requestId = Thread.current.threadDictionary["requestId"] as! UUID
        print(requestId, "Making database query")
        Thread.sleep(forTimeInterval: 0.5)
        print(requestId, "Finished database query")
    }
    func makeNetworkRequest() {
        let requestId = Thread.current.threadDictionary["requestId"] as! UUID
        print(requestId, "Making network request")
        Thread.sleep(forTimeInterval: 0.5)
        print(requestId, "Finished network request")
    }

    func response(for request: URLRequest) -> HTTPURLResponse {
        let requestId = Thread.current.threadDictionary["requestId"] as! UUID

        let start = Date()
        defer { print(requestId, "Finished in", Date().timeIntervalSince(start)) }

        let databaseQueryThread = Thread { makeDatabaseQuery() }
        databaseQueryThread.threadDictionary.addEntries(from: Thread.current.threadDictionary as! [AnyHashable: Any])
        databaseQueryThread.start()

        let networkRequestThread = Thread { makeNetworkRequest() }
        networkRequestThread.threadDictionary.addEntries(from: Thread.current.threadDictionary as! [AnyHashable: Any])
        networkRequestThread.start()

        while !databaseQueryThread.isFinished || !networkRequestThread.isFinished {
            Thread.sleep(forTimeInterval: 0.1)
        }

        return .init()
    }

    let thread = Thread {
        _ = response(for: .init(url: .init(string: "http://pointfree.co")!))
    }
    thread.threadDictionary["requestId"] = UUID()
    thread.start()
}

/// This function checks if a given integer is a prime number.
///
/// The `isPrime` function accepts an integer and checks if it is a prime number.
/// A prime number is only divisible by itself and 1.
///
/// - Parameter:
///   - p: The integer to check.
/// - Returns:
///   - `true` if the number is prime.
///   - `false` if the number is not prime.
///
/// Example:
/// ```swift
/// isPrime(1)   // false
/// isPrime(2)   // true
/// isPrime(3)   // true
/// isPrime(4)   // false
/// isPrime(29)  // true
/// isPrime(30)  // false
/// ```
func isPrime(_ p: Int) -> Bool {
    if p <= 1 { return false }
    if p <= 3 { return true }
    for i in 2...Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
    }
    return true
}

/// This function finds the nth prime number and prints the time taken to find it.
///
/// The `nthPrime` function accepts an integer `n` and finds the nth prime number.
/// It also measures and prints the time taken to compute the result.
///
/// - Parameter:
///   - n: The index of the prime number to find.
///
/// Example:
/// ```swift
/// nthPrime(1)  // 1st prime 2 time ...
/// nthPrime(5)  // 5th prime 11 time ...
/// nthPrime(10) // 10th prime 29 time ...
/// ```
func nthPrime(_ n: Int) {
    let start = Date()
    var primeCount = 0
    var prime = 2
    while primeCount < n {
        defer { prime += 1 }
        if isPrime(prime) {
            primeCount += 1
        }
    }
    print(
        "\(n)th prime", prime - 1,
        "time", Date().timeIntervalSince(start)
    )
}

/// This async function finds the nth prime number concurrently and prints the time taken to compute it.
///
/// The `asyncNthPrime` function accepts an integer `n` and asynchronously computes the nth prime number,
/// yielding control to allow concurrent tasks.
///
/// - Parameter:
///   - n: The index of the prime number to find.
///
/// Example:
/// ```swift
/// await asyncNthPrime(1)  // 1st prime 2 time ...
/// await asyncNthPrime(5)  // 5th prime 11 time ...
/// await asyncNthPrime(10) // 10th prime 29 time ...
/// ```
///
/// Note: This function must be called in an asynchronous context.
func asyncNthPrime(_ n: Int) async {
    let start = Date()
    var primeCount = 0
    var prime = 2
    while primeCount < n {
        defer { prime += 1 }
        if isPrime(prime) {
            primeCount += 1
        } else if prime.isMultiple(of: 1000) {
            await Task.yield()
        }
    }
    print(
        "\(n)th prime", prime - 1,
        "time", Date().timeIntervalSince(start)
    )
}

/// This function simulates a scenario where multiple threads access a shared variable concurrently, showing data race issues.
///
/// The `threadDataRace` function defines a `Counter` class that uses locks to manage concurrent access to a shared variable.
/// It creates 1000 threads, each of which increases the `count` using the `modify` method.
///
/// - Explanation of the `Counter` class:
///   - It has a `count` variable that is accessed concurrently by multiple threads.
///   - It uses `NSLock` to prevent data race issues.
///   - Includes two methods `increment` and `modify` to safely increase the `count`.
///
/// - Functionality:
///   - Creates 1000 threads that sleep for 0.01 seconds and then increase the `count`.
///   - Prints the final value of `count` after all threads finish.
///
/// Usage:
/// ```swift
/// threadDataRace()
/// ```
///
/// Example output:
/// ```
/// count 1000
/// ```
/// The output may vary depending on thread scheduling, and without proper locking, the result may be incorrect.
func threadDataRace() {
    class Counter {
        let lock = NSLock()
        var count = 0

        func increment() {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.count += 1
        }

        func modify(work: (Counter) -> Void) {
            self.lock.lock()
            defer { self.lock.unlock() }
            work(self)
        }
    }

    let counter = Counter()

    for _ in 0..<1000 {
        Thread.detachNewThread {
            Thread.sleep(forTimeInterval: 0.01)
            counter.increment()
        }
    }
    Thread.sleep(forTimeInterval: 2)
    print("count", counter.count)
}

/// This function creates multiple threads to simulate thread performance and management.
///
/// The `threadPerformance` function creates multiple threads that perform various tasks,
/// demonstrating thread creation, management, and performance evaluation.
func threadPerformance() {
    for n in 0..<10 {
        var thread: Thread!
        thread = Thread { [weak thread] in
            print(n, Thread.current)
            while true {
                if thread?.isCancelled == true {
                    print("Canceled!")
                    return
                }
            }
        }
        thread.start()
        Thread.sleep(forTimeInterval: 0.1)
        thread.cancel()
    }

    /*
     Thread.detachNewThread {
     print("Starting the prime thread")
     nthPrime(50000)
     }
     */
}
