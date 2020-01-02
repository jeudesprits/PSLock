import Foundation

open class PSUnfairLock {
  
  private var _lock = os_unfair_lock()
  
  public init() { }
}

public extension PSUnfairLock {
  
  final func lock() { os_unfair_lock_lock(&_lock) }
  
  final func unlock() { os_unfair_lock_unlock(&_lock) }
}
