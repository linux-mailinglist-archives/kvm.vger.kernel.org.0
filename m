Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0817233A532
	for <lists+kvm@lfdr.de>; Sun, 14 Mar 2021 15:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhCNOgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 10:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233259AbhCNOfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 10:35:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 12DB564EE5
        for <kvm@vger.kernel.org>; Sun, 14 Mar 2021 14:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615732543;
        bh=mU+pTwrnvwLuUXAHAOyo29EaSN/DCx4dMGVYq2R9pVM=;
        h=From:To:Subject:Date:From;
        b=JgryjocrEpFKbW3BMdF+wizMk9N3dfqSN00hvcBHW9TfVdmIzXWMt9QSCWMO8giy0
         Zv4EMZ1Uc6E3Ha9qBQwJKtJ/OuQMO60SRChBt8f/PoxQe7pjMlLXnL0hOfEJ1gQFGZ
         dX33sFPdp5+q418IecM37z3b5lOPSnRDM72xf+GEr3857bakP2VEP1RtCsk+U2xjId
         B3bY+tO7l9FuTrPYqRq8sUNUtNmKZrymFNUynWIs+0lhaF1A6htDqGBidWGFGmbjSH
         5SoFU/nmHX/QB9TwaaFUEBdhWnqKMhu91fkjzxSt1DgRwsPw2HlCyod8KrpWTZ+ByE
         JfB0h53VKEEdg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 054A5652FD; Sun, 14 Mar 2021 14:35:43 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 212273] New: unchecked MSR access error
Date:   Sun, 14 Mar 2021 14:35:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ionut_n2001@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-212273-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212273

            Bug ID: 212273
           Summary: unchecked MSR access error
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.12.0-rc2
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ionut_n2001@yahoo.com
        Regression: No

[    8.581625] calling  intel_uncore_init+0x0/0x10c @ 1
[    8.582371] unchecked MSR access error: RDMSR from 0x620 at rIP:
0xffffffff8d7abe2b (__rdmsr_on_cpu+0x2b/0x60)
[    8.584572] Call Trace:
[    8.584572]  generic_exec_single+0x4b/0x80
[    8.584572]  smp_call_function_single+0xc4/0x100
[    8.584572]  ? wrmsr_safe_regs_on_cpu+0x40/0x40
[    8.584572]  rdmsrl_on_cpu+0x43/0x60
[    8.584572]  ? rdmsrl_on_cpu+0x43/0x60
[    8.584572]  uncore_read_ratio.isra.6+0x23/0x60
[    8.584572]  uncore_add_die_entry+0xe2/0x140
[    8.584572]  uncore_event_cpu_online+0x43/0x50
[    8.584572]  ? show_min_freq_khz+0x60/0x60
[    8.584572]  cpuhp_invoke_callback+0x80/0x410
[    8.584572]  ? __schedule+0x2b0/0x900
[    8.584572]  ? sort_range+0x20/0x20
[    8.584572]  cpuhp_thread_fun+0xa7/0x110
[    8.584572]  smpboot_thread_fn+0xf7/0x170
[    8.584572]  kthread+0x121/0x140
[    8.584572]  ? kthread_park+0x90/0x90
[    8.584572]  ret_from_fork+0x22/0x30
[    8.603792] initcall intel_uncore_init+0x0/0x10c returned 0 after 20960
usecs

qemu-system-x86_64 -kernel arch/x86_64/boot/bzImage -initrd initrd -nograph=
ic
-append "console=3DttyS0 acpi_rev_override=3D1 acpi_osi=3D! acpi_osi=3D'Win=
dows 2017'
loglevel=3D7 root=3D/dev/ram initcall_debug tsc=3Dreliable no_timer_check
noreplace-smp kvm-intel.nested=3D1 intel_iommu=3Digfx_off cryptomgr.notests
rcupdate.rcu_expedited=3D1 rcu_nocbs=3D0-64 rw nomodeset i915.modeset=3D0 d=
ebug
ignore_loglevel log_buf_len=3D16M no_console_suspend systemd.log_target=3Dn=
ull
systemd.unit=3Drescue.target" -no-reboot -m 3100 -enable-kvm -cpu host -smp
cores=3D2,sockets=3D2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
