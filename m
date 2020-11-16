Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD052B42B3
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 12:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgKPLVe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 16 Nov 2020 06:21:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgKPLVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 06:21:34 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209253] Loss of connectivity on guest after important host <->
 guest traffic
Date:   Mon, 16 Nov 2020 11:21:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: maironire@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209253-28872-uchzhHZVjc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209253-28872@https.bugzilla.kernel.org/>
References: <bug-209253-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209253

Mair O'Nire (maironire@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |maironire@gmail.com

--- Comment #23 from Mair O'Nire (maironire@gmail.com) ---
Hi all.
I'm new here, registered exactly to track this bug.
I've got a new laptop recently, HP Omen 2020, with AMD Ryzen 4800H and Nvidia
1660Ti, and whilst was trying to setup kvm virtualized system I ran into the
same issue. During investigation I've found Ian's report, and then this one,
too.
Backtraces were very similar to other posted above, all at fs/eventfd.c:74, but
sometimes with different origin. So I decided to give Alex's patch a try, and
built mainline kernel with this patch applied. Mine host kernel was
5.8.[6,17,18], Fedora 33, and they all seems to be affected. Guest is Windows
10.
So, I do confirm - patch works, system became stable, and there was no crashes
for about a week, nor under regular work load, neither while running
benchmarks. Before the fix guest uptime varied from 2 to 10 minutes and then
crash. Moreover, I had to reboot host to get Nvidia back to work in vm again.
Thanks Alex, Ian, and others, you guys doin' a great work if you don't know
this already :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
