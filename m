Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4844CBA4
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 12:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbfFTKTH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 20 Jun 2019 06:19:07 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58094 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbfFTKTG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jun 2019 06:19:06 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 54E7D28658
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 10:19:06 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 47BFF28653; Thu, 20 Jun 2019 10:19:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203923] Running a nested freedos on AMD Athlon i686-pae results
 in NULL pointer dereference in L0 (kvm_mmu_load)
Date:   Thu, 20 Jun 2019 10:19:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bonzini@gnu.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-203923-28872-Vohsh87wy2@https.bugzilla.kernel.org/>
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

Paolo Bonzini (bonzini@gnu.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bonzini@gnu.org

--- Comment #2 from Paolo Bonzini (bonzini@gnu.org) ---
A patch for this is on its way to Linus.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
