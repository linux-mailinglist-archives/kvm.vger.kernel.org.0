Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1FF3090AF
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 00:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhA2Xj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 18:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhA2Xj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 18:39:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9EC4C64DEC
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 23:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611963527;
        bh=PrK3Wlc0DA0ICdjtkh2aP+SukoPT9Muy9k0ZUCnuowI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EXtAtRQLVASaFhLJQNS1vQd2wgPxGf8gReaDecuK0ulmu0ZqE1gkseSFn/riEOvyU
         4gJWs4/Z4StT/tBx7a/+I1vRp++9f63Jsip9qJA+gm5jYbt0TXkvMnS3wl8aUU86FB
         Y3/9GR10Z2GYz2hTZDddW92CvFIdcVjsjK8207126Ufs/cSeE+Y8/SuxpapX0lJYhh
         YNq0dgiVSt7juBQ69cazGurW3rPXdezEiSvGcrjIEPg8OGDVivzWxlyz5pMo69K8rP
         pruZ+crqghfwyrnCM0+InZqlmAAXSBRUKCx6VPmSIOTn/23dDhsxYYsMs/lfqz0dw7
         jzpMM3aztx/Zw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 93CF5652D4; Fri, 29 Jan 2021 23:38:47 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 211467] Regression affecting 32->64 bit SYSENTER on AMD
Date:   Fri, 29 Jan 2021 23:38:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-211467-28872-XMLxUDkv7V@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211467-28872@https.bugzilla.kernel.org/>
References: <bug-211467-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211467

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #2 from Sean Christopherson (seanjc@google.com) ---
LOL, this is awesome.  Presumably you're also exposing an Intel CPU model to
the guest, otherwise KVM would inject a #UD on SYSENTER instead of emulatin=
g.

Anyways, hilarity aside, your patch looks correct as Intel CPUs uncondition=
ally
transition to 64-bit mode on SYSENTER from compatibility mode.  Want to sen=
d a
formal patch?  If you're not set up to send a patch, I'd be happy to write a
changelog if you want to provide a Signed-off-by.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
