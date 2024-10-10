//
//  File.swift
//
//
//  Created by Reza Akbari on 7/2/24.
//

import Foundation
//import UIKit

/// این تابع مثالی از استفاده از `DispatchQueue` برای مدیریت و اجرای عملیات‌های همزمان با استفاده از ویژگی‌ها و خصوصیات مختلف آن را نشان می‌دهد.
///
/// کلاس `DispatchQueue` یکی از ابزارهای قدرتمند برای مدیریت عملیات‌های همزمان (concurrent) در Swift است.
/// این کلاس شامل صف‌های پیش‌فرض و سفارشی، سطوح کیفیت سرویس، متدهای زمان‌بندی و کنترل همزمانی است.
///
/// - ویژگی‌ها و خصوصیات:
///   - صف‌های پیش‌فرض:
///     - `main`: صف اصلی که عملیات‌ها را در ترد اصلی اجرا می‌کند.
///     - `global()`: صف‌های جهانی که با سطوح کیفیت سرویس مختلف ارائه می‌شوند.
///   - سطوح کیفیت سرویس (QoS):
///     - `.userInteractive`: بالاترین سطح QoS.
///     - `.userInitiated`: برای عملیات‌هایی که کاربر شروع کرده و منتظر نتیجه آن است.
///     - `.default`: سطح QoS پیش‌فرض.
///     - `.utility`: برای عملیات‌های طولانی مدت.
///     - `.background`: پایین‌ترین سطح QoS.
///   - زمان‌بندی و تأخیر:
///     - `asyncAfter(deadline:execute:)`: برای اجرای عملیات پس از یک تأخیر مشخص.
///   - خصوصیات دیگر:
///     - `label`: یک رشته که به صف اختصاص داده می‌شود تا بتوان آن را شناسایی کرد.
///     - `attributes`: ویژگی‌هایی مثل `concurrent` که مشخص می‌کنند صف به صورت همزمانی (concurrent) یا ترتیبی (serial) اجرا شود.
///
/// مثال استفاده:
/// ```swift
/// dispatchQueueFeaturesExample()
/// ```
func dispatchQueueFeaturesExample() {
    // استفاده از صف اصلی
    let mainQueue = DispatchQueue.main
    mainQueue.sync {
        print("Executing on the main queue")
    }

    // استفاده از صف جهانی با کیفیت سرویس پیش‌فرض
    let globalQueue = DispatchQueue.global()
    globalQueue.sync {
        print("Executing on the global queue with default QoS")
    }

    // استفاده از صف جهانی با کیفیت سرویس خاص
    let backgroundQueue = DispatchQueue.global(qos: .background)
    backgroundQueue.sync {
        print("Executing on the global queue with background QoS")
    }

    // استفاده از متد async برای اجرای همزمان عملیات در صف سفارشی ترتیبی (serial queue)
    let serialQueue = DispatchQueue(label: "com.example.serialQueue")
    serialQueue.sync {
        print("Executing async operation on serial queue")
    }

    // استفاده از متد async برای اجرای همزمان عملیات در صف سفارشی همزمانی (concurrent queue)
    let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
    concurrentQueue.sync {
        print("Executing async operation on concurrent queue")
    }

    // استفاده از متد asyncAfter برای اجرای همزمان عملیات پس از تأخیر
    let delayQueue = DispatchQueue(label: "com.example.delayQueue")
    delayQueue.asyncAfter(deadline: .now() + 2) {
        print("Executing operation after delay on delay queue")
    }
}

