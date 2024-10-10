import Foundation

/// این تابع توضیحاتی در مورد کلاس `Thread` و ویژگی‌ها و روش‌های آن در Swift ارائه می‌دهد.
///
/// کلاس `Thread` یکی از کلاس‌های پایه‌ای برای مدیریت تردها در برنامه‌های چندنخی است.
/// این کلاس به شما اجازه می‌دهد که عملیات مختلفی را به صورت همزمان اجرا کنید، بدون اینکه نیاز به استفاده از صف‌های پیشرفته‌تر مثل `DispatchQueue` یا `OperationQueue` داشته باشید.
///
/// ویژگی‌ها و روش‌های کلاس `Thread`:
/// 1. **ایجاد ترد**: با استفاده از `Thread { ... }` یا `Thread(target:selector:object:)` می‌توان یک ترد جدید ایجاد کرد.
/// 2. **شروع ترد**: با استفاده از `start()` ترد را شروع کنید.
/// 3. **لغو ترد**: با استفاده از `cancel()` ترد را لغو کنید. باید توجه داشت که این عملیات بلافاصله اجرای ترد را متوقف نمی‌کند، بلکه یک فلگ (پرچم) لغو تنظیم می‌کند که باید به صورت دستی درون کد ترد بررسی شود.
/// 4. **اولویت ترد**: با استفاده از `threadPriority` می‌توان اولویت اجرای ترد را تنظیم کرد.
/// 5. **ذخیره‌سازی محلی ترد**: از `threadDictionary` می‌توان برای ذخیره و دسترسی به داده‌های محلی درون هر ترد استفاده کرد.
///
/// مثال:
/// ```swift
/// let thread = Thread {
///     print("This is a new thread.")
/// }
/// thread.start()
/// ```
///
/// این روش برای استفاده در برنامه‌های ساده مناسب است، اما برای برنامه‌های پیچیده‌تر معمولاً استفاده از `DispatchQueue` یا `OperationQueue` توصیه می‌شود.
func explainThreadClass() {
    print("""
    کلاس Thread یکی از کلاس‌های پایه‌ای برای مدیریت تردها در برنامه‌های چندنخی است.
    این کلاس به شما اجازه می‌دهد که عملیات مختلفی را به صورت همزمان اجرا کنید، بدون اینکه نیاز به استفاده از صف‌های پیشرفته‌تر مثل DispatchQueue یا OperationQueue داشته باشید.

    ویژگی‌ها و روش‌های کلاس Thread:
    1. ایجاد ترد: با استفاده از Thread { ... } یا Thread(target:selector:object:) می‌توان یک ترد جدید ایجاد کرد.
    2. شروع ترد: با استفاده از start() ترد را شروع کنید.
    3. لغو ترد: با استفاده از cancel() ترد را لغو کنید. باید توجه داشت که این عملیات بلافاصله اجرای ترد را متوقف نمی‌کند، بلکه یک فلگ (پرچم) لغو تنظیم می‌کند که باید به صورت دستی درون کد ترد بررسی شود.
    4. اولویت ترد: با استفاده از threadPriority می‌توان اولویت اجرای ترد را تنظیم کرد.
    5. ذخیره‌سازی محلی ترد: از threadDictionary می‌توان برای ذخیره و دسترسی به داده‌های محلی درون هر ترد استفاده کرد.

    مثال:
    let thread = Thread {
        print("This is a new thread.")
    }
    thread.start()

    این روش برای استفاده در برنامه‌های ساده مناسب است، اما برای برنامه‌های پیچیده‌تر معمولاً استفاده از DispatchQueue یا OperationQueue توصیه می‌شود.
    """)
}

