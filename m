Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82ACC30DF85
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 17:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbhBCQRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 11:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234870AbhBCQR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 11:17:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A44164F7E
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612369008;
        bh=idbmNhpLZXm8v6LVorzPUnzxsai7ZaaZQR8kNltTbBA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Zd7dMqkqJqyPqxdksLIuBjFJrBQe9qWkI+r2/UIGe4KOlad5RbmVR+vL7KHPyYMrB
         nJwfp0p2btd4h0NhNI8sOVXR/j9esi6oauhbmSBCu+GN4Bl8qUo6SjKpcFT8j+1rFf
         lUiQDjsDr03umW7LCnWlMrSPc9dx0lCOmXqQiLK9+XqYYMr64fiPZjn6t4YuQ2+wD9
         0E6zKKKFhUvG0umT95T/xu8A2dSZfEn2QxVXWvMX38KpTJA23X5cN7QFkYyZ1+pbHl
         QeKzaoTYyt+aZgOY6ZgcTdX69jVU0ZRRUCJbzkE/Kl+AHi+qeA/xmCfZPoaL5I5Lq7
         jtlhB+cK1T3kg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 4746665332; Wed,  3 Feb 2021 16:16:48 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 207489] Kernel panic due to Lazy update IOAPIC EOI on an x86_64
 *host*, when two (or more) PCI devices from different IOMMU groups are passed
 to Windows 10 guest, upon guest boot into Windows, with more than 4 VCPUs
Date:   Wed, 03 Feb 2021 16:16:47 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: i@shantur.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-207489-28872-eSXoqdNNIb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207489-28872@https.bugzilla.kernel.org/>
References: <bug-207489-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D207489

shantur (i@shantur.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |i@shantur.com

--- Comment #18 from shantur (i@shantur.com) ---
I am seeing this in Centos 8.3 based oVirt Node NG 4.4.4.
Is there any workaround for this issue ( a kernel param or something else )=
 ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
