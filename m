Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9D2BBEE8
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 01:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503542AbfIWXUZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 23 Sep 2019 19:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503537AbfIWXUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 19:20:24 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 204975] AMD-Vi: Command buffer timeout
Date:   Mon, 23 Sep 2019 23:20:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-204975-28872-KNWvhyPhAa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204975-28872@https.bugzilla.kernel.org/>
References: <bug-204975-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204975

Alex Williamson (alex.williamson@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alex.williamson@redhat.com

--- Comment #7 from Alex Williamson (alex.williamson@redhat.com) ---
When we get the "stuck in D3" message, it usually means that we're getting back
-1 on config space reads rather than the device is actually stuck in D3.  The
-1 return probably means the downstream bus never recovered when we issued a
secondary bus reset to perform a reset on the GPU.  This seems to be common
with AGESA updates and AFAICT indicates a hardware/firmware issue, not a kernel
issue.  As you indicate, it worked previously and started failing after BIOS
update.  This is the common story, AMD needs to fix secondary bus reset support
on their root ports.  I believe some users have had success rolling back their
BIOS to a previous release.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
