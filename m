Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1951F2E6CED
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 02:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgL2BBX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 28 Dec 2020 20:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729721AbgL2BBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Dec 2020 20:01:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0F5F422262
        for <kvm@vger.kernel.org>; Tue, 29 Dec 2020 01:00:43 +0000 (UTC)
Received: by pdx-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0B31B81645; Tue, 29 Dec 2020 01:00:43 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 202055] Failed to PCI passthrough SSD with SMI SM2262
 controller.
Date:   Tue, 29 Dec 2020 01:00:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: plantroon@plantroon.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-202055-28872-iWEAei1MNX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202055-28872@https.bugzilla.kernel.org/>
References: <bug-202055-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202055

plantroon@plantroon.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |plantroon@plantroon.com

--- Comment #48 from plantroon@plantroon.com ---
For Intel SSD 660p series, the latest firmware is required for pass-through to
work without issues. The latest one should be from mid 2020 at the time of
writing this.

Not even any workarounds or special settings for qemu/libvirt are needed, just
a simple pass-through setup as with any other PCIe device.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.
