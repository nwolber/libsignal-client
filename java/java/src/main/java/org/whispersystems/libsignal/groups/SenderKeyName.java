/**
 * Copyright (C) 2014-2016 Open Whisper Systems
 *
 * Licensed according to the LICENSE file in this repository.
 */
package org.whispersystems.libsignal.groups;

import org.signal.client.internal.Native;
import org.whispersystems.libsignal.SignalProtocolAddress;

/**
 * A representation of a (senderKeyId + senderName + deviceId) tuple.
 */
public class SenderKeyName {
  private long handle;

  public SenderKeyName(String senderKeyId, SignalProtocolAddress sender) {
    this.handle = Native.SenderKeyName_New(senderKeyId, sender.getName(), sender.getDeviceId());
  }

  public SenderKeyName(String senderKeyId, String senderName, int senderDeviceId) {
    this.handle = Native.SenderKeyName_New(senderKeyId, senderName, senderDeviceId);
  }

  @Override
  protected void finalize() {
    Native.SenderKeyName_Destroy(this.handle);
  }

  public String getId() {
    return Native.SenderKeyName_GetId(this.handle);
  }

  /** @deprecated Renamed to {@link #getId}. */
  @Deprecated
  public String getGroupId() {
    return Native.SenderKeyName_GetId(this.handle);
  }

  public SignalProtocolAddress getSender() {
    return new SignalProtocolAddress(Native.SenderKeyName_GetSenderName(this.handle), Native.SenderKeyName_GetSenderDeviceId(this.handle));
  }

  @Override
  public boolean equals(Object other) {
    if (other == null)                     return false;
    if (!(other instanceof SenderKeyName)) return false;

    SenderKeyName that = (SenderKeyName)other;

    return
       this.getId().equals(that.getId()) &&
       this.getSender().equals(that.getSender());
  }

  @Override
  public int hashCode() {
    return this.getId().hashCode() ^ this.getSender().hashCode();
  }

  public long nativeHandle() {
    return this.handle;
  }

}
