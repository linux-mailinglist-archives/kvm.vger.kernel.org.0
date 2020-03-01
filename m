Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7481174C0C
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 07:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgCAG1C convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 1 Mar 2020 01:27:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgCAG1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 01:27:02 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sun, 01 Mar 2020 06:27:00 +0000
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
Message-ID: <bug-206579-28872-eWDdAv2F2V@https.bugzilla.kernel.org/>
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

--- Comment #42 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 287723
  --> https://bugzilla.kernel.org/attachment.cgi?id=287723&action=edit
Many "WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);" warnings

Oh sheesh gentlemen. I'd grepped dmesg for "error" after getting avic working,
but when I went to check out the latest git to see if automount was fixed and
manually browsed through dmesg I discovered a bunch of KVM warnings. So I went
back and checked rc3 and they're there as well. I've attached the dmesg output
from the latest git since I figure that's what you're working with.

They're coming from the svm.c "avic_vcpu_load" function. Here's the statement:
```
        WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
```
The function continues after the warning, and I've tested the VM pretty
thoroughly now and haven't discovered any problems, so of course as usual I
have no idea what the heck is going on :)

Anyway, I just thought I'd let you know and if you want me to help debug it I'd
be happy to. It would be nice to get rid of them though because it makes the
dmesg output look really scary! :) Seriously though, many people would assume
they're errors because of the way they display.

By the way, avic works without any patches with today's git. I saw part of the
patch created here was there, and part wasn't, so I just compiled git without
patches and it seems to work fine. And automount is fixed! Yay!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
