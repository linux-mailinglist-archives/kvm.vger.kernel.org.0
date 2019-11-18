Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B33100621
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 14:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfKRNFi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 18 Nov 2019 08:05:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfKRNFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 08:05:37 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205441] Enabling KVM causes any Linux VM reboot on kernel boot
Date:   Mon, 18 Nov 2019 13:05:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ct@flyingcircus.io
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-205441-28872-gz2FglIOwc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205441-28872@https.bugzilla.kernel.org/>
References: <bug-205441-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205441

Christian Theune (ct@flyingcircus.io) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ct@flyingcircus.io

--- Comment #2 from Christian Theune (ct@flyingcircus.io) ---
I think this is happening to me, too.

Affected hosts:

Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                24
On-line CPU(s) list:   0-23
Thread(s) per core:    2
Core(s) per socket:    6
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 44
Model name:            Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz
Stepping:              2
CPU MHz:               1596.000
CPU max MHz:           2661.0000
CPU min MHz:           1596.0000
BogoMIPS:              5319.79
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              12288K
NUMA node0 CPU(s):     0,2,4,6,8,10,12,14,16,18,20,22
NUMA node1 CPU(s):     1,3,5,7,9,11,13,15,17,19,21,23

and

Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0-7
Thread(s) per core:    1
Core(s) per socket:    4
Socket(s):             2
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 23
Model name:            Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz
Stepping:              6
CPU MHz:               2327.504
CPU max MHz:           2333.0000
CPU min MHz:           2000.0000
BogoMIPS:              4655.07
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              6144K
NUMA node0 CPU(s):     0-7

The OOPSes we see in the guest:

