Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5250B1729B4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 21:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgB0Uue convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 27 Feb 2020 15:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgB0Uue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 15:50:34 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Thu, 27 Feb 2020 20:50:32 +0000
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
Message-ID: <bug-206579-28872-cLmQoq4vnE@https.bugzilla.kernel.org/>
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

--- Comment #27 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 287667
  --> https://bugzilla.kernel.org/attachment.cgi?id=287667&action=edit
avic_inhibit_reasons debug information

Oh, that was so cool Suravee!

I applied the initial svm.c and debug patch and tested both host-passthrough
and EPYC-IBPB configurations, and avic failed with both.

With host-passthrough the avic_inhibit_reasons value immediately changed from 0
to 20, and then a few seconds later changed to 28.

With the EPYC-IBPB the avic_inhibit_reasons value immediately changed from 0 to
16, and then a few seconds later changed to 24.

I wanted to give you as much accurate information as possible so I attached the
avic_inhibit_reason values, my physical machine and domain capabilities, and
the command lines and XML files used in the tests for each configuration to
this comment.

By the way, I ran multiple tests with both configurations. I used the defaults,
then explicit 1-8-2 topology, and with host-passthrough I removed the cache
passthrough and VM hiding. I also ran all tests again using the second
variation of the svm.c patch. Unfortunately nothing changed the avic failure
though.

I hope this information helps, and am looking forward to assisting you
gentlemen further in any way possible.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
