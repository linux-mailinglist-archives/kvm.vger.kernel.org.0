Return-Path: <kvm+bounces-48617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA11ACFA35
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 02:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7C6D3B033D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 23:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD957171C9;
	Fri,  6 Jun 2025 00:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/NdJXgh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47F729A1
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749168014; cv=none; b=WeF3YpFUW/gcCwI5dGOyF2vtoIiNvMq1kGKjpK5/ubf6XUxhdTpCpR/JF4LUWYegMuJGkLFZ/pQyXYwghK+mhNPDd5suUPwNvt06TBjyvjsCHbIJABOyQUfywUJxtd1XOXtu3VPrJfl0IE3aM6/Y4P/E7W9iePGquq1lIxA+DIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749168014; c=relaxed/simple;
	bh=F5OaZ9yhKe50RbhMlI9/7Qw1xETmB7A8Bp4MO7dQbQ8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RPOTw4JbxikD4xEPKxvk9cuw3f+oIsTE9axNcEWHROTrQ7FDMhiJbMpWm/wWK8DKbFEF7XKz106a7mCZ28YrXcgeTHhZFuumLDTIK4rVnZRX/jz8jY3YT4ddp1006Co0j+c20lM+haZalsA0Yc9EFLrC5W8TUnWjjI5Mhxvxnn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/NdJXgh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52A87C4CEF0
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 00:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749168014;
	bh=F5OaZ9yhKe50RbhMlI9/7Qw1xETmB7A8Bp4MO7dQbQ8=;
	h=From:To:Subject:Date:From;
	b=m/NdJXghIWhLOjgArVvfLiT9tYvLv+HggsKQYrm2fii9iB4bkuA9piuqqfEC+dQul
	 8DMTHRc3fdIn+XK664RZ3IATvqiwC80je6OZUcmcxFXXz+YVSttr3QyGsgEDMBapq6
	 sfcv8D+zhDRQf0rL3sgXE5nKb98KBNfXsRiWbV7ML5GF08EPy5C2cNjPybRzqWSNEL
	 GNmGH5tFWn/YQ4DyhWopB8EzEzz6vAaz8EGNX1EoCEzFhGMTMffdeDMT3ZWyyzWoqO
	 vWHjWl+ZTMIfgua0x9OyB7v6NtclzsvZRMlQnv+/FC9+bzhSmcPZEhKxAv6mEHP7at
	 UHJjNq6zlBtUg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4547FC41612; Fri,  6 Jun 2025 00:00:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220200] New: Kernel crash with WARNING: CPU: 17 PID: 4510 at
 lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
Date: Fri, 06 Jun 2025 00:00:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: gs.thiruus@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-220200-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220200

            Bug ID: 220200
           Summary: Kernel crash with WARNING: CPU: 17 PID: 4510 at
                    lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: gs.thiruus@gmail.com
        Regression: No

Hi,=20

Observed below Kernel crash after every 30-40 mins on bootup on KVM based l=
inux
guest VM.=20
Kernel version used: 5.4.286
Is there any similar issue with this version?
Any possible fixes has been suggested for this type of kernel crash?

[ 1930.216104] refcount_t: underflow; use-after-free.
 [ 1930.216868] WARNING: CPU: 17 PID: 4510 at lib/refcount.c:28
refcount_warn_saturate+0xd8/0xe0
 [ 1930.218113] Modules linked in: rte_kni(O) igb_uio(O) ucad_shim_fifo(O)
be2net ice iavf i40e ixgbevf enic ixgbe mdio mlx5_core mlxfw rdma_ucm rdma_=
cm
ib_uverbs iw_cm ib_cm ib_core e1000e e1000 vmxnet3 vhost_net vhost virtio_n=
et
net_failover failover virtio_scsi virtio_blk vmw_pvscsi ahci libahci ata_pi=
ix
mptsas mptspi mptscsih mptbase uhci_hcd ehci_hcd
 [ 1930.222688] CPU: 17 PID: 4510 Comm: kni_single Tainted: G           O=
=20=20=20=20=20
5.4.286-x86-64 #1
 [ 1930.224074] Hardware name: Red Hat OpenStack Compute, BIOS
1.13.0-2.module+el8.2.1+7284+aa32a2c4 04/01/2014
 [ 1930.225502] RIP: 0010:refcount_warn_saturate+0xd8/0xe0
 [ 1930.226261] Code: ff 48 c7 c7 68 cf 01 a7 c6 05 9d 3e f0 00 01 e8 11 7d=
 40
