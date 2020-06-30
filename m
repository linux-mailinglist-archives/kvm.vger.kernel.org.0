Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E78D20F653
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 15:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732164AbgF3NxV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 30 Jun 2020 09:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388655AbgF3NxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 09:53:12 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207389] Regression in nested SVM from 5.7-rc1, starting L2
 guest locks up L1
Date:   Tue, 30 Jun 2020 13:53:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: maximlevitsky@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-207389-28872-aOhmyeGFTI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207389-28872@https.bugzilla.kernel.org/>
References: <bug-207389-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207389

Maxim Levitsky (maximlevitsky@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |maximlevitsky@gmail.com

--- Comment #3 from Maxim Levitsky (maximlevitsky@gmail.com) ---
5.7 kernel has several nested virtualization issues that mostly make it
useless, but good news are that all of this was fixed, and 5.8 kernel should
contain all the fixes.

On my machine I am able even to run even windows 10 nested (mostly for fun,
don't need it), I can play (a bit slow but works) some linux games in nested
VM, with virtio-gpu on top of virtio-gpu, and I was even able to run a win98 VM
nested on KVM, and it works as good as it works non nested (has bunch of issues
that probably will never get fixed sadly).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
