Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C524D16C84
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 22:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfEGUpr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 May 2019 16:45:47 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53866 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbfEGUpr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 May 2019 16:45:47 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 13ACB28675
        for <kvm@vger.kernel.org>; Tue,  7 May 2019 20:45:46 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 0851028985; Tue,  7 May 2019 20:45:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203543] New: Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Date:   Tue, 07 May 2019 20:45:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: hilld@binarystorm.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-203543-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203543

            Bug ID: 203543
           Summary: Starting with kernel 5.1.0-rc6,  kvm_intel can no
                    longer be loaded in nested kvm/guests
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.1.0-rc6
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: hilld@binarystorm.net
        Regression: No

1. Please describe the problem:
Starting with kernel 5.1.0-rc6,  kvm_intel can no longer be loaded in nested
kvm/guests

[root@undercloud-0-rhosp10 ~]# modprobe kvm_intel
modprobe: ERROR: could not insert 'kvm_intel': Input/output error


2. What is the Version-Release number of the kernel:
5.1.0-rc7

3. Did it work previously in Fedora? If so, what kernel version did the issue
   *first* appear?  Old kernels are available for download at
   https://koji.fedoraproject.org/koji/packageinfo?packageID=8 :
Yes it seems to have appearded between 5.1.0-rc4 (it worked) and 5.1.0-rc6 (it
no longer worked)

4. Can you reproduce this issue? If so, please provide the steps to reproduce
   the issue below:
Yes, update to 5.1.0-rc6 and try to modprobe kvm_intel inside a guest where the
VMX capabilities has been exposted


5. Does this problem occur with the latest Rawhide kernel? To install the
   Rawhide kernel, run ``sudo dnf install fedora-repos-rawhide`` followed by
   ``sudo dnf update --enablerepo=rawhide kernel``:
Yes


6. Are you running any modules that not shipped with directly Fedora's kernel?:
No

7. Please attach the kernel logs. You can get the complete kernel log
   for a boot with ``journalctl --no-hostname -k > dmesg.txt``. If the
   issue occurred on a previous boot, use the journalctl ``-b`` flag.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
