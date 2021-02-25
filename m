Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51013254F5
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 18:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhBYR4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 12:56:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233225AbhBYRzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 12:55:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7FA8664F4C
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614275695;
        bh=ojrG93Ubm1gwCz0IAQjt9qjyzj9quLdrQTHb1EVLiQ8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PW7pBMxE+7CLrQoGPQg3Izal3iHTAfFJbEYYYTG7Djo57NyAO6HtbiHB4+h9vNBni
         ZR3xpN61ZH0NUwICeNaSWZBh9o2MpegWmTPFprb9lKObmtH5YUmTI+L/0qtG3yCRYa
         JwM2g30t7DeRE/bBRuHnzT0NjZ3yRl3hzWfzrkyTqZHS7GoWN8yALUeegLDJpL7Egb
         cl98yxe6j8Ee1rPA4t26Zyzvy01Ow/3K4cnyCc2IZB8DPqwFydzWD163xn8K7GBf3+
         7aAWLFeIFdR1iaiaoq+mkeABIi2HzVstZJu7irkVVsjxUeB/us8/c/4u3jzYH9zQbH
         b11iJ3KFgeZow==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 79B0D65382; Thu, 25 Feb 2021 17:54:55 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Thu, 25 Feb 2021 17:54:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david.coe@live.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-201753-28872-DwGO5ZYCQU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201753-28872@https.bugzilla.kernel.org/>
References: <bug-201753-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201753

David Coe (david.coe@live.co.uk) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |david.coe@live.co.uk

--- Comment #10 from David Coe (david.coe@live.co.uk) ---
Hi Suravee!=20

This bug has been bothering Ryzen users for some while now and work-arounds
adding various linux boot parameters have had patchy success. It's good to =
see
an informed and more forensic approach. Bravo!

I've been exercising your RFCv3 patch over the last few days (AMD Ryzen 5
2400G, Asus Prime B350-Plus, Ubuntu 20.10, Linux 5.8.0-43). With the origin=
al
20 msec delay I still get:

[    0.703538] Trying to unpack rootfs image as initramfs...
[    0.859160] Freeing initrd memory: 83748K
[    0.859256] pci 0000:00:00.2: AMD-Vi: Unable to read/write to IOMMU perf
counter.
[    0.859265] fbcon: Taking over console
[    0.859367] pci 0000:00:00.2: can't derive routing for PCI INT A
[    0.859368] pci 0000:00:00.2: PCI INT A: not connected
[    0.859413] pci 0000:00:01.0: Adding to iommu group 0
                                                      ...
                                                      ...
[    0.859959] pci 0000:0b:00.0: Adding to iommu group 12
[    0.863140] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.863142] pci 0000:00:00.2: AMD-Vi: Extended features (0x4f77ef22294ad=
a):
[    0.863143]  PPR NX GT IA GA PC GA_vAPIC
[    0.863144] AMD-Vi: Interrupt remapping enabled
[    0.863145] AMD-Vi: Virtual APIC enabled
[    0.863375] AMD-Vi: Lazy IO/TLB flushing enabled
[    0.864261] amd_uncore: AMD NB counters detected
[    0.864273] amd_uncore: AMD LLC counters detected
[    0.864696] check: Scanning for low memory corruption every 60 seconds

Increasing the delay to msleep(40) gives:

[    0.212761] Trying to unpack rootfs image as initramfs...
[    0.366407] Freeing initrd memory: 83304K
[    0.509105] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters support=
ed
[    0.509199] pci 0000:00:00.2: can't derive routing for PCI INT A
[    0.509200] pci 0000:00:00.2: PCI INT A: not connected
[    0.509244] pci 0000:00:01.0: Adding to iommu group 0
                                                      ...
                                                      ...
[    0.509802] pci 0000:0b:00.0: Adding to iommu group 12
[    0.512997] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.512999] pci 0000:00:00.2: AMD-Vi: Extended features (0x4f77ef22294ad=
a):
[    0.512999]  PPR NX GT IA GA PC GA_vAPIC
[    0.513001] AMD-Vi: Interrupt remapping enabled
[    0.513001] AMD-Vi: Virtual APIC enabled
[    0.513181] AMD-Vi: Lazy IO/TLB flushing enabled
[    0.514116] amd_uncore: AMD NB counters detected
[    0.514128] amd_uncore: AMD LLC counters detected
[    0.514482] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4
counters/bank).
[    0.514534] check: Scanning for low memory corruption every 60 seconds

If Linus is taking up the patch (hurrah), is 40 msec too large over the Ryz=
en
range? I would quite like the good Ubuntu people to merge your patch into t=
heir
current and upcoming distributions (I think SuSE are already doing so) but
don't want to jump-the-gun or tread-on-any-toes :-).

Over the next few days, I'll try my 2400G on delays between 20 and 40 msec =
and
maybe even test the patch on the still rather unstable Ubuntu 21.04. Any
guidance
much appreciated and, once again, many thanks.

David

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
