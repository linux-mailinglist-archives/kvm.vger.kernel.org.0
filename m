Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943771C2EF1
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 21:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgECT6z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 3 May 2020 15:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728207AbgECT6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 15:58:55 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sun, 03 May 2020 19:58:54 +0000
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
Message-ID: <bug-206579-28872-aYn8djSh9y@https.bugzilla.kernel.org/>
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

Maxim Levitsky (maximlevitsky@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |maximlevitsky@gmail.com

--- Comment #63 from Maxim Levitsky (maximlevitsky@gmail.com) ---
I tried the patch from comment 55 and it works for me (3970X).

Maybe you have something disabled in the config? You need synic,'vapic' hyper-v
enlightenments disabled, and on top of that you need x2apic and svm (nested
virtualization) to be disabled in the guest cpu config. 

And you need to have PIC reinject policy to be set to 'discard'.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
