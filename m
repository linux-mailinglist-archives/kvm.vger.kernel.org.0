Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA99658EBD1
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbiHJMNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiHJMNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:13:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11FC2DAA7
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 05:13:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5284CB818DF
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0DCBC433C1
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660133626;
        bh=bVfO+8Hj++FyIkd942XOtXfwwYMWCkrZgD2pfrId5xU=;
        h=From:To:Subject:Date:From;
        b=m79lj5603NYcddgFlnF8pj7jnhHAfXK89n+1RAWmSGke+3ONHHl0BBl2shO10ceZL
         ArZlPNc25KWK5mhouC+wzDGpeGo7JJU10RJJU0v1OvgiVBjnmNweHVi1q7lTUPV5D6
         kBL1QoAXS2RqV++rBNkWpeAMuSr4v6ZbCFlpu7bGl2D8xHJt1C8Am7MzERGf6a0WuA
         UcfR3pSuHYWtl1HN/LQTiX8DJ+b6z5YJ2wCEd7MartzRx4JjiUoYmqIm0WKuvVLTBZ
         VQDDu1XNDgu1yUrh0k8/WXvnetrjQyptaM21CDKZ3Lvl/goFRgMsJ5nVP2Yb27xQ3v
         L5CivPEvjLQkA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E2A77C433E9; Wed, 10 Aug 2022 12:13:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] New: Kernel panic in a Ubuntu VM running on Proxmox
Date:   Wed, 10 Aug 2022 12:13:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216349-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 216349
           Summary: Kernel panic in a Ubuntu VM running on Proxmox
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.15.39-3
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: jdpark.au@gmail.com
        Regression: No

Hi,

I've experienced quite a few kernel panics over a week or so on a VM runnin=
g on
a Proxmox server. I've also experienced the same issue on a pfSense VM runn=
ing
on the same Proxmox server but haven't been able to capture a log from that=
 VM.

Host details:
Proxmox 7.2-7
Kernel: 5.15.39-3
CPU: Intel N5105

VM Details:
Ubuntu 22.04
Kernel: 5.15.0-46-generic

The VM freezes and becomes completely unresponsive. I have to do a hard res=
et
on the VM in order to recover. Nothing is logged to dmesg or syslog so I se=
t up
netconsole to log to a remote server and added:
GRUB_CMDLINE_LINUX_DEFAULT=3D"debug ignore_loglevel" to grub.

Below is the output of the panic. Please let me know if there's any more
information I can provide.

---