/// این تابع مثالی از استفاده از `DispatchQueue` برای ایجاد یک صف ترتیبی (serial queue) و اجرای عملیات‌ها به صورت ترتیبی را نشان می‌دهد.
///
/// کلاس `DispatchQueue` یکی از ابزارهای قدرتمند برای مدیریت و اجرای عملیات‌های همزمان (concurrent) و ترتیبی (serial) در Swift است.
/// این تابع یک صف ترتیبی ایجاد می‌کند و چندین عملیات را به صورت غیرهمزمان (asynchronous) به این صف اضافه می‌کند.
///
/// - عملکرد:
/// 1. ایجاد یک صف ترتیبی با برچسب `my.queue`.
/// 2. افزودن پنج عملیات به صف ترتیبی با استفاده از متد `async`.
/// 3. هر عملیات یک عدد و اطلاعات ترد جاری را چاپ می‌کند.
///
/// مثال استفاده:
/// ```swift
/// dispatchQueueSerialBasics()
/// ```
func dispatchQueueSerialBasics() {
    // ایجاد یک صف ترتیبی با برچسب `my.queue`
    let queue = DispatchQueue(label: "my.queue")
//    print(1)
//    queue.sync {
//        print("10_000_000-1")
//        for _ in 0 ... 10_000_000 {}
//        print("10_000_000-1")
//    }
//    queue.sync {
//        print("10_000_000-2")
//        for _ in 0 ... 10_000_000 {}
//        print("10_000_000-2")
//    }
//    queue.sync {
//        print("10_000_000-3")
//        for _ in 0 ... 10_000_000 {}
//        print("10_000_000-3")
//    }
//    queue.sync {
//        print("10_000_000-4")
//        for _ in 0 ... 10_000_000 {}
//        print("10_000_000-4")
//    }
//    queue.sync {
//        print("10_000_000-5")
//        for _ in 0 ... 10_000_000 {}
//        print("10_000_000-5")
//    }
//    print(2)
    var set = Set<UInt64>()
    DispatchQueue.concurrentPerform(iterations: 100) { i in
        let id = unsafeBitCast(Thread.current, to: UInt64.self)
        queue.async {
            set.insert(id)
            print(set.count)
        }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    }
    
    // افزودن عملیات‌ها به صف ترتیبی
//    let one = queue.sync { 1 }
//    
//    queue.async { print("2", Thread.current) }
//    queue.async { print("3", Thread.current) }
//    queue.async { print("4", Thread.current) }
//    queue.async { print("5", Thread.current) }
}

/// این تابع مثالی از استفاده از `DispatchQueue` برای ایجاد یک صف همزمانی (concurrent queue) و اجرای عملیات‌ها به صورت همزمان را نشان می‌دهد.
///
/// کلاس `DispatchQueue` یکی از ابزارهای قدرتمند برای مدیریت و اجرای عملیات‌های همزمان (concurrent) و ترتیبی (serial) در Swift است.
/// این تابع یک صف همزمانی ایجاد می‌کند و چندین عملیات را به صورت غیرهمزمان (asynchronous) به این صف اضافه می‌کند.
///
/// - عملکرد:
/// 1. ایجاد یک صف همزمانی با برچسب `my.queue` و ویژگی `.concurrent`.
/// 2. افزودن پنج عملیات به صف همزمانی با استفاده از متد `async`.
/// 3. هر عملیات یک عدد و اطلاعات ترد جاری را چاپ می‌کند.
///
/// مثال استفاده:
/// ```swift
/// dispatchQueueConcurrentBasics()
/// ```
func dispatchQueueConcurrentBasics() {
    // ایجاد یک صف همزمانی با برچسب `my.queue` و ویژگی `.concurrent`
    let queue = DispatchQueue(label: "my.queue")

    // افزودن عملیات‌ها به صف همزمانی
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

/// این تابع مثالی از استفاده از `DispatchQueue` برای تنظیم اولویت و لغو یک عملیات با استفاده از `DispatchWorkItem` را نشان می‌دهد.
///
/// کلاس `DispatchQueue` یکی از ابزارهای قدرتمند برای مدیریت و اجرای عملیات‌های همزمان (concurrent) و ترتیبی (serial) در Swift است.
/// این تابع یک صف با اولویت پس‌زمینه ایجاد می‌کند و یک عملیات را با استفاده از `DispatchWorkItem` به صف اضافه می‌کند و سپس آن را لغو می‌کند.
///
/// - عملکرد:
/// 1. ایجاد یک صف با برچسب `my.queue` و اولویت `.background`.
/// 2. تعریف یک `DispatchWorkItem` برای اجرای عملیات.
/// 3. افزودن عملیات به صف با استفاده از `async`.
/// 4. لغو عملیات پس از 0.5 ثانیه.
///
/// مثال استفاده:
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
        guard !(item?.isCancelled == true)
        else {
            print("Cancelled!")
            return
        }
        print(Thread.current)
    }

    queue.async(execute: item!)
    item?.cancel()

    Thread.sleep(forTimeInterval: 0.5)
}

