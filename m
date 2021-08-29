Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB953FAC58
	for <lists+kvm@lfdr.de>; Sun, 29 Aug 2021 16:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhH2O7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Aug 2021 10:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235452AbhH2O7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Aug 2021 10:59:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C11160F46
        for <kvm@vger.kernel.org>; Sun, 29 Aug 2021 14:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630249128;
        bh=S+Pu1dTjQIflgJn7se2MGLz5unqa+Zxsn07NEukFikE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=uXyL1phebIMA0UMinXPqcvMsIzoosGgF2kSpthvNN246zd8F2HCcQss+udEC+B8xQ
         qh1WBQ7IOeMDJ1fseqMoV4/0jcn/sZx7PZZslpx+/QPmPJblJ2qYeCHHBx2/A4/Tis
         WCJKpN6XfHL5JWrfa51dZr7Fr9wUJ4l5AW4us66LjO91BpmqgQ3eT/pKG47TC3Xf9c
         K6JXzjktx4bpeSbjXcxHaGLcr8kI4Y+hYZtW5j6ZlsAf+/5JLWxUZlohZagpsPwnko
         n+W6pKSIKuIvPkauL+p0Wm7b3MwQAtDRZ49m0P5BoHr3hjDrQJowXm7TIxyfyuaguI
         qHta4gHWGGdCg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 778A460F48; Sun, 29 Aug 2021 14:58:48 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Sun, 29 Aug 2021 14:58:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-AfErhP1NP4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #5 from Roland Kletzing (devzero@web.de) ---
apparently, things got even worse with proxmox 7, as it seems it's using as=
ync
io (via io_uring) by default for all virtual disk IO, i.e. the workaround
"cache=3Dwriteback" does not work for me anymore.

if i set aio=3Dthreads by directly editing VM configuration, things run smo=
othly
again.

so, still being curious:

why do VMs get severe hiccup with async (via io_submit or io_uring) when
storage is getting some load and why does that NOT happen with the described
workaround ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
