Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50CF19E50C
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 14:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgDDM5f convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 4 Apr 2020 08:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgDDM5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 08:57:35 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sat, 04 Apr 2020 12:57:34 +0000
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
Message-ID: <bug-206579-28872-YgcRzaq1EB@https.bugzilla.kernel.org/>
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

--- Comment #49 from Anthony (anthonysanwo@googlemail.com) ---
Just wanted to share my experience also with trying to replicate muncrief's
issue. So far I haven't had any luck reproducing the issue with my config
either using a Windows 10/Linux Guest. 

Suravee Suthikulpanit just a quick question. Since my previous comment I have
gotten some better understanding and found ways to tell for sure AVIC is
working. On that note in Windows I can't seem to get IOMMU AVIC working testing
different configurations but SVM AVIC works great.

Using perf kvm --host top -p `pidof qemu-system-x86_64`

On Linux -    
0.12%  [kvm_amd]  [k] avic_vcpu_put.part.0
   0.10%  [kvm_amd]  [k] avic_vcpu_load
   0.02%  [kvm_amd]  [k] avic_incomplete_ipi_interception
   0.01%  [kvm_amd]  [k] svm_deliver_avic_intr

   2.83%  [kernel]  [k] iommu_completion_wait
   0.87%  [kernel]  [k] __iommu_queue_command_sync
   0.16%  [kernel]  [k] amd_iommu_update_ga
   0.03%  [kernel]  [k] iommu_flush_irt

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
