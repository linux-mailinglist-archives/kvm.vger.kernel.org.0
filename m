Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054F71A8A49
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 20:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504481AbgDNSxw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 14 Apr 2020 14:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504434AbgDNSxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 14:53:50 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMDcxNzNdIGt2bSBjb21waWxpbmcgcHJvYmxlbSA1LjYu?=
 =?UTF-8?B?eCBrdm1fbWFpbi5jOjIyMzY6NDI6IGVycm9yOiDigJhucl9wYWdlc19hdmFp?=
 =?UTF-8?B?bOKAmSBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rp?=
 =?UTF-8?B?b24=?=
Date:   Tue, 14 Apr 2020 18:53:49 +0000
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
Message-ID: <bug-207173-28872-2DDfwTqXws@https.bugzilla.kernel.org/>
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

--- Comment #5 from zoran.davidovac@gmail.com ---
I've back-ported kvm and instead loop changed to while as in 5.4 
and I could compile it.

But I found what the problem is. 

In short I can compile it with -O2 , -O2 -march=native, but NOT with -O3 with
or without -march=native.
Further more in kernel menuconfig optimization I see only O2 an Os(ize) now!?

How to reproduce:
-use my config
-edit Makefile and replace -O2 to -O3 and you will get this error.


I always compile stock kernel with -O3 -march=native for servers 
and my laptop with -Ofast -march=native for ages without any problem :)

On error .kvm_main.o.cmd is not generated, thank you Sean, 
you made me look to something that I would never suspect
as I had same compile problem on server, laptop and virtual server.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
