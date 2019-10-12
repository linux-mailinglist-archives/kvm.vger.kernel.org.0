Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A886D50F2
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 18:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbfJLQU6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 12 Oct 2019 12:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfJLQU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 12:20:58 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205171] New: kernel panic during windows 10pro start
Date:   Sat, 12 Oct 2019 16:20:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dront78@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-205171-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205171

            Bug ID: 205171
           Summary: kernel panic during windows 10pro start
           Product: Virtualization
           Version: unspecified
    Kernel Version: 4.19.74 and higher
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: dront78@gmail.com
        Regression: No

works fine on 4.19.73

[ 5829.948945] BUG: unable to handle kernel NULL pointer dereference at
0000000000000000
[ 5829.948951] PGD 0 P4D 0 
[ 5829.948954] Oops: 0002 [#1] SMP NOPTI
[ 5829.948957] CPU: 3 PID: 1699 Comm: CPU 0/KVM Tainted: G           OE    
4.19.78-2-lts #1
[ 5829.948958] Hardware name: Micro-Star International Co., Ltd. GE62
6QF/MS-16J4, BIOS E16J4IMS.117 01/18/2018
[ 5829.948989] RIP: 0010:kvm_write_guest_virt_system+0x1e/0x40 [kvm]
[ 5829.948991] Code: 5d 41 5c 41 5d 41 5e e9 40 e0 ff ff 0f 1f 44 00 00 49 89
fa 4d 89 c1 48 89 f7 48 89 d6 41 c6 82 29 56 00 00 01 89 ca 4c 89 d1 <49> c7 00
00 00 00 00 49 c7 40 08 00 00 00 00 49 c7 40 10 00 00 00
[ 5829.948992] RSP: 0018:ffffb80142743cc0 EFLAGS: 00010202
[ 5829.948993] RAX: 0000000000000400 RBX: 0000000000000003 RCX:
ffff916d7c9e8000
[ 5829.948993] RDX: 0000000000000008 RSI: ffffb80142743cd0 RDI:
0000010000003d68
[ 5829.948994] RBP: ffff916d7c9e8000 R08: 0000000000000000 R09:
0000000000000000
[ 5829.948995] R10: ffff916d7c9e8000 R11: 0000000000000000 R12:
0000000000e1c908
[ 5829.948995] R13: 0000000000000000 R14: ffff916d6b57e228 R15:
0000000000000000
[ 5829.948997] FS:  00007fb3a23ff700(0000) GS:ffff916daeac0000(0000)
knlGS:0000000000000000
[ 5829.948997] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5829.948998] CR2: 0000000000000000 CR3: 0000000442444003 CR4:
00000000003626e0
[ 5829.948999] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 5829.948999] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[ 5829.949000] Call Trace:
[ 5829.949006]  handle_vmread+0x28f/0x300 [kvm_intel]
[ 5829.949009]  ? handle_vmwrite+0x269/0x4d0 [kvm_intel]
[ 5829.949019]  kvm_arch_vcpu_ioctl_run+0xbb2/0x1b20 [kvm]
[ 5829.949026]  kvm_vcpu_ioctl+0x24b/0x5d0 [kvm]
[ 5829.949029]  ? __seccomp_filter+0x42/0x480
[ 5829.949032]  do_vfs_ioctl+0x40e/0x670
[ 5829.949034]  ksys_ioctl+0x5e/0x90
[ 5829.949035]  __x64_sys_ioctl+0x16/0x20
[ 5829.949038]  do_syscall_64+0x4e/0x100
[ 5829.949041]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 5829.949044] RIP: 0033:0x7fb3a58f625b
[ 5829.949045] Code: 0f 1e fa 48 8b 05 25 9c 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d f5 9b 0c 00 f7 d8 64 89 01 48
[ 5829.949046] RSP: 002b:00007fb3a23fcee8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 5829.949047] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007fb3a58f625b
[ 5829.949048] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
0000000000000016
[ 5829.949048] RBP: 00007fb3a3194140 R08: 000055bfdd046910 R09:
000000003b9aca00
[ 5829.949049] R10: 0000000000000001 R11: 0000000000000246 R12:
0000000000000000
[ 5829.949050] R13: 00007fb3a7059004 R14: 0000000000000608 R15:
0000000000000000
[ 5829.949051] Modules linked in: vhost_net vhost tap rfcomm dm_crypt dm_mod
uas usb_storage ccm devlink fuse xt_conntrack ipt_REJECT nf_reject_ipv4
ip6table_mangle ip6table_nat nf_nat_ipv6 ebtable_filter ebtables
ip6table_filter ip6_tables tun cmac iptable_mangle xt_CHECKSUM algif_hash
iptable_nat algif_skcipher ipt_MASQUERADE nf_nat_ipv4 af_alg nf_nat bnep
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c xt_tcpudp bridge stp llc
iptable_filter nls_iso8859_1 nls_cp437 vfat fat snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic intel_rapl rtsx_usb_sdmmc
rtsx_usb_ms mmc_core memstick x86_pkg_temp_thermal arc4 i915 intel_powerclamp
kvm_intel crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc iwlmvm
aesni_intel kvmgt vfio_mdev mdev aes_x86_64 vfio_iommu_type1 crypto_simd vfio
cryptd
[ 5829.949084]  glue_helper intel_cstate kvm mac80211 intel_uncore
intel_rapl_perf snd_hda_intel irqbypass i2c_algo_bit drm_kms_helper uvcvideo
snd_hda_codec videobuf2_vmalloc videobuf2_memops drm snd_hda_core
videobuf2_v4l2 iwlwifi videobuf2_common snd_hwdep snd_pcm videodev btusb btrtl
btbcm btintel snd_timer bluetooth mousedev psmouse joydev intel_gtt media
rtsx_usb ecdh_generic cfg80211 input_leds snd agpgart alx i2c_i801 mei_me
soundcore syscopyarea sysfillrect rfkill sysimgblt mei fb_sys_fops mdio battery
ac evdev mac_hid vboxnetflt(OE) vboxnetadp(OE) vboxpci(OE) vboxdrv(OE)
usbip_host usbip_core coretemp msr sg crypto_user ip_tables x_tables ext4
crc32c_generic crc16 mbcache jbd2 hid_generic usbhid hid sr_mod sd_mod cdrom
serio_raw atkbd ahci libps2 libahci libata xhci_pci scsi_mod crc32c_intel
[ 5829.949122]  xhci_hcd i8042 serio
[ 5829.949125] CR2: 0000000000000000
[ 5829.949127] ---[ end trace 61e91d3bdaf90c11 ]---
[ 5829.949158] RIP: 0010:kvm_write_guest_virt_system+0x1e/0x40 [kvm]
[ 5829.949160] Code: 5d 41 5c 41 5d 41 5e e9 40 e0 ff ff 0f 1f 44 00 00 49 89
fa 4d 89 c1 48 89 f7 48 89 d6 41 c6 82 29 56 00 00 01 89 ca 4c 89 d1 <49> c7 00
00 00 00 00 49 c7 40 08 00 00 00 00 49 c7 40 10 00 00 00
[ 5829.949161] RSP: 0018:ffffb80142743cc0 EFLAGS: 00010202
[ 5829.949162] RAX: 0000000000000400 RBX: 0000000000000003 RCX:
ffff916d7c9e8000
[ 5829.949163] RDX: 0000000000000008 RSI: ffffb80142743cd0 RDI:
0000010000003d68
[ 5829.949164] RBP: ffff916d7c9e8000 R08: 0000000000000000 R09:
0000000000000000
[ 5829.949164] R10: ffff916d7c9e8000 R11: 0000000000000000 R12:
0000000000e1c908
[ 5829.949165] R13: 0000000000000000 R14: ffff916d6b57e228 R15:
0000000000000000
[ 5829.949166] FS:  00007fb3a23ff700(0000) GS:ffff916daeac0000(0000)
knlGS:0000000000000000
[ 5829.949167] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5829.949167] CR2: 0000000000000000 CR3: 0000000442444003 CR4:
00000000003626e0
[ 5829.949168] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 5829.949169] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
