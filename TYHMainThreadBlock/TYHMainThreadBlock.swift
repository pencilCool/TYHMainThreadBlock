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

        runLoopObserver = CFRunLoopObserverCreate(nil, CFRunLoopActivity.beforeTimers.rawValue, true, 0, {
            (observer ,activity,context) in
            let weakSelf = Unmanaged<TYHMainThreadBlock>.fromOpaque(context!).takeUnretainedValue()
            weakSelf.runLoopActivity = activity
            weakSelf.semaphore.signal()
            
        },&context)
        
        CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, CFRunLoopMode.commonModes)
        
        DispatchQueue.global().async {
            switch self.semaphore.wait(timeout: 3) {
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
