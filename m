Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF36D30B1FA
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 22:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhBAVRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 16:17:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232310AbhBAVRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 16:17:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DA04060232
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 21:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612214197;
        bh=EH2it3f/3HA4SV7HXQdwZssSN+uOy1dsCHalrdxTUnI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=d1ENr4qGU3kq9uzU5lInkBjOhhXyzTQORuPGTw0D1Hj29ShFqRmxHFOk1aQCi1qNu
         mW3j/+O/pEkuNSbMPGs1IaAq6XvmPddoHrH3uOjkyD6kN6gp7+kv0mYYsskAk68nZ5
         LMbxIJuo1rkLsM5neutAy4uL5Rdg6OCx7sA4LoaqEC8jsRp6LMDBoZ5pu32kv2AY78
         DRKXZWH+hwmdBlajzXO+fPe+O8hNG7ssP6TsMNu+pq+IibbRljWt5z757LDgisI2Ce
         GavEuYhOEDILRxjFUO1qaubV7EaJRs0vj87na+stcOZ2vsq+cgDx4NKmC6yMcmczSa
         CcrML3z5UNqEg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id CA21365303; Mon,  1 Feb 2021 21:16:37 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 211467] Regression affecting 32->64 bit SYSENTER on AMD
Date:   Mon, 01 Feb 2021 21:16:37 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211467-28872-gWO90TpI6Y@https.bugzilla.kernel.org/>
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

--- Comment #4 from Sean Christopherson (seanjc@google.com) ---
Running a 64-bit guest with a 32-bit host kernel is firmly unsupported,
emulator issues are but one of many things that would completely break.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
