Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999BC1CC61D
	for <lists+kvm@lfdr.de>; Sun, 10 May 2020 04:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEJCEr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 9 May 2020 22:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEJCEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 May 2020 22:04:47 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMDcxNzNdIGt2bSBjb21waWxpbmcgcHJvYmxlbSA1LjYu?=
 =?UTF-8?B?eCBrdm1fbWFpbi5jOjIyMzY6NDI6IGVycm9yOiDigJhucl9wYWdlc19hdmFp?=
 =?UTF-8?B?bOKAmSBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rp?=
 =?UTF-8?B?b24=?=
Date:   Sun, 10 May 2020 02:04:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: enhancement
X-Bugzilla-Who: tony-cook@bigpond.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-207173-28872-qLvxKTIWL7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207173-28872@https.bugzilla.kernel.org/>
References: <bug-207173-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207173

Tony Cook (tony-cook@bigpond.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tony-cook@bigpond.com

--- Comment #10 from Tony Cook (tony-cook@bigpond.com) ---
arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function
‘__kvm_gfn_to_hva_cache_init’:
arch/x86/kvm/../../../virt/kvm/kvm_main.c:2236:42: error: ‘nr_pages_avail’ may
be used uninitialized in this function [-Werror=maybe-uninitialized]
 2236 |  for ( ; start_gfn <= end_gfn; start_gfn += nr_pages_avail) {
cc1: all warnings being treated as errors
make[2]: *** [scripts/Makefile.build:267:
arch/x86/kvm/../../../virt/kvm/kvm_main.o] Error 1
make[1]: *** [scripts/Makefile.build:505: arch/x86/kvm] Error 2
make[1]: *** Waiting for unfinished jobs....

Nothing non-standard here, just trying to build the latest kernel 5.6.11 with #
Compiler: gcc (GCC) 10.0.1 20200430 (Red Hat 10.0.1-0.14)

I agree that there is in fact no error here as the nr_pages_avail is set before
it is used to increment start_gfn, or at any rate one can infer that it might
be set by the procedure call that passes it by reference. Nonetheless it is
more than just annoying when this breaks my build. Either change the default
setting and disable werror for this module or make the uneccessary assignment
just for my pleasure.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
