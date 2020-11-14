Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFD72B2DFF
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 16:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgKNP2w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 14 Nov 2020 10:28:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbgKNP2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Nov 2020 10:28:52 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 210197] New: qemu: freezes host X server, if spice gl enabled
Date:   Sat, 14 Nov 2020 15:28:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ne-vlezay80@yandex.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-210197-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210197

            Bug ID: 210197
           Summary: qemu: freezes host X server, if spice gl enabled
           Product: Virtualization
           Version: unspecified
    Kernel Version: 4.19.0-5-amd64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ne-vlezay80@yandex.ru
        Regression: No

Kernel log:
[13555.138319] nouveau 0000:01:00.0: fifo: fault 00 [READ] at 000000707508d000
engine 00 [GR] client 0d [GPC0/GCC] reason 00 [PDE] on channel 9 [003f83b000
qemu-system-x86[8502]]
[13555.138330] nouveau 0000:01:00.0: fifo: channel 9: killed
[13555.138331] nouveau 0000:01:00.0: fifo: runlist 0: scheduled for recovery
[13555.138334] nouveau 0000:01:00.0: fifo: engine 0: scheduled for recovery
[13555.138340] nouveau 0000:01:00.0: fifo: engine 6: scheduled for recovery
[13555.138345] nouveau 0000:01:00.0: qemu-system-x86[8502]: channel 9 killed!
[13602.883360] sysrq: SysRq : SAK
[13602.883401] tty tty7: SAK: killed process 1025 (Xorg): by session
[13602.883539] tty tty7: SAK: killed process 1025 (Xorg): by controlling tty
[13602.883542] tty tty7: SAK: killed process 1051 (Xorg:disk$0): by controlling
tty
[13602.883545] tty tty7: SAK: killed process 1054 (InputThread): by controlling
tty
[13602.937287] Chrome_~dThread[2240]: segfault at 0 ip 00007f3588b21d9f sp
00007f3586f7ead0 error 6 in libxul.so[7f3588b0e000+3a35000]
[13602.937300] Code: 15 1e a2 60 04 48 89 10 c7 04 25 00 00 00 00 d4 08 00 00
e8 fb 77 ff ff 90 48 8b 05 0b 39 9e 05 48 8d 0d 64 a2 60 04 48 89 08 <c7> 04 25
00 00 00 00 54 09 00 00 e8 d9 77 ff ff e8 1e f3 ff ff 48
[13603.403328] sysrq: SysRq : SAK
[13605.755244] sysrq: SysRq : SAK
[13616.122877] sysrq: SysRq : SAK
[13617.514829] sysrq: SysRq : SAK
[13618.020548] nouveau 0000:01:00.0: Xorg[1025]: failed to idle channel 10
[Xorg[1025]]
[13618.522804] sysrq: SysRq : SAK
[13623.002648] sysrq: SysRq : SAK
[13626.378530] sysrq: SysRq : SAK
[13626.586521] sysrq: SysRq : SAK
[13626.802514] sysrq: SysRq : SAK
[13627.242507] sysrq: SysRq : This sysrq operation is disabled.
[13627.714483] sysrq: SysRq : SAK
[13627.962474] sysrq: SysRq : This sysrq operation is disabled.
[13628.314462] sysrq: SysRq : SAK
[13628.538455] sysrq: SysRq : SAK
[13628.850443] sysrq: SysRq : SAK
[13633.020587] nouveau 0000:01:00.0: Xorg[1025]: failed to idle channel 10
[Xorg[1025]]
[13633.021707] nouveau 0000:01:00.0: fifo: fault 00 [READ] at 0000000000013000
engine 07 [HOST0] client 07 [HUB/HOST_CPU] reason 42 [] on channel 10
[003f7f6000 Xorg[1025]]
[13633.021724] nouveau 0000:01:00.0: fifo: channel 10: killed
[13633.021730] nouveau 0000:01:00.0: fifo: runlist 0: scheduled for recovery
[13633.021743] nouveau 0000:01:00.0: Xorg[1025]: channel 10 killed!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
