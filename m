Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8503D1C57
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 01:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbfJIXBB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 9 Oct 2019 19:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731140AbfJIXBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 19:01:01 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205151] New: "user requested TSC rate below hardware speed"
 warning
Date:   Wed, 09 Oct 2019 23:01:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: v.zubkov87@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-205151-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205151

            Bug ID: 205151
           Summary: "user requested TSC rate below hardware speed" warning
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.3
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: v.zubkov87@gmail.com
        Regression: Yes

5.3 seems to have broken TSC, at least for qemu/kvm VMs. After 5.3 upgrade
starting a VM gets me "user requested TSC rate below hardware speed" warnings
(1 per assigned core).

I'm not quite sure when kind of data I could provide, however after a short
while (several minutes) drift becomes quite noticable (severe audio/video
desync).

Relevant(?) dmesg entries from 5.3:
[Sun Oct  6 16:59:21 2019] tsc: Detected 4000.000 MHz processor
[Sun Oct  6 16:59:21 2019] tsc: Detected 3999.984 MHz TSC
[Sun Oct  6 16:59:22 2019] tsc: Refined TSC clocksource calibration: 4008.064
MHz
[Sun Oct  6 17:00:48 2019] user requested TSC rate below hardware speed
[Sun Oct  6 17:00:48 2019] user requested TSC rate below hardware speed

And 5.2:
[Thu Oct  3 21:56:01 2019] tsc: Detected 4000.000 MHz processor
[Thu Oct  3 21:56:01 2019] tsc: Detected 4008.000 MHz TSC
(no refined calibration here)

My CPU is Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz (family: 0x6, model: 0x5e,
stepping: 0x3).

Revering commit 604dc9170f2435d27da5039a3efd757dceadc684 fixes the problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
