Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA83307FEB
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 21:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhA1UwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 15:52:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229840AbhA1Uv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 15:51:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 398C764DD6
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 20:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611867076;
        bh=aMu17FJnwnzyal3jmQWT8olNIqNKd/uMXLrfvzgCU7o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gZg0+Dok2qpGQAhlLcnOYoYE1yA0kZmdO8oVvhuh+H99ZVMTMRqQtL8br8aF72fu9
         8XRSXfYqz6dCuinG54niQ+XX7yWNeRyzjhfkfFq7IBnxqvhhqWMg19zAHtXr2PCLdd
         vtBNOyCXD8M3pzmIHAoEBNm2jhdsxBdCkxUtLVWZ9Mf7tMo2B3Wuhiru9H9HIKJamh
         fnHTq8BPOjdQI2AkiTfGxp4kVtLZSXG/pJVw035tSOazOhMyXgu15tpKNf4K0glrkk
         R0B7nE7tkPUjrRAxrx95RgsIE9LKEVB6FvSorl2mbIZxtEiOGIu0RkZGdxU1smnNaL
         htL/qJFCgyotQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 25A63652E8; Thu, 28 Jan 2021 20:51:16 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 207707] USB pass through to qemu/kvm causes CDROM reset and
 "device not configured"
Date:   Thu, 28 Jan 2021 20:51:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: steffen@sdaoden.eu
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: OBSOLETE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status cf_kernel_version resolution
Message-ID: <bug-207707-28872-ryGVtU0SGL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207707-28872@https.bugzilla.kernel.org/>
References: <bug-207707-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D207707

Steffen Nurpmeso (steffen@sdaoden.eu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
     Kernel Version|4.19.121                    |5.10.10
         Resolution|---                         |OBSOLETE

--- Comment #1 from Steffen Nurpmeso (steffen@sdaoden.eu) ---
It seems fixed with 5.10.10.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
