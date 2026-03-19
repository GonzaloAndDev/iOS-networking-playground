//
//  DebugLog.swift
//  iOSNetworkingPlayground
//
//  Created by Gonzalo Andrade Estrella on 18/03/26.
//

import Foundation

enum DebugLog {
    static func message(_ value: @autoclosure () -> String) {
        #if DEBUG
            print(value())
        #endif
    }
    
    static func object(_ value: @autoclosure () -> Any) {
        #if DEBUG
            debugPrint(value())
        #endif
    }
}
