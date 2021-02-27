Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AF5326D8F
	for <lists+kvm@lfdr.de>; Sat, 27 Feb 2021 16:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhB0PWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Feb 2021 10:22:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhB0PWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Feb 2021 10:22:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 430E364F13
        for <kvm@vger.kernel.org>; Sat, 27 Feb 2021 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614439298;
        bh=W+SeVyv0niIANPiFLarFsHTMk2NDdsHHwW8XyQfs4n8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=sUCR13jS3N3ZPGoucEzDyDZoJAxHlqcWumn/hEGUnJoCAeaU8OUQYRhav+15BGuau
         l+reZ9fZjHoWVnDGVTygCex3IrZeei5XkPh+iS5CzpYSvXwoqkHm4CN/d/0vbw9Xhz
         NfBtv8qU173EWoV38r0is3qcUraOU5TKel6mrDYEPJMI7+6mBlHeh+SE+6ZPf3C2k9
         IIr5IgJ8OQuhEgZFlmfSOflyd9KfyTW/2D4F9U2/p/ZjNssVMRDbUuMVZ8JJrD/Zr9
         lyQ9k/x3la7eOpYpA/7Cs4vL7JtxiIomU+qUrsKjQ3981JFeATgjJOFLNca429ghTt
         PKLfs/eEjGmWQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 3E22F65328; Sat, 27 Feb 2021 15:21:38 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Sat, 27 Feb 2021 15:21:37 +0000
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
Message-ID: <bug-201753-28872-RtVJd4OEq4@https.bugzilla.kernel.org/>
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

--- Comment #17 from David Coe (david.coe@live.co.uk) ---
Again, good day!

Two re-builds using Alex's (one-line) patch, for kernels 5.8.18 and 5.10.11.
Both give on the Ryzen 2400G:

[    0.374138] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters support=
ed
[    0.374141] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.375457] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4
counters/bank).
[    0.626269] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>

I don't know how significant an extra 125 msec on boot time is but, on grou=
nds
of simplicity and elegance, I'd vote for Alex :-). Are there any downsides?

Much appreciated all.

David

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
