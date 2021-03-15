Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F4533C8F4
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 23:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhCOWAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 18:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231371AbhCOWAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 18:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D25F364F60
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 22:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615845616;
        bh=J7PLDfv7b19BDojN3LSd/g5IVJLtfBzxOxUtpNbGlF8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=X7bVaf9kP3rzxTEarpqjKNxqvo5FUPbxPUa2skSl8398qtPqflovPHWlCzQZOzhdg
         TQ8oy/u+XJMtIu578lQcyEs/sHgRYvin00bpTMjsLoNrHvNw0QFy9h1TrRjPg4OW4X
         REkeXMRgv9itd5DwRTxl6K8paYc1pQYm8r7cE8HM5pH8062rIO312vdxnzBP2zFmkE
         1o76p4UxRmkrBof4ksRO80ppCDqchqliYp6ff8Mp3Rk8QYVDH/hNZqShCLn/9CB6Qk
         e2GPN0o+PvvyW5CTa9y0DVSR+lVc57BuP/IceMYwamaWXQ8NQxvEsWe2/mlGocInwb
         f3FLgIAWyt+eg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id CFCE76533C; Mon, 15 Mar 2021 22:00:16 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Mon, 15 Mar 2021 22:00:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bubuxp@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-201753-28872-ZFclF5BdZT@https.bugzilla.kernel.org/>
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

BubuXP (bubuxp@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bubuxp@gmail.com

--- Comment #22 from BubuXP (bubuxp@gmail.com) ---
Just a note, maybe useless.
I own a Huawei laptop, model KPL-W00D with Ryzen 2500U and it suffer this s=
ame
bug.

I cannot compile a kernel so, after installing Devuan testing, I installed =
also
the generic kernel located here:
https://kernel.ubuntu.com/~kernel-ppa/mainline/daily/2021-03-15/amd64/
that is a 5.12.0 RC3 and it includes the upstream patch for this bug.

The patch works but only on cold boots, after a simple reboot the bug turns
back again.

Maybe it's only a hardware problem, maybe a distro fault or misconfiguratio=
n, I
don't know, but I felt compelled to report this.

If needed I can give more detailed informations.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
