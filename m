Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656053CD2E0
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 13:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbhGSKQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 06:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235471AbhGSKQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 06:16:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 64D1161107
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 10:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626692248;
        bh=6wEDfg7ibPBYRhGGSuSXooWfmuyo90fWujYdQSWVzXU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qIezc68GT7o/Fx+VOYeEcX66P1+GAs+srwwHz2BK21aTLskWZC/onUWcov9e8HPxX
         qvQONjYN25ZWv33teuJdkEAlmeCpDbLU/j4BeBzJn8esCfJj+b7uGirnxgsLw00TMg
         VQ6H+pFTuFr67XZZ18rvS2Vo/blQEDCBbP9XBjmaj0d7p4L7RKzrpkjBMqvfe1BEoK
         kDqYVtb7dPUTMMviPHHkjHztQ6wsoyOKRP8fFCC0safzQ75T5EFnzp0YEI+1mFcgC6
         a1b2dOyHTD+5hl+9mDCYM1c8QoF2G0VV1laxnLEKYxxYemdQkcR8h/mt/ashF3fxIS
         o5Jf9A0L+TQtA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 5C338611CE; Mon, 19 Jul 2021 10:57:28 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213781] KVM: x86/svm: The guest (#vcpu>1) can't boot up with
 QEMU "-overcommit cpu-pm=on"
Date:   Mon, 19 Jul 2021 10:57:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: maximlevitsky@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213781-28872-PUKpGHVDEb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213781-28872@https.bugzilla.kernel.org/>
References: <bug-213781-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213781

Maxim Levitsky (maximlevitsky@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |maximlevitsky@gmail.com

--- Comment #1 from Maxim Levitsky (maximlevitsky@gmail.com) ---
I sadly know exactly why this happens and yes this commit is technically to
blame.

But the root cause is non atomic memslot updates that qemu does. It will be
fixed this way or another I hope.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
