//
//  Combine.swift
//
//
//  Created by Reza Akbari on 7/22/24.
//

import Foundation
import Combine

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

var cancellables = Set<AnyCancellable>()

/// این تابع توضیحی در مورد Publisher در Combine ارائه می‌دهد.
/// همچنین مثال‌هایی از کلاس‌های مختلف Publisher و استفاده‌های آنها را نشان می‌دهد.
///
/// Publisher یک پروتکل در Combine است که یک یا چند مقدار را در طول زمان منتشر می‌کند.
/// Publisher می‌تواند مقادیر، خطاها یا تکمیل (completion) را ارسال کند.
///
/// المان‌های اصلی Publisher:
/// - Output: نوع داده‌ای که Publisher منتشر می‌کند.
/// - Failure: نوع خطایی که Publisher ممکن است ارسال کند.
///
/// کلاس‌های اصلی Publisher در Combine:
/// - Just: یک مقدار واحد را منتشر می‌کند.
/// - Future: یک مقدار یا یک خطا را در آینده منتشر می‌کند.
/// - PassthroughSubject: به صورت دستی مقادیر و خطاها را منتشر می‌کند.
/// - CurrentValueSubject: یک مقدار جاری دارد که هر زمان تغییر کند، آن را منتشر می‌کند.
/// - Deferred: یک Publisher که تا زمانی که اشتراک انجام نشود، ایجاد نمی‌شود.
/// - Empty: هیچ مقداری منتشر نمی‌کند و فوراً تکمیل می‌شود.
/// - Fail: یک خطا را فوراً منتشر می‌کند.
///
/// مثال استفاده:
/// ```swift
/// demonstratePublisherConcept()
/// ```
func combinePublisherConcept() {
    // Just: یک مقدار واحد را منتشر می‌کند.
//    let justPublisher = Just("Hello, Combine!")
//    justPublisher
//        .sink(receiveCompletion: { completion in
//            print("Just completion: \(completion)")
//        }, receiveValue: { value in
//            print("Just value: \(value)")
//        }).store(in: &cancellables)
//    
    // Future: یک مقدار یا یک خطا را در آینده منتشر می‌کند.
    let futurePublisher = Future<Int, Error> { promise in
        //        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        print("Inside future")
        promise(.success(42))
        
        Thread.sleep(forTimeInterval: 1)
        promise(.success(43))
                }
    
    print("OutSide future")
//    Thread.sleep(forTimeInterval: 2)
    futurePublisher
        .sink(receiveCompletion: { completion in
            print("Future completion: \(completion)")
        }, receiveValue: { value in
            print("Future value: \(value)")
        }).store(in: &cancellables)
    
    // PassthroughSubject: به صورت دستی مقادیر و خطاها را منتشر می‌کند.
    let passthroughSubject = PassthroughSubject<String, Never>()
    passthroughSubject
        .sink(receiveCompletion: { completion in
            print("PassthroughSubject completion: \(completion)")
        }, receiveValue: { value in
            print("PassthroughSubject value: \(value)")
        }).store(in: &cancellables)
    passthroughSubject.send("First Value")
    passthroughSubject.send("Second Value")
    passthroughSubject.send(completion: .finished)
    
    // CurrentValueSubject: یک مقدار جاری دارد که هر زمان تغییر کند، آن را منتشر می‌کند.
    let currentValueSubject = CurrentValueSubject<Int, Never>(0)
    currentValueSubject
        .sink(receiveCompletion: { completion in
            print("CurrentValueSubject completion: \(completion)")
        }, receiveValue: { value in
            print("CurrentValueSubject value: \(value)")
        }).store(in: &cancellables)
    currentValueSubject.send(1)
    currentValueSubject.send(2)
    currentValueSubject.value = 3 // همچنین می‌توان به صورت مستقیم مقدار آن را تغییر داد
    currentValueSubject.send(completion: .finished)
    
    // Deferred: یک Publisher که تا زمانی که اشتراک انجام نشود، ایجاد نمی‌شود.
    let deferredPublisher = Deferred {
        Just("Deferred Value")
    }
    deferredPublisher
        .sink(receiveCompletion: { completion in
            print("Deferred completion: \(completion)")
        }, receiveValue: { value in
            print("Deferred value: \(value)")
        }).store(in: &cancellables)
    
    // Empty: هیچ مقداری منتشر نمی‌کند و فوراً تکمیل می‌شود.
    let emptyPublisher = Empty<Int, Never>()
    emptyPublisher
        .sink(receiveCompletion: { completion in
            print("Empty completion: \(completion)")
        }, receiveValue: { value in
            print("Empty value: \(value)")
        }).store(in: &cancellables)
    
    // Fail: یک خطا را فوراً منتشر می‌کند.
    struct SampleError: Error {}
    let failPublisher = Fail<Int, SampleError>(error: SampleError())
    failPublisher
        .sink(receiveCompletion: { completion in
            print("Fail completion: \(completion)")
        }, receiveValue: { value in
            print("Fail value: \(value)")
        }).store(in: &cancellables)
}

