Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4424619F380
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 12:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgDFK1j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 6 Apr 2020 06:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgDFK1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 06:27:39 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Mon, 06 Apr 2020 10:27:37 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-206579-28872-snbnHsy6st@https.bugzilla.kernel.org/>
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

--- Comment #54 from Anthony (anthonysanwo@googlemail.com) ---
Created attachment 288227
  --> https://bugzilla.kernel.org/attachment.cgi?id=288227&action=edit
Kvm-anthony-warnings

(In reply to muncrief from comment #53)
> (In reply to Anthony from comment #52)
> > ...
> > Good news I finally managed to reproduce the same errors both in a test VM
> > and my current config.
> > ...
> 
> Whew! I'm glad someone else is able to see it as well. I was beginning to
> wonder if I was just doing something wrong.
> 
> Just to be clear though, this error occurs every time I start my VM. It
> doesn't even matter if I login to the VM, the warnings have already appeared
> by the time the login screen appears.
> 
> Anyway, as you said, hopefully your discovery that CPU pinning and
> -overcommit cpu-pm get rid of the warnings will help guide the devs to a
> solution.
> 

In terms of getting the warnings early in the boot phase. I did some more
testing today and found some more things. In terms of the warnings happening
around early in the booting phase as you described I got warnings in 8 out of
10 cases when booting and shutting down my test VM.

I also found the reason changing things like the core count/topology and
kernel_irqchip=on/off can delay were the first warning appears.

I attached my test config qemu launch args/libvirt config. As well as dmesg
although the errors are basically the same as muncrief's.

> Also, I'm feeling a bit under the weather so if I don't respond to requests
> for more info for a few days it's because I need to get some rest and get
> well. But if anyone needs anything else just let me know and I'll get on it
> as soon as possible.

Take care and hope for a speedy recovery :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