/// این تابع مثالی از استفاده از `DispatchSpecificKey` برای تشخیص صفی که یک بلوک کد روی آن اجرا می‌شود را نشان می‌دهد.
func dispatchQueueIdentification() {
    // تعریف کلیدهای مخصوص برای شناسایی صف
    let queueLabelKey = DispatchSpecificKey<String>()
    
    let main = DispatchQueue.main
    main.setSpecific(key: queueLabelKey, value: "main")
    
    // ایجاد صف اول و تنظیم مقدار مخصوص
    let queue1 = DispatchQueue(label: "queue1")
    queue1.setSpecific(key: queueLabelKey, value: "queue1")
    
    // ایجاد صف دوم و تنظیم مقدار مخصوص
    let queue2 = DispatchQueue(label: "queue2")
    queue2.setSpecific(key: queueLabelKey, value: "queue2")
    
    // تابعی برای چاپ صف جاری
    func printCurrentQueue() {
        if let label = DispatchQueue.getSpecific(key: queueLabelKey) {
            print("Executing on \(label)")
            print(Thread.current)
        } else {
            print("Executing on an unknown queue")
        }
    }
    
    // اجرای بلوک کد در صف اول
//    queue1.async {
//        printCurrentQueue()
//    }
    
    // اجرای بلوک کد در صف دوم
//    queue2.async {
//        printCurrentQueue()
//    }
    
    // اجرای بلوک کد در صف اصلی
    DispatchQueue.main.async {
        printCurrentQueue()
    }
}

/// این تابع مثالی از ایجاد سلسله مراتب صف‌ها (DispatchQueue) را نشان می‌دهد.
///
/// - عملکرد:
/// 1. ایجاد صف هدف با کیفیت سرویس .utility.
/// 2. ایجاد سه صف با کیفیت سرویس‌های مختلف و تنظیم صف هدف.
/// 3. اجرای بلوک‌های کد در صف‌های مختلف و چاپ کیفیت سرویس و اطلاعات ترد جاری.
///
/// مثال استفاده:
/// ```swift
/// dispatchHierachy()
/// ```
func dispatchHierachy() {
    // ایجاد صف هدف با کیفیت سرویس .utility
    let targetQueue = DispatchQueue(label: "com.test.targetQueue", qos: .utility, attributes: .concurrent)
    
    // ایجاد سه صف با کیفیت سرویس‌های مختلف و تنظیم صف هدف
    let queue1 = DispatchQueue(label: "com.test.queue1", target: targetQueue)
    let queue2 = DispatchQueue(label: "com.test.queue2", qos: .background, target: targetQueue)
    let queue3 = DispatchQueue(label: "com.test.queue3", qos: .default, target: targetQueue)
    
    // اجرای بلوک کد در صف هدف و چاپ کیفیت سرویس و اطلاعات ترد جاری
    targetQueue.async {
        Thread.current.name = "\(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)"
        print("Target Queue QoS: \(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)")
        print("Target Queue Thread: \(Thread.current)")
    }
    
    // اجرای بلوک کد در صف queue1 و چاپ کیفیت سرویس و اطلاعات ترد جاری
    queue1.async {
        print("Queue1 QoS: \(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)")
        print("Queue1 Thread: \(Thread.current)")
    }
    
    // اجرای بلوک کد در صف queue2 و چاپ کیفیت سرویس و اطلاعات ترد جاری
    queue2.async {
        print("Queue2 QoS: \(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)")
        print("Queue2 Thread: \(Thread.current)")
    }
    
    // اجرای بلوک کد در صف queue3 و چاپ کیفیت سرویس و اطلاعات ترد جاری
    queue3.async {
        print("Queue3 QoS: \(DispatchQoS.QoSClass(rawValue: qos_class_self()) ?? .unspecified)")
        print("Queue3 Thread: \(Thread.current)")
    }
}


