Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 008351F914
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 19:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfEORFg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 15 May 2019 13:05:36 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43230 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbfEORFg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 13:05:36 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B579928816
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 17:05:34 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id AA2ED28857; Wed, 15 May 2019 17:05:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203611] New: Qemu nested virtualization is not working
Date:   Wed, 15 May 2019 17:05:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ne-vlezay80@yandex.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-203611-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203611

            Bug ID: 203611
           Summary: Qemu nested virtualization is not working
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.1.0 and 4.20.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ne-vlezay80@yandex.ru
        Regression: No

The error:
[ 1288.133697] WARNING: CPU: 0 PID: 5898 at arch/x86/kvm/mmu.c:2107
nonpaging_update_pte+0x5/0x10 [kvm]
[ 1288.133698] Modules linked in: ipt_MASQUERADE iptable_nat ip_tables x_tables
bpfilter fuse openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 cpufreq_conservative cpufreq_userspace cpufreq_powersave
binfmt_misc vhost_vsock vmw_vsock_virtio_transport_common vsock vhost_net tun
vhost tap dm_crypt dm_mod zram zsmalloc snd_hda_codec_hdmi edac_mce_amd kvm_amd
ccp rng_core kvm irqbypass crct10dif_pclmul snd_hda_codec_realtek joydev
snd_hda_codec_generic crc32_pclmul ledtrig_audio ghash_clmulni_intel
snd_hda_intel ppdev snd_hda_codec aesni_intel evdev snd_hda_core snd_hwdep
aes_x86_64 snd_pcm crypto_simd cryptd snd_timer glue_helper snd serio_raw
soundcore pcspkr wmi_bmof k10temp fam15h_power sp5100_tco parport_pc parport
asus_atk0110 pcc_cpufreq acpi_cpufreq button hid_generic usbhid hid ext4 crc16
mbcache jbd2 btrfs xor zstd_decompress zstd_compress raid6_pq libcrc32c
crc32c_generic overlay ohci_pci sg xhci_pci crc32c_intel r8169 psmouse ehci_pci
ohci_hcd xhci_hcd
[ 1288.133722]  realtek ehci_hcd sr_mod pata_atiixp i2c_piix4 cdrom sd_mod
libphy usbcore e1000e wmi
[ 1288.133727] CPU: 0 PID: 5898 Comm: qemu-system-x86 Not tainted 5.1.0 #1
[ 1288.133728] Hardware name: System manufacturer System Product Name/M5A78L-M
PLUS/USB3, BIOS 0502    11/18/2016
[ 1288.133742] RIP: 0010:nonpaging_update_pte+0x5/0x10 [kvm]
[ 1288.133743] Code: 00 00 00 00 00 0f 1f 44 00 00 31 c0 c3 0f 1f 84 00 00 00
00 00 0f 1f 44 00 00 f3 c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 <0f> 0b c3
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 85 c9 48 89 f0
[ 1288.133744] RSP: 0018:ffffa73c085cba60 EFLAGS: 00010202
[ 1288.133745] RAX: ffffffffc0967730 RBX: 0000000000000000 RCX:
ffffa73c085cba98
[ 1288.133746] RDX: ffff9a1e64ad0000 RSI: ffff9a1e4dadff18 RDI:
ffff9a1e4d870240
[ 1288.133746] RBP: ffffa73c085cbaa0 R08: ffff9a1e4dadff18 R09:
ffff9a1e6cba0008
[ 1288.133747] R10: ffff9a1e6cba0000 R11: 0000000000000001 R12:
0000000000000701
[ 1288.133747] R13: ffff9a1e4d870240 R14: ffff9a1e64ad0000 R15:
ffff9a1e4dadff18
[ 1288.133748] FS:  00007f17e9922700(0000) GS:ffff9a1e86a00000(0000)
knlGS:0000000000000000
[ 1288.133749] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1288.133749] CR2: 0000000000000000 CR3: 0000000601414000 CR4:
00000000000406f0
[ 1288.133750] Call Trace:
[ 1288.133767]  kvm_mmu_pte_write+0x424/0x430 [kvm]
[ 1288.133782]  kvm_page_track_write+0x6d/0xb0 [kvm]
[ 1288.133796]  emulator_write_phys+0x36/0x50 [kvm]
[ 1288.133808]  emulator_read_write_onepage+0xfd/0x310 [kvm]
[ 1288.133819]  ? kvm_io_bus_get_first_dev+0x56/0x110 [kvm]
[ 1288.133832]  emulator_read_write+0xc3/0x170 [kvm]
[ 1288.133846]  segmented_write+0x5f/0x80 [kvm]
[ 1288.133860]  writeback+0x17f/0x2f0 [kvm]
[ 1288.133874]  ? em_in+0x179/0x240 [kvm]
[ 1288.133887]  x86_emulate_insn+0x58c/0xda0 [kvm]
[ 1288.133901]  x86_emulate_instruction+0x343/0x730 [kvm]
[ 1288.133903]  ? recalc_sigpending+0x17/0x50
[ 1288.133905]  ? __set_task_blocked+0x38/0x90
[ 1288.133917]  complete_emulated_pio+0x3a/0x70 [kvm]
[ 1288.133931]  kvm_arch_vcpu_ioctl_run+0x13d9/0x1a90 [kvm]
[ 1288.133944]  ? kvm_vm_ioctl_irq_line+0x23/0x30 [kvm]
[ 1288.133945]  ? _copy_to_user+0x22/0x30
[ 1288.133956]  ? kvm_vm_ioctl+0x6ea/0x990 [kvm]
[ 1288.133967]  ? kvm_vcpu_ioctl+0x367/0x5d0 [kvm]
[ 1288.133977]  kvm_vcpu_ioctl+0x367/0x5d0 [kvm]
[ 1288.133979]  ? __wake_up_common+0x96/0x180
[ 1288.133981]  do_vfs_ioctl+0xa2/0x640
[ 1288.133983]  ksys_ioctl+0x70/0x80
[ 1288.133984]  __x64_sys_ioctl+0x16/0x20
[ 1288.133986]  do_syscall_64+0x55/0x100
[ 1288.133988]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1288.133989] RIP: 0033:0x7f17f3079017
[ 1288.133990] Code: 00 00 00 48 8b 05 81 7e 2b 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 51 7e 2b 00 f7 d8 64 89 01 48
[ 1288.133991] RSP: 002b:00007f17e9921878 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 1288.133992] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007f17f3079017
[ 1288.133993] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
0000000000000010
[ 1288.133993] RBP: 0000563e2a8946b0 R08: 0000563e2913e0b0 R09:
0000000000000004
[ 1288.133994] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[ 1288.133994] R13: 00007f17f8938000 R14: 0000000000000000 R15:
0000563e2a8946b0
[ 1288.133995] ---[ end trace a44ba1fe968f1fdc ]---
Kernel version: 5.1.0
My CPU: AMD FX(tm)-6300 Six-Core Processor
QEMU version: 2.8.1

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
