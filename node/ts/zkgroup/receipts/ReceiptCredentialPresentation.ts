//
// Copyright 2021 Signal Messenger, LLC.
// SPDX-License-Identifier: AGPL-3.0-only
//

import ByteArray from '../internal/ByteArray';
import * as Native from '../../../Native';
import ReceiptSerial from './ReceiptSerial';

export default class ReceiptCredentialPresentation extends ByteArray {
  static SIZE = 329;

  constructor(contents: Buffer) {
    super(contents, Native.ReceiptCredentialPresentation_CheckValidContents);
  }

  getReceiptExpirationTime(): bigint {
    return Native.ReceiptCredentialPresentation_GetReceiptExpirationTime(
      this.contents
    ).readBigUInt64BE();
  }

  getReceiptLevel(): bigint {
    return Native.ReceiptCredentialPresentation_GetReceiptLevel(
      this.contents
    ).readBigUInt64BE();
  }

  getReceiptSerialBytes(): ReceiptSerial {
    return new ReceiptSerial(
      Native.ReceiptCredentialPresentation_GetReceiptSerial(this.contents)
    );
  }
}
