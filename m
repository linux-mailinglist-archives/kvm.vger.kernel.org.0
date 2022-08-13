Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D03591867
	for <lists+kvm@lfdr.de>; Sat, 13 Aug 2022 04:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiHMCzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 22:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiHMCzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 22:55:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9CA45F68
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 19:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6DB5B82219
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 02:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BF6CC433C1
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 02:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660359346;
        bh=dyLUIFgQbK0GJ8rap5ozZH+TTjxbdl67GTz6+2bNgHs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=f99+32U1PVM4/ypNemxSID77oqQCeKLLy/UTXkNnLNT3yMRthhdge9YsepHs1l/TG
         Yn8bauaxalNCwBWTYN+iX8yILV3CVvSYDshr1MOGG4SAgk0jMfiKB9Gi0Qj+KNgmOP
         vjw9yKuW/EliK3Mo86UYpwFqK5wcEKp0MOaqc3Da2aHDgQX0rDvdSKnwCWEvjDjHL2
         kKvhdOcsX/FSZaP9YOnUpHOS/yXNU/EL6So5a8pO/B7CD9bnVqISd5Y4He3148fKZN
         tk17Q2EgZypzTlwG4dtlBPYKEGuAO/VoaOHbb5gtdzRwC7z/gfNUauHoOLWdaS0qfJ
         JLy7Fu2v+G/xg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6557AC433E9; Sat, 13 Aug 2022 02:55:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Sat, 13 Aug 2022 02:55:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jdpark.au@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216349-28872-f8RHiL312E@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

--- Comment #8 from John Park (jdpark.au@gmail.com) ---
Another kernel panic and VM freeze occurred today. Log below:

---

