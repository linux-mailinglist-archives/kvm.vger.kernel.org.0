Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DEC19E74F
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 21:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgDDTYF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 4 Apr 2020 15:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgDDTYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 15:24:05 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sat, 04 Apr 2020 19:24:04 +0000
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
Message-ID: <bug-206579-28872-vyqG6XjiTD@https.bugzilla.kernel.org/>
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

--- Comment #51 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 288207
  --> https://bugzilla.kernel.org/attachment.cgi?id=288207&action=edit
Latest KVM warnings information

Okay gentlemen, here is an archive with all the latest information I have for
the continued KVM warnings. To make things as clean as possible I did a clean
compile of kernel 5.6.0 from the torvalds git. As before the first KVM patch
was already in the kernel, and I manually checked the source file just to be
sure. And the second KVM patch applied cleanly. However I included both patches
so you can check to make sure they're correct. Here's a quick description of
the four files in the archive:

dmesg_kvm_warnings.txt - Full dmesg output after a reboot, and then starting
and logging into the VM.

Win10-1_UEFI.xml - The VM XML.

kvm_1.patch - The first KVM patch, which is now already in the kernel


kvm_2.patch - The second KVM patch that applied cleanly to the kernel.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
