import Foundation

private final class AnyCancellable: Hashable {

    private let cancel: () -> Void

    init(_ cancel: @escaping () -> Void) {
        self.cancel = cancel
    }

    deinit {
        cancel()
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: AnyCancellable, rhs: AnyCancellable) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

extension AnyCancellable {
    func store(_ store: inout Set<AnyCancellable>) {
        store.insert(self)
    }
}

extension Task {
    private func store(_ store: inout Set<AnyCancellable>) {
        store.insert(AnyCancellable(cancel))
    }
}
