Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B521C2A89
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 09:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgECH1E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 3 May 2020 03:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgECH1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 03:27:03 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207489] Kernel panic due to Lazy update IOAPIC EOI on an x86_64
 *host*, when two (or more) PCI devices from different IOMMU groups are passed
 to Windows 10 guest, upon guest boot into Windows, with more than 4 VCPUs
Date:   Sun, 03 May 2020 07:27:02 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: harn-solo@gmx.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-207489-28872-FV04sfeXtk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207489-28872@https.bugzilla.kernel.org/>
References: <bug-207489-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207489

Michael Long (harn-solo@gmx.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |harn-solo@gmx.de

--- Comment #10 from Michael Long (harn-solo@gmx.de) ---
*** Bug 207541 has been marked as a duplicate of this bug. ***

-- 
You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.
