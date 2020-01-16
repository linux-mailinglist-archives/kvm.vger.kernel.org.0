Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDF213D194
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 02:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgAPBga convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 15 Jan 2020 20:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729195AbgAPBga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 20:36:30 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206215] QEMU guest crash due to random 'general protection
 fault' since kernel 5.2.5 on i7-3517UE
Date:   Thu, 16 Jan 2020 01:36:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: kernel@najdan.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206215-28872-Oa24nnXTGv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206215-28872@https.bugzilla.kernel.org/>
References: <bug-206215-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206215

--- Comment #4 from kernel@najdan.com ---
(In reply to derek from comment #3)
> On 1/15/20 4:52 PM, Sean Christopherson wrote:
> > +cc Derek, who is hitting the same thing.
> >
> > On Wed, Jan 15, 2020 at 09:18:56PM +0000,
> bugzilla-daemon@bugzilla.kernel.org
> > wrote:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=206215
> > *snip*
> > that's a big smoking gun pointing at commit ca7e6b286333 ("KVM: X86: Fix
> > fpu state crash in kvm guest"), which is commit e751732486eb upstream.
> >
> > 1. Can you verify reverting ca7e6b286333 (or e751732486eb in upstream)
> >     solves the issue?
> >
> > 2. Assuming the answer is yes, on a buggy kernel, can you run with the
> >     attached patch to try get debug info?
> I did these out of order since I had 5.3.11 built with the patch, ready to
> go

Sean,
I'm not familiar with rebuilding the kernel, nor applying a patch but I'm
working on it right now so I can provide feedback.

> for weeks now, waiting for an opportunity to test.
> 
> Win10 guest immediately BSOD'ed with:
> 
> WARNING: CPU: 2 PID: 9296 at include/linux/thread_info.h:55 
> kernel_fpu_begin+0x6b/0xc0
> 
> Then stashed the patch, reverted ca7e6b286333, compile, reboot.
> 
> Guest is running stable now on 5.3.11. Did test my CAD under the guest, did
> not 
> experience the crashes that had me stuck at 5.1.

> I did these out of order since I had 5.3.11 built with the patch, ready to
> go 
> for weeks now, waiting for an opportunity to test.
> 
> Win10 guest immediately BSOD'ed with:
> 
> WARNING: CPU: 2 PID: 9296 at include/linux/thread_info.h:55 
> kernel_fpu_begin+0x6b/0xc0
> 
> Then stashed the patch, reverted ca7e6b286333, compile, reboot.
> 
> Guest is running stable now on 5.3.11. Did test my CAD under the guest, did
> not 
> experience the crashes that had me stuck at 5.1.

Derek,

Thanks for the update.

I'm still curious about the hypervisor CPU model you have.

On Windows I did exprecience a different behavior though.
The OS did boot but the spice/VNC screen did freeze randomly.
One of my windows VM did end up being corrupted as an update ehich tried to
install just failed miserably.

Anyways, I will try to provide debug details asap from the patch that Sean
provided...

To be continued ...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