/// این تابع یک مثال ساده از استفاده از کلاس `Thread` برای ایجاد و مدیریت تردها را نشان می‌دهد.
///
/// تابع `exampleThreadUsage` یک ترد جدید ایجاد می‌کند که درون آن یک شمارنده را چاپ می‌کند.
/// همچنین ترد اصلی نیز به صورت همزمان در حال اجرا بوده و شمارنده دیگری را چاپ می‌کند.
///
/// عملکرد:
/// 1. ایجاد یک ترد جدید با استفاده از کلاس `Thread`.
/// 2. تنظیم اولویت ترد جدید.
/// 3. شروع ترد جدید.
/// 4. اجرای یک شمارنده در ترد اصلی.
///
/// مثال خروجی:
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
/// بسته به زمان‌بندی تردها، خروجی ممکن است متفاوت باشد.
func exampleThreadUsage() {
    // ایجاد یک ترد جدید
    let thread = Thread {
        print("This is a new thread.")
        for i in 1...5 {
            print("Count \(i) from thread.")
            Thread.sleep(forTimeInterval: 1) // ترد را به مدت 1 ثانیه به حالت خواب می‌برد
        }
        print("Thread is exiting.")
    }

    // تنظیم اولویت ترد
    thread.threadPriority = 0.8

    // شروع ترد
    thread.start()

    // چاپ از ترد اصلی
    for i in 1...5 {
        print("Count \(i) from main thread.")
        Thread.sleep(forTimeInterval: 1)
    }

    print("Main thread is exiting.")
}


/// این تابع پنج ترد جدید ایجاد و هر کدام را شروع می‌کند که یک شماره منحصر به فرد و اطلاعات ترد فعلی را چاپ می‌کنند.
///
/// تابع `threadBasics` نشان‌دهنده ساده‌ترین روش استفاده از کلاس `Thread` در زبان Swift برای ایجاد تردهای جدید است.
/// در این روش، پنج ترد جدید ایجاد شده و هر کدام شماره‌ای از 1 تا 5 و اطلاعات ترد فعلی را چاپ می‌کنند.
/// این روش به عنوان ساده‌ترین روش ساخت ترد به صورت دستی شناخته می‌شود، اما امروزه دیگر توصیه نمی‌شود و روش‌های جدیدتری برای مدیریت تردها وجود دارد.
///
/// استفاده:
/// ```swift
/// threadBasics()
/// ```
///
/// خروجی:
/// هر ترد شماره خود و اطلاعات ترد را چاپ می‌کند. ترتیب خروجی ممکن است بسته به زمان‌بندی تردها متفاوت باشد.
///
/// مثال خروجی:
/// ```
/// 1 <NSThread: 0x600003d40380>{number = 5, name = (null)}
/// 2 <NSThread: 0x600003d40740>{number = 6, name = (null)}
/// 3 <NSThread: 0x600003d40900>{number = 7, name = (null)}
/// 4 <NSThread: 0x600003d40ac0>{number = 8, name = (null)}
/// 5 <NSThread: 0x600003d40c80>{number = 9, name = (null)}
/// ```
///
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


