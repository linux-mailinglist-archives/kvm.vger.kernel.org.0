Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E268196021
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 21:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgC0U6k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 27 Mar 2020 16:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbgC0U6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 16:58:39 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Fri, 27 Mar 2020 20:58:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ledufff@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-201753-28872-8I7XbfdyG7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201753-28872@https.bugzilla.kernel.org/>
References: <bug-201753-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201753

Neil (ledufff@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ledufff@hotmail.com

--- Comment #1 from Neil (ledufff@hotmail.com) ---
Similar finding:
[    1.144340] pci 0000:00:00.2: AMD-Vi: Unable to read/write to IOMMU perf
counter.
[    1.144456] pci 0000:00:00.2: can't derive routing for PCI INT A
[    1.144457] pci 0000:00:00.2: PCI INT A: not connected
[    1.144521] pci 0000:00:01.0: Adding to iommu group 0
[    1.144774] pci 0000:00:01.2: Adding to iommu group 1
[    1.145009] pci 0000:00:01.3: Adding to iommu group 2
[    1.145245] pci 0000:00:01.6: Adding to iommu group 3
[    1.145468] pci 0000:00:08.0: Adding to iommu group 4
[    1.145677] pci 0000:00:08.1: Adding to iommu group 5
[    1.145899] pci 0000:00:08.2: Adding to iommu group 4
[    1.145924] pci 0000:00:14.0: Adding to iommu group 6
[    1.146173] pci 0000:00:14.3: Adding to iommu group 6
[    1.146224] pci 0000:00:18.0: Adding to iommu group 7
[    1.146438] pci 0000:00:18.1: Adding to iommu group 7
[    1.146464] pci 0000:00:18.2: Adding to iommu group 7
[    1.146481] pci 0000:00:18.3: Adding to iommu group 7
[    1.146498] pci 0000:00:18.4: Adding to iommu group 7
[    1.146515] pci 0000:00:18.5: Adding to iommu group 7
[    1.146542] pci 0000:00:18.6: Adding to iommu group 7
[    1.146560] pci 0000:00:18.7: Adding to iommu group 7
[    1.146598] pci 0000:01:00.0: Adding to iommu group 8
[    1.146851] pci 0000:02:00.0: Adding to iommu group 9
[    1.147143] pci 0000:03:00.0: Adding to iommu group 10
[    1.147467] pci 0000:04:00.0: Adding to iommu group 11
[    1.147606] pci 0000:04:00.0: Using iommu direct mapping
[    1.147648] pci 0000:04:00.1: Adding to iommu group 12
[    1.147875] pci 0000:04:00.2: Adding to iommu group 12
[    1.147912] pci 0000:04:00.3: Adding to iommu group 12
[    1.147941] pci 0000:04:00.4: Adding to iommu group 12
[    1.147979] pci 0000:04:00.5: Adding to iommu group 12
[    1.148015] pci 0000:04:00.6: Adding to iommu group 12
[    1.148032] pci 0000:05:00.0: Adding to iommu group 4
[    1.148310] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    1.148311] pci 0000:00:00.2: AMD-Vi: Extended features (0x4f77ef22294ada):
[    1.148312]  PPR NX GT IA GA PC GA_vAPIC

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
