Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195CA5B24A
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 01:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfF3XDM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 30 Jun 2019 19:03:12 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44958 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbfF3XDM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 30 Jun 2019 19:03:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 986A928511
        for <kvm@vger.kernel.org>; Sun, 30 Jun 2019 23:03:11 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 8A250284ED; Sun, 30 Jun 2019 23:03:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203979] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD i686-pae
Date:   Sun, 30 Jun 2019 23:03:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jpalecek@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-203979-28872-Zy5CFsTk5r@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203979-28872@https.bugzilla.kernel.org/>
References: <bug-203979-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203979

Jiri Palecek (jpalecek@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |karahmed@amazon.de

--- Comment #1 from Jiri Palecek (jpalecek@web.de) ---
So, I have bisected this and found the culprit to be:

commit 8c5fbf1a723107814c20c3f4d6343ab9d694a705 (refs/bisect/bad)
Author: KarimAllah Ahmed <karahmed@amazon.de>
Date:   Thu Jan 31 21:24:40 2019 +0100

    KVM/nSVM: Use the new mapping API for mapping guest memory

    Use the new mapping API for mapping guest memory to avoid depending on
    "struct page".

    Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
    Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
