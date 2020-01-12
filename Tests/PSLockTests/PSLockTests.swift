import XCTest
@testable import PSLock

final class PSLockTests: XCTestCase {
  
  private var lock: PSUnfairLock!
  
  
  override func setUp() {
    super.setUp()
    lock = PSUnfairLock()
  }
  
  func testLockUnlock() {
    executeLockTest { (block) in
      self.lock.lock()
      block()
      self.lock.unlock()
    }
  }
  
  func testSync() {
    executeLockTest { (block) in
      self.lock.sync { block() }
    }
  }
  
  func testLocked() {
    lock.lock()
    XCTAssertFalse(lock.locked())
    lock.unlock()
    XCTAssertTrue(lock.locked())
    lock.unlock()
  }
  
  func testTrySync() {
    lock.lock()
    XCTAssertNil(lock.trySync({}))
    lock.unlock()
    XCTAssertNotNil(lock.trySync({}))
  }
  
  func testPrecondition() {
    self.lock.lock()
    self.lock.precondition(condition: .onThreadOwner)
    self.lock.unlock()
    self.lock.precondition(condition: .notOnThreadOwner)
  }
  
  override func tearDown() {
    lock = nil
    super.tearDown()
  }
}

private extension PSLockTests {
  
  func executeLockTest(performBlock: @escaping (_ block: () -> Void) -> Void) {
    let dispatchBlockCount = 16
    let iterationCountPerBlock = 100_000
    let queues: [DispatchQueue] = [
      .global(qos: .userInteractive),
      .global(),
      .global(qos: .utility),
    ]
    var value = 0
    
    
    let group = DispatchGroup()
    
    for block in 0..<dispatchBlockCount {
      group.enter()
      let queue = queues[block % queues.count]
      queue.async {
        for _ in 0..<iterationCountPerBlock {
          performBlock {
            value += 2
            value -= 1
          }
        }
        group.leave()
      }
    }
    
    _ = group.wait(timeout: .distantFuture)
    
    
    XCTAssert(value == dispatchBlockCount * iterationCountPerBlock)
  }
}

extension {
  
  static var allTests = [
    ("testUnfairLock", testLockUnlock),
    ("testSync", testSync),
    ("testLocked", testLocked),
    ("testTrySync", testTrySync),
    ("testPrecondition", testPrecondition),
  ]
}
