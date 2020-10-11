Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D7028A972
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 20:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgJKSro convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 11 Oct 2020 14:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727610AbgJKSro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Oct 2020 14:47:44 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 203477] [AMD][KVM] Windows L1 guest becomes extremely slow and
 unusable after enabling Hyper-V
Date:   Sun, 11 Oct 2020 18:47:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: luoyonggang@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-203477-28872-z3BrEJ2VHS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203477-28872@https.bugzilla.kernel.org/>
References: <bug-203477-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203477

Yonggang Luo (luoyonggang@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |luoyonggang@gmail.com

--- Comment #5 from Yonggang Luo (luoyonggang@gmail.com) ---
I have the same problem on a Ryzen 3950x, are this a problem in kvm or in
windows guest or in qemu?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
