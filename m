Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42891342716
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 21:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhCSUnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 16:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230092AbhCSUnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 16:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8457361989
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 20:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616186600;
        bh=mHSpIH9ybVmZsfU9VFMdM5LDTuGMQwxopt5lZ2u2OxE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JL1Ooc7CStasbZfrfNA6fhKYcEeZdvPzy7JjNe8/bI59n5yrdVykY6Z6e00+ifbLn
         UM+Plclc98VO7maBhoaO1LxZpIOP42+uwzqYZNh4kbhW2ctlEdGnrEJd6y3WIrVEze
         RnZhrWL05Sp7JrLmt/me/5WEu0RUdMLlAdhyJDBPbbe8n9eLjI3IOGn+FkXk0gJNoS
         CQpAcBv0JllwxWHfdMWa+pR7Lz0f/FcO/f3R3AWxnhQB5wq6MHjzLAvueehvlvih6z
         I13kpn9KcG6ddzhpXXqd7vn4FQNBIkn+8Yr76GXcY9/peuy42WajErOx2FH4oSwzGg
         c6NdYKq+RIAkw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 8177562A50; Fri, 19 Mar 2021 20:43:20 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Fri, 19 Mar 2021 20:43:19 +0000
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
Message-ID: <bug-201753-28872-UhhJcL5Nis@https.bugzilla.kernel.org/>
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

--- Comment #32 from David Coe (david.coe@live.co.uk) ---
I'm pretty sure this is because IOMMU (for some Ryzens) unlatches after 5 t=
ries
on cold boot and 6 tries on warm. Suravee, alas, has set his patch at 5 x 20
msecs just on the 'dither' point!

Some time mid-next week I'll lay my sticky hands on a 4700U laptop. I have
images re-compiled for Ubuntu's kernel 5.8.0-45 (20.10) and 5.11.0-11 (21.0=
4)
patched at 25 x 20 msecs and logged. Ditto with Alex's oh-so-simple patch.

If all goes well(!), I'll draw up a nice, comparative table of mine and
everybody else's data so we can draw some conclusions. If you scan the
Debian/Ubuntu kernel changelog, you'll find a long list of 'cherry-picked'
patches for both AMD and Intel for IOMMU. It is very much a work-in-progress
still!

Best regards and many thanks all for input.

David

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