// مثال‌های مختلف برای Combine
func combineExamples() {
    let publisher = Just("Hello, Combine!")
    publisher.sink { value in
        print(value)
    }.store(in: &cancellables)
}

// مثال برای ایجاد عملیات ترتیبی
func combineSerialBasics() {
    let publisher = [1, 2, 3, 4, 5].publisher
    print(publisher)
    publisher.sink { value in
        print(value, Thread.current)
    }.store(in: &cancellables)
}

// مثال برای ایجاد عملیات همزمان
func combineConcurrentBasics() {
//    let publishers = (1...5)
//        .map { Just($0)
//        .subscribe(on: DispatchQueue.global()) }
    
//
//    Publishers.MergeMany(publishers)
//        .sink { value in
//            print(value, Thread.current)
//        }
//        .store(in: &cancellables)

//    func method1() -> Int {
//        print(#function, Thread.current)
//        return 1
//    }
//    func method2() -> Int {
//        print(#function, Thread.current)
//        return 2
//    }
//    func method3() -> Int {
//        print(#function, Thread.current)
//        return 3
//    }
//    func method4() -> Int {
//        print(#function, Thread.current)
//        return 4
//    }
//    func method5() -> Int {
//        print(#function, Thread.current)
//        return 5
//    }
//
//    struct Box {
//        let delay: Int
//        let closure: () -> Int
//
//        init(delay: Int, closure: @escaping () -> Int) {
//            self.delay = delay
//            self.closure = closure
//        }
//    }
//
//    let array = [
//        Box(delay: 4, closure: method1),
//        Box(delay: 2, closure: method2),
//        Box(delay: 1, closure: method3),
//        Box(delay: 5, closure: method4),
//        Box(delay: 3, closure: method5),
//    ].publisher

//    func method1() -> AnyPublisher<Int, Never> {
//        print(#function, Thread.current)
//        return Future { promise in
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//                promise(.success(1))
//            }
//        }.receive(on: DispatchQueue.global()).eraseToAnyPublisher()
//    }
//    func method2() -> AnyPublisher<Int, Never> {
//        print(#function, Thread.current)
//        return Future { promise in
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
//                promise(.success(2))
//            }
//        }.receive(on: DispatchQueue.global()).eraseToAnyPublisher()
//    }
//    func method3() -> AnyPublisher<Int, Never> {
//        print(#function, Thread.current)
//        return Future { promise in
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
//                promise(.success(3))
//            }
//        }.receive(on: DispatchQueue.global()).eraseToAnyPublisher()
//    }
//    func method4() -> AnyPublisher<Int, Never> {
//        print(#function, Thread.current)
//        return Future { promise in
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//                promise(.success(4))
//            }
//        }.receive(on: DispatchQueue.global()).eraseToAnyPublisher()
//    }
//    func method5() -> AnyPublisher<Int, Never> {
//        print(#function, Thread.current)
//        return Future { promise in
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
//                promise(.success(5))
//            }
//        }.receive(on: DispatchQueue.global()).eraseToAnyPublisher()
//    }

//    let array = [
//        method1,
//        method2,
//        method3,
//        method4,
//        method5
//    ].publisher

//    Publishers.MergeMany(array)
//        .flatMap { box -> AnyPublisher<Int, Never> in
//            print(">", "box:", box.delay)
//            return Future { promise in
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(box.delay)) {
//                    promise(.success(box.closure()))
//                }
//            }.eraseToAnyPublisher()
//        }
//        .collect()
//        .sink(receiveCompletion: { completion in
//            print("Counter value: \(completion)")
//        }, receiveValue: { value in
//            print(value)
//        })
//        .store(in: &cancellables)
    
    struct AppError: Error {}
    
    let publishers = [
//        Fail(error: AppError()).delay(for: 5.0, scheduler: DispatchQueue.global()).eraseToAnyPublisher(),
        Just("1").setFailureType(to: AppError.self).delay(for: 5.0, scheduler: DispatchQueue.global()).eraseToAnyPublisher(),
        Just("2").setFailureType(to: AppError.self).delay(for: 2.0, scheduler: DispatchQueue.global()).eraseToAnyPublisher(),
        Just("3").setFailureType(to: AppError.self).delay(for: 0.2, scheduler: DispatchQueue.global()).eraseToAnyPublisher()
    ]

    let cancellable = publishers.zipAndSort()
        .sink(receiveCompletion: { completion in
            print("Completed: \(completion)")
        }, receiveValue: { values in
            print("Received values: \(values)", terminator: "\n")
        })
    
//    let cancellable = publishers.collectAllResults()
//        .sink(receiveCompletion: { completion in
//            print("Completed: \(completion)")
//        }, receiveValue: { values in
//            values.forEach { result in
//                switch result {
//                case let .success(success):
//                    print("Received values: \(success)", terminator: "\n")
//                case let .failure(failure):
//                    print("Received values: \(failure)", terminator: "\n")
//                }
//            }
//        })
}

