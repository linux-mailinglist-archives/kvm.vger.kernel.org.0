Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16613F6EDB
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 07:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhHYFh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 01:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:32836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232420AbhHYFhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 01:37:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 145C2610FD
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 05:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629869800;
        bh=YDzXHv3O6ZSM0MjPeYM62PhfRbKTerIE9g1T/4bpCMw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WMhLB/wjSCDbaKbkZfI1Qr720pRdiQw45YoMoxa9a4w6wvVRqb+J2DKr71gORrUsN
         1Wt3Arj1Q5YwJitfyS4llcff3GkAPcfAoR+PBG9JrZocCdmiNyw5oz8nm05mHZqw0h
         +fqcKdCeLlFU6WAjDUVaJIkEo2Ih4f/W3V2Bx7IdWjZrm0hCPvnvin4ASCnrA4EldS
         m3jx8/dGypCbzeJ+JVWXxpy2GL+Mc6hksAO966KM665xL2moKZkQknikL7RFKOo8qE
         TUHbkD6WEE/wZC8FtGii66YMjREFvKuzbkPNsn3qzzIe2EnuZE6j6s5ANL5OF5EhOq
         K7nWq8avkE/SQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 0C5E561003; Wed, 25 Aug 2021 05:36:40 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 110441] KVM guests randomly get I/O errors on VirtIO based
 devices
Date:   Wed, 25 Aug 2021 05:36:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: almaza24map@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-110441-28872-Anmr9hI22o@https.bugzilla.kernel.org/>
In-Reply-To: <bug-110441-28872@https.bugzilla.kernel.org/>
References: <bug-110441-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D110441

Jerick Fischer (almaza24map@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |almaza24map@gmail.com

--- Comment #2 from Jerick Fischer (almaza24map@gmail.com) ---
(In reply to Jordi Mallach from comment #1)
> Sorry for the noise. This is actually caused by os-prober opening the
> devices and causing corruption and mayhem. See
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D788062 for details.

Thank you much for sharing your knowledge and a reference, much appreciated.

Respectfully,
RJ from https://www.sanjosetruckingcompany.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
