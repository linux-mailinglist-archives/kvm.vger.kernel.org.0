Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BA71D01C9
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 00:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgELWUx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 12 May 2020 18:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgELWUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 18:20:53 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207707] New: USB pass through to qemu/kvm causes CDROM reset
 and "device not configured"
Date:   Tue, 12 May 2020 22:20:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: steffen@sdaoden.eu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-207707-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207707

            Bug ID: 207707
           Summary: USB pass through to qemu/kvm causes CDROM reset and
                    "device not configured"
           Product: Virtualization
           Version: unspecified
    Kernel Version: 4.19.121
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: steffen@sdaoden.eu
        Regression: No

Hello.
I update my 4.19 kernel each Saturday.
In March i wrote a C program that accesses CDDA data (toc, CD-TEXT, etc), and
ported it to *BSD via qemu/kvm via USB pass through (i could).  I updated the
binary (s-cdda) last on March 16th.

Now, two weeks ago i wanted to pass through the USB CD-ROM again, and it did
not work no more with error as below.  This was directly after updating to qemu
5.0.0, so i reinstalled 4.2.0, with which i did the above, but it did no longer
work, too.
This is CRUX-Linux 3.5, and libusb has not changed. The only thing that really
changed otherwise is the kernel, i would say.

I used this USB CD-ROM:

May 11 22:25:32 kent kernel: usb 1-1: new high-speed USB device number 5 using
xhci_hcd
May 11 22:25:32 kent kernel: usb 1-1: New USB device found, idVendor=0e8d,
idProduct=1806, bcdDevice= 0.00
May 11 22:25:32 kent kernel: usb 1-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
May 11 22:25:32 kent kernel: usb 1-1: Product: MT1887
May 11 22:25:32 kent kernel: usb 1-1: Manufacturer: MediaTek Inc
May 11 22:25:32 kent kernel: usb 1-1: SerialNumber: S16D6YMG2003AB
May 11 22:25:32 kent kernel: usb-storage 1-1:1.0: USB Mass Storage device
detected
May 11 22:25:32 kent kernel: scsi host0: usb-storage 1-1:1.0
May 11 22:25:33 kent kernel: scsi 0:0:0:0: CD-ROM            TSSTcorp CDDVDW
SE-218GN  TS00 PQ: 0 ANSI: 0
May 11 22:25:33 kent kernel: sr 0:0:0:0: Power-on or device reset occurred
May 11 22:25:33 kent kernel: sr 0:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer
dvd-ram cd/rw xa/form2 cdda tray
May 11 22:25:33 kent kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
May 11 22:25:33 kent kernel: sr 0:0:0:0: Attached scsi CD-ROM sr0
May 11 22:25:33 kent kernel: sr 0:0:0:0: Attached scsi generic sg0 type 5

And it works.  I start qemu, the device disappears on the host, the guest OS
detects it during boot, and this causes a "reset":

May 11 22:27:31 kent kernel: usb 1-1: reset high-speed USB device number 5
using xhci_hcd

After which the device is still not back in the host, and also inaccessible in
the guest (FreeBSD says "device not configured" when i try to access it).

Is this right here, or should i open an USB bug?
Happy to help or test, thank you!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
