//
//  YHTMainThreadBlock.swift
//  TYHMainThreadBlock
//
//  Created by pencilCool on 2019/5/21.
//  Copyright © 2019 pencilCool. All rights reserved.
//

import Foundation

extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}


class TYHMainThreadBlock {
    static let shared = TYHMainThreadBlock()
    var semaphore:DispatchSemaphore!
    var runLoopObserver:CFRunLoopObserver!
    var runLoopActivity:CFRunLoopActivity!
    
    func beginMonitor() {
        
        let unmanaged = Unmanaged.passRetained(self)
        let uptr = unmanaged.toOpaque()
        let vptr = UnsafeMutableRawPointer(uptr)
        
        semaphore =  DispatchSemaphore(value: 0)
        var context = CFRunLoopObserverContext()
        context.version = 0
        context.info = vptr

        runLoopObserver = CFRunLoopObserverCreate(nil, CFRunLoopActivity.beforeTimers.rawValue, true, 0,callBackObserve(),&context)
        
        CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, CFRunLoopMode.commonModes)
        
        let queue = DispatchQueue.global()
        queue.async {
            while true {
                switch self.semaphore.wait(timeout: 0.03) {
                case .timedOut:
                    guard let _ = self.runLoopObserver else {
                        return
                    }
                    
                    if  self.runLoopActivity == .beforeSources ||
                        self.runLoopActivity == .afterWaiting {
                        print("monitor trigger")
                    }
                    
                    print("timeout")
                case .success:
                    print("success")
                }
            }
           
        }
    }

    func removeRunloopObserver(){
        if runLoopObserver == nil {
            return
        }
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), runLoopObserver, CFRunLoopMode.commonModes)
    }
    
    private func callBackObserve() -> CFRunLoopObserverCallBack {
        return{ (observer, activity, context) in
            let weakSelf = Unmanaged<TYHMainThreadBlock>.fromOpaque(context!).takeUnretainedValue()
            weakSelf.runLoopActivity = activity
            weakSelf.semaphore.signal()
        }
    }
}
