Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF8272F63
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 15:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfGXNCL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 24 Jul 2019 09:02:11 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57614 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbfGXNCL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Jul 2019 09:02:11 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0F5EE28848
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 13:02:10 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id F18192886B; Wed, 24 Jul 2019 13:02:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 204293] New: When destroying guests, hypervisor freezes for
 some seconds and get BUG: soft lockup - CPU* stuck for Xs
Date:   Wed, 24 Jul 2019 13:02:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hilld@binarystorm.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-204293-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=204293

            Bug ID: 204293
           Summary: When destroying guests, hypervisor freezes for some
                    seconds and get BUG: soft lockup - CPU* stuck for Xs
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.2.0
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: hilld@binarystorm.net
        Regression: No

When destroying guests, hypervisor freezes for some seconds and get BUG: soft
lockup - CPU* stuck for Xs:

[root@zappa ~]# virsh list | grep runn | awk '{ print $1 }' | xargs -I% virsh
destroy %

Message from syslogd@zappa at Jul 24 08:56:34 ...
 kernel:[5519315.215069] watchdog: BUG: soft lockup - CPU#4 stuck for 22s!
[worker:2540]

Message from syslogd@zappa at Jul 24 08:56:34 ...
 kernel:watchdog: BUG: soft lockup - CPU#4 stuck for 22s! [worker:2540]
error: Disconnected from qemu:///system due to keepalive timeout
error: Failed to destroy domain 43
error: internal error: connection closed due to keepalive timeout


Message from syslogd@zappa at Jul 24 08:57:10 ...
 kernel:[5519351.240533] watchdog: BUG: soft lockup - CPU#12 stuck for 22s!
[worker:2540]

Message from syslogd@zappa at Jul 24 08:57:10 ...
 kernel:watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [worker:2540]
error: Failed to destroy domain 44
error: Failed to terminate process 19480 with SIGKILL: Device or resource busy

Domain 45 destroyed

Domain 46 destroyed

Domain 47 destroyed

Domain 48 destroyed


Message from syslogd@zappa at Jul 24 08:58:06 ...
 kernel:[5519407.261656] watchdog: BUG: soft lockup - CPU#21 stuck for 22s!
[worker:8228]

Message from syslogd@zappa at Jul 24 08:58:06 ...
 kernel:watchdog: BUG: soft lockup - CPU#21 stuck for 22s! [worker:8228]
error: Disconnected from qemu:///system due to keepalive timeout
error: Failed to destroy domain 49
error: internal error: connection closed due to keepalive timeout


Message from syslogd@zappa at Jul 24 08:59:02 ...
 kernel:[5519463.135812] watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
[worker:8190]

Message from syslogd@zappa at Jul 24 08:59:02 ...
 kernel:watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [worker:8190]
error: Disconnected from qemu:///system due to keepalive timeout
error: Failed to destroy domain 50
error: internal error: connection closed due to keepalive timeout

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
