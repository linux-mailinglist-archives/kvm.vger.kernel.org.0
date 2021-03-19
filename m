Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B90A3418EB
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCSJ4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhCSJ4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 05:56:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D830764F81
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 09:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616147795;
        bh=WPLpAsxZDAZmlkMIgIPfYu0O9w9G5IYbaAmN/2zfbEQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BP/KoDhxcs3WskLY/aBQUxVKIVKeSWkETCuNSppczvQYK6A15254N9W4CHqFKqCGw
         zRvkZnMkyHFzpS2CN0UvooviR42opxfywJ+2bV1szOh6vz+1/ovP08YGlG9faEOgE9
         K24leYlWW/3KaEqMokWbVTBB4+jVImspfyfIzd4gdRRaoULAdfOuunpVZg6RjG925y
         07uLcnfeUi9pqtXMgMyoVrQ1HwNCpZulO/WTFhgJz4ljIuZoWcNWAMn27a2KVXdaEA
         oVXNTWdCBP8Dmaz6L6iwRjsqP16EpdgKAm9y2bC3N2BT7c0kiw0n7QYi2SCM8Kt5dz
         2TykMUyCov6MQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id D3ABB653CF; Fri, 19 Mar 2021 09:56:35 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Fri, 19 Mar 2021 09:56:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: info@felicetufo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-IimVxkKWrp@https.bugzilla.kernel.org/>
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

--- Comment #30 from Felice Tufo (info@felicetufo.com) ---
Hello, a little update to my previous message: same machine, same kernel, b=
ut
this time the patch works. So it seems that also on the same HW the timings=
 are
not so predictable...

[    1.844903] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters support=
ed
[    1.845157] pci 0000:00:00.2: can't derive routing for PCI INT A
[    1.845160] pci 0000:00:00.2: PCI INT A: not connected
[    1.845213] pci 0000:00:01.0: Adding to iommu group 0
[    1.845240] pci 0000:00:01.3: Adding to iommu group 1
[    1.845267] pci 0000:00:02.0: Adding to iommu group 2
[    1.845284] pci 0000:00:02.1: Adding to iommu group 3
[    1.845301] pci 0000:00:02.2: Adding to iommu group 4
[    1.845318] pci 0000:00:02.4: Adding to iommu group 5
[    1.845349] pci 0000:00:08.0: Adding to iommu group 6
[    1.845368] pci 0000:00:08.1: Adding to iommu group 6
[    1.845394] pci 0000:00:14.0: Adding to iommu group 7
[    1.845411] pci 0000:00:14.3: Adding to iommu group 7
[    1.845469] pci 0000:00:18.0: Adding to iommu group 8
[    1.845484] pci 0000:00:18.1: Adding to iommu group 8
[    1.845500] pci 0000:00:18.2: Adding to iommu group 8
[    1.845515] pci 0000:00:18.3: Adding to iommu group 8
[    1.845530] pci 0000:00:18.4: Adding to iommu group 8
[    1.845545] pci 0000:00:18.5: Adding to iommu group 8
[    1.845559] pci 0000:00:18.6: Adding to iommu group 8
[    1.845574] pci 0000:00:18.7: Adding to iommu group 8
[    1.845592] pci 0000:01:00.0: Adding to iommu group 9
[    1.845611] pci 0000:02:00.0: Adding to iommu group 10
[    1.845629] pci 0000:03:00.0: Adding to iommu group 11
[    1.845646] pci 0000:04:00.0: Adding to iommu group 12
[    1.845665] pci 0000:05:00.0: Adding to iommu group 6
[    1.845674] pci 0000:05:00.1: Adding to iommu group 6
[    1.845683] pci 0000:05:00.2: Adding to iommu group 6
[    1.845691] pci 0000:05:00.3: Adding to iommu group 6
[    1.845699] pci 0000:05:00.4: Adding to iommu group 6
[    1.845706] pci 0000:05:00.5: Adding to iommu group 6
[    1.845714] pci 0000:05:00.6: Adding to iommu group 6
[    1.848251] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    1.848257] pci 0000:00:00.2: AMD-Vi: Extended features
(0x206d73ef22254ade):
[    1.848258]  PPR X2APIC NX GT IA GA PC GA_vAPIC
[    1.848263] AMD-Vi: Interrupt remapping enabled
[    1.848264] AMD-Vi: Virtual APIC enabled
[    1.848264] AMD-Vi: X2APIC enabled
[    1.848490] AMD-Vi: Lazy IO/TLB flushing enabled

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