00 0f 0b c3 48 c7 c7 10 cf 01 a7 c6 05 89 3e f0 00 01 e8 fb 7c 40 00 <0f> 0=
b c3
0f 1f 44 00 00 8b 07 3d 00 00 00 c0 74 12 83 f8 01 74 1f
 [ 1930.229001] RSP: 0000:ffffbe96c66c4d30 EFLAGS: 00010286
 [ 1930.229778] RAX: 0000000000000026 RBX: ffffa4258d236a00 RCX:
ffffffffa72480d8
 [ 1930.230830] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
ffffffffa60fc28c
 [ 1930.231873] RBP: ffffa4353a400a40 R08: 000000000000070c R09:
0000000000000035
 [ 1930.232914] R10: 0000000000000000 R11: ffffbe96c66c4bf5 R12:
ffffa435e5c9e040
 [ 1930.233953] R13: 0000000000003721 R14: ffffa4258d0ec08e R15:
ffffa4258d0ec09e
 [ 1930.234999] FS:  0000000000000000(0000) GS:ffffa4287fa40000(0000)
knlGS:0000000000000000
 [ 1930.236180] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [ 1930.237029] CR2: 000000001ae64ee4 CR3: 0000000f75476002 CR4:
0000000000760ee0
 [ 1930.238074] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
 [ 1930.239125] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
 [ 1930.240171] PKRU: 55555554
 [ 1930.240575] Call Trace:
 [ 1930.240957]  <IRQ>
 [ 1930.241266]  ? __warn+0x89/0xd0
 [ 1930.241739]  ? refcount_warn_saturate+0xd8/0xe0
 [ 1930.242408]  ? refcount_warn_saturate+0xd8/0xe0
 [ 1930.243082]  ? report_bug+0xb8/0x100
 [ 1930.243616]  ? do_error_trap+0x9e/0xd0
 [ 1930.244179]  ? do_invalid_op+0x36/0x40
 [ 1930.244740]  ? refcount_warn_saturate+0xd8/0xe0
 [ 1930.245417]  ? invalid_op+0x23/0x30
 [ 1930.245945]  ? console_unlock.part.25+0x3ac/0x500
 [ 1930.246640]  ? refcount_warn_saturate+0xd8/0xe0
 [ 1930.247309]  tcp_v6_rcv+0x636/0xb60
 [ 1930.247835]  ip6_protocol_deliver_rcu+0xb1/0x350
 [ 1930.248531]  ip6_input_finish+0x21/0x30
 [ 1930.249095]  ip6_input+0x9b/0xb0
 [ 1930.249577]  ipv6_rcv+0xb3/0xc0
 [ 1930.250050]  ? tick_init_highres+0x20/0x20
 [ 1930.250656]  ? task_tick_fair+0x44/0x8e0
 [ 1930.251246]  __netif_receive_skb_one_core+0x48/0x50
 [ 1930.251979]  process_backlog+0xa3/0x150
 [ 1930.252549]  net_rx_action+0xd7/0x2e0
 [ 1930.253097]  __do_softirq+0xc0/0x362
 [ 1930.253634]  irq_exit+0x7e/0x80
 [ 1930.254105]  smp_apic_timer_interrupt+0x6a/0x150
 [ 1930.254792]  apic_timer_interrupt+0xf/0x20
 [ 1930.255406]  </IRQ>
 [ 1930.255729] RIP: 0010:kni_net_poll_resp+0x12/0x50 [rte_kni]
 [ 1930.256546] Code: 00 00 5b e9 00 ef ff ff 0f 1f 44 00 00 e9 66 f1 ff ff=
 66
0f 1f 44 00 00 0f 1f 44 00 00 48 83 ec 08 48 8b 97 98 00 00 00 8b 02 <89> 0=
4 24
8b 04 24 8b 4a 04 89 4c 24 04 8b 4c 24 04 8b 52 08 29 c8
 [ 1930.259259] RSP: 0000:ffffbe96c7abbed0 EFLAGS: 00000282 ORIG_RAX:
ffffffffffffff13
 [ 1930.260367] RAX: 0000000000000001 RBX: ffffa427f09ce840 RCX:
00000000000009e5
 [ 1930.261412] RDX: ffffa4268dd2e1c0 RSI: ffffa4268dd6e4c0 RDI:
ffffa427f09ce840
 [ 1930.262463] RBP: ffffa427f54f5fe0 R08: 0000000000000020 R09:
00000000000009e5
 [ 1930.263506] R10: 0000000000000001 R11: ffffa427f09ce840 R12:
0000000000000001
 [ 1930.264553] R13: 0000000000000095 R14: ffffa427f54f5f80 R15:
