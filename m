Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930CA2712E9
	for <lists+kvm@lfdr.de>; Sun, 20 Sep 2020 10:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgITIhR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 20 Sep 2020 04:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbgITIhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Sep 2020 04:37:16 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209333] New: VM not starting anymore with 5.8.8 - lots of page
 faults
Date:   Sun, 20 Sep 2020 08:37:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel@martin.schrodt.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-209333-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209333

            Bug ID: 209333
           Summary: VM not starting anymore with 5.8.8 - lots of page
                    faults
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.8.8
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: kernel@martin.schrodt.org
        Regression: No

Host system is a Threadripper 1920x on a X399 Motherboard.
I have a VM here, that I pass through a Samsung 960 EVO SSD. 

> 08:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD
> Controller SM961/PM961

The VM starts up and works fine with Kernel 5.8.7, and when I start the VM with
a 5.8.8 kernel, libvirt/QEMU say the VM is started, but it doesn't come up, and
I see lots and lots of these in dmesg:

> AMD-Vi: Event logged [IO_PAGE_FAULT device=08:00.0 domain=0x002c
> address=0xfffffffdf8000000 flags=0x0008]

Now, one thing to mention is that the VM uses AMD AVIC to directly deliver
interrupts to the VM.

There are 2 IOMMU related changes in the 5.8.8 changelog that seem likely for
the layman that I am, both by Suravee Suthikulpanit from AMD:

iommu/amd: Use cmpxchg_double() when updating 128-bit IRTE
iommu/amd: Restore IRTE.RemapEn bit after programming IRTE

I observe the same behaviour with 5.8.10.

Happy to provide more info if needed!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
