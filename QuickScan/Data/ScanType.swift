//
//  File.swift
//  QuickScan
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import AVFoundation
import Foundation

protocol ScanType {
    var supportedCodeTypes: [AVMetadataObject.ObjectType] { get }
}

extension ScanType {
    var supportedCodeTypes: [AVMetadataObject.ObjectType] {
        return [AVMetadataObject.ObjectType.upce,
                AVMetadataObject.ObjectType.code39,
                AVMetadataObject.ObjectType.code39Mod43,
                AVMetadataObject.ObjectType.code93,
                AVMetadataObject.ObjectType.code128,
                AVMetadataObject.ObjectType.ean8,
                AVMetadataObject.ObjectType.ean13,
                AVMetadataObject.ObjectType.aztec,
                AVMetadataObject.ObjectType.pdf417,
                AVMetadataObject.ObjectType.itf14,
                AVMetadataObject.ObjectType.dataMatrix,
                AVMetadataObject.ObjectType.interleaved2of5,
                AVMetadataObject.ObjectType.qr]
    }
}
