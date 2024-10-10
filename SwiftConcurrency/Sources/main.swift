import Foundation
import Combine

let workCount = 100_000

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

//exampleDeferOrder()

//MARK: - Thread

//explainThreadClass()
//exampleThreadUsage()
//threadBasics()
//threadPriorityAndCancellation()
//threadStorageAndCoordination()
//isPrime()
//nthPrime()
//Task {
//    await asyncNthPrime(53000)
//}
//threadDataRace()
//threadPerformance()

//MARK: - OperationQueue

//operationQueue()
//operationQueueExample()
//operationPriorityAndCancellation()
//operationQueueCoordination()
//operationPerformance()

//MARK: - DispatchQueue

//dispatchQueueFeaturesExample()
//dispatchQueueSerialBasics()
//dispatchQueueConcurrentBasics()
//dispatchPriorityAndCancellation()
//dispatchQueueIdentification()

//dispatchSourceTimer()
//dispatchSourceMemoryPressure()
//dispatchSourceSignalSource()
//dispatchSourceProcessSource()

//dispatchHierachy()
//demonstrateAutoreleaseFrequencies()

//dispatchGroupTestCase()

//dispatchSemaphore()

//dispatchDataRace()
//dispatchQueuePerformance()


//MARK: - Combine

//combinePublisherConcept()
//combineExamples()
//combineSerialBasics()
//combineConcurrentBasics()
//combinePriorityAndCancellation()
//combineIdentification()
//combineHierarchy()
//combineSerialTestCase()
//combineGroupTestCase()
//demonstrateSchedulers()
//combineDataRace()
combineQueuePerformance()


// RunLoop.main.run()
Thread.sleep(forTimeInterval: .infinity)


//final class AnyCancellable: Hashable {
//
//    private let cancel: () -> Void
//
//    init(_ cancel: @escaping () -> Void) {
//        self.cancel = cancel
//    }
//
//    deinit {
//        cancel()
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(ObjectIdentifier(self))
//    }
//
//    static func == (lhs: AnyCancellable, rhs: AnyCancellable) -> Bool {
//        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
//    }
//}


//extension AnyCancellable {
//    func store(_ store: inout Set<AnyCancellable>) {
//        store.insert(self)
//    }
//}

//extension Task {
//    func store(_ store: inout Set<AnyCancellable>) {
//        store.insert(AnyCancellable(cancel))
//    }
//}

//class A {
//
//    var cancellable1 = Set<AnyCancellable>()
//
//    init() {
