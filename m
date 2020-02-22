Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87229168AE7
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 01:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgBVAVd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 21 Feb 2020 19:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgBVAVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 19:21:33 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sat, 22 Feb 2020 00:21:32 +0000
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
Message-ID: <bug-206579-28872-ZR0HXjhAVX@https.bugzilla.kernel.org/>
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

--- Comment #7 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 287549
  --> https://bugzilla.kernel.org/attachment.cgi?id=287549&action=edit
KVM crash at boot with two test patched

Unfortunately with the two test patches KVM crashes at boot now. And though the
libvirtd status was good, virt-manager couldn't connect and nothing would run.

I noticed an odd APIC warning in dmesg about conflicting address space
surrounding some nvidia stuff though, and wondered if that had anything to do
with it. So I uninstalled rc6 and the Tk-Glitch nvidia-dkms drivers I had to
use for rc6, and reinstalled the normal nvidia-dkms drivers. But the dmesg
warning is still present with my working 5.5.4 kernel, and my VM runs great, so
I don't think that has anything to do with it.

Nevertheless I'm attaching the full dmesg output I got at boot.

I'll be up for another few hours so if you need anymore help today I'll get
right on it. My son is getting married tomorrow though so I won't be available,
but from Sunday on I'll be back online.

Thanks for all your help gentlemen!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
