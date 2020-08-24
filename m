Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8263C25065B
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 19:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgHXRbv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Aug 2020 13:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgHXQfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:07 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209025] New: The "VFIO_MAP_DMA failed: Cannot allocate memory"
 bug is back
Date:   Mon, 24 Aug 2020 16:35:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-209025-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209025

            Bug ID: 209025
           Summary: The "VFIO_MAP_DMA failed: Cannot allocate memory" bug
                    is back
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.9 rc1 and rc2
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: rmuncrief@humanavance.com
        Regression: No

Created attachment 292143
  --> https://bugzilla.kernel.org/attachment.cgi?id=292143&action=edit
VM Fail Log

My primary Windows 10 VM uses GPU/SATA/USB passthrough and it appears a
regression has been introduced in kernel 5.9. The VM will not start with both
rc1 and rc2 because of the "VFIO_MAP_DMA failed: Cannot allocate memory" error
on all passthrough devices.

I'm running an R7 3700X CPU, ASUS TUF Gaming X570-Plus MB, 16GB PC3200 DDR4,
and two RX 580 GPUs (one dedicated to the VM passthrough). I've attached the
relevant log excerpt to this report.

By the way, the log only shows one device failing because QEMU/KVM exits on the
first error. But I switched around all VM devices so they were the first
encountered and each one failed in the same way, so it's not device related. 

The VM works fantastically with kernels 5.8.3 and 5.4.60.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
