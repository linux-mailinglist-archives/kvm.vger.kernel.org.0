Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D38100656
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 14:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfKRNUi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 18 Nov 2019 08:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfKRNUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 08:20:38 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205441] Enabling KVM causes any Linux VM reboot on kernel boot
Date:   Mon, 18 Nov 2019 13:20:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: t.lamprecht@proxmox.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205441-28872-Hbw8VS5vd2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205441-28872@https.bugzilla.kernel.org/>
References: <bug-205441-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205441

--- Comment #4 from Thomas Lamprecht (t.lamprecht@proxmox.com) ---
This was identified[0] but the proposed backport of the fix[1] was not yet
included in the 4.19.84 kernel.

5.3 has [1] already included, so it should not show up there, if it's this
specific issue.

[0]: https://lore.kernel.org/stable/20191111173757.GB11805@linux.intel.com/
[1]:
https://lore.kernel.org/stable/20191111225423.29309-1-sean.j.christopherson@intel.com/

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
