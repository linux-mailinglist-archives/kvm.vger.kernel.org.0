Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B647519E4B4
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 13:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgDDLic convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 4 Apr 2020 07:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgDDLic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 07:38:32 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207099] New: VM fails to boot with invariant tsc enabled with
 kvm_amd
Date:   Sat, 04 Apr 2020 11:38:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: geggen54@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-207099-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207099

            Bug ID: 207099
           Summary: VM fails to boot with invariant tsc enabled with
                    kvm_amd
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.6.0 - 5.6.2
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: geggen54@gmail.com
        Regression: No

After the 5.6.0 release my windows 10 VM running on AMD 3950x fails to boot
when option "migratable=no,+invtsc" is enabled. The VM starts the boot process
but after a few seconds I get a bluescreen with the error "Kernel security
check failed". 

Neither the host or guest has any logs that I can find with any more details on
the issue, or even that it happens at all.

The issue is reproducible at least for me with a minimum set of options in QEMU
with no enlightenments:

"-M type=q35,accel=kvm,kernel_irqchip=on -cpu host, kvm=off,
migratable=no,+invtsc, topoext -smp 24,sockets=1, cores=12, threads=2
-enable-kvm"

I've tried changing the options kvm_amd.avic and nested to no avail.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
