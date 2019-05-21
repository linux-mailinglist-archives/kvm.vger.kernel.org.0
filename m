Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C98251BA
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 16:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfEUORg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 21 May 2019 10:17:36 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53132 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbfEUORg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 May 2019 10:17:36 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9CC1F28B93
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 14:17:35 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 9B25628BA3; Tue, 21 May 2019 14:17:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Date:   Tue, 21 May 2019 14:17:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: sean.j.christopherson@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203543-28872-UFNAaEsGCn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203543-28872@https.bugzilla.kernel.org/>
References: <bug-203543-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203543

--- Comment #11 from Sean Christopherson (sean.j.christopherson@intel.com) ---
On Tue, May 21, 2019 at 07:11:01AM -0700, Sean Christopherson wrote:
> On Tue, May 21, 2019 at 01:37:42PM +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=203543
> > 
> > --- Comment #10 from moi@davidchill.ca ---
> > Reverting both commits solves this problem:
> > 
> > f93f7ede087f2edcc18e4b02310df5749a6b5a61
> > e51bfdb68725dc052d16241ace40ea3140f938aa
> 
> Hmm, that makes no sense, f93f7ede087f is a straight revert of
> e51bfdb68725.  I do see the same behavior on v5.2-rc1 where hiding the
> pmu from L1 breaks nested virtualization, but manually reverting both
> commits doesn't change that for me, i.e. there's another bug lurking,
> which I'll start hunting.

Scratch that, had a brain fart and tested the wrong kernel.  I do *NOT*
see breakage on v5.2-rc1, at least when running v5.2-rc1 as L1 and probing
KVM in L2.

When running v5.2-rc1 as L0, what are the values of MSRs 0x482 and 0x48e
in L1?

> 
> Any chance the successful test used a different command line or something?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
