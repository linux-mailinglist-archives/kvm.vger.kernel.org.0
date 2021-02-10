Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31FD3170AB
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 20:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhBJTxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 14:53:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232882AbhBJTxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 14:53:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CCCBE64EEE
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 19:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612986738;
        bh=uzLut7zwTZYAkHBovgkM1nocutIRdo7mWyXv/CBR5Uk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Wrk0LeVDsU9itb6t+Ce4f5TkOJtJ2h0/rwh/cPA5O4F4ByVbvIo4ZVZCRjkoUXESN
         V2grYZb2ZbBRsugnARcJQBs59iVM3mXEQEbAvo1ucjIhcJEJ0BqAUAHgFLXSClQiPY
         ju8VcgUAmKtsDI5Icim1jmrWgLlQA2HW5gYA03SKC4UXFnf6YZ3eYNyk/L5XXuBkvG
         hbtWYRJOJtlZc0NMZioCzdAA2m9Ue3XpfJsT5VBIBQ4IQvCZmmYTOWmzhid8hBw4Pu
         faiQUXiPShYdwHs58nsA7tLH1VojZSjwN8mZK0rOHxz3F/jij1m5eI5TvPDdHViT3v
         JTVJU2/BBXSkw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id C730E61479; Wed, 10 Feb 2021 19:52:18 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Wed, 10 Feb 2021 19:52:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ledufff@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-Ks71hBB3WA@https.bugzilla.kernel.org/>
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

--- Comment #6 from Neil (ledufff@hotmail.com) ---
Hello, Suravee,  I tried your patch in my Thinkpad E495. With RFCv1 and had=
 no
success, I'm sorry I forgot to save a dmesg for that, but I am sure it was =
like
no patch was used, it was the same dmesg as before.

I had success with RFCv2,  and got the following:

[    0.606952] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters support=
ed
[    0.607117] pci 0000:00:00.2: can't derive routing for PCI INT A
[    0.607118] pci 0000:00:00.2: PCI INT A: not connected
[    0.607169] pci 0000:00:01.0: Adding to iommu group 0
[    0.607180] pci 0000:00:01.1: Adding to iommu group 1
[    0.607191] pci 0000:00:01.2: Adding to iommu group 2
[    0.607204] pci 0000:00:01.3: Adding to iommu group 3
[    0.607215] pci 0000:00:01.6: Adding to iommu group 4
[    0.607238] pci 0000:00:08.0: Adding to iommu group 5
[    0.607249] pci 0000:00:08.1: Adding to iommu group 6
[    0.607257] pci 0000:00:08.2: Adding to iommu group 5
[    0.607271] pci 0000:00:14.0: Adding to iommu group 7
[    0.607279] pci 0000:00:14.3: Adding to iommu group 7
[    0.607307] pci 0000:00:18.0: Adding to iommu group 8
[    0.607314] pci 0000:00:18.1: Adding to iommu group 8
[    0.607321] pci 0000:00:18.2: Adding to iommu group 8
[    0.607328] pci 0000:00:18.3: Adding to iommu group 8
[    0.607336] pci 0000:00:18.4: Adding to iommu group 8
[    0.607343] pci 0000:00:18.5: Adding to iommu group 8
[    0.607350] pci 0000:00:18.6: Adding to iommu group 8
[    0.607357] pci 0000:00:18.7: Adding to iommu group 8
[    0.607368] pci 0000:01:00.0: Adding to iommu group 9
[    0.607380] pci 0000:02:00.0: Adding to iommu group 10
[    0.607392] pci 0000:03:00.0: Adding to iommu group 11
[    0.607403] pci 0000:04:00.0: Adding to iommu group 12
[    0.607434] pci 0000:05:00.0: Adding to iommu group 13
[    0.607474] pci 0000:05:00.1: Adding to iommu group 14
[    0.607493] pci 0000:05:00.2: Adding to iommu group 14
[    0.607511] pci 0000:05:00.3: Adding to iommu group 14
[    0.607530] pci 0000:05:00.4: Adding to iommu group 14
[    0.607548] pci 0000:05:00.5: Adding to iommu group 14
[    0.607566] pci 0000:05:00.6: Adding to iommu group 14
[    0.607571] pci 0000:06:00.0: Adding to iommu group 5
[    0.609950] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.609951] pci 0000:00:00.2: AMD-Vi: Extended features (0x4f77ef22294ad=
a):
[    0.609952]  PPR NX GT IA GA PC GA_vAPIC
[    0.609954] AMD-Vi: Interrupt remapping enabled
[    0.609954] AMD-Vi: Virtual APIC enabled
[    0.610822] AMD-Vi: Lazy IO/TLB flushing enabled
[    0.611644] amd_uncore: AMD NB counters detected
[    0.611647] amd_uncore: AMD LLC counters detected
[    0.611963] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4
counters/bank).

I will attach the full dmesg later.
Should I try the v3?=20=20
Is there anything else apart from booting and checking dmesg that I can do =
to
test your patch?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
