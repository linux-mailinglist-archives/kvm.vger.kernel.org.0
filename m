Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18D019E513
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 15:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgDDNCy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 4 Apr 2020 09:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbgDDNCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 09:02:54 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sat, 04 Apr 2020 13:02:53 +0000
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
Message-ID: <bug-206579-28872-kZn4kZkK66@https.bugzilla.kernel.org/>
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

--- Comment #50 from Anthony (anthonysanwo@googlemail.com) ---

On Windows -

   0.61%  [kvm_amd]  [k] svm_deliver_avic_intr
   0.05%  [kvm_amd]  [k] avic_vcpu_put.part.0
   0.02%  [kvm_amd]  [k] avic_vcpu_load
   0.14%  [kvm]      [k] kvm_emulate_wrmsr     

Looking around that should that IOMMU was working in Linux as intended when
combined with looking at proc/interrupts and seeing interrupts when being
handled by AMD-Vi and not IRQ counters for the PCI devices I passed through.

I was working is there a difference in how Windows/Hyper-V handles IOMMU AVIC
or am I missing something that could be disabling it being activate?  

Sorry for the double comment i mistakenly submitted my first comment midway
typing my full reply.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
