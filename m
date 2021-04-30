Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263B936F923
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 13:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhD3LVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 07:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbhD3LVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 07:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B423B61434
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 11:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619781633;
        bh=+Uz0ivy0dEZNegvRnImA/13aDgbfhzUA6kJAhBHN65w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PjRK8kKoXpkc6y8co9JwGgWS9TC09xslkI52It08Ij5AB8/Uy6LsHZpjK2YCdCCGK
         aREip441SrAfV+56O1Q1n4dEOjebV9t6qz7JvxOCJrPLwFqk022qZGCX9LMgSBYgf7
         CgNdJdysUypIUdOzweHoF4O3cZ2CNg2TIRjCPUaVIfVxdepABm/SEq7HDVGJPoLIAJ
         06Hm/t8wRNCdfsKNxR1ZHd/sR4LENxpQyxAV4cwSh2ctJBJBFPLEzOlDNly6ycQOEW
         3BL8daxbewYj/JN/4cuWqBw2NjrGV5Zlp0K0W9nmBj75hHH+TcgnQbmunzr/T0lymC
         PFNlnKlxbHjWg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id A61DD61106; Fri, 30 Apr 2021 11:20:33 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 209809] kernel: x86/cpu: VMX (outside TXT) disabled by BIOS
Date:   Fri, 30 Apr 2021 11:20:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nicolopiazzalunga@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc cf_kernel_version
Message-ID: <bug-209809-28872-tapmT1qTEe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209809-28872@https.bugzilla.kernel.org/>
References: <bug-209809-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D209809

Nicolo' (nicolopiazzalunga@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nicolopiazzalunga@gmail.com
     Kernel Version|5.8.16                      |5.6

--- Comment #1 from Nicolo' (nicolopiazzalunga@gmail.com) ---
More precisely, one could replace 'pr_err_once' with 'pr_notice_once' in
https://github.com/torvalds/linux/commit/bb02e2cb715a3f3552dbe765ea4a07799e=
4dff43

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