[32846.996729] invalid opcode: 0000 [#1] SMP PTI
[32846.997520] CPU: 0 PID: 2951 Comm: cron Not tainted 5.15.0-46-generic
#49-Ubuntu
[32846.998310] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
[32847.000030] RIP: 0010:asm_exc_page_fault+0x1/0x30
[32847.001067] Code: 28 ff 74 24 28 ff 74 24 28 ff 74 24 28 e8 27 09 00 00 =
48
89 c4 48 8d 6c 24 01 48 89 e7 e8 b7 86 f9 ff e9 42 0a 00 00 66 90 0f <1f> 0=
0 e8
08 09 00 00 48 89 c4 48 8d 6c 24 01 48 89 e7 48 8b 74 24
[32847.003280] RSP: 0018:ffffb688031c7b08 EFLAGS: 00010086
[32847.004521] RAX: ffffffffc07f5360 RBX: 0000000000000000 RCX:
0000000000000002
[32847.005772] RDX: 0000000000000081 RSI: ffff9cb54955cb60 RDI:
ffffffff91681300
[32847.007063] RBP: ffffb688031c7ba8 R08: 0000000000000000 R09:
0000000000000000
[32847.008418] R10: ffff9cb54eab3000 R11: 0000000000000000 R12:
ffff9cb54955cb60
[32847.009782] R13: 0000000000000081 R14: ffffffff91681300 R15:
d0d0d0d0d0d0d0d0
[32847.011199] FS:  00007fe632c78840(0000) GS:ffff9cb57bc00000(0000)
knlGS:0000000000000000
[32847.012623] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[32847.013711] CR2: ffffffffc63418c3 CR3: 0000000001c14000 CR4:
00000000000006f0
[32847.014847] Call Trace:
[32847.015811]  <TASK>
[32847.016616]  ? asm_sysvec_spurious_apic_interrupt+0x20/0x20
[32847.017488]  ? ovl_verify_inode+0xd0/0xd0 [overlay]
[32847.018341]  ? ovl_verify_inode+0xd0/0xd0 [overlay]
[32847.018939]  ? inode_permission+0xef/0x1a0
[32847.019561]  link_path_walk.part.0.constprop.0+0xc9/0x370
[32847.020165]  ? path_init+0x2c0/0x3f0
[32847.020779]  path_lookupat+0x3e/0x1c0
[32847.021416]  ? generic_fillattr+0x4e/0xe0
[32847.021941]  filename_lookup+0xcf/0x1d0
[32847.022468]  ? __check_object_size+0x1d/0x30
[32847.023003]  ? strncpy_from_user+0x44/0x150
[32847.023583]  ? getname_flags.part.0+0x4c/0x1b0
[32847.024200]  user_path_at_empty+0x3f/0x60
[32847.024880]  vfs_statx+0x7a/0x130
[32847.025450]  __do_sys_newstat+0x3e/0x80
[32847.026194]  ? __secure_computing+0xa9/0x120
[32847.026825]  ? syscall_trace_enter.constprop.0+0xa7/0x1c0
[32847.027410]  __x64_sys_newstat+0x16/0x20
[32847.028025]  do_syscall_64+0x5c/0xc0
[32847.028621]  ? syscall_exit_to_user_mode+0x27/0x50
[32847.029197]  ? __x64_sys_newstat+0x16/0x20
[32847.029748]  ? do_syscall_64+0x69/0xc0
[32847.030298]  ? do_syscall_64+0x69/0xc0
[32847.030853]  ? syscall_exit_to_user_mode+0x27/0x50
[32847.031415]  ? __x64_sys_newstat+0x16/0x20
[32847.032002]  ? do_syscall_64+0x69/0xc0
[32847.032591]  ? do_syscall_64+0x69/0xc0
[32847.033193]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[32847.033786] RIP: 0033:0x7fe632e643a6
[32847.034390] Code: 00 00 75 05 48 83 c4 18 c3 e8 66 f3 01 00 66 0f 1f 44 =
00
00 41 89 f8 48 89 f7 48 89 d6 41 83 f8 01 77 29 b8 04 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 02 c3 90 48 8b 15 b9 fa 0c 00 f7 d8 64 89 02
[32847.035617] RSP: 002b:00007ffdce8c1f98 EFLAGS: 00000246 ORIG_RAX:
0000000000000004
[32847.036257] RAX: ffffffffffffffda RBX: 00005558fae76690 RCX:
00007fe632e643a6
[32847.036879] RDX: 00007ffdce8c2190 RSI: 00007ffdce8c2190 RDI:
00007ffdce8c2320
[32847.037492] RBP: 00007ffdce8c4380 R08: 0000000000000001 R09:
0000000000000012
[32847.038105] R10: 00005558fae764e8 R11: 0000000000000246 R12:
00007ffdce8c1fe0
[32847.038699] R13: 00007ffdce8c2320 R14: 00007ffdce8c2070 R15:
00005558fa816186
[32847.039280]  </TASK>
[32847.039875] Modules linked in: tls xt_nat xt_tcpudp veth xt_conntrack
nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo nft_counter xt_addrtype
nft_compat nf_tables nfnetlink br_netfilter bridge stp llc overlay sch_fq_c=
odel
joydev input_leds serio_raw qemu_fw_cfg mac_hid ramoops dm_multipath
scsi_dh_rdac scsi_dh_emc scsi_dh_alua reed_solomon pstore_blk mtd netconsole
pstore_zone ipmi_devintf ipmi_msghandler efi_pstore msr ip_tables x_tables
autofs4 btrfs blake2b_generic zstd_compress raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0
multipath linear bochs drm_vram_helper drm_ttm_helper ttm drm_kms_helper
syscopyarea hid_generic sysfillrect sysimgblt xhci_pci fb_sys_fops cec rc_c=
ore
psmouse xhci_pci_renesas virtio_net usbhid net_failover hid failover drm
virtio_scsi i2c_piix4 pata_acpi floppy
[32847.045209] ---[ end trace 3eb46e5a4c095231 ]---
[32847.045918] RIP: 0010:asm_exc_page_fault+0x1/0x30
[32847.046626] Code: 28 ff 74 24 28 ff 74 24 28 ff 74 24 28 e8 27 09 00 00 =
48
89 c4 48 8d 6c 24 01 48 89 e7 e8 b7 86 f9 ff e9 42 0a 00 00 66 90 0f <1f> 0=
0 e8
08 09 00 00 48 89 c4 48 8d 6c 24 01 48 89 e7 48 8b 74 24
[32847.048094] RSP: 0018:ffffb688031c7b08 EFLAGS: 00010086
[32847.048831] RAX: ffffffffc07f5360 RBX: 0000000000000000 RCX:
0000000000000002
[32847.049554] RDX: 0000000000000081 RSI: ffff9cb54955cb60 RDI:
ffffffff91681300
[32847.050314] RBP: ffffb688031c7ba8 R08: 0000000000000000 R09:
0000000000000000
[32847.051091] R10: ffff9cb54eab3000 R11: 0000000000000000 R12:
ffff9cb54955cb60
[32847.051868] R13: 0000000000000081 R14: ffffffff91681300 R15:
d0d0d0d0d0d0d0d0
[32847.052613] FS:  00007fe632c78840(0000) GS:ffff9cb57bc00000(0000)
knlGS:0000000000000000
[32847.053373] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[32847.054163] CR2: ffffffffc63418c3 CR3: 0000000001c14000 CR4:
00000000000006f0
[32854.484979] systemd-journald[352]: Sent WATCHDOG=3D1 notification.
[32907.065589] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[32907.068463] rcu:     0-...!: (0 ticks this GP) idle=3D3b4/0/0x0
softirq=3D164676/164676 fqs=3D0  (false positive?)
[32907.071403]  (detected by 1, t=3D15002 jiffies, g=3D339469, q=3D958)
[32907.074366] Sending NMI from CPU 1 to CPUs 0:
[32907.077480] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[32907.078309] rcu: rcu_sched kthread timer wakeup didn't happen for 15001
jiffies! g339469 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[32907.083751] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[32907.084959] rcu: rcu_sched kthread starved for 15002 jiffies! g339469 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[32907.086186] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[32907.087160] rcu: RCU grace-period kthread stack dump:
[32907.088098] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[32907.089034] Call Trace:
[32907.089950]  <TASK>
[32907.090876]  __schedule+0x23d/0x590
[32907.091804]  schedule+0x4e/0xc0
[32907.092731]  schedule_timeout+0x87/0x140
[32907.093631]  ? __bpf_trace_tick_stop+0x20/0x20
[32907.094525]  rcu_gp_fqs_loop+0xe5/0x330
[32907.095402]  rcu_gp_kthread+0xa7/0x130
[32907.096269]  ? rcu_gp_init+0x5f0/0x5f0
[32907.097173]  kthread+0x12a/0x150
[32907.098040]  ? set_kthread_struct+0x50/0x50
[32907.098891]  ret_from_fork+0x22/0x30
[32907.099759]  </TASK>
[32907.100599] rcu: Stack dump where RCU GP kthread last ran:
[32907.101423] Sending NMI from CPU 1 to CPUs 0:
[32907.102298] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33087.076178] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[33087.076988] rcu:     0-...!: (0 ticks this GP) idle=3D770/0/0x0
softirq=3D164676/164676 fqs=3D1  (false positive?)
[33087.077752]  (detected by 1, t=3D60007 jiffies, g=3D339469, q=3D4980)
[33087.079970] Sending NMI from CPU 1 to CPUs 0:
[33087.082000] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33087.082923] rcu: rcu_sched kthread timer wakeup didn't happen for 45004
jiffies! g339469 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[33087.086526] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[33087.087490] rcu: rcu_sched kthread starved for 45005 jiffies! g339469 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[33087.088245] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[33087.089024] rcu: RCU grace-period kthread stack dump:
[33087.089799] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[33087.090701] Call Trace:
[33087.091595]  <TASK>
[33087.092463]  __schedule+0x23d/0x590
[33087.093351]  schedule+0x4e/0xc0
[33087.094150]  schedule_timeout+0x87/0x140
[33087.094925]  ? __bpf_trace_tick_stop+0x20/0x20
[33087.095704]  rcu_gp_fqs_loop+0xe5/0x330
[33087.096590]  rcu_gp_kthread+0xa7/0x130
[33087.097453]  ? rcu_gp_init+0x5f0/0x5f0
[33087.098198]  kthread+0x12a/0x150
[33087.098964]  ? set_kthread_struct+0x50/0x50
[33087.099761]  ret_from_fork+0x22/0x30
[33087.100502]  </TASK>
[33087.101186] rcu: Stack dump where RCU GP kthread last ran:
[33087.101855] Sending NMI from CPU 1 to CPUs 0:
[33087.102544] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33147.081021] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[33147.081747] rcu:     0-...!: (0 ticks this GP) idle=3D884/0/0x0
softirq=3D164676/164676 fqs=3D0  (false positive?)
[33147.082426]  (detected by 1, t=3D15002 jiffies, g=3D339473, q=3D5992)
[33147.083144] Sending NMI from CPU 1 to CPUs 0:
[33147.083899] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33147.084830] rcu: rcu_sched kthread timer wakeup didn't happen for 15001
jiffies! g339473 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[33147.086851] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[33147.087588] rcu: rcu_sched kthread starved for 15002 jiffies! g339473 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[33147.088368] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[33147.089176] rcu: RCU grace-period kthread stack dump:
[33147.089947] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[33147.090709] Call Trace:
[33147.091463]  <TASK>
[33147.092241]  __schedule+0x23d/0x590
[33147.092969]  schedule+0x4e/0xc0
[33147.093692]  schedule_timeout+0x87/0x140
[33147.094410]  ? __bpf_trace_tick_stop+0x20/0x20
[33147.095141]  rcu_gp_fqs_loop+0xe5/0x330
[33147.095881]  rcu_gp_kthread+0xa7/0x130
[33147.096649]  ? rcu_gp_init+0x5f0/0x5f0
[33147.097360]  kthread+0x12a/0x150
[33147.098055]  ? set_kthread_struct+0x50/0x50
[33147.098780]  ret_from_fork+0x22/0x30
[33147.099463]  </TASK>
[33147.100156] rcu: Stack dump where RCU GP kthread last ran:
[33147.100804] Sending NMI from CPU 1 to CPUs 0:
[33147.101514] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33327.091939] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[33327.094235] rcu:     0-...!: (0 ticks this GP) idle=3Dbac/0/0x0
softirq=3D164676/164676 fqs=3D1  (false positive?)
[33327.096512]  (detected by 1, t=3D60007 jiffies, g=3D339473, q=3D8311)
[33327.098758] Sending NMI from CPU 1 to CPUs 0:
[33327.101146] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33327.102058] rcu: rcu_sched kthread timer wakeup didn't happen for 45004
jiffies! g339473 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[33327.108229] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[33327.109665] rcu: rcu_sched kthread starved for 45005 jiffies! g339473 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[33327.111089] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[33327.112187] rcu: RCU grace-period kthread stack dump:
[33327.113164] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[33327.114173] Call Trace:
[33327.115034]  <TASK>
[33327.115788]  __schedule+0x23d/0x590
[33327.116548]  schedule+0x4e/0xc0
[33327.117302]  schedule_timeout+0x87/0x140
[33327.118062]  ? __bpf_trace_tick_stop+0x20/0x20
[33327.118819]  rcu_gp_fqs_loop+0xe5/0x330
[33327.119557]  rcu_gp_kthread+0xa7/0x130
[33327.120284]  ? rcu_gp_init+0x5f0/0x5f0
[33327.120994]  kthread+0x12a/0x150
[33327.121689]  ? set_kthread_struct+0x50/0x50
[33327.122426]  ret_from_fork+0x22/0x30
[33327.123117]  </TASK>
[33327.123772] rcu: Stack dump where RCU GP kthread last ran:
[33327.124418] Sending NMI from CPU 1 to CPUs 0:
[33327.125112] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33387.096689] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[33387.099051] rcu:     0-...!: (0 ticks this GP) idle=3Dcc8/0/0x0
softirq=3D164676/164676 fqs=3D0  (false positive?)
[33387.101398]  (detected by 1, t=3D15002 jiffies, g=3D339477, q=3D8413)
[33387.103719] Sending NMI from CPU 1 to CPUs 0:
[33387.105931] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33387.106831] rcu: rcu_sched kthread timer wakeup didn't happen for 15001
jiffies! g339477 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[33387.110589] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[33387.111627] rcu: rcu_sched kthread starved for 15002 jiffies! g339477 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[33387.112383] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[33387.113148] rcu: RCU grace-period kthread stack dump:
[33387.113919] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[33387.114682] Call Trace:
[33387.115475]  <TASK>
[33387.116259]  __schedule+0x23d/0x590
[33387.117046]  schedule+0x4e/0xc0
[33387.117828]  schedule_timeout+0x87/0x140
[33387.118605]  ? __bpf_trace_tick_stop+0x20/0x20
[33387.119382]  rcu_gp_fqs_loop+0xe5/0x330
[33387.120166]  rcu_gp_kthread+0xa7/0x130
[33387.120920]  ? rcu_gp_init+0x5f0/0x5f0
[33387.121659]  kthread+0x12a/0x150
[33387.122350]  ? set_kthread_struct+0x50/0x50
[33387.123068]  ret_from_fork+0x22/0x30
[33387.123799]  </TASK>
[33387.124483] rcu: Stack dump where RCU GP kthread last ran:
[33387.125155] Sending NMI from CPU 1 to CPUs 0:
[33387.125859] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33567.107272] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[33567.108086] rcu:     0-...!: (0 ticks this GP) idle=3Dff8/0/0x0
softirq=3D164676/164676 fqs=3D1  (false positive?)
[33567.108782]  (detected by 1, t=3D60007 jiffies, g=3D339477, q=3D8523)
[33567.109471] Sending NMI from CPU 1 to CPUs 0:
[33567.110180] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33567.110205] rcu: rcu_sched kthread timer wakeup didn't happen for 45004
jiffies! g339477 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[33567.112387] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[33567.113184] rcu: rcu_sched kthread starved for 45005 jiffies! g339477 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[33567.113997] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[33567.114835] rcu: RCU grace-period kthread stack dump:
[33567.115616] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[33567.116456] Call Trace:
[33567.117284]  <TASK>
[33567.118105]  __schedule+0x23d/0x590
[33567.118928]  schedule+0x4e/0xc0
[33567.119758]  schedule_timeout+0x87/0x140
[33567.120548]  ? __bpf_trace_tick_stop+0x20/0x20
[33567.121340]  rcu_gp_fqs_loop+0xe5/0x330
[33567.122137]  rcu_gp_kthread+0xa7/0x130
[33567.123071]  ? rcu_gp_init+0x5f0/0x5f0
[33567.123850]  kthread+0x12a/0x150
[33567.124594]  ? set_kthread_struct+0x50/0x50
[33567.125333]  ret_from_fork+0x22/0x30
[33567.126093]  </TASK>
[33567.126838] rcu: Stack dump where RCU GP kthread last ran:
[33567.127558] Sending NMI from CPU 1 to CPUs 0:
[33567.128290] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33627.112252] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[33627.114524] rcu:     0-...!: (0 ticks this GP) idle=3D12c/0/0x0
softirq=3D164676/164676 fqs=3D1  (false positive?)
[33627.116778]  (detected by 1, t=3D15002 jiffies, g=3D339481, q=3D4061)
[33627.118964] Sending NMI from CPU 1 to CPUs 0:
[33627.121277] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33627.122219] rcu: rcu_sched kthread timer wakeup didn't happen for 15001
jiffies! g339481 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[33627.127242] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[33627.128561] rcu: rcu_sched kthread starved for 15002 jiffies! g339481 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[33627.129605] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[33627.130497] rcu: RCU grace-period kthread stack dump:
[33627.131431] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[33627.132336] Call Trace:
[33627.133137]  <TASK>
[33627.133914]  __schedule+0x23d/0x590
[33627.134697]  schedule+0x4e/0xc0
[33627.135491]  schedule_timeout+0x87/0x140
[33627.136266]  ? __bpf_trace_tick_stop+0x20/0x20
[33627.137041]  rcu_gp_fqs_loop+0xe5/0x330
[33627.137815]  rcu_gp_kthread+0xa7/0x130
[33627.138555]  ? rcu_gp_init+0x5f0/0x5f0
[33627.139304]  kthread+0x12a/0x150
[33627.140026]  ? set_kthread_struct+0x50/0x50
[33627.140753]  ret_from_fork+0x22/0x30
[33627.141451]  </TASK>
[33627.142133] rcu: Stack dump where RCU GP kthread last ran:
[33627.142774] Sending NMI from CPU 1 to CPUs 0:
[33627.143520] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33687.117032] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[33687.117692] rcu:     0-...!: (0 ticks this GP) idle=3D240/0/0x0
softirq=3D164676/164676 fqs=3D0  (false positive?)
[33687.118360]  (detected by 1, t=3D15002 jiffies, g=3D339485, q=3D792)
[33687.119007] Sending NMI from CPU 1 to CPUs 0:
[33687.119749] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33687.120680] rcu: rcu_sched kthread timer wakeup didn't happen for 15001
jiffies! g339485 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[33687.122730] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[33687.123524] rcu: rcu_sched kthread starved for 15002 jiffies! g339485 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[33687.124318] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[33687.125097] rcu: RCU grace-period kthread stack dump:
[33687.125902] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[33687.126703] Call Trace:
[33687.127500]  <TASK>
[33687.128318]  __schedule+0x23d/0x590
[33687.129116]  schedule+0x4e/0xc0
[33687.129908]  schedule_timeout+0x87/0x140
[33687.130745]  ? __bpf_trace_tick_stop+0x20/0x20
[33687.131535]  rcu_gp_fqs_loop+0xe5/0x330
[33687.132386]  rcu_gp_kthread+0xa7/0x130
[33687.133149]  ? rcu_gp_init+0x5f0/0x5f0
[33687.133902]  kthread+0x12a/0x150
[33687.134638]  ? set_kthread_struct+0x50/0x50
[33687.135370]  ret_from_fork+0x22/0x30
[33687.136120]  </TASK>
[33687.136813] rcu: Stack dump where RCU GP kthread last ran:
[33687.137500] Sending NMI from CPU 1 to CPUs 0:
[33687.138285] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33867.127694] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[33867.128396] rcu:     0-...!: (0 ticks this GP) idle=3D538/0/0x0
softirq=3D164676/164676 fqs=3D1  (false positive?)
[33867.129073]  (detected by 1, t=3D60007 jiffies, g=3D339485, q=3D894)
[33867.129719] Sending NMI from CPU 1 to CPUs 0:
[33867.130464] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33867.130491] rcu: rcu_sched kthread timer wakeup didn't happen for 45004
jiffies! g339485 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[33867.132521] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[33867.133243] rcu: rcu_sched kthread starved for 45005 jiffies! g339485 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[33867.133982] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[33867.134745] rcu: RCU grace-period kthread stack dump:
[33867.135493] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[33867.136269] Call Trace:
[33867.137090]  <TASK>
[33867.137857]  __schedule+0x23d/0x590
[33867.138674]  schedule+0x4e/0xc0
[33867.139458]  schedule_timeout+0x87/0x140
[33867.140238]  ? __bpf_trace_tick_stop+0x20/0x20
[33867.141035]  rcu_gp_fqs_loop+0xe5/0x330
[33867.141820]  rcu_gp_kthread+0xa7/0x130
[33867.142602]  ? rcu_gp_init+0x5f0/0x5f0
[33867.143354]  kthread+0x12a/0x150
[33867.144085]  ? set_kthread_struct+0x50/0x50
[33867.144812]  ret_from_fork+0x22/0x30
[33867.145542]  </TASK>
[33867.146236] rcu: Stack dump where RCU GP kthread last ran:
[33867.146933] Sending NMI from CPU 1 to CPUs 0:
[33867.147763] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33927.132635] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[33927.133318] rcu:     0-...!: (0 ticks this GP) idle=3D654/0/0x0
softirq=3D164676/164676 fqs=3D0  (false positive?)
[33927.133978]  (detected by 1, t=3D15002 jiffies, g=3D339489, q=3D740)
[33927.134619] Sending NMI from CPU 1 to CPUs 0:
[33927.135332] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[33927.136309] rcu: rcu_sched kthread timer wakeup didn't happen for 15001
jiffies! g339489 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[33927.138323] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[33927.139085] rcu: rcu_sched kthread starved for 15002 jiffies! g339489 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[33927.139888] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[33927.140659] rcu: RCU grace-period kthread stack dump:
[33927.141395] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[33927.142187] Call Trace:
[33927.142968]  <TASK>
[33927.143794]  __schedule+0x23d/0x590
[33927.144580]  schedule+0x4e/0xc0
[33927.145354]  schedule_timeout+0x87/0x140
[33927.146160]  ? __bpf_trace_tick_stop+0x20/0x20
[33927.146908]  rcu_gp_fqs_loop+0xe5/0x330
[33927.147650]  rcu_gp_kthread+0xa7/0x130
[33927.148371]  ? rcu_gp_init+0x5f0/0x5f0
[33927.149077]  kthread+0x12a/0x150
[33927.149767]  ? set_kthread_struct+0x50/0x50
[33927.150454]  ret_from_fork+0x22/0x30
[33927.151133]  </TASK>
[33927.151792] rcu: Stack dump where RCU GP kthread last ran:
[33927.152435] Sending NMI from CPU 1 to CPUs 0:
[33927.153130] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34107.143372] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[34107.145414] rcu:     0-...!: (0 ticks this GP) idle=3D958/0/0x0
softirq=3D164676/164676 fqs=3D1  (false positive?)
[34107.147516]  (detected by 1, t=3D60007 jiffies, g=3D339489, q=3D843)
[34107.149668] Sending NMI from CPU 1 to CPUs 0:
[34107.152012] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34107.152867] rcu: rcu_sched kthread timer wakeup didn't happen for 45004
jiffies! g339489 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[34107.156675] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[34107.157822] rcu: rcu_sched kthread starved for 45005 jiffies! g339489 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[34107.158981] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[34107.159712] rcu: RCU grace-period kthread stack dump:
[34107.160447] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[34107.161207] Call Trace:
[34107.161956]  <TASK>
[34107.162713]  __schedule+0x23d/0x590
[34107.163467]  schedule+0x4e/0xc0
[34107.164214]  schedule_timeout+0x87/0x140
[34107.165048]  ? __bpf_trace_tick_stop+0x20/0x20
[34107.165825]  rcu_gp_fqs_loop+0xe5/0x330
[34107.166600]  rcu_gp_kthread+0xa7/0x130
[34107.167353]  ? rcu_gp_init+0x5f0/0x5f0
[34107.168126]  kthread+0x12a/0x150
[34107.168850]  ? set_kthread_struct+0x50/0x50
[34107.169571]  ret_from_fork+0x22/0x30
[34107.170294]  </TASK>
[34107.170947] rcu: Stack dump where RCU GP kthread last ran:
[34107.171620] Sending NMI from CPU 1 to CPUs 0:
[34107.172354] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34167.148166] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[34167.148854] rcu:     0-...!: (0 ticks this GP) idle=3Da64/0/0x0
softirq=3D164676/164676 fqs=3D0  (false positive?)
[34167.149539]  (detected by 1, t=3D15002 jiffies, g=3D339493, q=3D825)
[34167.150215] Sending NMI from CPU 1 to CPUs 0:
[34167.150972] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34167.151899] rcu: rcu_sched kthread timer wakeup didn't happen for 15001
jiffies! g339493 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[34167.153969] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[34167.154714] rcu: rcu_sched kthread starved for 15002 jiffies! g339493 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[34167.155504] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[34167.156280] rcu: RCU grace-period kthread stack dump:
[34167.157058] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[34167.157859] Call Trace:
[34167.158650]  <TASK>
[34167.159459]  __schedule+0x23d/0x590
[34167.160254]  schedule+0x4e/0xc0
[34167.161039]  schedule_timeout+0x87/0x140
[34167.161851]  ? __bpf_trace_tick_stop+0x20/0x20
[34167.162605]  rcu_gp_fqs_loop+0xe5/0x330
[34167.163393]  rcu_gp_kthread+0xa7/0x130
[34167.164125]  ? rcu_gp_init+0x5f0/0x5f0
[34167.164841]  kthread+0x12a/0x150
[34167.165590]  ? set_kthread_struct+0x50/0x50
[34167.166299]  ret_from_fork+0x22/0x30
[34167.167013]  </TASK>
[34167.167685] rcu: Stack dump where RCU GP kthread last ran:
[34167.168346] Sending NMI from CPU 1 to CPUs 0:
[34167.169070] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34347.159098] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[34347.163576] rcu:     0-...!: (0 ticks this GP) idle=3Dd6a/0/0x0
softirq=3D164676/164676 fqs=3D1  (false positive?)
[34347.165841]  (detected by 1, t=3D60007 jiffies, g=3D339493, q=3D955)
[34347.168124] Sending NMI from CPU 1 to CPUs 0:
[34347.170497] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34347.171412] rcu: rcu_sched kthread timer wakeup didn't happen for 45004
jiffies! g339493 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[34347.176473] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[34347.177835] rcu: rcu_sched kthread starved for 45005 jiffies! g339493 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[34347.178836] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[34347.179849] rcu: RCU grace-period kthread stack dump:
[34347.180798] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[34347.181587] Call Trace:
[34347.182355]  <TASK>
[34347.183131]  __schedule+0x23d/0x590
[34347.183880]  schedule+0x4e/0xc0
[34347.184623]  schedule_timeout+0x87/0x140
[34347.185368]  ? __bpf_trace_tick_stop+0x20/0x20
[34347.186160]  rcu_gp_fqs_loop+0xe5/0x330
[34347.186897]  rcu_gp_kthread+0xa7/0x130
[34347.187619]  ? rcu_gp_init+0x5f0/0x5f0
[34347.188336]  kthread+0x12a/0x150
[34347.189026]  ? set_kthread_struct+0x50/0x50
[34347.189754]  ret_from_fork+0x22/0x30
[34347.190435]  </TASK>
[34347.191087] rcu: Stack dump where RCU GP kthread last ran:
[34347.191731] Sending NMI from CPU 1 to CPUs 0:
[34347.192425] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34407.163845] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[34407.166112] rcu:     0-...!: (0 ticks this GP) idle=3De7a/0/0x0
softirq=3D164676/164676 fqs=3D0  (false positive?)
[34407.168371]  (detected by 1, t=3D15002 jiffies, g=3D339497, q=3D838)
[34407.170692] Sending NMI from CPU 1 to CPUs 0:
[34407.173003] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34407.173907] rcu: rcu_sched kthread timer wakeup didn't happen for 15001
jiffies! g339497 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[34407.178683] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[34407.179735] rcu: rcu_sched kthread starved for 15002 jiffies! g339497 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[34407.180810] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[34407.181746] rcu: RCU grace-period kthread stack dump:
[34407.182496] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[34407.183280] Call Trace:
[34407.184053]  <TASK>
[34407.184806]  __schedule+0x23d/0x590
[34407.185576]  schedule+0x4e/0xc0
[34407.186328]  schedule_timeout+0x87/0x140
[34407.187086]  ? __bpf_trace_tick_stop+0x20/0x20
[34407.187995]  rcu_gp_fqs_loop+0xe5/0x330
[34407.188739]  rcu_gp_kthread+0xa7/0x130
[34407.189595]  ? rcu_gp_init+0x5f0/0x5f0
[34407.190341]  kthread+0x12a/0x150
[34407.191075]  ? set_kthread_struct+0x50/0x50
[34407.191801]  ret_from_fork+0x22/0x30
[34407.192517]  </TASK>
[34407.193203] rcu: Stack dump where RCU GP kthread last ran:
[34407.193879] Sending NMI from CPU 1 to CPUs 0:
[34407.194572] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34587.174533] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[34587.176807] rcu:     0-...!: (0 ticks this GP) idle=3D186/0/0x0
softirq=3D164676/164676 fqs=3D1  (false positive?)
[34587.179131]  (detected by 1, t=3D60007 jiffies, g=3D339497, q=3D984)
[34587.181442] Sending NMI from CPU 1 to CPUs 0:
[34587.183795] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34587.184714] rcu: rcu_sched kthread timer wakeup didn't happen for 45004
jiffies! g339497 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[34587.190238] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[34587.191693] rcu: rcu_sched kthread starved for 45005 jiffies! g339497 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[34587.192865] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[34587.193890] rcu: RCU grace-period kthread stack dump:
[34587.194912] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[34587.195743] Call Trace:
[34587.196495]  <TASK>
[34587.197284]  __schedule+0x23d/0x590
[34587.198053]  schedule+0x4e/0xc0
[34587.198835]  schedule_timeout+0x87/0x140
[34587.199611]  ? __bpf_trace_tick_stop+0x20/0x20
[34587.200387]  rcu_gp_fqs_loop+0xe5/0x330
[34587.201216]  rcu_gp_kthread+0xa7/0x130
[34587.201957]  ? rcu_gp_init+0x5f0/0x5f0
[34587.202696]  kthread+0x12a/0x150
[34587.203418]  ? set_kthread_struct+0x50/0x50
[34587.204178]  ret_from_fork+0x22/0x30
[34587.204894]  </TASK>
[34587.205585] rcu: Stack dump where RCU GP kthread last ran:
[34587.206258] Sending NMI from CPU 1 to CPUs 0:
[34587.206950] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34647.179423] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[34647.181691] rcu:     0-...!: (0 ticks this GP) idle=3D28a/0/0x0
softirq=3D164676/164676 fqs=3D0  (false positive?)
[34647.183968]  (detected by 1, t=3D15002 jiffies, g=3D339501, q=3D891)
[34647.186380] Sending NMI from CPU 1 to CPUs 0:
[34647.188753] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34647.189597] rcu: rcu_sched kthread timer wakeup didn't happen for 15001
jiffies! g339501 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[34647.194326] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[34647.195349] rcu: rcu_sched kthread starved for 15002 jiffies! g339501 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[34647.196404] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[34647.197354] rcu: RCU grace-period kthread stack dump:
[34647.198167] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[34647.198932] Call Trace:
[34647.199707]  <TASK>
[34647.200530]  __schedule+0x23d/0x590
[34647.201324]  schedule+0x4e/0xc0
[34647.202185]  schedule_timeout+0x87/0x140
[34647.202951]  ? __bpf_trace_tick_stop+0x20/0x20
[34647.203698]  rcu_gp_fqs_loop+0xe5/0x330
[34647.204436]  rcu_gp_kthread+0xa7/0x130
[34647.205160]  ? rcu_gp_init+0x5f0/0x5f0
[34647.205870]  kthread+0x12a/0x150
[34647.206605]  ? set_kthread_struct+0x50/0x50
[34647.207297]  ret_from_fork+0x22/0x30
[34647.207979]  </TASK>
[34647.208661] rcu: Stack dump where RCU GP kthread last ran:
[34647.209306] Sending NMI from CPU 1 to CPUs 0:
[34647.210057] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34827.190031] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[34827.190721] rcu:     0-...!: (0 ticks this GP) idle=3D58e/0/0x0
softirq=3D164676/164676 fqs=3D1  (false positive?)
[34827.191380]  (detected by 1, t=3D60007 jiffies, g=3D339501, q=3D1046)
[34827.192019] Sending NMI from CPU 1 to CPUs 0:
[34827.192677] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34827.193648] rcu: rcu_sched kthread timer wakeup didn't happen for 45004
jiffies! g339501 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[34827.195679] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[34827.196419] rcu: rcu_sched kthread starved for 45005 jiffies! g339501 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[34827.197187] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[34827.197951] rcu: RCU grace-period kthread stack dump:
[34827.198722] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[34827.199518] Call Trace:
[34827.200302]  <TASK>
[34827.201091]  __schedule+0x23d/0x590
[34827.201878]  schedule+0x4e/0xc0
[34827.202660]  schedule_timeout+0x87/0x140
[34827.203446]  ? __bpf_trace_tick_stop+0x20/0x20
[34827.204230]  rcu_gp_fqs_loop+0xe5/0x330
[34827.205010]  rcu_gp_kthread+0xa7/0x130
[34827.205762]  ? rcu_gp_init+0x5f0/0x5f0
[34827.206499]  kthread+0x12a/0x150
[34827.207219]  ? set_kthread_struct+0x50/0x50
[34827.207951]  ret_from_fork+0x22/0x30
[34827.208683]  </TASK>
[34827.209405] rcu: Stack dump where RCU GP kthread last ran:
[34827.210077] Sending NMI from CPU 1 to CPUs 0:
[34827.210774] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34887.194943] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[34887.197306] rcu:     0-...!: (0 ticks this GP) idle=3D692/0/0x0
softirq=3D164676/164676 fqs=3D0  (false positive?)
[34887.199651]  (detected by 1, t=3D15002 jiffies, g=3D339505, q=3D900)
[34887.201971] Sending NMI from CPU 1 to CPUs 0:
[34887.204327] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[34887.205244] rcu: rcu_sched kthread timer wakeup didn't happen for 15001
jiffies! g339505 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[34887.209853] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[34887.210644] rcu: rcu_sched kthread starved for 15002 jiffies! g339505 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[34887.211468] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[34887.212291] rcu: RCU grace-period kthread stack dump:
[34887.213115] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[34887.214011] Call Trace:
[34887.214802]  <TASK>
[34887.215582]  __schedule+0x23d/0x590
[34887.216368]  schedule+0x4e/0xc0
[34887.217192]  schedule_timeout+0x87/0x140
[34887.217995]  ? __bpf_trace_tick_stop+0x20/0x20
[34887.218794]  rcu_gp_fqs_loop+0xe5/0x330
[34887.219561]  rcu_gp_kthread+0xa7/0x130
[34887.220314]  ? rcu_gp_init+0x5f0/0x5f0
[34887.221053]  kthread+0x12a/0x150
[34887.221803]  ? set_kthread_struct+0x50/0x50
[34887.222526]  ret_from_fork+0x22/0x30
[34887.223238]  </TASK>
[34887.223928] rcu: Stack dump where RCU GP kthread last ran:
[34887.224609] Sending NMI from CPU 1 to CPUs 0:
[34887.225333] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[35067.205569] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[35067.206256] rcu:     0-...!: (0 ticks this GP) idle=3D992/0/0x0
softirq=3D164676/164676 fqs=3D1  (false positive?)
[35067.206934]  (detected by 1, t=3D60007 jiffies, g=3D339505, q=3D1040)
[35067.207619] Sending NMI from CPU 1 to CPUs 0:
[35067.208378] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10
[35067.209305] rcu: rcu_sched kthread timer wakeup didn't happen for 45004
jiffies! g339505 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[35067.211413] rcu:     Possible timer handling issue on cpu=3D0
timer-softirq=3D238296
[35067.212162] rcu: rcu_sched kthread starved for 45005 jiffies! g339505 f0=
x0
RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
[35067.212985] rcu:     Unless rcu_sched kthread gets sufficient CPU time, =
OOM
is now expected behavior.
[35067.213769] rcu: RCU grace-period kthread stack dump:
[35067.214574] task:rcu_sched       state:I stack:    0 pid:   13 ppid:    =
 2
flags:0x00004000
[35067.215473] Call Trace:
[35067.216288]  <TASK>
[35067.217104]  __schedule+0x23d/0x590
[35067.217906]  schedule+0x4e/0xc0
[35067.218699]  schedule_timeout+0x87/0x140
[35067.219485]  ? __bpf_trace_tick_stop+0x20/0x20
[35067.220311]  rcu_gp_fqs_loop+0xe5/0x330
[35067.221125]  rcu_gp_kthread+0xa7/0x130
[35067.221896]  ? rcu_gp_init+0x5f0/0x5f0
[35067.222653]  kthread+0x12a/0x150
[35067.223400]  ? set_kthread_struct+0x50/0x50
[35067.224123]  ret_from_fork+0x22/0x30
[35067.224850]  </TASK>
[35067.225564] rcu: Stack dump where RCU GP kthread last ran:
[35067.226235] Sending NMI from CPU 1 to CPUs 0:
[35067.227017] NMI backtrace for cpu 0 skipped: idling at
native_safe_halt+0xb/0x10

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
