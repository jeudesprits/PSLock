import Foundation

@available(OSX 10.12, *)
final class PSUnfairLock {
  
  private var _lock = os_unfair_lock()
  
  func lock() { os_unfair_lock_lock(&_lock) }
  
  func unlock() { os_unfair_lock_unlock(&_lock) }
}
