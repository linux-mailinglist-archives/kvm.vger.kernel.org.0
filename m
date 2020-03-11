Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1FE181C20
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 16:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgCKPOZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 11 Mar 2020 11:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbgCKPOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 11:14:25 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206795] 4.19.108 Ryzen 1600X , kvm BUG
 kvm_mmu_set_mmio_spte_mask
Date:   Wed, 11 Mar 2020 15:14:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: hvtaifwkbgefbaei@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-206795-28872-EjzgoWJ0E4@https.bugzilla.kernel.org/>
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

Sami Farin (hvtaifwkbgefbaei@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #4 from Sami Farin (hvtaifwkbgefbaei@gmail.com) ---
4.19.109 was already released and I rebooted it with your fix in comment #1 ,
qemu works OK.

[   32.839932] kvm: Nested Virtualization enabled
[   32.839939] kvm: Nested Paging enabled
[   32.839940] SVM: Virtual VMLOAD VMSAVE supported
[   32.839940] SVM: Virtual GIF supported

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
