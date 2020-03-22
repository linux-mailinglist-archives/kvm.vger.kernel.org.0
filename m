Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C2F18EBBA
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 19:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCVS6m convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 22 Mar 2020 14:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgCVS6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 14:58:42 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sun, 22 Mar 2020 18:58:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-206579-28872-pxtQa63fPG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206579-28872@https.bugzilla.kernel.org/>
References: <bug-206579-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206579

--- Comment #47 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 288009
  --> https://bugzilla.kernel.org/attachment.cgi?id=288009&action=edit
dmesg output with latest patches from Comment 46

I'm glad to see people are still working on this bug, but unfortunately the
patches from Comment 46 don't change anything on my system. I still get the
same warning messages numerous times about the "is running" bit. And it still
comes from this same instruction in svm.c : 

```
WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
```

I'm running 5.6-rc6, and the first patch was already in the code, so I just
added the trace patch for completeness. Then I rebooted and immediately ran my
VM and have attached the full dmesg output just in case there's something
unusual going on in my system that you might recognize.

Let me know if there's anything else I can do to help. I'd given up on this bug
because the several fixes I tried didn't work, and then I didn't see any
activity here so I began to wonder if the warnings were unimportant. But as I
said before they sure make the dmesg output look alarming, and it would be nice
to get rid of them even if they aren't significant. I guess I could just
comment out the line if worse comes to worse though.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
