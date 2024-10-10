import Foundation

/// This function demonstrates using `DispatchSource` to create and manage timers.
///
/// - Functionality:
/// 1. Create a timer using `DispatchSource.makeTimerSource`.
/// 2. Set the event handler for the timer to print a message every time the timer fires.
/// 3. Set the timer to fire immediately and repeat every 2 seconds.
/// 4. Start the timer.
///
/// Example usage:
/// ```swift
/// dispatchSourceTimer()
/// ```
func dispatchSourceTimer() {
    // Create a timer using `DispatchSource.makeTimerSource`
    let timerSource = DispatchSource.makeTimerSource()

    // Test function for the timer
    func testTimerDispatchSource() {
        // Set the event handler for the timer
        timerSource.setEventHandler {
            print("Timer event fired")
        }

        // Set the timer to fire immediately and repeat every 2 seconds
        timerSource.schedule(deadline: .now(), repeating: 2)

        // Start the timer
        timerSource.resume()
    }

    // Call the test function for the timer
    testTimerDispatchSource()
}

/// This function demonstrates using `DispatchSource` to monitor and respond to memory pressure events.
///
/// - Functionality:
/// 1. Create a memory pressure source using `DispatchSource.makeMemoryPressureSource`.
/// 2. Set the event handler for the memory pressure source to print a message when a warning is received.
/// 3. Start monitoring memory pressure.
///
/// Example usage:
/// ```swift
/// dispatchSourceMemoryPressure()
/// ```
func dispatchSourceMemoryPressure() {
    // Create a memory pressure source using `DispatchSource.makeMemoryPressureSource`
    let memorySource = DispatchSource.makeMemoryPressureSource(eventMask: .warning, queue: .main)

    // Test function for memory pressure source
    func testMemoryDispatchSource() {
        // Set the event handler for memory pressure warnings
        memorySource.setEventHandler {
            print("Memory pressure warning received")
        }

        // Start monitoring memory pressure
        memorySource.resume()
    }

    // Call the test function for memory pressure monitoring
    testMemoryDispatchSource()
}

/// This function demonstrates using `DispatchSource` to handle system signals.
///
/// - Functionality:
/// 1. Create a signal source using `DispatchSource.makeSignalSource`.
/// 2. Set the event handler for the signal source to print a message when a signal is received.
/// 3. Start monitoring the signal.
///
/// Example usage:
/// ```swift
/// dispatchSourceSignalSource()
/// ```
func dispatchSourceSignalSource() {
    // Create a signal source using `DispatchSource.makeSignalSource`
    let signalSource = DispatchSource.makeSignalSource(signal: SIGSTOP, queue: .main)

    // Test function for signal source
    func testSignalSource() {
        // Set the event handler for the signal
        signalSource.setEventHandler {
            print("Signal SIGSTOP received")
        }

        // Start monitoring the signal
        signalSource.resume()
    }

    // Call the test function for signal source
    testSignalSource()
}

/// This function demonstrates using `DispatchSource` to monitor events related to the current process.
///
/// - Functionality:
/// 1. Create a process source using `DispatchSource.makeProcessSource`.
/// 2. Set the event handler for the process source to print a message when an event is received.
/// 3. Start monitoring process events.
///
/// Example usage:
/// ```swift
/// dispatchSourceProcessSource()
/// ```
func dispatchSourceProcessSource() {
    // Create a process source using `DispatchSource.makeProcessSource`
    let processSource = DispatchSource.makeProcessSource(
        identifier: ProcessInfo.processInfo.processIdentifier,
        eventMask: .signal,
        queue: .main
    )

    // Test function for process source
    func testProcessSource() {
        // Set the event handler for process events
        processSource.setEventHandler {
            print("Process signal event received")
        }

        // Start monitoring process events
        processSource.resume()
    }

    // Call the test function for process events
    testProcessSource()
}
