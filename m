Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415803A0F10
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 10:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhFII5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 04:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231485AbhFII5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 04:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 349596101A
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 08:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623228942;
        bh=et/0Xbkcdpw3vu8dWPUN3pSLgIuWO4S40YT/2ghWrk8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DBYcwWM65EohlhHLr8o/aC3vcgvgws06y/fgWe+sNXwE2MNgQOx68gk8ilN6cknw6
         5/yYBuOPhlcgFj21QZRt73HBkAhSV0DCMn50aPEEgaIFgR709NTmOFHtBtSW56NJde
         lZK15BEG4Yg8D08FrbXOz1lh/HD3cENBGmYagSZwbrh+8ICyXMNFkNQErj980dmpFk
         mcx1ah9Q2bIoLOBpUfjnz9yfwuak8r/vWxiBveSz+Fz9uBsWET0VorLCMMA5pYDUpH
         R/sD77ZdOXTWTNU89CaBsb5s7wIc0oVyEDeSgbeKSRsZ8BdF9sP+nhJ5c2yMStHwxB
         LOnEfOoJ3LMGg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 26DE66113B; Wed,  9 Jun 2021 08:55:42 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 53851] nVMX: Support live migration of whole L1 guest
Date:   Wed, 09 Jun 2021 08:55:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: christian.rohmann@frittentheke.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-53851-28872-bYWXmtlHPv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-53851-28872@https.bugzilla.kernel.org/>
References: <bug-53851-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D53851

--- Comment #2 from christian.rohmann@frittentheke.de ---
Sorry for replying to this rather old bug - I was pointed to this via
https://www.linux-kvm.org/page/Nested_Guests#Limitations=20


If I may ask, is this really the last state of discussion and work on this
issue?
Looking at i.e.=20

* https://github.com/qemu/qemu/commit/ebbfef2f34cfc749c045a4569dedb4f748ec0=
24a
*
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D039aeb9deb9291f3b19c375a8bc6fa7f768996cc


there have been commits for the kernel as well as QEMU to support migration=
 of
nested VMs.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