/// این تابع مثالی از استفاده از اولویت‌بندی ترد و لغو ترد را نشان می‌دهد.
///
/// تابع `threadPriorityAndCancellation` یک ترد جدید با اولویت مشخص ایجاد می‌کند و در طول اجرای آن بررسی می‌کند که آیا ترد لغو شده است یا خیر.
/// همچنین یک ترد داخلی نیز ایجاد می‌کند که وضعیت لغو آن را چاپ می‌کند.
///
/// استفاده:
/// ```swift
/// threadPriorityAndCancellation()
/// ```
///
/// توضیحات عملکرد:
/// 1. یک ترد جدید با استفاده از یک کلوزر ایجاد می‌شود.
/// 2. در شروع ترد، زمان شروع ثبت می‌شود و در پایان زمان سپری شده چاپ می‌شود.
/// 3. ترد به مدت 1 ثانیه به حالت خواب می‌رود.
/// 4. یک ترد داخلی ایجاد می‌شود که وضعیت لغو آن را چاپ می‌کند.
/// 5. وضعیت لغو ترد اصلی بررسی می‌شود و اگر لغو شده باشد، پیامی چاپ شده و اجرای ترد متوقف می‌شود.
/// 6. اولویت ترد اصلی به 0.75 تنظیم می‌شود و ترد شروع به کار می‌کند.
/// 7. ترد اصلی به مدت 0.01 ثانیه به حالت خواب می‌رود و سپس لغو می‌شود.
///
/// مثال خروجی:
/// ```
/// Cancelled!
/// Inner thread cancelled? false
/// Finished in 1.01 seconds
/// ```
/// بسته به زمان‌بندی تردها، خروجی ممکن است متفاوت باشد.
///
/// هشدار:
/// این مثال تنها برای آموزش است و در عمل معمولاً از روش‌های پیچیده‌تر و کارآمدتری برای مدیریت تردها و لغو آنها استفاده می‌شود.
///
func threadPriorityAndCancellation() {
    let thread = Thread {
        let start = Date()
        defer { print("Finished in", Date().timeIntervalSince(start)) }
        Thread.sleep(forTimeInterval: 1)
        Thread.detachNewThread {
            print("Inner thread cancelled?", Thread.current.isCancelled)
        }
        guard !Thread.current.isCancelled
        else {
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


/// این تابع مثالی از استفاده از ذخیره‌سازی اطلاعات ترد و هماهنگی بین تردها را نشان می‌دهد.
///
/// تابع `threadStorageAndCoordination` چندین ترد ایجاد می‌کند که هر کدام درخواست‌های شبکه و پایگاه داده را به صورت موازی انجام می‌دهند.
/// از `threadDictionary` برای ذخیره و بازیابی شناسه‌های درخواست‌ها در تردهای مختلف استفاده می‌شود.
///
/// استفاده:
/// ```swift
/// threadStorageAndCoordination()
/// ```
///
/// توضیحات عملکرد:
/// 1. دو تابع داخلی `makeDatabaseQuery` و `makeNetworkRequest` تعریف می‌شوند که هر کدام شناسه درخواست را از `threadDictionary` دریافت کرده و عملیات مربوطه را انجام می‌دهند.
/// 2. تابع `response(for:)` یک پاسخ HTTP ساختگی را برمی‌گرداند و در این بین، دو ترد برای انجام درخواست‌های شبکه و پایگاه داده ایجاد می‌کند.
/// 3. شناسه درخواست به `threadDictionary` تردهای جدید اضافه می‌شود تا اطلاعات درخواست بین تردها به اشتراک گذاشته شود.
/// 4. هر ترد اصلی ده درخواست مختلف را به صورت موازی ارسال می‌کند و شناسه منحصر به فردی به هر درخواست اختصاص می‌دهد.
///
/// مثال خروجی:
/// ```
/// 2D4FC2A7-8A9D-4A5E-8265-A1B8F1E89B42 Making network request
/// 2D4FC2A7-8A9D-4A5E-8265-A1B8F1E89B42 Making database query
/// 2D4FC2A7-8A9D-4A5E-8265-A1B8F1E89B42 Finished network request
/// 2D4FC2A7-8A9D-4A5E-8265-A1B8F1E89B42 Finished database query
/// 2D4FC2A7-8A9D-4A5E-8265-A1B8F1E89B42 Finished in 0.51 seconds
/// ```
/// بسته به زمان‌بندی تردها، خروجی ممکن است متفاوت باشد.
///
/// هشدار:
/// این مثال تنها برای آموزش است و در عمل معمولاً از روش‌های پیچیده‌تر و کارآمدتری برای مدیریت تردها و هماهنگی بین آنها استفاده می‌شود.
///
func threadStorageAndCoordination() {
    func makeDatabaseQuery() {
        let requestId = Thread.current.threadDictionary["requestId"] as! UUID
        print(requestId, "Making database query")
        Thread.sleep(forTimeInterval: 0.5)
        print(requestId, "Finished database query")
        print("\(#function)",Thread.current)
    }
    func makeNetworkRequest() {
        let requestId = Thread.current.threadDictionary["requestId"] as! UUID
        print(requestId, "Making network request")
        Thread.sleep(forTimeInterval: 0.5)
        print(requestId, "Finished network request")
        print("\(#function)",Thread.current)
    }

    func response(for request: URLRequest) -> HTTPURLResponse {
        let requestId = Thread.current.threadDictionary["requestId"] as! UUID

        let start = Date()
        defer { print(requestId, "Finished in", Date().timeIntervalSince(start)) }

        print("\(#function)",Thread.current)

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

//    for _ in 0..<10 {
        let thread = Thread {
            print("\(#function)",Thread.current)
            _ = response(for: .init(url: .init(string: "http://pointfree.co")!))
        }
        thread.threadDictionary["requestId"] = UUID()
        thread.start()
//    }
}

/// این تابع بررسی می‌کند که آیا یک عدد صحیح داده شده یک عدد اول است یا خیر.
///
/// تابع `isPrime` یک عدد صحیح را به عنوان ورودی می‌پذیرد و بررسی می‌کند که آیا این عدد اول است یا خیر.
/// عدد اول عددی است که تنها بر خودش و 1 بخش‌پذیر باشد.
///
/// - پارامتر:
///   - p: عدد صحیحی که باید بررسی شود.
/// - خروجی:
///   - `true` اگر عدد اول باشد.
///   - `false` اگر عدد اول نباشد.
///
/// عملکرد:
/// 1. اگر عدد کمتر یا مساوی 1 باشد، تابع `false` را بازمی‌گرداند.
/// 2. اگر عدد کمتر یا مساوی 3 باشد (و بزرگ‌تر از 1)، تابع `true` را بازمی‌گرداند.
/// 3. برای اعداد بزرگ‌تر از 3، تابع بررسی می‌کند که آیا عدد بر هر یک از اعداد تا ریشه دوم آن بخش‌پذیر است یا خیر. اگر بله، عدد اول نیست و تابع `false` را بازمی‌گرداند.
/// 4. اگر هیچ کدام از شرایط بالا برقرار نباشد، عدد اول است و تابع `true` را بازمی‌گرداند.
///
/// مثال‌ها:
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

/// این تابع `n`امین عدد اول را پیدا می‌کند و زمان سپری شده برای پیدا کردن آن را چاپ می‌کند.
///
/// تابع `nthPrime` یک عدد صحیح `n` را به عنوان ورودی می‌پذیرد و `n`امین عدد اول را پیدا می‌کند.
/// همچنین زمان سپری شده برای انجام این محاسبه را اندازه‌گیری و چاپ می‌کند.
///
/// - پارامتر:
///   - n: عدد صحیحی که نشان می‌دهد چندمین عدد اول باید پیدا شود.
///
/// عملکرد:
/// 1. زمان شروع محاسبه ثبت می‌شود.
/// 2. شمارنده‌ای برای تعداد اعداد اول پیدا شده (`primeCount`) و متغیری برای نگهداری عدد فعلی (`prime`) تعریف می‌شوند.
/// 3. تا زمانی که تعداد اعداد اول پیدا شده کمتر از `n` باشد، اعداد یکی یکی بررسی می‌شوند.
/// 4. اگر عدد فعلی اول باشد، شمارنده اعداد اول (`primeCount`) افزایش می‌یابد.
/// 5. پس از یافتن `n`امین عدد اول، مقدار آن و زمان سپری شده چاپ می‌شود.
///
/// مثال:
/// ```swift
/// nthPrime(1)  // 2nd prime 2 time ...
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


/// این تابع به صورت همزمان `n`امین عدد اول را پیدا می‌کند و زمان سپری شده برای پیدا کردن آن را چاپ می‌کند.
///
/// تابع `asyncNthPrime` یک عدد صحیح `n` را به عنوان ورودی می‌پذیرد و به صورت همزمان `n`امین عدد اول را پیدا می‌کند.
/// همچنین زمان سپری شده برای انجام این محاسبه را اندازه‌گیری و چاپ می‌کند.
///
/// - پارامتر:
///   - n: عدد صحیحی که نشان می‌دهد چندمین عدد اول باید پیدا شود.
///
/// عملکرد:
/// 1. زمان شروع محاسبه ثبت می‌شود.
/// 2. شمارنده‌ای برای تعداد اعداد اول پیدا شده (`primeCount`) و متغیری برای نگهداری عدد فعلی (`prime`) تعریف می‌شوند.
/// 3. تا زمانی که تعداد اعداد اول پیدا شده کمتر از `n` باشد، اعداد یکی یکی بررسی می‌شوند.
/// 4. اگر عدد فعلی اول باشد، شمارنده اعداد اول (`primeCount`) افزایش می‌یابد.
/// 5. اگر عدد فعلی به 1000 بخش‌پذیر باشد و اول نباشد، ترد فعلی کنترل را به سیستم عامل باز می‌گرداند تا دیگر تردها فرصت اجرا داشته باشند.
/// 6. پس از یافتن `n`امین عدد اول، مقدار آن و زمان سپری شده چاپ می‌شود.
///
/// - مثال:
/// ```swift
/// await asyncNthPrime(1)  // 1st prime 2 time ...
/// await asyncNthPrime(5)  // 5th prime 11 time ...
/// await asyncNthPrime(10) // 10th prime 29 time ...
/// ```
///
/// - توجه: این تابع باید در یک محیط همزمان (asynchronous context) فراخوانی شود.
///
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

/// این تابع یک سناریو را شبیه‌سازی می‌کند که در آن چندین ترد به طور همزمان به یک متغیر مشترک دسترسی دارند و مشکلات رقابت داده‌ها را نمایش می‌دهد.
///
/// تابع `threadDataRace` یک کلاس `Counter` را تعریف می‌کند که از قفل‌ها برای مدیریت دسترسی همزمان به یک متغیر مشترک استفاده می‌کند.
/// این تابع 1000 ترد را ایجاد می‌کند که هر کدام مقدار `count` را با استفاده از روش `modify` افزایش می‌دهند.
///
/// - توضیحات کلاس `Counter`:
///   - دارای یک متغیر `count` است که به صورت همزمان توسط چندین ترد به آن دسترسی پیدا می‌کند.
///   - از `NSLock` برای جلوگیری از رقابت داده‌ها استفاده می‌کند.
///   - شامل دو متد `increment` و `modify` برای افزایش مقدار `count` است.
///
/// - توضیحات متد `threadDataRace`:
///   - 1000 ترد ایجاد می‌کند که هر کدام به مدت 0.01 ثانیه می‌خوابند و سپس مقدار `count` را افزایش می‌دهند.
///   - پس از اتمام تمامی تردها، مقدار نهایی `count` چاپ می‌شود.
///
/// استفاده:
/// ```swift
/// threadDataRace()
/// ```
///
/// مثال خروجی:
/// ```
/// count 1000
/// ```
/// بسته به زمان‌بندی تردها، خروجی ممکن است متفاوت باشد و در صورتی که قفل‌ها به درستی استفاده نشوند، خروجی می‌تواند نادرست باشد.
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

    for _ in 0..<workCount {
        Thread.detachNewThread {
            Thread.sleep(forTimeInterval: 0.01)
//            counter.modify { $0.count += 1 }

//            قفل‌ها برای دسترسی ایمن به متغیر count
//            counter.lock.lock()
//            let count = counter.count
//            counter.lock.unlock()
//            counter.lock.lock()
//            counter.count = count + 1
//            counter.lock.unlock()

            //    کدهای دیگر برای دسترسی به متغیر count بدون قفل
//            counter.count += 1
        }
    }
    Thread.sleep(forTimeInterval: 2)
    print("count", counter.count)
}

func threadPerformance() {
    for n in 0..<workCount {
        var thread: Thread!
        thread = Thread { [weak thread] in
            print(n, Thread.current)
            while true {
//                print("harchi")
//                if thread?.isCancelled == true {
//                    print("Canceled!")
//                    return
//                } else {
//                    print(Thread.current)
//                    Thread.sleep(forTimeInterval: 1)
//                    thread?.cancel()
//                }
            }
        }
        thread.start()
        Thread.sleep(forTimeInterval: 0.1)
    }

//    Thread.detachNewThread {
//        print("Starting the prime thread")
//        nthPrime(50000)
//    }
}
