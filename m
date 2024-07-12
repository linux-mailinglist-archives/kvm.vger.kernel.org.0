Return-Path: <kvm+bounces-21465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 441C092F472
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 05:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7C3E1F22BBA
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 03:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B245A10940;
	Fri, 12 Jul 2024 03:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JuxNj8Td"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A248BE5
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 03:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720755648; cv=none; b=Q+oLNqk0FUaKfLpBpT51it1QZjlpn4le9pS9P+xQGIpcE/Pj0BVq8rPviaf3mDp1DtgxjfA10Y8KyjA66qCemikwNoIwGQ/S5a9WU/l4IpVTH9Fcoppu5G+QGIml/btI7Ebhu62/MI7+UuTboFrMbDdHT/uZun/38PCC6W+/UPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720755648; c=relaxed/simple;
	bh=4PqC2xrGneS5uUg5jAM1GbyFeOLj+F0bdgszfrHShBU=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SSpg0vSC8WSxd+z2RnpR5+plIgNq4J2GTnLzloE73/w0JeYEImf7tQ/ZLS75l3zOY8JA7IIOWOKbi3zlKNZD+vrzo+0aSHN5Lc59in4/kLHnjwfR1rmPqm/olK3jj3Jp1aJcRz9mQECWxmqGXFANkPjb6KRttDirME2KlXGdjIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JuxNj8Td; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67993C4AF07
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 03:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720755648;
	bh=4PqC2xrGneS5uUg5jAM1GbyFeOLj+F0bdgszfrHShBU=;
	h=From:To:Subject:Date:From;
	b=JuxNj8TdcJ6U/v7wg8a1+t/zvo12v19sBOEI9AHqDQdVAMaGVsw8xuX4meNrL3QEz
	 41ovAj4nhl4HQgpIwZFL0KO3xHqcXiwGZNpG84FDy2bFH68VSEp9D66OMCsttEulVn
	 oIwSREVsilY1O5jQcvKzn5z8BtC259uEZp+Az9fzyB40Q0uWd9Vj5JvkoJ+ewQPD5f
	 G+7wRZXU2aQJzTEPbC2e0Pw3IVblF2fl/asL81y66nWleb/v2GUxRCdliWWNKbAVkW
	 NfQw0h4DRfM/rQfehHqBNhxJSTgNm+EPcTVFc8ROa2AEJgh9PWpKDAds5BEmpTq/iu
	 nvXijlga0JZIw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 54880C53B73; Fri, 12 Jul 2024 03:40:48 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219034] New: [linux-next][tag next-20240709] kernel BUG at
 lib/dynamic_queue_limits.c:99! and Oops: invalid opcode: 0000 [#1] PREEMPT
 SMP NOPTI
Date: Fri, 12 Jul 2024 03:40:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hongyu.ning@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219034-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219034

            Bug ID: 219034
           Summary: [linux-next][tag next-20240709] kernel BUG at
                    lib/dynamic_queue_limits.c:99! and Oops: invalid
                    opcode: 0000 [#1] PREEMPT SMP NOPTI
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: hongyu.ning@intel.com
        Regression: No

Hi,

based on regular regression check on linux-next tree as KVM/QEMU based gues=
t VM
kernel, there are following error observed since next-20240709.

it's 100% reproduced on my local setup.

based on bisect, it points to linux-next merge commit:
first bad commit: [28ab424895157dfea418c12418c5d0fc9263e850] Merge branch
'linux-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git

while no further check for vhost.git repo possible on my side,
can somebody help to take a look?

[    1.770041] ------------[ cut here ]------------
[    1.770088] kernel BUG at lib/dynamic_queue_limits.c:99!
[    1.770132] Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[    1.770135] CPU: 0 UID: 0 PID: 218 Comm: NetworkManager Not tainted
6.10.0-rc7-next-20240709-next-20240709 #97
[    1.770137] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unk=
nown
2/2/2022
[    1.770138] RIP: 0010:dql_completed+0x155/0x170
[    1.770153] Code: 51 cb 03 02 48 89 57 58 e9 35 ff ff ff 85 ed 41 0f 95 =
c0
39 d9 0f 95 c1 41 84 c8 74 05 45 85 e4 78 0a 44 89 d9 e9 18 ff ff ff <0f> 0=
b 01
d2 44 89 d9 29 d1 ba 00 00 00 00 0f 48 ca eb 88 0f 1f 84
[    1.770154] RSP: 0018:ffa0000000003d98 EFLAGS: 00010283
[    1.770156] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000000
[    1.770157] RDX: 0000000000000000 RSI: 000000000739aa20 RDI:
ff1100000702c6c0
[    1.770158] RBP: ffa0000000003de8 R08: 0000000000000000 R09:
0000000000000000
[    1.770159] R10: 0000000000000000 R11: ffa0000000003ff8 R12:
ff1100000770a800
[    1.770160] R13: ff1100000702c600 R14: 0000000000000001 R15:
ff1100000770a800
[    1.770161] FS:  00007f6420576500(0000) GS:ff1100003d400000(0000)
knlGS:0000000000000000
[    1.770164] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.770164] CR2: 0000564d582a9048 CR3: 000000000e2ce003 CR4:
0000000000771ef0
[    1.770165] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[    1.770166] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7:
0000000000000400
[    1.770166] PKRU: 55555554
[    1.770167] Call Trace:
[    1.770169]  <IRQ>
[    1.770171]  ? die+0x33/0x90
[    1.770174]  ? do_trap+0xda/0x100
[    1.770180]  ? do_error_trap+0x65/0x80
[    1.770181]  ? dql_completed+0x155/0x170
[    1.770183]  ? exc_invalid_op+0x4e/0x70
[    1.770186]  ? dql_completed+0x155/0x170
[    1.770188]  ? asm_exc_invalid_op+0x16/0x20
[    1.770194]  ? dql_completed+0x155/0x170
[    1.770195]  __free_old_xmit+0xe4/0x160
[    1.770199]  free_old_xmit+0x28/0x80
[    1.770200]  virtnet_poll+0xdb/0x350
[    1.770204]  ? update_load_avg+0x7e/0x7a0
[    1.770209]  __napi_poll+0x29/0x1b0
[    1.770214]  net_rx_action+0x2fe/0x3d0
[    1.770216]  ? wakeup_preempt+0x5a/0x70
[    1.770219]  ? ttwu_do_activate+0x6f/0x210
[    1.770221]  ? _raw_spin_unlock_irqrestore+0x1e/0x40
[    1.770224]  ? kvm_sched_clock_read+0xd/0x20
[    1.770227]  ? sched_clock+0xc/0x30
[    1.770232]  ? kvm_sched_clock_read+0xd/0x20
[    1.770233]  ? sched_clock+0xc/0x30
[    1.770235]  ? sched_clock_cpu+0xb/0x190
[    1.770239]  handle_softirqs+0xfa/0x2f0
[    1.770242]  do_softirq+0x71/0x90
[    1.770243]  </IRQ>
[    1.770243]  <TASK>
[    1.770244]  __local_bh_enable_ip+0x65/0x80
[    1.770245]  virtnet_open+0xa6/0x2d0
[    1.770248]  __dev_open+0xea/0x1b0
[    1.770250]  __dev_change_flags+0x1e0/0x250
[    1.770253]  dev_change_flags+0x21/0x60
[    1.770255]  do_setlink+0x283/0xbc0
[    1.770260]  ? __nla_validate_parse+0x47/0x1d0
[    1.770262]  __rtnl_newlink+0x502/0x640
[    1.770264]  ? __kmalloc_cache_noprof+0x27e/0x2f0
[    1.770268]  rtnl_newlink+0x44/0x70
[    1.770269]  rtnetlink_rcv_msg+0x159/0x420
[    1.770271]  ? netlink_unicast+0x31c/0x360
[    1.770275]  ? __pfx_rtnetlink_rcv_msg+0x10/0x10
[    1.770277]  netlink_rcv_skb+0x54/0x100
[    1.770280]  netlink_unicast+0x23e/0x360
[    1.770282]  netlink_sendmsg+0x1e4/0x420
[    1.770284]  ____sys_sendmsg+0x310/0x340
[    1.770289]  ? copy_msghdr_from_user+0x6d/0xa0
[    1.770291]  ___sys_sendmsg+0x88/0xd0
[    1.770293]  ? kfree+0x13b/0x2a0
[    1.770298]  ? preempt_count_add+0x69/0xa0
[    1.770299]  ? _raw_spin_unlock+0x14/0x30
[    1.770300]  ? proc_sys_call_handler+0xe7/0x280
[    1.770304]  ? mod_objcg_state+0xbe/0x2e0
[    1.770307]  ? __fdget+0xc7/0x100
[    1.770311]  __sys_sendmsg+0x59/0xa0
[    1.770313]  ? syscall_trace_enter+0xfb/0x190
[    1.770317]  do_syscall_64+0x47/0x110
[    1.770321]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    1.770323] RIP: 0033:0x7f642154fa9d
[    1.770324] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 aa c1 f4 =
ff
8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 fe c1 f4 ff 48
[    1.770325] RSP: 002b:00007ffe1fcbd3c0 EFLAGS: 00000293 ORIG_RAX:
000000000000002e
[    1.770326] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f642154fa9d
[    1.770327] RDX: 0000000000000000 RSI: 00007ffe1fcbd400 RDI:
000000000000000d
[    1.770328] RBP: 0000000000000001 R08: 0000000000000000 R09:
0000000000000000
[    1.770328] R10: 0000000000000000 R11: 0000000000000293 R12:
000000000000000a
[    1.770328] R13: 00007ffe1fcbd56c R14: 0000564d58220040 R15:
00007ffe1fcbd570
[    1.770330]  </TASK>
[    1.770330] Modules linked in:
[    1.770331] ---[ end trace 0000000000000000 ]---
[    1.778118] RIP: 0010:dql_completed+0x155/0x170
[    1.778158] Code: 51 cb 03 02 48 89 57 58 e9 35 ff ff ff 85 ed 41 0f 95 =
c0
39 d9 0f 95 c1 41 84 c8 74 05 45 85 e4 78 0a 44 89 d9 e9 18 ff ff ff <0f> 0=
b 01
d2 44 89 d9 29 d1 ba 00 00 00 00 0f 48 ca eb 88 0f 1f 84
[    1.778271] RSP: 0018:ffa0000000003d98 EFLAGS: 00010283
[    1.778308] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000000
[    1.778363] RDX: 0000000000000000 RSI: 000000000739aa20 RDI:
ff1100000702c6c0
[    1.778422] RBP: ffa0000000003de8 R08: 0000000000000000 R09:
0000000000000000
[    1.778474] R10: 0000000000000000 R11: ffa0000000003ff8 R12:
ff1100000770a800
[    1.778528] R13: ff1100000702c600 R14: 0000000000000001 R15:
ff1100000770a800
[    1.778581] FS:  00007f6420576500(0000) GS:ff1100003d400000(0000)
knlGS:0000000000000000
[    1.778636] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.778680] CR2: 0000564d582a9048 CR3: 000000000e2ce003 CR4:
0000000000771ef0
[    1.778736] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[    1.778788] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7:
0000000000000400
[    1.778843] PKRU: 55555554
[    1.778863] Kernel panic - not syncing: Fatal exception in interrupt
[    1.778929] Kernel Offset: disabled
[    1.783606] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