[12361.508193] BUG: kernel NULL pointer dereference, address: 0000000000000=
000
[12361.509399] #PF: supervisor write access in kernel mode
[12361.510524] #PF: error_code(0x0002) - not-present page
[12361.511847] PGD 0 P4D 0=20
[12361.513120] Oops: 0002 [#1] SMP PTI
[12361.514392] CPU: 0 PID: 3268 Comm: python3 Not tainted 5.15.0-46-generic
#49-Ubuntu
[12361.515796] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
[12361.518606] RIP: 0010:asm_exc_general_protection+0x4/0x30
[12361.520233] Code: c4 48 8d 6c 24 01 48 89 e7 48 8b 74 24 78 48 c7 44 24 =
78
ff ff ff ff e8 ea 7f f9 ff e9 05 0b 00 00 0f 1f 44 00 00 0f 1f 00 e8 <c8> 0=
9 00
00 48 89 c4 48 8d 6c 24 01 48 89 e7 48 8b 74 24 78 48 c7
[12361.523251] RSP: 0018:ffffa7498342f010 EFLAGS: 00010046
[12361.524599] RAX: 0000000000000000 RBX: 0000000000000015 RCX:
0000000000000001
[12361.525806] RDX: ffff8fed49a6ed00 RSI: ffff8fed4b178000 RDI:
ffff8fec418a9400
[12361.527014] RBP: ffffa7498342f8b0 R08: 0000000000000015 R09:
ffff8fed4b1780a8
[12361.527868] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff8fed57e4f180
[12361.528754] R13: 0000000000004000 R14: 0000000000000015 R15:
0000000000000001
[12361.529623] FS:  00007f291afb8b30(0000) GS:ffff8fed7bc00000(0000)
knlGS:0000000000000000
[12361.530318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12361.530941] CR2: 0000000000000000 CR3: 0000000102ad8000 CR4:
00000000000006f0
[12361.531602] Call Trace:
[12361.532257]  <TASK>
[12361.532953]  ? asm_exc_int3+0x40/0x40
[12361.533565]  ? asm_exc_general_protection+0x4/0x30
[12361.534192]  ? asm_exc_int3+0x40/0x40
[12361.534823]  ? asm_exc_general_protection+0x4/0x30
[12361.535450]  ? asm_exc_int3+0x40/0x40
[12361.536063]  ? asm_exc_general_protection+0x4/0x30
[12361.536675]  ? asm_exc_int3+0x40/0x40
[12361.537262]  ? asm_exc_general_protection+0x4/0x30
[12361.537845]  ? asm_exc_int3+0x40/0x40
[12361.538425]  ? asm_exc_general_protection+0x4/0x30
[12361.539015]  ? asm_exc_int3+0x40/0x40
[12361.539630]  ? asm_exc_general_protection+0x4/0x30
[12361.540212]  ? asm_exc_int3+0x40/0x40
[12361.540825]  ? asm_exc_general_protection+0x4/0x30
[12361.541561]  ? asm_exc_int3+0x40/0x40
[12361.542191]  ? asm_exc_general_protection+0x4/0x30
[12361.542761]  ? asm_exc_int3+0x40/0x40
[12361.543325]  ? asm_exc_general_protection+0x4/0x30
[12361.543909]  ? asm_exc_int3+0x40/0x40
[12361.544481]  ? asm_exc_general_protection+0x4/0x30
[12361.545062]  ? asm_exc_int3+0x40/0x40
[12361.545677]  ? asm_exc_general_protection+0x4/0x30
[12361.546270]  ? asm_exc_int3+0x40/0x40
[12361.546861]  ? asm_exc_general_protection+0x4/0x30
[12361.547466]  ? asm_exc_int3+0x40/0x40
[12361.548071]  ? asm_exc_general_protection+0x4/0x30
[12361.548669]  ? asm_exc_int3+0x40/0x40
[12361.549258]  ? asm_exc_general_protection+0x4/0x30
[12361.549844]  ? asm_exc_int3+0x40/0x40
[12361.550425]  ? asm_exc_general_protection+0x4/0x30
[12361.551007]  ? asm_exc_int3+0x40/0x40
[12361.551594]  ? asm_exc_general_protection+0x4/0x30
[12361.552138]  ? asm_exc_int3+0x40/0x40
[12361.552671]  ? asm_exc_general_protection+0x4/0x30
[12361.553201]  ? asm_exc_int3+0x40/0x40
[12361.553737]  ? asm_exc_general_protection+0x4/0x30
[12361.554226]  ? asm_exc_int3+0x40/0x40
[12361.554706]  ? asm_exc_general_protection+0x4/0x30
[12361.555175]  ? asm_exc_int3+0x40/0x40
[12361.555646]  ? asm_exc_general_protection+0x4/0x30
[12361.556093]  ? asm_exc_int3+0x40/0x40
[12361.556549]  ? asm_exc_general_protection+0x4/0x30
[12361.556992]  ? asm_exc_int3+0x40/0x40
[12361.557420]  ? asm_sysvec_spurious_apic_interrupt+0x20/0x20
[12361.557849]  ? schedule_hrtimeout_range_clock+0xa0/0x120
[12361.558272]  ? __fget_files+0x51/0xc0
[12361.558707]  ? __hrtimer_init+0x110/0x110
[12361.559140]  __fget_light+0x32/0x90
[12361.559560]  __fdget+0x13/0x20
[12361.559989]  do_select+0x302/0x850
[12361.560405]  ? __pollwait+0xe0/0xe0
[12361.560820]  ? __pollwait+0xe0/0xe0
[12361.561261]  ? __pollwait+0xe0/0xe0
[12361.561648]  ? __pollwait+0xe0/0xe0
[12361.562028]  ? cpumask_next_and+0x24/0x30
[12361.562443]  ? update_sg_lb_stats+0x78/0x580
[12361.562857]  ? kfree_skbmem+0x81/0xa0
[12361.563266]  ? update_group_capacity+0x2c/0x2d0
[12361.563725]  ? update_sd_lb_stats.constprop.0+0xe0/0x250
[12361.564130]  ? __check_object_size.part.0+0x3a/0x150
[12361.564518]  ? __check_object_size+0x1d/0x30
[12361.564904]  ? core_sys_select+0x246/0x420
[12361.565288]  core_sys_select+0x1dd/0x420
[12361.565684]  ? ktime_get_ts64+0x55/0x100
[12361.566086]  ? _copy_to_user+0x20/0x30
[12361.566495]  ? poll_select_finish+0x121/0x220
[12361.566899]  ? kvm_clock_get_cycles+0x11/0x20
[12361.567313]  kern_select+0xdd/0x180
[12361.567744]  __x64_sys_select+0x21/0x30
[12361.568148]  do_syscall_64+0x5c/0xc0
[12361.568546]  ? __do_softirq+0xd9/0x2e7
[12361.568947]  ? exit_to_user_mode_prepare+0x37/0xb0
[12361.569349]  ? irqentry_exit_to_user_mode+0x9/0x20
[12361.569753]  ? irqentry_exit+0x1d/0x30
[12361.570154]  ? sysvec_apic_timer_interrupt+0x4e/0x90
[12361.570558]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[12361.570970] RIP: 0033:0x7f292739f4a3
[12361.571394] Code: c3 8b 07 85 c0 75 24 49 89 fb 48 89 f0 48 89 d7 48 89 =
ce
4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> e=
9 c7
d1 ff ff 41 54 b8 02 00 00 00 49 89 f4 be 00 88 08 00 55
[12361.572283] RSP: 002b:00007f291afaaf68 EFLAGS: 00000246 ORIG_RAX:
0000000000000017
[12361.572752] RAX: ffffffffffffffda RBX: 00007f291afb8b30 RCX:
00007f292739f4a3
[12361.573227] RDX: 00007f291afab090 RSI: 00007f291afab010 RDI:
0000000000000017
[12361.573706] RBP: 00007f291afab010 R08: 00007f291afaafb0 R09:
0000000000000000
[12361.574182] R10: 00007f291afab110 R11: 0000000000000246 R12:
0000000000000017
[12361.574656] R13: 00007f291afab090 R14: 00007f291afab190 R15:
00007f291afaf1a0
[12361.575144]  </TASK>
[12361.575640] Modules linked in: xt_nat xt_tcpudp veth xt_conntrack
nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo nft_counter xt_addrtype
nft_compat nf_tables nfnetlink br_netfilter bridge stp llc overlay sch_fq_c=
odel
joydev input_leds cp210x serio_raw usbserial cdc_acm qemu_fw_cfg mac_hid
dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua efi_pstore pstore_blk mtd
ramoops netconsole reed_solomon ipmi_devintf ipmi_msghandler msr pstore_zone
ip_tables x_tables autofs4 btrfs blake2b_generic zstd_compress raid10 raid4=
56
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
libcrc32c raid1 raid0 multipath linear hid_generic bochs drm_vram_helper
drm_ttm_helper ttm psmouse drm_kms_helper usbhid syscopyarea sysfillrect
virtio_net sysimgblt fb_sys_fops net_failover failover cec hid rc_core
virtio_scsi drm i2c_piix4 pata_acpi floppy
[12361.580240] CR2: 0000000000000000
[12361.580896] ---[ end trace 2596706ab1b3b337 ]---
[12361.581518] RIP: 0010:asm_exc_general_protection+0x4/0x30
[12361.582178] Code: c4 48 8d 6c 24 01 48 89 e7 48 8b 74 24 78 48 c7 44 24 =
78
ff ff ff ff e8 ea 7f f9 ff e9 05 0b 00 00 0f 1f 44 00 00 0f 1f 00 e8 <c8> 0=
9 00
00 48 89 c4 48 8d 6c 24 01 48 89 e7 48 8b 74 24 78 48 c7
[12361.583552] RSP: 0018:ffffa7498342f010 EFLAGS: 00010046
[12361.584323] RAX: 0000000000000000 RBX: 0000000000000015 RCX:
0000000000000001
[12361.585078] RDX: ffff8fed49a6ed00 RSI: ffff8fed4b178000 RDI:
ffff8fec418a9400
[12361.585828] RBP: ffffa7498342f8b0 R08: 0000000000000015 R09:
ffff8fed4b1780a8
[12361.586563] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff8fed57e4f180
[12361.587283] R13: 0000000000004000 R14: 0000000000000015 R15:
0000000000000001
[12361.588012] FS:  00007f291afb8b30(0000) GS:ffff8fed7bc00000(0000)
knlGS:0000000000000000
[12361.588742] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12361.589472] CR2: 0000000000000000 CR3: 0000000102ad8000 CR4:
00000000000006f0
[12394.744918] BUG: kernel NULL pointer dereference, address: 0000000000000=
045
[12394.745723] #PF: supervisor instruction fetch in kernel mode
[12394.746513] #PF: error_code(0x0010) - not-present page
[12394.747292] PGD 0 P4D 0=20
[12394.748083] Oops: 0010 [#2] SMP PTI
[12394.748858] CPU: 0 PID: 3950 Comm: mosquitto Tainted: G      D=20=20=20=
=20=20=20=20=20=20=20
5.15.0-46-generic #49-Ubuntu
[12394.749639] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
[12394.751251] RIP: 0010:0x45
[12394.752088] Code: Unable to access opcode bytes at RIP 0x1b.
[12394.752907] RSP: 0018:ffffa74980003648 EFLAGS: 00010046
[12394.753731] RAX: 0000000000000045 RBX: ffff8fed57f082c8 RCX:
00000000000000c3
[12394.754576] RDX: 0000000000000010 RSI: 0000000000000001 RDI:
ffffa7498342fa00
[12394.755413] RBP: ffffa74980003690 R08: 00000000000000c3 R09:
ffffa749800036a8
[12394.756244] R10: 00000000b140ae3e R11: ffffa74980003730 R12:
0000000000000000
[12394.757091] R13: 0000000000000000 R14: 0000000000000010 R15:
00000000000000c3
[12394.757972] FS:  00007f250ea9ab48(0000) GS:ffff8fed7bc00000(0000)
knlGS:0000000000000000
[12394.758803] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12394.759627] CR2: 0000000000000045 CR3: 0000000026064000 CR4:
00000000000006f0
[12394.760488] Call Trace:
[12394.761303]  <IRQ>
[12394.762148]  ? __wake_up_common+0x7d/0x140
[12394.762979]  __wake_up_common_lock+0x7c/0xc0
[12394.763834]  __wake_up_sync_key+0x20/0x30
[12394.764666]  sock_def_readable+0x3b/0x80
[12394.765471]  tcp_data_ready+0x31/0xe0
[12394.766280]  tcp_data_queue+0x315/0x610
[12394.767028]  tcp_rcv_established+0x25f/0x6d0
[12394.767799]  tcp_v4_do_rcv+0x155/0x260
[12394.768568]  tcp_v4_rcv+0xd9d/0xed0
[12394.769302]  ip_protocol_deliver_rcu+0x3d/0x240
[12394.770033]  ip_local_deliver_finish+0x48/0x60
[12394.770726]  ip_local_deliver+0xfb/0x110
[12394.771387]  ? ip_protocol_deliver_rcu+0x240/0x240
[12394.772059]  ip_rcv_finish+0xbe/0xd0
[12394.772746]  ip_sabotage_in+0x5f/0x70 [br_netfilter]
[12394.773425]  nf_hook_slow+0x44/0xc0
[12394.774105]  ip_rcv+0x8a/0x190
[12394.774731]  ? ip_sublist_rcv+0x200/0x200
[12394.775349]  __netif_receive_skb_one_core+0x8a/0xa0
[12394.775959]  __netif_receive_skb+0x15/0x60
[12394.776551]  netif_receive_skb+0x43/0x140
[12394.777140]  ? fdb_find_rcu+0xb1/0x130 [bridge]
[12394.777769]  br_pass_frame_up+0x151/0x190 [bridge]
[12394.778382]  br_handle_frame_finish+0x1a5/0x520 [bridge]
[12394.778981]  ? __nf_ct_refresh_acct+0x55/0x60 [nf_conntrack]
[12394.779589]  ? nf_conntrack_tcp_packet+0x61f/0xf60 [nf_conntrack]
[12394.780171]  ? br_pass_frame_up+0x190/0x190 [bridge]
[12394.780758]  br_nf_hook_thresh+0xe1/0x120 [br_netfilter]
[12394.781337]  ? br_pass_frame_up+0x190/0x190 [bridge]
[12394.781937]  br_nf_pre_routing_finish+0x16e/0x430 [br_netfilter]
[12394.782517]  ? br_pass_frame_up+0x190/0x190 [bridge]
[12394.783122]  ? nf_nat_ipv4_pre_routing+0x4a/0xc0 [nf_nat]
[12394.783755]  br_nf_pre_routing+0x245/0x550 [br_netfilter]
[12394.784323]  ? tcp_write_xmit+0x690/0xb10
[12394.784872]  ? br_nf_forward_arp+0x320/0x320 [br_netfilter]
[12394.785424]  br_handle_frame+0x211/0x3c0 [bridge]
[12394.785995]  ? fib_multipath_hash+0x4a0/0x6a0
[12394.786535]  ? br_pass_frame_up+0x190/0x190 [bridge]
[12394.787075]  ? br_handle_frame_finish+0x520/0x520 [bridge]
[12394.787615]  __netif_receive_skb_core.constprop.0+0x23a/0xef0
[12394.788148]  ? ip_rcv+0x16f/0x190
[12394.788718]  __netif_receive_skb_one_core+0x3f/0xa0
[12394.789306]  __netif_receive_skb+0x15/0x60
[12394.789831]  process_backlog+0x9e/0x170
[12394.790353]  __napi_poll+0x33/0x190
[12394.790860]  net_rx_action+0x126/0x280
[12394.791351]  __do_softirq+0xd9/0x2e7
[12394.791846]  do_softirq+0x7d/0xb0
[12394.792350]  </IRQ>
[12394.792855]  <TASK>
[12394.793338]  __local_bh_enable_ip+0x54/0x60
[12394.793830]  ip_finish_output2+0x1a2/0x580
[12394.794331]  __ip_finish_output+0xb7/0x180
[12394.794823]  ip_finish_output+0x2e/0xc0
[12394.795316]  ip_output+0x78/0x100
[12394.795803]  ? __ip_finish_output+0x180/0x180
[12394.796322]  ip_local_out+0x5e/0x70
[12394.796816]  __ip_queue_xmit+0x180/0x440
[12394.797311]  ? page_counter_cancel+0x2e/0x80
[12394.797820]  ip_queue_xmit+0x15/0x20
[12394.798322]  __tcp_transmit_skb+0x8dd/0xa00
[12394.798813]  tcp_write_xmit+0x3ab/0xb10
[12394.799303]  ? __check_object_size.part.0+0x4a/0x150
[12394.799808]  __tcp_push_pending_frames+0x37/0x100
[12394.800308]  tcp_push+0xd6/0x100
[12394.800806]  tcp_sendmsg_locked+0x883/0xc80
[12394.801303]  tcp_sendmsg+0x2d/0x50
[12394.801793]  inet_sendmsg+0x43/0x80
[12394.802302]  sock_sendmsg+0x62/0x70
[12394.802787]  sock_write_iter+0x93/0xf0
[12394.803277]  new_sync_write+0x193/0x1b0
[12394.803770]  vfs_write+0x1d5/0x270
[12394.804276]  ksys_write+0xb5/0xf0
[12394.804737]  ? syscall_trace_enter.constprop.0+0xa7/0x1c0
[12394.805205]  __x64_sys_write+0x19/0x20
[12394.805665]  do_syscall_64+0x5c/0xc0
[12394.806129]  ? syscall_exit_to_user_mode+0x27/0x50
[12394.806592]  ? do_syscall_64+0x69/0xc0
[12394.807059]  ? do_syscall_64+0x69/0xc0
[12394.807549]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[12394.808008] RIP: 0033:0x7f250ea593ad
[12394.808499] Code: c3 8b 07 85 c0 75 24 49 89 fb 48 89 f0 48 89 d7 48 89 =
ce
4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> e=
9 8a
d2 ff ff 41 54 b8 02 00 00 00 49 89 f4 be 00 88 08 00 55
[12394.809442] RSP: 002b:00007ffea08ec188 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[12394.809945] RAX: ffffffffffffffda RBX: 00007f250ea9ab48 RCX:
00007f250ea593ad
[12394.810440] RDX: 00000000000000a2 RSI: 00007f250e79c810 RDI:
0000000000000009
[12394.810933] RBP: 00007f250e7d7e80 R08: 0000000000000000 R09:
0000000000000000
[12394.811451] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000001
[12394.811938] R13: 000000000000009f R14: 0000000000000000 R15:
00007f250e7d7e80
[12394.812449]  </TASK>
[12394.812930] Modules linked in: xt_nat xt_tcpudp veth xt_conntrack
nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo nft_counter xt_addrtype
nft_compat nf_tables nfnetlink br_netfilter bridge stp llc overlay sch_fq_c=
odel
joydev input_leds cp210x serio_raw usbserial cdc_acm qemu_fw_cfg mac_hid
dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua efi_pstore pstore_blk mtd
ramoops netconsole reed_solomon ipmi_devintf ipmi_msghandler msr pstore_zone
ip_tables x_tables autofs4 btrfs blake2b_generic zstd_compress raid10 raid4=
56
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
libcrc32c raid1 raid0 multipath linear hid_generic bochs drm_vram_helper
drm_ttm_helper ttm psmouse drm_kms_helper usbhid syscopyarea sysfillrect
virtio_net sysimgblt fb_sys_fops net_failover failover cec hid rc_core
virtio_scsi drm i2c_piix4 pata_acpi floppy
[12394.817596] CR2: 0000000000000045
[12394.818324] ---[ end trace 2596706ab1b3b338 ]---
[12394.819007] RIP: 0010:asm_exc_general_protection+0x4/0x30
[12394.819695] Code: c4 48 8d 6c 24 01 48 89 e7 48 8b 74 24 78 48 c7 44 24 =
78
ff ff ff ff e8 ea 7f f9 ff e9 05 0b 00 00 0f 1f 44 00 00 0f 1f 00 e8 <c8> 0=
9 00
00 48 89 c4 48 8d 6c 24 01 48 89 e7 48 8b 74 24 78 48 c7
[12394.821094] RSP: 0018:ffffa7498342f010 EFLAGS: 00010046
[12394.821847] RAX: 0000000000000000 RBX: 0000000000000015 RCX:
0000000000000001
[12394.822622] RDX: ffff8fed49a6ed00 RSI: ffff8fed4b178000 RDI:
ffff8fec418a9400
[12394.823371] RBP: ffffa7498342f8b0 R08: 0000000000000015 R09:
ffff8fed4b1780a8
[12394.824113] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff8fed57e4f180
[12394.824874] R13: 0000000000004000 R14: 0000000000000015 R15:
0000000000000001
[12394.825623] FS:  00007f250ea9ab48(0000) GS:ffff8fed7bc00000(0000)
knlGS:0000000000000000
[12394.826391] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12394.827160] CR2: 0000000000000045 CR3: 0000000026064000 CR4:
00000000000006f0
[12394.827934] Kernel panic - not syncing: Fatal exception in interrupt
[12394.828901] Kernel Offset: 0x8200000 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffffbfffffff)
[12394.829699] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
