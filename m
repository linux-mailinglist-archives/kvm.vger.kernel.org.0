Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3C01BAA3C
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 18:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgD0Qpq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 27 Apr 2020 12:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgD0Qpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 12:45:46 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMDcxNzNdIGt2bSBjb21waWxpbmcgcHJvYmxlbSA1LjYu?=
 =?UTF-8?B?eCBrdm1fbWFpbi5jOjIyMzY6NDI6IGVycm9yOiDigJhucl9wYWdlc19hdmFp?=
 =?UTF-8?B?bOKAmSBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rp?=
 =?UTF-8?B?b24=?=
Date:   Mon, 27 Apr 2020 16:45:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: enhancement
X-Bugzilla-Who: sean.j.christopherson@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207173-28872-mQoB7hEDZi@https.bugzilla.kernel.org/>
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

--- Comment #9 from Sean Christopherson (sean.j.christopherson@intel.com) ---
Zeroing nr_pages_avail was proposed upstream[*] and effectively rejected
because it's unnecessary, i.e. there is no KVM bug.

[*] https://lkml.kernel.org/r/20200218184756.242904-1-oupton@google.com

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
