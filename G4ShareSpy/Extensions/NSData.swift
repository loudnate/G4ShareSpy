//
//  NSData.swift
//  Naterade
//
//  Created by Nathan Racklyeft on 9/2/15.
//  Copyright © 2015 Nathan Racklyeft. All rights reserved.
//

import Foundation


public extension Data {
    @nonobjc subscript(range: Range<Int>) -> UInt16 {
        subdata(in: range).toInt()
    }

    @nonobjc subscript(range: Range<Int>) -> UInt32 {
        subdata(in: range).toInt()
    }
}

extension Data {
    private func toDefaultEndian<T: FixedWidthInteger>(_: T.Type) -> T {
        return self.withUnsafeBytes({ (rawBufferPointer: UnsafeRawBufferPointer) -> T in
            let bufferPointer = rawBufferPointer.bindMemory(to: T.self)
            guard let pointer = bufferPointer.baseAddress else {
                return 0
            }
            return T(pointer.pointee)
        })
    }

    func to<T: FixedWidthInteger>(_ type: T.Type) -> T {
        return T(littleEndian: toDefaultEndian(type))
    }

    func toInt<T: FixedWidthInteger>() -> T {
        return to(T.self)
    }

    func toBigEndian<T: FixedWidthInteger>(_ type: T.Type) -> T {
        return T(bigEndian: toDefaultEndian(type))
    }

    mutating func append<T: FixedWidthInteger>(_ newElement: T) {
        var element = newElement.littleEndian
        append(Data(bytes: &element, count: element.bitWidth / 8))
    }

    mutating func appendBigEndian<T: FixedWidthInteger>(_ newElement: T) {
        var element = newElement.bigEndian
        append(Data(bytes: &element, count: element.bitWidth / 8))
    }

    init<T: FixedWidthInteger>(_ value: T) {
        var value = value.littleEndian
        self.init(bytes: &value, count: value.bitWidth / 8)
    }

    init<T: FixedWidthInteger>(bigEndian value: T) {
        var value = value.bigEndian
        self.init(bytes: &value, count: value.bitWidth / 8)
    }
}
