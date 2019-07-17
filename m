Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50ED16BE32
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 16:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfGQO1F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 17 Jul 2019 10:27:05 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60792 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbfGQO1E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jul 2019 10:27:04 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DBDE328419
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2019 14:27:03 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id DA32328745; Wed, 17 Jul 2019 14:27:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 204209] New: kernel 5.2.1: "floating point exception" in qemu
 with kvm enabled
Date:   Wed, 17 Jul 2019 14:27:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: antdev66@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-204209-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204209

            Bug ID: 204209
           Summary: kernel 5.2.1: "floating point exception" in qemu with
                    kvm enabled
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.2.1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: antdev66@gmail.com
        Regression: No

After updating the kernel from 5.1.17 to 5.2.1, when I use the g++ compiler in
qemu with kvm enabled, often the compiler launched in the guest for compile my
sources ends with this error: "exception in floating point".

Moreever it is not possible to update the bsd system because the process (that
use g++ compiler) exits with the same error.

Same thing for some system utilities, like "pkg update".

But if I boot the system with the previous 5.1.17 kernel and launch qemu, as
indicated above, everything works fine and I don't detect errors.

Command line is:

/usr/bin/qemu-system-x86_64 -k it -machine accel=kvm -m 4096 -no-fd-bootchk
-show-cursor -drive file="vmdragon.img",if=ide,media=disk -boot once=c,menu=off
-net none -rtc base=localtime -name "vmdragon" -smp 8 -vga std -device
qemu-xhci,id=xhci

I can't test without kvm because the process is very slow, but I think the
problem could be in some changes made to the kvm module.

Thanks,
Antonio

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
