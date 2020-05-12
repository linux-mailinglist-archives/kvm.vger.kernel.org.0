Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166641CF265
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgELKac convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 12 May 2020 06:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbgELKab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 06:30:31 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMDcxNzNdIGt2bSBjb21waWxpbmcgcHJvYmxlbSA1LjYu?=
 =?UTF-8?B?eCBrdm1fbWFpbi5jOjIyMzY6NDI6IGVycm9yOiDigJhucl9wYWdlc19hdmFp?=
 =?UTF-8?B?bOKAmSBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rp?=
 =?UTF-8?B?b24=?=
Date:   Tue, 12 May 2020 10:30:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: enhancement
X-Bugzilla-Who: mike.auty@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207173-28872-0nwj29fBoA@https.bugzilla.kernel.org/>
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

--- Comment #11 from Mike Auty (mike.auty@gmail.com) ---
I'm also experiencing this, but not on clang, on gcc-10.1.0.  The initially
proposed resolution:

gfn_t nr_pages_avail = 0; 

succeeded.  The alternative resolution:

gfn uninitialized_var(nr_pages_avail);

Needed to be changed to 

gfn_t uninitialized_var(nr_pages_avail);

but also allowed compilation.

The suggestion to mark __gfn_to_hva_many and gfn_to_hva_many as always inline
failed to resolve the problem though.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