ffffa427f54f5fb8
 [ 1930.265595]  kni_thread_single+0xa3/0x110 [rte_kni]
 [ 1930.266304]  ? kni_thread_multiple+0x70/0x70 [rte_kni]
 [ 1930.267059]  kthread+0x12c/0x150
 [ 1930.267563]  ? kthread_create_worker_on_cpu+0x40/0x40
 [ 1930.268302]  ret_from_fork+0x24/0x30
 [ 1930.268835] ---[ end trace 22c2946fdda8eee0 ]---

 [ 2000.865923] IPv4: Attempt to release TCP socket in state 10
000000004253e08a
 [ 2001.053919] ------------[ cut here ]------------
 [ 2001.054675] refcount_t: saturated; leaking memory.
 [ 2001.055426] WARNING: CPU: 13 PID: 6861 at lib/refcount.c:22
refcount_warn_saturate+0x61/0xe0
 [ 2001.056695] Modules linked in: rte_kni(O) igb_uio(O) ucad_shim_fifo(O)
be2net ice iavf i40e ixgbevf enic ixgbe mdio mlx5_core mlxfw rdma_ucm rdma_=
cm
ib_uverbs iw_cm ib_cm ib_core e1000e e1000 vmxnet3 vhost_net vhost virtio_n=
et
net_failover failover virtio_scsi virtio_blk vmw_pvscsi ahci libahci ata_pi=
ix
mptsas mptspi mptscsih mptbase uhci_hcd ehci_hcd
 [ 2001.061276] CPU: 13 PID: 6861 Comm: dhmgr Tainted: G        W  O=20=20=
=20=20=20
5.4.286-x86-64 #1
 [ 2001.062610] Hardware name: Red Hat OpenStack Compute, BIOS
1.13.0-2.module+el8.2.1+7284+aa32a2c4 04/01/2014
 [ 2001.064053] RIP: 0010:refcount_warn_saturate+0x61/0xe0
 [ 2001.064827] Code: 05 1e 3f f0 00 01 e8 91 7d 40 00 0f 0b c3 80 3d 12 3f=
 f0
00 00 75 d7 48 c7 c7 b8 ce 01 a7 c6 05 02 3f f0 00 01 e8 72 7d 40 00 <0f> 0=
b c3
80 3d f2 3e f0 00 00 75 b8 48 c7 c7 e0 ce 01 a7 c6 05 e2
 [ 2001.067568] RSP: 0000:ffffbe96c7d3be20 EFLAGS: 00210282
 [ 2001.068347] RAX: 0000000000000026 RBX: ffffa4353b6b0300 RCX:
ffffffffa72480d8
 [ 2001.069391] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
ffffffffa60fc28c
 [ 2001.070446] RBP: 0000000000000000 R08: 00000000000007ad R09:
0000000000000035
 [ 2001.071506] R10: 0000000000000000 R11: ffffbe96c7d3bce5 R12:
0000000000000007
 [ 2001.072561] R13: ffffa43569647240 R14: ffffa4287a2f6920 R15:
ffffa43569644240
 [ 2001.073621] FS:  0000000000000000(0000) GS:ffffa4287f940000(0063)
knlGS:00000000f6d47700
 [ 2001.074834] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
 [ 2001.075680] CR2: 000000000b99e834 CR3: 0000001db8876006 CR4:
0000000000760ee0
 [ 2001.076735] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
 [ 2001.077807] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
 [ 2001.078854] PKRU: 55555554
 [ 2001.079270] Call Trace:
 [ 2001.079647]  ? __warn+0x89/0xd0
 [ 2001.080132]  ? refcount_warn_saturate+0x61/0xe0
 [ 2001.080799]  ? refcount_warn_saturate+0x61/0xe0
 [ 2001.081485]  ? report_bug+0xb8/0x100
 [ 2001.082022]  ? do_error_trap+0x9e/0xd0
 [ 2001.082583]  ? do_invalid_op+0x36/0x40
 [ 2001.083153]  ? refcount_warn_saturate+0x61/0xe0
 [ 2001.083825]  ? invalid_op+0x23/0x30
 [ 2001.084367]  ? console_unlock.part.25+0x3ac/0x500
 [ 2001.085072]  ? refcount_warn_saturate+0x61/0xe0
 [ 2001.085744]  __tcp_close+0x3c4/0x440
 [ 2001.086290]  tcp_close+0x1f/0x70
 [ 2001.086772]  inet_release+0x2e/0x60
 [ 2001.087321]  __sock_release+0x37/0xa0
 [ 2001.087872]  sock_close+0x11/0x20
 [ 2001.088384]  __fput+0xab/0x230
 [ 2001.088846]  task_work_run+0x89/0xb0
 [ 2001.089396]  exit_to_usermode_loop+0xb2/0xc0
 [ 2001.090031]  do_int80_syscall_32+0x101/0x120
 [ 2001.090668]  entry_INT80_compat+0x9f/0xb0
 [ 2001.091286] ---[ end trace 22c2946fdda8eee1 ]---
 [ 2001.146908] IPv4: Attempt to release TCP socket in state 10
