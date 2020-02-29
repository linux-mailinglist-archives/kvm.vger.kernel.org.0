Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF04A17457B
	for <lists+kvm@lfdr.de>; Sat, 29 Feb 2020 08:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgB2HCx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 29 Feb 2020 02:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgB2HCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Feb 2020 02:02:53 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sat, 29 Feb 2020 07:02:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: anthonysanwo@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-fxqSiKDZJJ@https.bugzilla.kernel.org/>
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

--- Comment #39 from Anthony (anthonysanwo@googlemail.com) ---
(In reply to muncrief from comment #38)
> (In reply to Anthony from comment #37)
> > ... I just wanted to check if I am missing anything on my side as I am not
> 100% sure on how to tell avic is working looking a trace, perf stat/live. ... 
> 
> You can tell if avic is working by executing "perf kvm stat live" and then
> looking for "avic_incomplete_ipi" and "avic_unaccelerated_" in the VM-EXIT
> column. If it's not working you'll see "vintr" instead.
> 
> By the way the way "avic_unaccelerated_" is actually
> "avic_unaccelerated_access" in the code but evidently it gets truncated in
> the perf command output.

Oh if that's the case then my understanding has just been poor as I assumed the
kvm_apicv_update_request counter should be higher to show the times where apicv
has been activated and deactivated which should also be reflected in a trace.
At least that is what it reads like to me reading this patch -
https://lore.kernel.org/patchwork/patch/1153605/

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
