//
//  YHTMainThreadBlock.swift
//  TYHMainThreadBlock
//
//  Created by pencilCool on 2019/5/21.
//  Copyright © 2019 pencilCool. All rights reserved.
//

import Foundation
class TYHMainThreadBlock {
    static let shared = TYHMainThreadBlock()
    var semaphore:DispatchSemaphore!
    var runLoopObserver:CFRunLoopObserver!
    
    func beginMonitor() {
        let unmanaged = Unmanaged.passRetained(self)
        let uptr = unmanaged.toOpaque()
        let vptr = UnsafeMutableRawPointer(uptr)
    
        semaphore =  DispatchSemaphore(value: 0)
        var context = CFRunLoopObserverContext()
        context.version = 0
        context.info = vptr

        runLoopObserver = CFRunLoopObserverCreate(nil, CFRunLoopActivity.beforeTimers.rawValue, true, 0, {
            (observer ,activety,info) in
            
        }, &context)
        
        CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, CFRunLoopMode.commonModes)
    }
    
    func callBackObserver() -> CFRunLoopObserverCallBack {
        return {
            (observer ,activiy,context) in
            
        }
    }
    
}
