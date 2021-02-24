Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DB0324541
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 21:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbhBXUc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 15:32:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235649AbhBXUcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 15:32:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 10B9064F08
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 20:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614198730;
        bh=LhbSe5Hs2BndJrq7Gnzvp0zVEg87v3R4FoCAAWwJ3lc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=m65q+IdwEb5SDO6PPgPORDl0N7jgmfMkZELOHtEQEWMmFd6yea6o31clUGdEXwE86
         5SiOEAbfzXu5vKSJxRpUjPYWewntK8/iyMFmkOLy+u8thLeIJb7k7zFb1doBRihJRn
         q58tAFP0oPAr0XpR5/B9J0YlQk7MzlH3am0MNAxbtdREZS9tGWRMNm2QVUmFl0QgXF
         qhMUMH+EEzyadecAn0PmWtBlrLCQ6pmh0RbogofL/slqolZzgpt45GRUjWTQq2VuaS
         bfAy8Fj/bMokZMawTlcdwYS/GwcPRUy0XpUbtBanaCcYBzMorD2C3r4d94LoGBGL22
         byNupjIKiSS5A==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 0B3F465368; Wed, 24 Feb 2021 20:32:10 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Wed, 24 Feb 2021 20:32:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pmenzel+bugzilla.kernel.org@molgen.mpg.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-201753-28872-2i0d8W20rd@https.bugzilla.kernel.org/>
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

--- Comment #9 from Paul Menzel (pmenzel+bugzilla.kernel.org@molgen.mpg.de)=
 ---
Created attachment 295423
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295423&action=3Dedit
Linux 5.12+ messages

Some days ago, Linus added the commit to this main branch [1].

Unfortunately, I am still seeing this error.

    [    0.000000] Linux version 5.11.0-10281-g19b4f3edd5c9 (root@a2ab663d9=
37e)
(gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian)
2.35.1) #138 SMP Wed Feb 24 11:28:17 UTC 2021
    [=E2=80=A6]
    [    0.106422] smpboot: CPU0: AMD Ryzen 3 2200G with Radeon Vega Graphi=
cs
(family: 0x17, model: 0x11, stepping: 0x0)
    [=E2=80=A6]
    [    0.291257] pci 0000:00:00.2: AMD-Vi: Unable to read/write to IOMMU =
perf
counter.
    [=E2=80=A6]

@00oo00, is the error gone for you now (AMD Ryzen 5 2400G with Radeon Vega
Graphics (family: 0x17, model: 0x11, stepping: 0x0))?


[1]:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D6778ff5b21bd8e78c8bd547fd66437cf2657fd9b

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