/// این تابع مثالی از استفاده از `DispatchQueue` با مقادیر مختلف `autoreleaseFrequency` را نشان می‌دهد.
///
/// - عملکرد:
/// 1. ایجاد یک صف والد با استفاده از `DispatchQueue` با `autoreleaseFrequency` تنظیم شده به `.workItem`.
/// 2. ایجاد یک صف فرعی که از تنظیمات صف والد پیروی می‌کند (حالت `.inherit`).
/// 3. ایجاد یک صف با استفاده از `DispatchQueue` با `autoreleaseFrequency` تنظیم شده به `.never`.
/// 4. ایجاد یک صف با استفاده از `DispatchQueue` با `autoreleaseFrequency` تنظیم شده به `.workItem`.
/// 5. اجرای بلاک‌های کد در هر یک از این صف‌ها.
///
/// مثال استفاده:
/// ```swift
/// demonstrateAutoreleaseFrequencies()
/// ```
func demonstrateAutoreleaseFrequencies() {
    class SomeObject {
        func doSomething() {}
    }
    
    // ایجاد یک صف والد با `autoreleaseFrequency` تنظیم شده به `.workItem`
    let parentQueue = DispatchQueue(label: "com.example.parentQueue", autoreleaseFrequency: .workItem)

    // ایجاد یک صف فرعی که از تنظیمات صف والد پیروی می‌کند
    let childQueue = DispatchQueue(label: "com.example.childQueue", target: parentQueue)

    // ایجاد یک صف با `autoreleaseFrequency` تنظیم شده به `.never`
    let neverQueue = DispatchQueue(label: "com.example.neverQueue", autoreleaseFrequency: .never)

    // ایجاد یک صف با `autoreleaseFrequency` تنظیم شده به `.workItem`
    let workItemQueue = DispatchQueue(label: "com.example.workItemQueue", autoreleaseFrequency: .workItem)

    // آزمایش صف فرعی (حالت .inherit)
    func testInheritQueue() {
        childQueue.sync {
            let object = SomeObject()
            print("Executing task in child queue with .inherit autorelease")
            // حافظه اشیاء پس از اتمام این بلاک آزاد می‌شود
        }
    }

    // آزمایش صف با `autoreleaseFrequency` تنظیم شده به `.never`
    func testNeverQueue() {
        neverQueue.sync {
            let object = SomeObject()
            print("Executing task in queue with .never autorelease")
            // حافظه اشیاء به‌صورت خودکار آزاد نمی‌شود
            // شما باید به‌صورت دستی حافظه را مدیریت کنید
            object.doSomething()
            // فرض کنید نیاز به آزاد کردن دستی object دارید
        }
    }

    // آزمایش صف با `autoreleaseFrequency` تنظیم شده به `.workItem`
    func testWorkItemQueue() {
        workItemQueue.sync {
            let object = SomeObject()
            print("Executing task in queue with .workItem autorelease")
            // حافظه اشیاء پس از اتمام این بلاک به‌صورت خودکار آزاد می‌شود
            object.doSomething()
            // نیازی به مدیریت دستی حافظه نیست
        }
    }

    // فراخوانی توابع برای آزمایش هر یک از صف‌ها
    testInheritQueue()
    testNeverQueue()
    testWorkItemQueue()
}



/// این تابع مثالی از استفاده از `DispatchGroup` برای مدیریت و هماهنگی بین چندین وظیفه همزمان را نشان می‌دهد.
///
/// - عملکرد:
/// 1. ایجاد یک صف برای نمایش نتایج.
/// 2. ایجاد یک گروه dispatch برای مدیریت وظایف.
/// 3. تعریف تابع `performTask` برای شبیه‌سازی یک وظیفه.
/// 4. شروع وظایف و افزودن آنها به گروه.
/// 5. اطلاع‌رسانی هنگامی که تمام وظایف به پایان رسید.
/// 6. انتظار برای تکمیل همه وظایف و سپس چاپ "Done".
///
/// مثال استفاده:
/// ```swift
/// dispatchGroupTestCase()
/// ```
func dispatchGroupTestCase() {
    // ایجاد یک صف برای نمایش نتایج
    let resultQueue = DispatchQueue(label: "queue.result")
    // ایجاد یک گروه dispatch برای مدیریت وظایف
    let dispatchGroup = DispatchGroup()
    
    // تعریف تابعی برای شبیه‌سازی یک وظیفه
    func performTask(taskNumber: Int) {
        dispatchGroup.enter()
        DispatchQueue.global().async {
            print("Task \(taskNumber) is starting")
            // شبیه‌سازی انجام کاری
//            sleep(UInt32(arc4random_uniform(4)))
            print("Task \(taskNumber) is completed")
            print(Thread.current)
            dispatchGroup.leave()
        }
    }

//        dispatchGroup.enter()
        performTask(taskNumber: 1)
//        dispatchGroup.enter()
        performTask(taskNumber: 2)
//        dispatchGroup.enter()
        performTask(taskNumber: 3)
    
    // شروع وظایف و افزودن آنها به گروه
//    for i in 0..<1_000 {
//        performTask(taskNumber: i)
//    }
    
    // اطلاع‌رسانی هنگامی که تمام وظایف به پایان رسید
    dispatchGroup.notify(queue: resultQueue) {
        print("All tasks are finished. Display the results here.")
    }
    
    // انتظار برای تکمیل همه وظایف و سپس چاپ "Done"
    dispatchGroup.wait()
    print("Done.")
}


