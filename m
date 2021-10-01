Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF01141F5F0
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 21:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhJAT4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 15:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229891AbhJAT4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 15:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 65FFE61AEF
        for <kvm@vger.kernel.org>; Fri,  1 Oct 2021 19:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633118073;
        bh=25jagUzeuW2/2s9giFiDn0qoMrdHgBBKX+8IgBwBPyg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=CZ3r3/s6Y6xjZwMIdM+SIBjxyjUWXr9d0aJy3zJrtv0yfeWniTI/PgF3GQLJItw17
         7ijMTEwB+g7cyj0Bu7/BPrq5Vt3IpKwZD/H781kMXhrZdBRT31U3SJp/Lt81kHFsnv
         xoGYrCUQfLWNAoV0fGB2XbybGsOY4cEblcUZGaONOMl3V431AZ+uGsjXViTEv1r0vo
         XPIZAlefxlk+5QmVfGLxhwNzdoaAsuk0/fXqwFPnv4CxjbL9uCIVAJ0VkgSDr9pGPm
         adbkarqNWasN97Zs+uRww1uWw5SxQarSaBAlL0rGP/qN+e+KI76x+XbP3NiBkml/1s
         4m1rxd4RUVEBQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 6352760F5B; Fri,  1 Oct 2021 19:54:33 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Fri, 01 Oct 2021 19:54:32 +0000
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
Message-ID: <bug-201753-28872-YPlbZQKe0q@https.bugzilla.kernel.org/>
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

--- Comment #37 from Neil (ledufff@hotmail.com) ---
Whoops,  I forgot to report as well that this is fixed for me.
Thinkpad E495 / Ryzen 3500u / debian 11 linux 5.10.46-5


[    0.366749] iommu: Default domain type: Translated=20
[    0.805580] pci 0000:00:01.0: Adding to iommu group 0
[    0.805589] pci 0000:00:01.1: Adding to iommu group 1
[    0.805600] pci 0000:00:01.2: Adding to iommu group 2
[    0.805608] pci 0000:00:01.3: Adding to iommu group 3
[    0.805616] pci 0000:00:01.6: Adding to iommu group 4
[    0.805635] pci 0000:00:08.0: Adding to iommu group 5
[    0.805644] pci 0000:00:08.1: Adding to iommu group 6
[    0.805651] pci 0000:00:08.2: Adding to iommu group 5
[    0.805663] pci 0000:00:14.0: Adding to iommu group 7
[    0.805670] pci 0000:00:14.3: Adding to iommu group 7
[    0.805701] pci 0000:00:18.0: Adding to iommu group 8
[    0.805709] pci 0000:00:18.1: Adding to iommu group 8
[    0.805716] pci 0000:00:18.2: Adding to iommu group 8
[    0.805723] pci 0000:00:18.3: Adding to iommu group 8
[    0.805730] pci 0000:00:18.4: Adding to iommu group 8
[    0.805736] pci 0000:00:18.5: Adding to iommu group 8
[    0.805743] pci 0000:00:18.6: Adding to iommu group 8
[    0.805749] pci 0000:00:18.7: Adding to iommu group 8
[    0.805758] pci 0000:01:00.0: Adding to iommu group 9
[    0.805767] pci 0000:02:00.0: Adding to iommu group 10
[    0.805775] pci 0000:03:00.0: Adding to iommu group 11
[    0.805783] pci 0000:04:00.0: Adding to iommu group 12
[    0.805809] pci 0000:05:00.0: Adding to iommu group 13
[    0.805835] pci 0000:05:00.1: Adding to iommu group 14
[    0.805846] pci 0000:05:00.2: Adding to iommu group 14
[    0.805857] pci 0000:05:00.3: Adding to iommu group 14
[    0.805868] pci 0000:05:00.4: Adding to iommu group 14
[    0.805879] pci 0000:05:00.5: Adding to iommu group 14
[    0.805890] pci 0000:05:00.6: Adding to iommu group 14
[    0.805895] pci 0000:06:00.0: Adding to iommu group 5
[    0.810116] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4
counters/bank).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
