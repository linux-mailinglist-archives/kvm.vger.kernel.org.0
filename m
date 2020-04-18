Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB8F1AF5D9
	for <lists+kvm@lfdr.de>; Sun, 19 Apr 2020 01:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgDRXUA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 18 Apr 2020 19:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbgDRXUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Apr 2020 19:20:00 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sat, 18 Apr 2020 23:19:59 +0000
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
Message-ID: <bug-206579-28872-Af8lNcEUq4@https.bugzilla.kernel.org/>
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

--- Comment #60 from Anthony (anthonysanwo@googlemail.com) ---
To add hiding cpu id hypervisor seems to also cause it to not work well.
Windows also generally don't perform as well when hiding the hypervisor CPU id
on Ryzen.

Using top we see high activity in avic_vcpu_put.part.0 & avic_vcpu_load
functions and near-zero to zero activity with svm_deliver_avic_intr function.
Which suggests AVIC isn't working correctly if my sight understanding of
svm_deliver_avic_intr function is correct.

Haven't looked to in-depth but I would guess SVM/AVIC uses hypervisor cpuid as
check? to apply its optimizations or something along those lines.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