/// این تابع مثالی از استفاده از `DispatchSource` برای ایجاد و مدیریت تایمرها را نشان می‌دهد.
///
/// - عملکرد:
/// 1. ایجاد یک تایمر با استفاده از `DispatchSource.makeTimerSource`.
/// 2. تنظیم `EventHandler` برای تایمر که در هر بار فعال شدن تایمر یک پیام چاپ می‌کند.
/// 3. تنظیم زمانبندی تایمر برای اجرا شدن بلافاصله و تکرار هر 2 ثانیه.
/// 4. شروع تایمر.
///
/// مثال استفاده:
/// ```swift
/// dispatchSourceTimer()
/// ```
func dispatchSourceTimer() {
    // ایجاد یک تایمر با استفاده از `DispatchSource.makeTimerSource`
    let timerSource = DispatchSource.makeTimerSource()

    // تابعی برای آزمایش تایمر
    func testTimerDispatchSource() {
        // تنظیم `EventHandler` برای تایمر
        timerSource.setEventHandler {
            print("test")
        }
        
        // تنظیم زمانبندی تایمر: اجرا شدن بلافاصله و تکرار هر 2 ثانیه
        timerSource.schedule(deadline: .now(), repeating: 2)
        
        // شروع تایمر
        timerSource.resume()
    }
    
    // فراخوانی تابع برای آزمایش تایمر
    testTimerDispatchSource()
}

/// این تابع مثالی از استفاده از `DispatchSource` برای مدیریت و پاسخگویی به فشار حافظه (Memory Pressure) را نشان می‌دهد.
///
/// - عملکرد:
/// 1. ایجاد یک منبع فشار حافظه با استفاده از `DispatchSource.makeMemoryPressureSource`.
/// 2. تنظیم `EventHandler` برای منبع فشار حافظه که در صورت بروز هشدار حافظه یک پیام چاپ می‌کند.
/// 3. شروع نظارت بر فشار حافظه.
///
/// مثال استفاده:
/// ```swift
/// dispatchSourceMemoryPressure()
/// ```
func dispatchSourceMemoryPressure() {
    // ایجاد یک منبع فشار حافظه با استفاده از `DispatchSource.makeMemoryPressureSource`
    let memorySource = DispatchSource.makeMemoryPressureSource(eventMask: .warning, queue: .main)

    // تابعی برای آزمایش منبع فشار حافظه
    func testMemoryDispatchSource() {
        // تنظیم `EventHandler` برای منبع فشار حافظه
        memorySource.setEventHandler {
            print("Memory pressure warning received")
        }
        
        // شروع نظارت بر فشار حافظه
        memorySource.resume()
    }
    
    // فراخوانی تابع برای آزمایش منبع فشار حافظه
    testMemoryDispatchSource()
    
    // برای شبیه‌سازی دریافت هشدار حافظه (فقط در دیباگینگ)
//     UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
}

