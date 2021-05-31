Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718273958EE
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 12:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhEaKai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 06:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230518AbhEaKae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 06:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8AADB6124B
        for <kvm@vger.kernel.org>; Mon, 31 May 2021 10:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622456934;
        bh=MjaahUB6yROM0KaxhUVeWaNuFZFu0FiHE3ut+DlVSE0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hAtuKc9GLZ6fZWGYIEBlibHaL7cgR8+KIBbv7/tCHpRTi1+Nlj9NXPLr2Plbk9TC/
         Cy0IoW8XiQ4ZmGzz0AptjKrJWZjrgA176+KChULz3uSL8SnJch0aRh39lJow9Kh2wU
         FRyq0iUm6WP11HR9KVmjShbN9jeshX2HhQ8nluKigvczsLMgLtUGQK8KWlzVlFFj+O
         ItBwDfGwYvpEBlBApQSyp6wd6gzOstopH4TsqXvCGfYKhTeKGxbRkCRHA4NbbplowY
         MROYlooMH+qnZDGLk6LfiJyQ4gv7ozuWLdPGjoU3g/HTFtaK+bXMoN57FAp3ZeLnsj
         UDrCKT+Xm9eHA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 7F1BF611AD; Mon, 31 May 2021 10:28:54 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213257] KVM-PR: FPU is broken when single-stepping
Date:   Mon, 31 May 2021 10:28:54 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213257-28872-LCsHSbhOZj@https.bugzilla.kernel.org/>
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

Luke Kenneth Casson Leighton (lkcl@lkcl.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lkcl@lkcl.net

--- Comment #1 from Luke Kenneth Casson Leighton (lkcl@lkcl.net) ---
the module being used is kvm_pr not kvm_hv.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
