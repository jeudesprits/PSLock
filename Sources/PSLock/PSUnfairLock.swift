import Foundation

public final class PSUnfairLock {
  
  private var _lock: UnsafeMutablePointer<os_unfair_lock>
  
  public init() {
    _lock = .allocate(capacity: 1)
    _lock.initialize(to: os_unfair_lock())
  }
  
  deinit {
    _lock.deallocate()
  }
}

public extension PSUnfairLock {
  
  func lock() { os_unfair_lock_lock(_lock) }
  
  func unlock() { os_unfair_lock_unlock(_lock) }
}

public extension PSUnfairLock {
  
  func locked() -> Bool { os_unfair_lock_trylock(_lock) }
}

public extension PSUnfairLock {
  
  func trySync<R>(_ block: () throws -> R) rethrows -> R? {
    guard locked() else  { return nil }
    defer { unlock() }
    return try block()
  }
  
  func sync<R>(_ block: () throws -> R) rethrows -> R {
    lock()
    defer { unlock() }
    return try block()
  }
}

public extension PSUnfairLock {
  
  enum Predicate {
    
    case threadOwned
    case threadNotOwned
  }
}

public extension PSUnfairLock {
  
  func precondition(condition: Predicate) {
    if condition == .threadOwned {
      os_unfair_lock_assert_owner(_lock)
    } else {
      os_unfair_lock_assert_not_owner(_lock)
    }
  }
}
