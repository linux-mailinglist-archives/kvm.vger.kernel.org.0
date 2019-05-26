Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA712A990
	for <lists+kvm@lfdr.de>; Sun, 26 May 2019 14:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfEZMLg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 26 May 2019 08:11:36 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44016 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbfEZMLf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 26 May 2019 08:11:35 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1BD9F28AAC
        for <kvm@vger.kernel.org>; Sun, 26 May 2019 12:11:35 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 091C428AC0; Sun, 26 May 2019 12:11:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Date:   Sun, 26 May 2019 12:11:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: dhill@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203543-28872-wQMaF5mPIZ@https.bugzilla.kernel.org/>
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

--- Comment #15 from dhill@redhat.com ---
You are right actually.   I did a mistake in my code and it didn't pull 
v5.2-rc1 ... I was still on v5.1.x tag so that's why it didn't work.

I guess this is issue is solved and if I hit any bugs with v5.2-rc1 it'd 
be a new issue since we reverted that commit.

On 2019-05-21 2:06 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=203543
>
> --- Comment #14 from Sean Christopherson (sean.j.christopherson@intel.com)
> ---
> I've verified reverting f93f7ede087f and e51bfdb68725 yields the exact same
> code as v5.2-rc1.  Can you please sanity check that v5.2-rc1 is indeed
> broken?
> E.g. ensure there are no modified files when compiling and include the git
> commit id in the kernel name.
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