/// این تابع مثالی از استفاده از `DispatchSource` برای مدیریت سیگنال‌ها در سیستم عامل را نشان می‌دهد.
///
/// - عملکرد:
/// 1. ایجاد یک منبع سیگنال با استفاده از `DispatchSource.makeSignalSource`.
/// 2. تنظیم `EventHandler` برای منبع سیگنال که در صورت دریافت سیگنال یک پیام چاپ می‌کند.
/// 3. شروع نظارت بر سیگنال.
///
/// مثال استفاده:
/// ```swift
/// dispatchSourceSignalSource()
/// ```
func dispatchSourceSignalSource() {
    // ایجاد یک منبع سیگنال با استفاده از `DispatchSource.makeSignalSource`
    let signalSource = DispatchSource.makeSignalSource(signal: SIGSTOP, queue: .main)

    // تابعی برای آزمایش منبع سیگنال
    func testSignalSource() {
        // تنظیم `EventHandler` برای منبع سیگنال
        signalSource.setEventHandler {
            print("Signal SIGSTOP received")
        }
        
        // شروع نظارت بر سیگنال
        signalSource.resume()
    }
    
    // فراخوانی تابع برای آزمایش منبع سیگنال
    testSignalSource()
}

/// این تابع مثالی از استفاده از `DispatchSource` برای نظارت بر رویدادهای مربوط به فرآیند جاری را نشان می‌دهد.
///
/// - عملکرد:
/// 1. ایجاد یک منبع فرآیند با استفاده از `DispatchSource.makeProcessSource`.
/// 2. تنظیم `EventHandler` برای منبع فرآیند که در صورت دریافت رویداد یک پیام چاپ می‌کند.
/// 3. شروع نظارت بر رویدادهای فرآیند.
///
/// مثال استفاده:
/// ```swift
/// dispatchSourceProcessSource()
/// ```
func dispatchSourceProcessSource() {
    // ایجاد یک منبع فرآیند با استفاده از `DispatchSource.makeProcessSource`
    let processSource = DispatchSource.makeProcessSource(identifier: ProcessInfo.processInfo.processIdentifier, eventMask: .signal, queue: .main)

    // تابعی برای آزمایش منبع فرآیند
    func testProcessSource() {
        // تنظیم `EventHandler` برای منبع فرآیند
        processSource.setEventHandler {
            print("Process signal event received")
        }
        
        // شروع نظارت بر رویدادهای فرآیند
        processSource.resume()
    }
    
    // فراخوانی تابع برای آزمایش منبع فرآیند
    testProcessSource()
}


func dispatchSemaphore() {
//    let semaphore = DispatchSemaphore(value: 3)

//    for i in 1...6 {
//        semaphore.wait()  // semaphore - 1
//        DispatchQueue.global().async() {
//            print("Start access to the shared resource: \(i)")
//            sleep(2)
//            semaphore.signal()  // semaphore + 1
//        }
//
//    }

    let semaphore = DispatchSemaphore(value: 0)
    var number: Int = 0

    print("thread 1 starts")

    // asynchronous events like fetching data from API
    DispatchQueue.global(qos: .background).async {
        print("thread 2 starts")
        number = 123
        sleep(2)
        print("thread 2 ends: \(Thread.current)")
        semaphore.signal() // semaphore + 1
    }

    semaphore.wait() // semaphore - 1
    print(number)
    print("thread 1 ends: \(Thread.current)")

}

/// این تابع مثالی از استفاده از `DispatchQueue` برای جلوگیری از وضعیت رقابتی داده‌ها (Data Race) را نشان می‌دهد.
///
/// - عملکرد:
/// 1. تعریف کلاس `Counter` که شامل یک صف همزمان برای مدیریت امن عملیات‌هاست.
/// 2. ایجاد یک نمونه از `Counter`.
/// 3. ایجاد یک صف همزمان برای اجرای وظایف.
/// 4. شروع وظایف افزایش شمارنده به صورت همزمان.
/// 5. انتظار برای تکمیل تمام وظایف و سپس چاپ مقدار شمارنده.
///
/// مثال استفاده:
/// ```swift
/// dispatchDataRace()
/// ```
func dispatchDataRace() {
    class Counter {
        let queue = DispatchQueue(label: "counter", attributes: .concurrent)
        var count = 0
        
        // تابع افزایش شمارنده با استفاده از ویژگی .barrier برای اطمینان از اجرای امن
        func increment() -> Int {
            self.queue.sync(flags: .barrier) {
                self.count += 1
                return count
            }
        }
    }
    
    let counter = Counter()
    let queue = DispatchQueue(label: "concurrent-queue", attributes: .concurrent)

    for _ in 0..<workCount {
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
    for _ in 0..<workCount {
        queue.async {
            print(Thread.current)
            while true {}
        }
    }
}
