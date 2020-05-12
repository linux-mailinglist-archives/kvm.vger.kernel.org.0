Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE221CF8E4
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 17:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgELPUG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 12 May 2020 11:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgELPUG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 11:20:06 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207489] Kernel panic due to Lazy update IOAPIC EOI on an x86_64
 *host*, when two (or more) PCI devices from different IOMMU groups are passed
 to Windows 10 guest, upon guest boot into Windows, with more than 4 VCPUs
Date:   Tue, 12 May 2020 15:20:05 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: tomm@lime-technology.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-207489-28872-nuN5BGKekm@https.bugzilla.kernel.org/>
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

LimeTech (tomm@lime-technology.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tomm@lime-technology.com

--- Comment #15 from LimeTech (tomm@lime-technology.com) ---
Kernel 5.6.12

Win10 VM with 8 cores assigned and with a USB controller passed through. 
Trying to add a 2nd pass through device in a different IOMMU group produces
this error.

Confirmed, applying patch fixes the issue.

-- 
You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.
