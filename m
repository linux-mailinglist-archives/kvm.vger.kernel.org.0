Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42EB1A7735
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 11:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437559AbgDNJTS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 14 Apr 2020 05:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437500AbgDNJTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 05:19:14 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMDcxNzNdIGt2bSBjb21waWxpbmcgcHJvYmxlbSA1LjYu?=
 =?UTF-8?B?eCBrdm1fbWFpbi5jOjIyMzY6NDI6IGVycm9yOiDigJhucl9wYWdlc19hdmFp?=
 =?UTF-8?B?bOKAmSBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rp?=
 =?UTF-8?B?b24=?=
Date:   Tue, 14 Apr 2020 09:19:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: zoran.davidovac@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207173-28872-DjwhAi3k9z@https.bugzilla.kernel.org/>
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

--- Comment #3 from zoran.davidovac@gmail.com ---
Yes all 5.6.X (up to 4 tested) before it was while loop now there is for loop
and some other changes in kvm code vs 5.5.x kernel that compiles with same
code,
and yes always reproducible.

Standard gcc 9.2 now 9.3

https://drive.google.com/open?id=18NDMqounXy6RwNhRxTJDUizTckm7QBOR
I do not see any other way to add file except paste it encode it ?

# make bzImage
  CALL    scripts/checksyscalls.sh
  CALL    scripts/atomic/check-atomics.sh
  DESCEND  objtool
  CHK     include/generated/compile.h
  CC      arch/x86/kvm/../../../virt/kvm/kvm_main.o
arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function
‘__kvm_gfn_to_hva_cache_init’:
arch/x86/kvm/../../../virt/kvm/kvm_main.c:2236:42: error: ‘nr_pages_avail’ may
be used uninitialized in this function [-Werror=maybe-uninitialized]
 2236 |  for ( ; start_gfn <= end_gfn; start_gfn += nr_pages_avail) {
      |                                ~~~~~~~~~~^~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[2]: *** [scripts/Makefile.build:268:
arch/x86/kvm/../../../virt/kvm/kvm_main.o] Error 1
make[1]: *** [scripts/Makefile.build:505: arch/x86/kvm] Error 2
make: *** [Makefile:1683: arch/x86] Error 2
root@host:/usr/src/linux-5.6.4#

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
