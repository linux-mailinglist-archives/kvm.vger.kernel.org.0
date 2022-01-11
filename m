Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1801548A95A
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 09:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348917AbiAKI3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 03:29:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39338 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348922AbiAKI3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 03:29:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8B25B81616
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 08:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9900DC36AE9
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 08:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641889740;
        bh=6VbmfqIv64PJjYq29M/p1jeGGqErKtmELtuxLcca27M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=D9rX9GjNDCtAgRrMKS7KjfNbaVzoeR46S6+CFHNstJ/4txUmBu1g+sRxC829E5Sw2
         UigcsPFMq8zmK4g3rdMUYBrtChpIcfuzpzsOzVxB8P0RIUu2VX//lgGm3YdrWm/XwM
         OiOWsKzLohq+hSL+4oJbDI1EIn/Rk95cYesJmt4ThcvIuby5xh2iT3AYJcQ5vE+8Lr
         9IiysF/K3iFCRI0CmkxMzR1PhKBhq5AR00hVpgYiFHFN7ta35dkUarnUgp4lIQjMaX
         bLefkamo18a1FxvI/jgabbmS1SQjlYiAB/uRPyGCliXxd7QRerdpbGwBt+0qTxDxjV
         KJ/2x2NoWnIHw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7CA9FC05FE3; Tue, 11 Jan 2022 08:29:00 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Tue, 11 Jan 2022 08:29:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: th3voic3@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215459-28872-Wk1EQCQEdY@https.bugzilla.kernel.org/>
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

--- Comment #11 from th3voic3@mailbox.org ---
(In reply to mlevitsk from comment #10)
> On Mon, 2022-01-10 at 09:30 +0000, bugzilla-daemon@bugzilla.kernel.org wr=
ote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D215459
> >=20
> > --- Comment #9 from th3voic3@mailbox.org ---
> > I've compiled the 5.16 kernel now and so far it's looking very good. AP=
ICv
> > and
> > tdp_mmu are both enabled. Also thanks to dynamic PREEMPT I no longer ne=
ed
> to
> > recompile to enable voluntary preemption to cut down my VMs boot time.
> >=20
> Great to hear that.
>=20=20
> I am just curious, with what PREEMPT setting, the boot is slow?
> With full preemption? I also noticed that long ago, before I joined redha=
t,
> back when I was just a VFIO fan, that booting with large amounts of ram
> (32 back then I think), forced preemption and passed-through GPU makes
> The VM hang for about like 1/2 of a minute before it shows the bios splash
> screen.
>=20=20
> Best regards,
>       Maxim Levitsky

Yeah it used to be like that.
I just compared the two though (full vs voluntary PREEMPT) and it doesn't s=
eem
to make a difference anymore. Full preemption is now just as fast as volunt=
ary
preemption, so I'm just sticking with full preemption since it's my distros
default.

Best regards

Nico

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
