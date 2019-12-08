Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668F31162C9
	for <lists+kvm@lfdr.de>; Sun,  8 Dec 2019 16:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfLHP1L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 8 Dec 2019 10:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbfLHP1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Dec 2019 10:27:11 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205801] New: ignore_msrs =Y and report_ignored_msrs = N not
 working
Date:   Sun, 08 Dec 2019 15:27:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: harliff@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-205801-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205801

            Bug ID: 205801
           Summary: ignore_msrs =Y and report_ignored_msrs = N not working
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.0.15-1-pve (from proxmox)
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: harliff@gmail.com
        Regression: No

There is a VM (windows 2016) which constantly generating more than 10 messages
every second like this:
```
kvm [35691]: vcpu1, guest rIP: 0xfffff800c9fedbb3 kvm_set_msr_common:
MSR_IA32_DEBUGCTLMSR 0x1, nop
```

I can't prevent the VM from generating these MSRs due to proprietary software
running inside it (maybe its due to some kind of software protection, but I'm
not sure). So I wish to be able to disable this messages on KVM level or filter
messages from getting to the kernel ring buffer (shown by dmesg). 

I've tried to set kvm module parameters -- without success:
- echo Y > /sys/module/kvm/parameters/ignore_msrs
- echo N > /sys/module/kvm/parameters/report_ignored_msrs

Is it due to a bug or I'm misunderstanding whats these parameters should do?

May you suggest me a workaround (to prevent these messages from getting shown
on console/via dmesg/via journalctl -k)?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
