//
// Copyright 2020 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import SignalFfi

public class SenderKeyName: ClonableHandleOwner {
    internal override class func destroyNativeHandle(_ handle: OpaquePointer) -> SignalFfiErrorRef? {
        return signal_sender_key_name_destroy(handle)
    }

    internal override class func cloneNativeHandle(_ newHandle: inout OpaquePointer?, currentHandle: OpaquePointer?) -> SignalFfiErrorRef? {
        return signal_sender_key_name_clone(&newHandle, currentHandle)
    }

    public init(id: String, senderName: String, deviceId: UInt32) throws {
        var handle: OpaquePointer?
        try checkError(signal_sender_key_name_new(&handle, id, senderName, deviceId))
        super.init(owned: handle!)
    }

    public convenience init(id: String, sender: ProtocolAddress) throws {
        try self.init(id: id, senderName: sender.name, deviceId: sender.deviceId)
    }

    internal override init(owned handle: OpaquePointer) {
        super.init(owned: handle)
    }

    internal override init(borrowing handle: OpaquePointer?) {
        super.init(borrowing: handle)
    }

    public var id: String {
        return failOnError {
            try invokeFnReturningString {
                signal_sender_key_name_get_id($0, nativeHandle)
            }
        }
    }

    public var senderName: String {
        return failOnError {
            try invokeFnReturningString {
                signal_sender_key_name_get_sender_name($0, nativeHandle)
            }
        }
    }

    public var senderDeviceId: UInt32 {
        return failOnError {
            try invokeFnReturningInteger {
                signal_sender_key_name_get_sender_device_id($0, nativeHandle)
            }
        }
    }
}

extension SenderKeyName: Hashable {
    public static func == (lhs: SenderKeyName, rhs: SenderKeyName) -> Bool {
        if lhs.senderDeviceId != rhs.senderDeviceId {
            return false
        }

        if lhs.senderName != rhs.senderName {
            return false
        }

        return lhs.id == rhs.id

    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.senderDeviceId)
        hasher.combine(self.senderName)
        hasher.combine(self.id)
    }
}