[6196425.778274] general protection fault: 0000 [#1] SMP
[6196425.780178] Modules linked in: ip6t_REJECT nf_reject_ipv6 nf_log_ipv6
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_REJECT
nf_reject_ipv4 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_tcpudp
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack iptable_filter ip_tables x_tables
mousedev psmouse input_leds led_class serio_raw ppdev evdev mac_hid ata_generic
pata_acpi floppy ide_pci_generic piix parport_pc 8250_fintek i2c_piix4
intel_agp parport intel_gtt i8042 ide_core tpm_tis i2c_core agpgart tpm
processor button nf_conntrack_ftp nf_conntrack atkbd libps2 serio loop
cpufreq_ondemand sunrpc i6300esb ipv6 autofs4 xfs libcrc32c crc32c_generic
virtio_net virtio_blk ata_piix libata rtc_cmos scsi_mod virtio_pci dm_mod
virtio_rng rng_core virtio_console virtio_balloon virtio_ring virtio
[6196425.809443] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.91 #1-NixOS
[6196425.812032] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[6196425.815522] task: ffffffff81a11500 ti: ffffffff81a00000 task.ti:
ffffffff81a00000
[6196425.817656] RIP: 0010:[<ffffffff814ddcfa>]  [<ffffffff814ddcfa>]
__schedule+0x28a/0xa10
[6196425.821087] RSP: 0018:ffffffff81a03e90  EFLAGS: 00010007
[6196425.822750] RAX: ffff880079b79b00 RBX: ffff88007fc15680 RCX:
0000000000000000
[6196425.824790] RDX: 000077ff80000000 RSI: ffff880079b79b00 RDI:
0000000078dda000
[6196425.826828] RBP: ffffffff81a03ec8 R08: 0000000000000001 R09:
0016039dcd5c1010
[6196425.828852] R10: 0000000000000003 R11: 0000000000000001 R12:
ffff880079bbce00
[6196425.830899] R13: ffff880079b30e00 R14: 0000000000000000 R15:
ffffffff81a11a58
[6196425.832924] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[6196425.835210] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[6196425.836863] CR2: 00000000ffffffff CR3: 0000000079b48000 CR4:
00000000000006f0
[6196425.838894] Stack:
[6196425.839519]  ffff880079b79b00 ffffffff81a11500 ffffffff81a04000
ffffffff81a04000
[6196425.841768]  0000000000000000 0000000000000000 ffffffff81a00000
ffffffff81a03ee0
[6196425.843997]  ffffffff814de4b5 ffffffff81ae3c18 ffffffff81a03ef0
ffffffff814de74e
[6196425.846234] Call Trace:
[6196425.847003]  [<ffffffff814de4b5>] schedule+0x35/0x80
[6196425.848433]  [<ffffffff814de74e>] schedule_preempt_disabled+0xe/0x10
[6196425.850269]  [<ffffffff810aaa62>] cpu_startup_entry+0x182/0x340
[6196425.851977]  [<ffffffff814db6ec>] rest_init+0x7c/0x80
[6196425.853454]  [<ffffffff81b06f92>] start_kernel+0x46c/0x479
[6196425.855045]  [<ffffffff81b06120>] ? early_idt_handler_array+0x120/0x120
[6196425.856967]  [<ffffffff81b064d7>] x86_64_start_reservations+0x2a/0x2c
[6196425.858806]  [<ffffffff81b06614>] x86_64_start_kernel+0x13b/0x14a
[6196425.860543] Code: 89 f6 3e 4d 0f ab b4 24 d0 02 00 00 bf 00 00 00 80 49 03
7c 24 40 48 ba 00 00 00 80 ff 77 00 00 48 0f 42 15 19 33 53 00 48 01 d7 <0f> 22
df 0f 1f 40 00 0f 1f 44 00 00 3e 4d 0f b3 b5 d0 02 00 00
[6196425.867994] RIP  [<ffffffff814ddcfa>] __schedule+0x28a/0xa10
[6196425.869677]  RSP <ffffffff81a03e90>
[6196425.871737] ---[ end trace 4aa829a660f98e5f ]---
[6196425.873089] Kernel panic - not syncing: Attempted to kill the idle task!
[6196425.875093] Kernel Offset: disabled
[6196425.876142] Rebooting in 1 seconds..

[6208895.826260] general protection fault: 0000 [#1] SMP
[6208895.828125] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4
nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo xt_addrtype br_netfilter
bridge stp llc dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio
ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_filter ip6_tables ipt_REJECT nf_reject_ipv4 xt_pkttype nf_log_ipv4
nf_log_common xt_LOG xt_tcpudp xt_conntrack iptable_filter iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip_tables x_tables mousedev
input_leds led_class psmouse serio_raw evdev ppdev mac_hid ata_generic
pata_acpi ide_pci_generic piix i2c_piix4 8250_fintek intel_agp tpm_tis
parport_pc intel_gtt floppy tpm ide_core parport i8042 i2c_core agpgart
processor button nf_conntrack_ftp nf_conntrack tun atkbd libps2 serio loop
cpufreq_ondemand sunrpc i6300esb ipv6 autofs4 xfs libcrc32c crc32c_generic
virtio_net virtio_blk ata_piix libata rtc_cmos scsi_mod virtio_pci dm_mod
virtio_rng rng_core virtio_console virtio_balloon virtio_ring virtio
[6208895.856708] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.4.91 #1-NixOS
[6208895.858538] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[6208895.862364] task: ffff88013abb9b00 ti: ffff88013abc0000 task.ti:
ffff88013abc0000
[6208895.864478] RIP: 0010:[<ffffffff814ddcfa>] [<ffffffff814ddcfa>]
__schedule+0x28a/0xa10
[6208895.866842] RSP: 0018:ffff88013abc3e78 EFLAGS: 00010007
[6208895.868359] RAX: ffff8800ba8a0000 RBX: ffff88013fd15680 RCX:
0000000000000000
[6208895.870387] RDX: 000077ff80000000 RSI: ffff8800ba8a0000 RDI:
0000000139541000
[6208895.872909] RBP: ffff88013abc3eb0 R08: 0000000000000000 R09:
00160ef5361dc5cd
[6208895.875064] R10: 0000000000000003 R11: 0000000000000001 R12:
ffff8800bb72ce00
[6208895.877105] R13: ffff8800baa0b800 R14: 0000000000000001 R15:
ffff88013abba058
[6208895.879125] FS: 0000000000000000(0000) GS:ffff88013fd00000(0000)
knlGS:0000000000000000
[6208895.881409] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[6208895.883057] CR2: 00000000ffffffff CR3: 000000013a359000 CR4:
00000000000006e0
[6208895.885082] Stack:
[6208895.885713] ffff8800ba8a0000 ffff88013abb9b00 ffff88013abc4000
ffff88013abc4000
[6208895.887943] 0000000000000000 0000000000000000 ffff88013abc0000
ffff88013abc3ec8
[6208895.890439] ffffffff814de4b5 ffffffff81ae3c18 ffff88013abc3ed8
ffffffff814de74e
[6208895.892742] Call Trace:
[6208895.893495] [<ffffffff814de4b5>] schedule+0x35/0x80
[6208895.894949] [<ffffffff814de74e>] schedule_preempt_disabled+0xe/0x10
[6208895.896789] [<ffffffff810aaa62>] cpu_startup_entry+0x182/0x340
[6208895.898481] [<ffffffff8104bca2>] start_secondary+0x132/0x140
[6208895.900151] Code: 89 f6 f0 4d 0f ab b4 24 d0 02 00 00 bf 00 00 00 80 49 03
7c 24 40 48 ba 00 00 00 80 ff 77 00 00 48 0f 42 15 19 33 53 00 48 01 d7 <0f> 22
df 0f 1f 40 00 0f 1f 44 00 00 f0 4d 0f b3 b5 d0 02 00 00
[6208895.907522] RIP [<ffffffff814ddcfa>] __schedule+0x28a/0xa10
[6208895.909189] RSP <ffff88013abc3e78>
[6208895.911235] ---[ end trace fc03b7585c232c61 ]---
[6208895.911247] general protection fault: 0000 [#2] SMP
[6208895.911287] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4
nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo xt_addrtype br_netfilter
bridge stp llc dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio
ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_filter ip6_tables ipt_REJECT nf_reject_ipv4 xt_pkttype nf_log_ipv4
nf_log_common xt_LOG xt_tcpudp xt_conntrack iptable_filter iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip_tables x_tables mousedev
input_leds led_class psmouse serio_raw evdev ppdev mac_hid ata_generic
pata_acpi ide_pci_generic piix i2c_piix4 8250_fintek intel_agp tpm_tis
parport_pc intel_gtt floppy tpm ide_core parport i8042 i2c_core agpgart
processor button nf_conntrack_ftp nf_conntrack tun atkbd libps2 serio loop
cpufreq_ondemand sunrpc i6300esb ipv6 autofs4 xfs libcrc32c crc32c_generic
virtio_net virtio_blk ata_piix libata rtc_cmos scsi_mod virtio_pci dm_mod
virtio_rng rng_core virtio_console virtio_balloon virtio_ring virtio
[6208895.911302] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G D 4.4.91 #1-NixOS
[6208895.911303] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[6208895.911305] task: ffffffff81a11500 ti: ffffffff81a00000 task.ti:
ffffffff81a00000
[6208895.911312] RIP: 0010:[<ffffffff814ddcfa>] [<ffffffff814ddcfa>]
__schedule+0x28a/0xa10
[6208895.911313] RSP: 0018:ffffffff81a03e90 EFLAGS: 00010007
[6208895.911314] RAX: ffff8800b9933600 RBX: ffff88013fc15680 RCX:
0000000000000000
[6208895.911315] RDX: 000077ff80000000 RSI: ffff8800b9933600 RDI:
000000013a359000
[6208895.911316] RBP: ffffffff81a03ec8 R08: 0000000000000001 R09:
00160ef53628cb62
[6208895.911317] R10: 0000000000000003 R11: 0000000000000001 R12:
ffff8800baa0b800
[6208895.911317] R13: ffff8800baa0ad80 R14: 0000000000000000 R15:
ffffffff81a11a58
[6208895.911322] FS: 0000000000000000(0000) GS:ffff88013fc00000(0000)
knlGS:0000000000000000
[6208895.911323] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[6208895.911324] CR2: 00000000ffffffff CR3: 00000000b81bb000 CR4:
00000000000006f0
[6208895.911328] Stack:
[6208895.911330] ffff8800b9933600 ffffffff81a11500 ffffffff81a04000
ffffffff81a04000
[6208895.911332] 0000000000000000 0000000000000000 ffffffff81a00000
ffffffff81a03ee0
[6208895.911333] ffffffff814de4b5 ffffffff81ae3c18 ffffffff81a03ef0
ffffffff814de74e
[6208895.911334] Call Trace:
[6208895.911338] [<ffffffff814de4b5>] schedule+0x35/0x80
[6208895.911340] [<ffffffff814de74e>] schedule_preempt_disabled+0xe/0x10
[6208895.911344] [<ffffffff810aaa62>] cpu_startup_entry+0x182/0x340
[6208895.911346] [<ffffffff814db6ec>] rest_init+0x7c/0x80
[6208895.911389] [<ffffffff81b06f92>] start_kernel+0x46c/0x479
[6208895.911397] [<ffffffff81b06120>] ? early_idt_handler_array+0x120/0x120
[6208895.911399] [<ffffffff81b064d7>] x86_64_start_reservations+0x2a/0x2c
[6208895.911401] [<ffffffff81b06614>] x86_64_start_kernel+0x13b/0x14a
[6208895.911418] Code: 89 f6 f0 4d 0f ab b4 24 d0 02 00 00 bf 00 00 00 80 49 03
7c 24 40 48 ba 00 00 00 80 ff 77 00 00 48 0f 42 15 19 33 53 00 48 01 d7 <0f> 22
df 0f 1f 40 00 0f 1f 44 00 00 f0 4d 0f b3 b5 d0 02 00 00
[6208895.911419] RIP [<ffffffff814ddcfa>] __schedule+0x28a/0xa10
[6208895.911420] RSP <ffffffff81a03e90>
[6208895.911425] ---[ end trace fc03b7585c232c62 ]---
[6208895.911428] Kernel panic - not syncing: Attempted to kill the idle task!
[6208897.121744] Shutting down cpus with NMI
[6208897.123596] Kernel Offset: disabled
[6208897.124691] Rebooting in 1 seconds..

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
