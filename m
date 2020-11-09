Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFAC2AB5A1
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 11:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgKIK72 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 9 Nov 2020 05:59:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgKIK72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 05:59:28 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209867] CPU soft lockup/stall with nested KVM and SMP
Date:   Mon, 09 Nov 2020 10:59:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: frantisek@sumsal.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-209867-28872-ieYd39Vshs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209867-28872@https.bugzilla.kernel.org/>
References: <bug-209867-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209867

Frantisek Sumsal (frantisek@sumsal.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|5.9.3-arch1-1               |5.9.6-arch1-1

--- Comment #4 from Frantisek Sumsal (frantisek@sumsal.cz) ---
Results with kernel 5.9.6:

[    4.353614] PCI: Using configuration type 1 for extended access
[    4.361708] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    4.363625] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[   64.373614] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[   64.376918] rcu:     3-...0: (0 ticks this GP) idle=95a/1/0x4000000000000000
softirq=18/18 fqs=6000 last_accelerate: 0000/e77e dyntick_enabled: 0
[   64.376918]  (detected by 0, t=18002 jiffies, g=-1123, q=62)
[   64.376918] Sending NMI from CPU 0 to CPUs 3:
[  244.390281] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  244.393584] rcu:     3-...0: (0 ticks this GP) idle=95a/1/0x4000000000000000
softirq=18/18 fqs=24002 last_accelerate: 0000/ba73 dyntick_enabled: 0
[  244.393584]  (detected by 0, t=72007 jiffies, g=-1123, q=62)
[  244.393584] Sending NMI from CPU 0 to CPUs 3:
[  424.406947] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  424.410251] rcu:     3-...0: (0 ticks this GP) idle=95a/1/0x4000000000000000
softirq=18/18 fqs=42004 last_accelerate: 0000/8d68 dyntick_enabled: 0
[  424.410251]  (detected by 0, t=126012 jiffies, g=-1123, q=62)
[  424.410251] Sending NMI from CPU 0 to CPUs 3:
qemu-system-x86_64: terminating on signal 15 from pid 31982 (timeout)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
