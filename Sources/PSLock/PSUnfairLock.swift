import Foundation

@available(iOS 13, *)
final public class PSUnfairLock {
  
  private var _lock = os_unfair_lock()
  
  public func lock() { os_unfair_lock_lock(&_lock) }
  
  public func unlock() { os_unfair_lock_unlock(&_lock) }
}
