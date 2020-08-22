Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8874524E7ED
	for <lists+kvm@lfdr.de>; Sat, 22 Aug 2020 16:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgHVOep convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 22 Aug 2020 10:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbgHVOep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Aug 2020 10:34:45 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207489] Kernel panic due to Lazy update IOAPIC EOI on an x86_64
 *host*, when two (or more) PCI devices from different IOMMU groups are passed
 to Windows 10 guest, upon guest boot into Windows, with more than 4 VCPUs
Date:   Sat, 22 Aug 2020 14:34:44 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: linux-kernel@polvanaubel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-207489-28872-v1dvB2OQhf@https.bugzilla.kernel.org/>
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

Pol Van Aubel (linux-kernel@polvanaubel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|5.5.0-07987-gf458d039db7e,  |5.5.0-07987-gf458d039db7e,
                   |5.6 up to and including     |5.6, and v5.7-rc4. Fixed in
                   |5.6.8                       |v5.7-rc5 and beyond.

-- 
You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.
