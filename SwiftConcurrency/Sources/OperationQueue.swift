import Foundation

/// این تابع مثالی از استفاده از کلاس `OperationQueue` برای مدیریت و اجرای عملیات‌ها به صورت همزمان را نشان می‌دهد.
///
/// کلاس `OperationQueue` به شما اجازه می‌دهد که عملیات‌های مختلف را به صف اضافه کنید و نحوه اجرای آن‌ها را کنترل کنید.
///
/// - پارامترها:
///   - maxConcurrentOperationCount: تعداد حداکثر عملیاتی که می‌توانند به صورت همزمان اجرا شوند. مقدار پیش‌فرض این پارامتر به سیستم عامل و منابع موجود بستگی دارد.
///   - isSuspended: یک بولین که نشان می‌دهد آیا صف عملیات متوقف شده است یا خیر. اگر مقدار `true` باشد، عملیات‌های جدید اجرا نمی‌شوند تا زمانی که صف از حالت تعلیق خارج شود.
///   - operations: یک آرایه از عملیات‌های فعلی که در صف هستند.
///   - operationCount: تعداد عملیات‌های موجود در صف.
///
/// - متدها:
///   - addOperation(_:): یک عملیات (`Operation`) را به صف اضافه می‌کند.
///   - addOperations(_:waitUntilFinished:): چندین عملیات را به صف اضافه می‌کند و می‌تواند منتظر بماند تا همه عملیات‌ها تمام شوند.
///   - addOperation(_:) (با یک کلوزر به عنوان ورودی): یک عملیات را با استفاده از یک کلوزر به صف اضافه می‌کند.
///   - cancelAllOperations(): تمام عملیات‌های موجود در صف را لغو می‌کند.
///   - waitUntilAllOperationsAreFinished(): منتظر می‌ماند تا تمام عملیات‌های موجود در صف تمام شوند.
///
/// عملکرد:
/// 1. یک صف عملیات جدید (`OperationQueue`) ایجاد می‌شود.
/// 2. پنج عملیات مختلف به صف اضافه می‌شوند که هر کدام یک پیغام را چاپ کرده و به مدت یک ثانیه به حالت خواب می‌روند.
/// 3. تعداد حداکثر عملیات‌های همزمان به 2 تنظیم می‌شود.
/// 4. صف عملیات متوقف و سپس از حالت توقف خارج می‌شود.
/// 5. پس از اتمام تمام عملیات‌ها، یک پیغام چاپ می‌شود.
///
/// مثال استفاده:
/// ```swift
/// operationQueueExample()
/// ```
func operationQueue() {
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 2
    operationQueue.name = "khariat Mahz"
    operationQueue.qualityOfService = .userInteractive
    
    for i in 1...100 {
        operationQueue.addOperation {
            print("Operation \(i) started")
            Thread.sleep(forTimeInterval: 1) // به مدت یک ثانیه به حالت خواب می‌رود
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


/// این تابع مثالی از استفاده از `OperationQueue` برای مدیریت عملیات‌های همزمان را نشان می‌دهد.
///
/// تابع `operationQueueExample` یک صف عملیات ایجاد می‌کند و چندین عملیات را به آن اضافه می‌کند.
/// هر عملیات یک پیام چاپ می‌کند و برای مدتی به حالت خواب می‌رود تا شبیه‌سازی یک کار زمان‌بر باشد.
///
/// عملکرد:
/// 1. یک `OperationQueue` ایجاد می‌شود.
/// 2. سه عملیات (`Operation`) به صف عملیات اضافه می‌شوند.
/// 3. هر عملیات یک پیام چاپ می‌کند و به مدت 2 ثانیه به حالت خواب می‌رود.
/// 4. عملیات‌ها به صورت همزمان اجرا می‌شوند.
///
/// مثال استفاده:
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


/// این تابع مثالی از استفاده از `OperationQueue` برای تنظیم اولویت و لغو یک عملیات را نشان می‌دهد.
///
/// تابع `operationPriorityAndCancellation` یک صف عملیات (`OperationQueue`) ایجاد می‌کند و یک عملیات (`BlockOperation`) به آن اضافه می‌کند.
/// این عملیات شامل یک بلوک اجرایی است که زمان اجرا را اندازه‌گیری کرده و پس از یک وقفه کوتاه، بررسی می‌کند که آیا عملیات لغو شده است یا خیر.
/// اگر عملیات لغو شده باشد، پیام "Cancelled!" چاپ می‌شود و در غیر این صورت، اطلاعات ترد جاری چاپ می‌شود.
///
/// - عملکرد:
/// 1. ایجاد یک صف عملیات جدید (`OperationQueue`).
/// 2. تعریف و اضافه کردن یک عملیات به صف.
/// 3. تنظیم کیفیت سرویس عملیات به `.background`.
/// 4. لغو عملیات پس از 0.1 ثانیه.
///
/// مثال استفاده:
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
//    Thread.sleep(forTimeInterval: 2)
    operation.cancel()
}


/// این تابع مثالی از استفاده از `OperationQueue` برای هماهنگی بین عملیات‌ها با استفاده از وابستگی‌ها را نشان می‌دهد.
///
/// تابع `operationQueueCoordination` یک صف عملیات (`OperationQueue`) ایجاد می‌کند و چهار عملیات (`BlockOperation`) به آن اضافه می‌کند.
/// با استفاده از متد `addDependency`، وابستگی‌هایی بین عملیات‌ها ایجاد می‌شود تا تعیین شود که کدام عملیات باید قبل از دیگری اجرا شود.
///
/// - عملکرد:
/// 1. ایجاد یک صف عملیات جدید (`OperationQueue`).
/// 2. تعریف و اضافه کردن چهار عملیات به صف.
/// 3. ایجاد وابستگی بین عملیات‌ها:
///    - عملیات B و C باید پس از اتمام عملیات A اجرا شوند.
///    - عملیات D باید پس از اتمام عملیات‌های B و C اجرا شود.
/// 4. اضافه کردن عملیات‌ها به صف.
///
/// مثال استفاده:
/// ```swift
/// operationQueueCoordination()
/// ```
///
/// نمودار وابستگی‌ها:
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
    
    // ایجاد وابستگی‌ها
    operationB.addDependency(operationA)
    operationC.addDependency(operationA)
    operationD.addDependency(operationB)
    operationD.addDependency(operationC)
    
    // اضافه کردن عملیات‌ها به صف
    queue.addOperation(operationA)
    queue.addOperation(operationB)
    queue.addOperation(operationC)
    queue.addOperation(operationD)

    // لغو عملیات A (اختیاری، برای مثال)
}


func operationPerformance() {
    let queue = OperationQueue()
    print(queue.maxConcurrentOperationCount)

    for n in 0..<workCount {
        queue.addOperation {
            print(queue.maxConcurrentOperationCount, Thread.current)
            while true {}
        }
    }

//    queue.addOperation {
//        print("Starting the prime operation")
//        nthPrime(50000)
//    }
}
