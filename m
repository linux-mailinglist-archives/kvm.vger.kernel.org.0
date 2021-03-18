Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CBA34011D
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 09:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhCRIm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 04:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhCRIly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 04:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B1CF64F4D
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616056914;
        bh=BRa+r/f1AlJRq4jH4I5CN2xR/sI7R2h3+KoqH6sjOEo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=szOa1jz3X0BmW9KgtL5CMReTE1cbVkITh1txKW+wYeLACBX3bka7EYr/rF1/osMqy
         /4iT6XgyFqJrPOhdZbQ2xQpOfV4EscXhXySCq+ADhLZT488dz9Jw5CB/ep9Bi3momZ
         Q6ju7JB3jZl6rK2/OjhxlooHNwEKpTX3xBauyWxZy7CmLy9mgOudYDi+jZMmtJSp3o
         rjf3Hkesj6TSJPZo2TMayCJMfL5Z8e18ibfHtho12RH9spy22dfgg8E7Nfqyz2ARI+
         Hrko2PAo2gRNf7SvmHgMMiyXPePKebD/hNEpYaCbWjhaHsNmcYLQjEPrc+2TWQly1C
         4EHnRfgrEhHbg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 98278653CC; Thu, 18 Mar 2021 08:41:54 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Thu, 18 Mar 2021 08:41:53 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-201753-28872-GXZFJJMpYx@https.bugzilla.kernel.org/>
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

Felice Tufo (info@felicetufo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |info@felicetufo.com

--- Comment #27 from Felice Tufo (info@felicetufo.com) ---
Good morning,
I'm using the latest 5.11.7 kernel on an Aura15 Tuxedo notebook (based on A=
md
Ryzen 4700U). As far as I can tell, the patch was merged on 5.11.7, but at
startup (cold boot) I read:

[    1.888186] pci 0000:00:00.2: AMD-Vi: Unable to read/write to IOMMU perf
counter.
[    1.888454] pci 0000:00:00.2: can't derive routing for PCI INT A
[    1.888457] pci 0000:00:00.2: PCI INT A: not connected
[    1.888510] pci 0000:00:01.0: Adding to iommu group 0
[    1.888537] pci 0000:00:01.3: Adding to iommu group 1
[    1.888565] pci 0000:00:02.0: Adding to iommu group 2
[    1.888583] pci 0000:00:02.1: Adding to iommu group 3
[    1.888600] pci 0000:00:02.2: Adding to iommu group 4
[    1.888616] pci 0000:00:02.4: Adding to iommu group 5
[    1.888644] pci 0000:00:08.0: Adding to iommu group 6
[    1.888663] pci 0000:00:08.1: Adding to iommu group 6
[    1.888689] pci 0000:00:14.0: Adding to iommu group 7
[    1.888707] pci 0000:00:14.3: Adding to iommu group 7
[    1.888764] pci 0000:00:18.0: Adding to iommu group 8
[    1.888779] pci 0000:00:18.1: Adding to iommu group 8
[    1.888795] pci 0000:00:18.2: Adding to iommu group 8
[    1.888810] pci 0000:00:18.3: Adding to iommu group 8
[    1.888825] pci 0000:00:18.4: Adding to iommu group 8
[    1.888840] pci 0000:00:18.5: Adding to iommu group 8
[    1.888855] pci 0000:00:18.6: Adding to iommu group 8
[    1.888869] pci 0000:00:18.7: Adding to iommu group 8
[    1.888886] pci 0000:01:00.0: Adding to iommu group 9
[    1.888906] pci 0000:02:00.0: Adding to iommu group 10
[    1.888923] pci 0000:03:00.0: Adding to iommu group 11
[    1.888940] pci 0000:04:00.0: Adding to iommu group 12
[    1.888959] pci 0000:05:00.0: Adding to iommu group 6
[    1.888968] pci 0000:05:00.1: Adding to iommu group 6
[    1.888977] pci 0000:05:00.2: Adding to iommu group 6
[    1.888985] pci 0000:05:00.3: Adding to iommu group 6
[    1.888993] pci 0000:05:00.4: Adding to iommu group 6
[    1.889000] pci 0000:05:00.5: Adding to iommu group 6
[    1.889008] pci 0000:05:00.6: Adding to iommu group 6
[    1.891539] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    1.891545] pci 0000:00:00.2: AMD-Vi: Extended features
(0x206d73ef22254ade):
[    1.891547]  PPR X2APIC NX GT IA GA PC GA_vAPIC
[    1.891552] AMD-Vi: Interrupt remapping enabled
[    1.891552] AMD-Vi: Virtual APIC enabled
[    1.891553] AMD-Vi: X2APIC enabled
[    1.891781] AMD-Vi: Lazy IO/TLB flushing enabled

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