0000000017c852ff
 [ 2007.380869] BUG: kernel NULL pointer dereference, address: 000000000000=
0058
 [ 2007.381952] #PF: supervisor read access in kernel mode
 [ 2007.382700] #PF: error_code(0x0000) - not-present page
 [ 2007.383452] PGD 8000001f77dc8067 P4D 8000001f77dc8067 PUD 1ffc315067 PMD
1dc0394067 PTE 0
 [ 2007.384657] Oops: 0000 [#1] PREEMPT SMP PTI
 [ 2007.385282] CPU: 29 PID: 6861 Comm: dhmgr Tainted: G        W  O=20=20=
=20=20=20
5.4.286-X86-64 #1
 [ 2007.386605] Hardware name: Red Hat OpenStack Compute, BIOS
1.13.0-2.module+el8.2.1+7284+aa32a2c4 04/01/2014
 [ 2007.388029] RIP: 0010:ipv6_sock_mc_close+0x20/0x50
 [ 2007.388726] Code: ff ff ff 0f 1f 80 00 00 00 00 0f 1f 44 00 00 0f b6 4f=
 12
b8 01 00 00 00 31 d2 d3 e0 a9 bf ef ff ff 74 07 48 8b 97 d8 02 00 00 <48> 8=
b 42
58 48 85 c0 75 01 c3 53 48 89 fb e8 7d 56 f0 ff 48 89 df
 [ 2007.391442] RSP: 0000:ffffbe96c7d3be60 EFLAGS: 00210202
 [ 2007.392222] RAX: 0000000000000001 RBX: ffffa43569665bc0 RCX:
0000000000000000
 [ 2007.393266] RDX: 0000000000000000 RSI: ffffa43569665c40 RDI:
ffffa4353a451300
 [ 2007.394313] RBP: ffffa4353a451300 R08: 0000000000000000 R09:
0000000000000000
 [ 2007.395360] R10: 0000000000000000 R11: 0000000000000008 R12:
0000000000000000
 [ 2007.396400] R13: ffffa43569665c40 R14: ffffa4287a2f6920 R15:
ffffa43569663540
 [ 2007.397443] FS:  0000000000000000(0000) GS:ffffa4387f8c0000(0063)
knlGS:00000000f6d47700
 [ 2007.398612] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
 [ 2007.399446] CR2: 0000000000000058 CR3: 0000001db8876003 CR4:
0000000000760ee0
 [ 2007.400484] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
 [ 2007.401538] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
 [ 2007.402591] PKRU: 55555554
 [ 2007.402991] Call Trace:
 [ 2007.403369]  ? __die+0x86/0xc8
 [ 2007.403824]  ? no_context.isra.26+0x148/0x2d0
 [ 2007.404480]  ? async_page_fault+0x34/0x40
 [ 2007.405083]  ? ipv6_sock_mc_close+0x20/0x50
 [ 2007.405695]  inet6_release+0x1b/0x40
 [ 2007.406244]  __sock_release+0x37/0xa0
 [ 2007.406782]  sock_close+0x11/0x20
 [ 2007.407280]  __fput+0xab/0x230
 [ 2007.407733]  task_work_run+0x89/0xb0
 [ 2007.408269]  exit_to_usermode_loop+0xb2/0xc0
 [ 2007.408895]  do_int80_syscall_32+0x101/0x120
 [ 2007.409538]  entry_INT80_compat+0x9f/0xb0
 [ 2007.410146] Modules linked in: rte_kni(O) igb_uio(O) ucad_shim_fifo(O)
be2net ice iavf i40e ixgbevf enic ixgbe mdio mlx5_core mlxfw rdma_ucm rdma_=
cm
ib_uverbs iw_cm ib_cm ib_core e1000e e1000 vmxnet3 vhost_net vhost virtio_n=
et
net_failover failover virtio_scsi virtio_blk vmw_pvscsi ahci libahci ata_pi=
ix
mptsas mptspi mptscsih mptbase uhci_hcd ehci_hcd
 [ 2007.414654] CR2: 0000000000000058
 [ 2007.415149] ---[ end trace 22c2946fdda8eee2 ]---

Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

