Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28B3396A3F
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 02:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhFAAOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 20:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhFAAOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 20:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AAEE06128A
        for <kvm@vger.kernel.org>; Tue,  1 Jun 2021 00:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622506379;
        bh=7LKvm3wF48hS/kERCgCGjHD4K1Kgg530i5SBfbvbPMU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JcsWCrLXeMhdeDlrjSYGovxwxguloY0Z+TARebckpC4Ni+Fkk6el0z1rZCgG3CeDY
         RGksBcagrQeGK1rnT8+VyZaTuwM/o/U/SYa1KYhW/DKNg0Uih2E+AJqqDFCIMpbKkh
         rPiJCHALlneU/kHka7yvf+ahyecCs75kSG3+r30WkFrzBa0x1Pd5wO1iRpOAD3mmaN
         nLdAwZiksfq9R+BnMgiUdLR9YPC4gi0fzf7OE0PK0lkY7uj+w122JSg0fdydZ/3l+t
         kNCaBkCcHHXsnRPDMwxnQXuA1A23zIY3ssMlKwpdhuXvKhyeYxHjEwBJF9e1IwM4X6
         k9m1uFwU1OSiA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id A0815611AD; Tue,  1 Jun 2021 00:12:59 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213257] KVM-PR: FPU is broken when single-stepping
Date:   Tue, 01 Jun 2021 00:12:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lkcl@lkcl.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213257-28872-y7MavhC4Lr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213257-28872@https.bugzilla.kernel.org/>
References: <bug-213257-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213257

--- Comment #2 from Luke Kenneth Casson Leighton (lkcl@lkcl.net) ---
out of interest if the bottom half of vs0-vs31 is read (or written),
are those also zero?

completely unrelated i am running into a gdb machine-interface bug
which has been "solved" through the workaround of reading/writing
the lower 64 bits of VSX registers instead of fp0-fp31

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