// مثال برای تنظیم اولویت و لغو عملیات
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

// مثال برای تشخیص عملیات جاری
func combineIdentification() {
    let publisher = Just("Test Combine Identification")
    publisher
        .map { _ in Thread.current }
        .sink { thread in
            print("Executing on \(thread)")
        }.store(in: &cancellables)
}

// مثال برای ایجاد سلسله مراتب عملیات
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

// مثال برای استفاده از Publishers.MergeMany برای هماهنگی بین چندین وظیفه همزمان
func combineSerialTestCase() {

    func processItem(_ item: Int) -> AnyPublisher<String, Never> {
        Just("Processed item \(item)")
            .delay(for: .seconds(Double(item)), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    DispatchQueue.global(qos: .background).async {
        let publishers = (1...5).map { Just($0) }

        Publishers.Sequence(sequence: publishers)
            .flatMap(maxPublishers: .max(1)) { item in
                //            processItem(item)

                print(item, Thread.current)
                return item.eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                print("Sequence completion: \(completion)")
            }, receiveValue: { value in
                print("Sequence value: \(value)")
            })
            .store(in: &cancellables)
    }

    let array = [1, 2, 3, 4, 5]
    Publishers.Sequence<[Int], Error>(sequence: array)
        .sink(receiveCompletion: { completion in
            print("Sequence completion: \(completion)")
        }, receiveValue: { value in
            print("Sequence value: \(value)")
        }).store(in: &cancellables)

//    Publishers.Sequence(sequence: array)
//        .flatMap { item in
//            processItem(item)
//        }
//        .sink(receiveCompletion: { completion in
//            print("Sequence completion: \(completion)")
//        }, receiveValue: { value in
//            print("Sequence value: \(value)")
//        })
//        .store(in: &cancellables)
}

// مثال برای استفاده از Publishers.MergeMany برای هماهنگی بین چندین وظیفه همزمان
func combineGroupTestCase() {
    struct SampleError: Error {}
    let publishers = 1...10

    Publishers.Sequence<ClosedRange<Int>, SampleError>(sequence: publishers)
        .collect(3)
        .sink(receiveCompletion: { completion in
            print("MergeMany completion: \(completion)")
        }, receiveValue: { value in
            print("MergeMany value: \(value)")
        }).store(in: &cancellables)
}

func demonstrateSchedulers() {
    // 1. DispatchQueue
    // این مثال نشان می‌دهد که چگونه می‌توانیم یک publisher را در background queue اجرا کنیم و سپس نتیجه را در main queue دریافت کنیم.
    let backgroundQueue = DispatchQueue(label: "backgroundQueue")
    let dispatchQueuePublisher = Just("`Hello from DispatchQueue`")
        .delay(for: 5.0, scheduler: DispatchQueue.global()).eraseToAnyPublisher()

    dispatchQueuePublisher
        .subscribe(on: backgroundQueue)
        .handleEvents(receiveSubscription: { _ in
            print("DispatchQueue - ReceiveSubscription on thread: \(Thread.current)")
        }, receiveOutput: { _ in
            print("DispatchQueue - ReceiveOutput       on thread: \(Thread.current)")
        }, receiveCompletion: { _ in
            print("DispatchQueue - ReceiveCompletion   on thread: \(Thread.current)")
        })
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            print("DispatchQueue - Execute Completion     on thread: \(Thread.current)")
        }, receiveValue: { value in
            print("DispatchQueue - Execute value \(value) on thread: \(Thread.current)")
        }).store(in: &cancellables)

    // 2. OperationQueue
    // این مثال نشان می‌دهد که چگونه می‌توانیم از OperationQueue برای اجرای publisher استفاده کنیم.
    let operationQueue = OperationQueue()
    let operationQueuePublisher = Just("Hello from OperationQueue")
        .delay(for: 5.0, scheduler: DispatchQueue.global()).eraseToAnyPublisher()

    operationQueuePublisher
        .subscribe(on: operationQueue)
        .handleEvents(receiveSubscription: { _ in
            print("OperationQueue - ReceiveSubscription on thread: \(Thread.current)")
        }, receiveOutput: { _ in
            print("OperationQueue - ReceiveOutput       on thread: \(Thread.current)")
        }, receiveCompletion: { _ in
            print("OperationQueue - ReceiveCompletion   on thread: \(Thread.current)")
        })
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            print("OperationQueue - Execute Completion     on thread: \(Thread.current)")
        }, receiveValue: { value in
            print("OperationQueue - Execute value \(value) on thread: \(Thread.current)")
        }).store(in: &cancellables)


    // 3. ImmediateScheduler
    // این مثال نشان می‌دهد که چگونه می‌توانیم از ImmediateScheduler برای اجرای عملیات‌ها بلافاصله در همان context استفاده کنیم.
    let immediatePublisher = Just("Immediate Execution")
        .delay(for: 5.0, scheduler: DispatchQueue.global()).eraseToAnyPublisher()
    

    immediatePublisher
        .subscribe(on: ImmediateScheduler.shared)
        .handleEvents(receiveSubscription: { _ in
            print("ImmediateScheduler - ReceiveSubscription on thread: \(Thread.current)")
        }, receiveOutput: { _ in
            print("ImmediateScheduler - ReceiveOutput       on thread: \(Thread.current)")
        }, receiveCompletion: { _ in
            print("ImmediateScheduler - ReceiveCompletion   on thread: \(Thread.current)")
        })
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            print("ImmediateScheduler - Execute Completion     on thread: \(Thread.current)")
        }, receiveValue: { value in
            print("ImmediateScheduler - Execute value \(value) on thread: \(Thread.current)")
        }).store(in: &cancellables)
}

