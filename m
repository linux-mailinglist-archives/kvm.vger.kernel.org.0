Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B16E32623D
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 13:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBZL7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 06:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBZL7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 06:59:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 66F6064F13
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 11:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614340719;
        bh=G2/hW7UPnVyxQKwKjHXsjDWzWmJB4nK8Iec5rBphLKo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=c/OI065zNwwUhBr7hvYBsgpMAlLuQiWr44Gvb3TNkcwAWjqnq7q5YyOtETP6YJb7p
         4zViyvX99zLZZ5+ONVBKuFe4wJjRHBCh8OoY3m+6jmCRdd+JnExKXS+ECcF9zPNrE6
         50wroOExM4Dk6qk5BSIO7m3SOcSTfS9JZaSYhkiiuSYaWjK4ma3qgzFKb3xvuX8qDu
         +COhDj1piKO4l5Aw9F7Z1P1/KpnBP9X6iIbxmsIe1JooOSPnyarKs6k2rjfDAgokDi
         pe82wenJ6wJzrnDVstexelJgYF7c7qERL8RqQVYEUFXEcdf9evwY5f847SwmTeQ/+/
         wDO3ePP3kXUWA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 410C565331; Fri, 26 Feb 2021 11:58:39 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Fri, 26 Feb 2021 11:58:38 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-Ijb50AVsOl@https.bugzilla.kernel.org/>
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

--- Comment #11 from David Coe (david.coe@live.co.uk) ---
Good morning again!

I've rebuilt the Ubuntu 20.10 kernel 5.8.0-44 overnight with increased dela=
ys.
Grep'ing dmesg for IOMMU gives:

20 msec delay:

[    0.506947] pci 0000:00:00.2: AMD-Vi: Unable to read/write to IOMMU perf
counter.
[    0.510822] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.764160] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>

30 & 40 msec delay:

[    1.017676] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters support=
ed
[    1.021591] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    1.023053] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4
counters/bank).
[    1.345196] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>

At least on my 2400G platform, that suggests 20 msec is still too short. Of
course, YMMV :-).

Machines are grinding through the same trial on Ubuntu 21.04 alpha's 5.10.11
kernel and I'll post results in due course.

Best regards

David

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
