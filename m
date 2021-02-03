Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80FF30E419
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 21:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhBCUdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 15:33:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhBCUdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:33:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E835F64F7E
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 20:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612384350;
        bh=RL3ZIT+tMd5FUL6oEuWNhq0Wk1qYxx00Zy/6KutFsys=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=K34gdtwl4vGpG0/VCQckI9t+pj6Y/XGMBLzy8s4CfKZfN7IJbrv36b6DKzJ2BOsgm
         qx+UsX0zCA/+3lw7qxNuBQUn/1SLCGbeRbbz5jTGNInTT3rqt9foRCD1hI1CohXLju
         iipz1Vfxd8LiY3E/DmXcWSMBSa8Ls2Rc2tGNokxn27Xeq95Uu2ISPtrKHZrZ2E6y5k
         Idd3gYxWvBsKxmrdDSpV3v/G2Ky508ktUfWQUtWQDgDDctH01vIEPNUVlOG3W1w94r
         o0wcUToT7x81wF23KkNfg2nwA8uQK090FqvccAJkeNUGarFTAyeeQiGhXLS81hChcn
         V6zAP5r2rmQzg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id E13A365336; Wed,  3 Feb 2021 20:32:30 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 208767] kernel stack overflow due to Lazy update IOAPIC on an
 x86_64 *host*, when gpu is passthrough to macos guest vm
Date:   Wed, 03 Feb 2021 20:32:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: i@shantur.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-208767-28872-sgu1UIqjyi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208767-28872@https.bugzilla.kernel.org/>
References: <bug-208767-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D208767

shantur (i@shantur.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |i@shantur.com

--- Comment #8 from shantur (i@shantur.com) ---
This bug is reproducible on Apple hardware too.

I tried this on MacPro 2013 running QEMU KVM with GPU passthrough and all
worked well until the commit with ioapic_lazy_update_eoi came in.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
