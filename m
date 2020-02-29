Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABDA41748ED
	for <lists+kvm@lfdr.de>; Sat, 29 Feb 2020 20:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgB2Tns convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 29 Feb 2020 14:43:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgB2Tns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Feb 2020 14:43:48 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sat, 29 Feb 2020 19:43:47 +0000
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
Message-ID: <bug-206579-28872-CiGKUk8y6Q@https.bugzilla.kernel.org/>
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

--- Comment #41 from Anthony (anthonysanwo@googlemail.com) ---
(In reply to muncrief from comment #40)
> (In reply to Anthony from comment #39)
> > (In reply to muncrief from comment #38)
> > > (In reply to Anthony from comment #37)
> > ... Oh if that's the case then my understanding has just been poor as I
> assumed
> > the kvm_apicv_update_request counter should be higher to show the times
> > where apicv has been activated and deactivated which should also be
> > reflected in a trace. At least that is what it reads like to me reading
> this
> > patch - https://lore.kernel.org/patchwork/patch/1153605/
> 
> I took a look at that just out of curiosity Anthony but unfortunately I
> don't know anything about the Linux kernel code, I've just been following
> along with the devs as best I can. I'm simply a retired
> hardware/firmware/software designer from the olden days. And by "olden" I
> mean before Linux, and even things like CGA graphics, existed :)
> 
> I was just passing along what I learned from Suravee, and some cursory
> observation of tiny related code segments. All I was ever able to accomplish
> was a partial understanding of the first 5 bits of the avic_inhibit_reasons
> output :)
> 
> Your question is an interesting one though, I wasn't even aware that a
> request counter existed!

Woah that's quite the background you got there :)
For me I have just done some basic programming in my life and just try to piece
things together as I go along.
The only reason I asked was because if I recall correctly in earlier patchsets
the debugging interface for apicv was different and the counter(probably not
the correct term) that showed apicv activity had more updates when it was
working. Although given it's changed since then am not sure how it's meant to
work now. 

Below is a sample of the output when you enable the trace -

"echo 1 >/sys/kernel/debug/tracing/events/kvm/kvm_apicv_update_request/enable"

Then to see the output

"cat /sys/kernel/debug/tracing/trace_pipe"

           <...>-211863 [000] .... 22493.097745: kvm_apicv_update_request:
deactivate bit=4
           <...>-211863 [000] .... 22493.097818: kvm_apicv_update_request:
activate bit=4

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
