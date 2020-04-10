//
//  SendData.swift
//  QuickScan
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import Foundation

protocol SendDataDelegate {
    var basicParams: [String:String] { get }
    func sendData(_ value: String)
}

extension SendDataDelegate {
    var basicParams: [String:String] {
        var dic: [String:String] = [:]
        dic["name"] = "Brandon"
        dic["phone"] = "010-7890-7890"
        
        return dic
    }
}
