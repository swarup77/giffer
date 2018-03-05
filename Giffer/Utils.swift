//
//  Utils.swift
//  Giffer
//
//  Created by Swarup Mahanti on 9/23/17.
//  Copyright © 2017 Swarup Mahanti. All rights reserved.
//

import Foundation

/**
 * debugprint extension that logs file name, line number and function name - based on Objetive C NSDLog
 */

func DEBUGPRINT(_ item: String, _ function: String = #function,_ file: String = #file, _ line: Int = #line) {
    #if DEBUG
        debugPrint("[" + (file as NSString).lastPathComponent + ":" + "\(line)] "  + function + ": " + item)
    #endif
}

