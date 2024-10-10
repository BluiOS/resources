import Foundation
import Combine

func exampleDeferOrder() {
    defer {
        print("First defer")
    }
    defer {
        print("Second defer")
    }
    defer {
        print("Third defer")
    }
    print("End of function")
}

// exampleDeferOrder()

// MARK: - Thread

// explainThreadClass()
// exampleThreadUsage()
// threadBasics()
// threadPriorityAndCancellation()
// threadStorageAndCoordination()
// isPrime(53000)
// nthPrime(53000)
// Task {
//   await asyncNthPrime(53000)
// }
// threadDataRace()
// threadPerformance()

// MARK: - OperationQueue

// operationQueue()
// operationQueueExample()
// operationPriorityAndCancellation()
// operationQueueCoordination()
// operationPerformance()

// MARK: - DispatchQueue

//dispatchQueueFeaturesExample()
//dispatchQueueSerialBasics()
//dispatchQueueConcurrentBasics()
//dispatchPriorityAndCancellation()
//dispatchQueueIdentification()
//dispatchHierarchy()
//demonstrateAutoreleaseFrequencies()
//dispatchGroupTestCase()
//dispatchSemaphore()
//dispatchDataRace()
//dispatchQueuePerformance()


// MARK: - DispatchSource

//dispatchSourceTimer()
//dispatchSourceMemoryPressure()
//dispatchSourceSignalSource()
//dispatchSourceProcessSource()


// MARK: - Combine

//combineExamples()
//combineSerialBasics()
//combineConcurrentBasics()
//combinePriorityAndCancellation()
//combineIdentification()
//combineHierarchy()
//combineSerialTestCase()
//combineGroupTestCase()
//demonstrateSchedulers()
//combineCoordination()
//combineDataRace()
//combineQueuePerformance()

// RunLoop.main.run()
Thread.sleep(forTimeInterval: .infinity)
