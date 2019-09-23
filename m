Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AAEBBEC2
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 01:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407847AbfIWXG7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 23 Sep 2019 19:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbfIWXG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 19:06:59 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 204975] New: AMD-Vi: Command buffer timeout
Date:   Mon, 23 Sep 2019 23:06:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: sss123next@list.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-204975-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 204975
           Summary: AMD-Vi: Command buffer timeout
           Product: Virtualization
           Version: unspecified
    Kernel Version: 4.19.75
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: sss123next@list.ru
        Regression: No

Created attachment 285127
  --> https://bugzilla.kernel.org/attachment.cgi?id=285127&action=edit
dmesg fragment with error

i have "ASRock X470 Gaming K4" motherboard, and using pci-passthrough for
sometime already, working fine on bios version 1.90, had some troubles, but
working overall, unfortunately i decided to update bios to latest versions
(3.40, 3.50), and pci-passthrough stopped work at all, i guess problem rerlated
to new "AMD AGESA Combo-AM4 1.0.0.3", a little searching over internet confirms
what it's common problem across different boards, i do not know exactly is it
amd bug, kvm, bug, or kernel bug, i have already reported problem to board
manufacturer.

in console i get something like "vfio: cannot power on device, stuck in D3"
from qemu.

also a lot of warnings in dmesg (see attachments).

device still visible in lspci, but looks completely unresponsive.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
