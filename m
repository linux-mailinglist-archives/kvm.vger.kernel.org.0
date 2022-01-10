Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E14648A2BB
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 23:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345423AbiAJW3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 17:29:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59690 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345394AbiAJW3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 17:29:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9B76B8180A
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 22:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94C25C36AF2
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 22:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641853762;
        bh=y28cb3oJfTEyeamcFBFBGlT7J3mZit57nZ4frKt6ssw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Zu/aLzfHdPXXUpIAvQCk7DrNGyOFLY5xL35iiM74y04KWH7XcJIlXHhK1XIVZNGs+
         dur0e8To4jreSQ4muRkSOtb9zDiTF2pqXZHbHe/jVSzhZHvLp1qs7YHGtMFqhx3WWR
         +mSNW5s+Cta/BSEfkMb9k4A8JQoOwbo+bBfZdGtOOuyfzbyi3Apoj5EkkKFAWvZ6yc
         usb/1L1GPHjcTIN/u29hNdqBSFTZHAKNauc2RYBr8qs42/38UKszl0WXY71pUMD7if
         FEuiOy43gSVwAjozcE261Cllh5a//ZzAIgLAza9GA3WJSQs0WIbI0vndlnlQmgx46O
         LrvfW3KlL33WQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7D62CC05FF0; Mon, 10 Jan 2022 22:29:22 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Mon, 10 Jan 2022 22:29:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215459-28872-VoXhwNHjAk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215459-28872@https.bugzilla.kernel.org/>
References: <bug-215459-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215459

--- Comment #10 from mlevitsk@redhat.com ---
On Mon, 2022-01-10 at 09:30 +0000, bugzilla-daemon@bugzilla.kernel.org wrot=
e:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215459
>=20
> --- Comment #9 from th3voic3@mailbox.org ---
> I've compiled the 5.16 kernel now and so far it's looking very good. APICv
> and
> tdp_mmu are both enabled. Also thanks to dynamic PREEMPT I no longer need=
 to
> recompile to enable voluntary preemption to cut down my VMs boot time.
>=20
Great to hear that.

I am just curious, with what PREEMPT setting, the boot is slow?
With full preemption? I also noticed that long ago, before I joined redhat,
back when I was just a VFIO fan, that booting with large amounts of ram
(32 back then I think), forced preemption and passed-through GPU makes
The VM hang for about like 1/2 of a minute before it shows the bios splash
screen.

Best regards,
        Maxim Levitsky

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
