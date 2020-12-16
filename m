Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43B82DC980
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 00:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbgLPXQL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 16 Dec 2020 18:16:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730759AbgLPXQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 18:16:11 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 210695] error: kvm run failed Invalid argument
Date:   Wed, 16 Dec 2020 23:14:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rherbert@sympatico.ca
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210695-28872-gZNimuHes6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210695-28872@https.bugzilla.kernel.org/>
References: <bug-210695-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210695

--- Comment #6 from Richard Herbert (rherbert@sympatico.ca) ---
Hi, Sean.

Thanks for the patch.  I applied it and recompiled kernel 5.10.1. Qemu still
crashes, but the output is slightly different.

Not sure if this has anything to do with it:

dmesg | grep -i mmu

[    0.301060] pci 0000:00:00.0: DMAR: Disabling IOMMU for graphics on this
chipset

Thanks again.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
