Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8DD24A4B3
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 17:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbfFRPDd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 18 Jun 2019 11:03:33 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50352 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727105AbfFRPDd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jun 2019 11:03:33 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7574C28B17
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 15:03:32 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 67B3228ADD; Tue, 18 Jun 2019 15:03:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203923] Running a nested freedos on AMD Athlon i686-pae results
 in NULL pointer dereference in L0 (kvm_mmu_load)
Date:   Tue, 18 Jun 2019 15:03:31 +0000
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
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-203923-28872-HSaz3ZT6oh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203923-28872@https.bugzilla.kernel.org/>
References: <bug-203923-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203923

Jiri Palecek (jpalecek@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Running a nested freedos    |Running a nested freedos on
                   |results in NULL pointer     |AMD Athlon i686-pae results
                   |dereference in L0           |in NULL pointer dereference
                   |(kvm_mmu_load)              |in L0 (kvm_mmu_load)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
