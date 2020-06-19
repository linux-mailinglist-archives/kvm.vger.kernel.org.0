Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CDA201DFC
	for <lists+kvm@lfdr.de>; Sat, 20 Jun 2020 00:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgFSWYC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 19 Jun 2020 18:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgFSWYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 18:24:01 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208091] vcpu1, guest rIP offset ignored wrmsr or rdmsr
Date:   Fri, 19 Jun 2020 22:24:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: commandline@protonmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DOCUMENTED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-208091-28872-dsDjGRI0tr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208091-28872@https.bugzilla.kernel.org/>
References: <bug-208091-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208091

Joris L. (commandline@protonmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |DOCUMENTED

--- Comment #9 from Joris L. (commandline@protonmail.com) ---
eventually, boot time parameters resolved all of these issues, sharing in case
they matter.

iommu=pt amd_iommu=forced_isolation video=vesafb:off,efifb:off rcu_nocbs=0-15
amdgpu.runpm=0 pci=nobar,noats,big_root_window
pcie_acs_override=downstream,multifunction pcie_pme=nomsi pcie_aspm=force
pcie_ports=native

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
