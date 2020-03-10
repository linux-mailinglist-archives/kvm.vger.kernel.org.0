Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7DB18081F
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 20:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgCJTcI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 10 Mar 2020 15:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgCJTcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 15:32:08 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206795] 4.19.108 Ryzen 1600X , kvm BUG
 kvm_mmu_set_mmio_spte_mask
Date:   Tue, 10 Mar 2020 19:32:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: thomas.lendacky@amd.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-206795-28872-VyWNXWgj2M@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206795-28872@https.bugzilla.kernel.org/>
References: <bug-206795-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206795

thomas.lendacky@amd.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |thomas.lendacky@amd.com

--- Comment #1 from thomas.lendacky@amd.com ---
Looks like the backport to the stable tree wasn't correct and I didn't notice
it when it came through my inbox. The change from the upstream form:
  kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);

to the 4.19 (and 4.14) tree should be:
  kvm_mmu_set_mmio_spte_mask(mask, mask);

Instead it was:
  kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);

which triggers the BUG_ON().

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