func combineCoordination() {
    var cancellables = Set<AnyCancellable>()
    
    // ناشر A
    let publisherA = Future<Void, Never> { promise in
        print("A")
        Thread.sleep(forTimeInterval: 1)
        promise(.success(()))
    }.eraseToAnyPublisher()
    
    // تابع B که یک Publisher برمی‌گرداند و وابسته به A است
    func bPublisher(_ input: Void) -> AnyPublisher<String, Never> {
        Deferred {
            Future<String, Never> { promise in
                print("B")
                promise(.success("B completed"))
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    // تابع C که یک Publisher برمی‌گرداند و وابسته به A است
    func cPublisher(_ input: Void) -> AnyPublisher<String, Never> {
        Deferred {
            Future<String, Never> { promise in
                print("C")
                promise(.success("C completed"))
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }

    // تابع D که یک Publisher برمی‌گرداند و وابسته به B و C است
    func dPublisher(_ inputB: String, _ inputC: String) -> AnyPublisher<String, Never> {
        Deferred {
            Future<String, Never> { promise in
                print("D")
                promise(.success("D received: \(inputB), \(inputC)"))
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    // ایجاد جریان داده‌ها با استفاده از Combine
    publisherA
        .handleEvents(receiveOutput: { _ in print("Handling A") })
        .compactMap { $0 }
        .flatMap { a in
            Publishers.Zip(bPublisher(a), cPublisher(a))
        }
        .flatMap { b, c in
            dPublisher(b, c)
        }
        .handleEvents(receiveCompletion: { _ in print("Finished") })
        .sink(receiveCompletion: { completion in
            print("Completion: \(completion)")
        }, receiveValue: { value in
            print("Final Output: \(value)")
        })
        .store(in: &cancellables)
}

// مثال برای جلوگیری از وضعیت رقابتی داده‌ها (Data Race)
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
    
    let publishers = (1...workCount).map { Just($0) }
    Publishers.MergeMany(publishers)
        .handleEvents(receiveOutput:  { _ in
            counter.increment()
        })
        .sink(receiveCompletion: { completion in
            print("Counter value: \(counter.count)")
        }, receiveValue: { _ in })
        .store(in: &cancellables)
}

// مثال برای ارزیابی عملکرد عملیات‌ها
func combineQueuePerformance() {
    let publisher = (0..<workCount).publisher
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
