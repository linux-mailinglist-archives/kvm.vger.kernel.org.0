Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2DB4F960
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2019 02:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfFWAW5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 22 Jun 2019 20:22:57 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36780 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbfFWAW5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 22 Jun 2019 20:22:57 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F2B0928B6E
        for <kvm@vger.kernel.org>; Sun, 23 Jun 2019 00:22:56 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id E73F528B8A; Sun, 23 Jun 2019 00:22:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203957] New: AGESA 0.0.7.2. based BIOS update broke IOMMU
 redirection
Date:   Sun, 23 Jun 2019 00:22:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: anjan@momi.ca
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-203957-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203957

            Bug ID: 203957
           Summary: AGESA 0.0.7.2. based BIOS update broke IOMMU
                    redirection
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.1.12
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: anjan@momi.ca
        Regression: No

Created attachment 283395
  --> https://bugzilla.kernel.org/attachment.cgi?id=283395&action=edit
pci patch that fixes pci passthrough for newer AMD Bios

Hello,

I am using a "AMD Ryzen 7 1700" on a "GA-AX370-Gaming 5". I recently updated to
the latest BIOS from an older BIOS. Updating my bios broke PCI passthrough.

Everytime I would try to start my virtual machine from virt-manager, I would
get "Unknown PCI header type '127'" and my virtual machines would refuse to
boot.

It seems this is a common issue:
1.
https://forum.manjaro.org/t/solved-agesa-0-0-7-2-based-bios-update-broke-iommu-redirection/88909

2. https://www.reddit.com/r/Amd/comments/bh3qqz/agesa_0072_pci_quirk/

However, following the solution in thread 1, I was able to fix pci passthrough.

I simply applied this patch:
https://clbin.com/VCiYJ

to kernel 5.1.12 and it fixed PCI passthrough. This patch is also attached to
this bug as a mirror.

It would be great if this patch could get merged into upstream. Please let me
know if I can provide any further information or assist in any way to make this
happen.

Thank you.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
