Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB871F07FB
	for <lists+kvm@lfdr.de>; Sat,  6 Jun 2020 19:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgFFRJ2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 6 Jun 2020 13:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgFFRJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jun 2020 13:09:28 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208091] New: vcpu1, guest rIP offset ignored wrmsr or rdmsr
Date:   Sat, 06 Jun 2020 17:09:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: commandline@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-208091-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 208091
           Summary: vcpu1, guest rIP offset ignored wrmsr or rdmsr
           Product: Virtualization
           Version: unspecified
    Kernel Version: Linux pvx 5.4.41-1-pve #1 SMP PVE 5.4.41-1 (Fri, 15
                    May 2020 15:06:08 +0200) x86_64 GNU/Linux
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: commandline@protonmail.com
        Regression: No

On launch of VM these messages are generated. Filing this report since hinted
at a reason for improvement such as for patch 7670771. First ever report, sorry
if violating any good habits.



pvx kernel: [   77.102686] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x3a
pvx kernel: [   77.102712] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0xd90
pvx kernel: [   77.102736] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x570
pvx kernel: [   77.102755] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x571
pvx kernel: [   77.102773] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x572
pvx kernel: [   77.102792] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x560
pvx kernel: [   77.102811] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x561
pvx kernel: [   77.102829] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x580
pvx kernel: [   77.102847] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x581
pvx kernel: [   77.102866] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x582

pvx kernel: [   77.102686] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x3a
pvx kernel: [   77.102712] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0xd90
pvx kernel: [   77.102736] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x570
pvx kernel: [   77.102755] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x571
pvx kernel: [   77.102773] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x572
pvx kernel: [   77.102792] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x560
pvx kernel: [   77.102811] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x561
pvx kernel: [   77.102829] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x580
pvx kernel: [   77.102847] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x581
pvx kernel: [   77.102866] kvm [3464]: vcpu1, guest rIP: 0xffffffff8666b9e4
ignored rdmsr: 0x582

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
