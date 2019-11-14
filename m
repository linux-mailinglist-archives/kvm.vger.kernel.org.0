Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920B0FCABA
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 17:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKNQ0c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 14 Nov 2019 11:26:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfKNQ0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 11:26:32 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205247] Kernel panic in network code when booting Windows 10
 kvm guest
Date:   Thu, 14 Nov 2019 16:26:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: michael@weiser.dinsnail.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-205247-28872-v1Yd3tDqIO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205247-28872@https.bugzilla.kernel.org/>
References: <bug-205247-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205247

Michael Weiser (michael@weiser.dinsnail.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |michael@weiser.dinsnail.net

--- Comment #2 from Michael Weiser (michael@weiser.dinsnail.net) ---
I can confirm exactly the same error down to the backtrace and (dis-)assembly
sequence. System is Gentoo Linux with 5.3.x kernels up to .9, qemu-4.0.0 and
Windows 10 1903 and 1909 in the guest. Problem also only occurs with e1000e as
virtual NIC and disappears when switching to virtio.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
