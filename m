Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2A310E4E5
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 04:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfLBDmv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 1 Dec 2019 22:42:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbfLBDmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Dec 2019 22:42:51 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Date:   Mon, 02 Dec 2019 03:42:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: hilld@binarystorm.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203543-28872-qLKLDKcfa1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203543-28872@https.bugzilla.kernel.org/>
References: <bug-203543-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203543

--- Comment #19 from David Hill (hilld@binarystorm.net) ---
v5.3.14 appears to be working too ... if I login another VM, I do get the same
error message:

[root@overcloud-compute-0 ~]# modprobe kvm_intel
modprobe: ERROR: could not insert 'kvm_intel': Input/output error



(undercloud) [stack@undercloud-0-rhosp13 ~]$ sudo lsmod | grep kvm
kvm_intel             188688  0 
kvm                   636931  1 kvm_intel
irqbypass              13503  1 kvm

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
