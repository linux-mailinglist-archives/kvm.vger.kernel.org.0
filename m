Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F16F28AB2B
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 02:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbgJLAHo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 11 Oct 2020 20:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgJLAHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Oct 2020 20:07:43 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209253] Loss of connectivity on guest after important host <->
 guest traffic
Date:   Mon, 12 Oct 2020 00:07:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: arequipeno@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209253-28872-miUHCSKsTI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209253-28872@https.bugzilla.kernel.org/>
References: <bug-209253-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209253

Ian Pilcher (arequipeno@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |arequipeno@gmail.com

--- Comment #1 from Ian Pilcher (arequipeno@gmail.com) ---
I am seeing a very similar crash, but the device in my case is an NVIDIA GPU,
passed through to a Windows guest for video processing.

[ 6094.567434] WARNING: CPU: 7 PID: 2524 at fs/eventfd.c:74
eventfd_signal+0x88/0xa0
[ 6094.567464] Modules linked in: vhost_net vhost tap vhost_iotlb tun
nft_chain_nat 8021q garp mrp stp llc sch_ingress bonding openvswitch nsh
nf_conncount nf_nat nft_counter ipt_REJECT ip6t_REJECT nf_reject_ipv4
nf_reject_ipv6 xt_state xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
nft_compat nf_tables nfnetlink intel_rapl_msr intel_rapl_common sb_edac
x86_pkg_temp_thermal sunrpc intel_powerclamp coretemp raid10 kvm_intel iTCO_wdt
intel_pmc_bxt kvm iTCO_vendor_support gpio_ich ipmi_ssif rapl ixgbe
intel_cstate joydev i2c_i801 igb intel_uncore ioatdma mei_me acpi_ipmi
i2c_smbus mdio intel_pch_thermal mei dca lpc_ich ipmi_si ipmi_devintf
ipmi_msghandler acpi_pad vfat fat ip_tables xfs ast drm_vram_helper
drm_ttm_helper i2c_algo_bit drm_kms_helper cec ttm mxm_wmi drm crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel wmi vfio_pci irqbypass
vfio_virqfd vfio_iommu_type1 vfio
[ 6094.567794] CPU: 7 PID: 2524 Comm: CPU 3/KVM Not tainted
5.8.13-200.fc32.x86_64 #1
[ 6094.567834] Hardware name: Supermicro SYS-5028D-TN4T/X10SDV-TLN4F, BIOS 2.1
11/22/2019
[ 6094.567868] RIP: 0010:eventfd_signal+0x88/0xa0
[ 6094.567889] Code: 03 00 00 00 4c 89 f7 e8 26 16 db ff 65 ff 0d 3f f3 ca 43
4c 89 ee 4c 89 f7 e8 34 8e 7f 00 4c 89 e0 5b 5d 41 5c 41 5d 41 5e c3 <0f> 0b 45
31 e4 5b 5d 4c 89 e0 41 5c 41 5d 41 5e c3 0f 1f 80 00 00
[ 6094.567974] RSP: 0018:ffffac8780b97bb0 EFLAGS: 00010286
[ 6094.567996] RAX: 00000000ffffffff RBX: ffff9b01c8ed0000 RCX:
0000000000000004
[ 6094.568021] RDX: 00000000c8088704 RSI: 0000000000000001 RDI:
ffff9b11ef445240
[ 6094.568050] RBP: ffffac8780b97c18 R08: ffff9b11ef4cdf40 R09:
00000000c8088708
[ 6094.568080] R10: 0000000000000000 R11: 0000000000000190 R12:
0000000000000002
[ 6094.568105] R13: ffff9b11ef4bbb00 R14: ffff9b11ef4cdf40 R15:
ffff9b11ef4bbb00
[ 6094.568145] FS:  00007f30b8b78700(0000) GS:ffff9b123fbc0000(0000)
knlGS:000000ad76006000
[ 6094.568178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6094.568202] CR2: 000001d9b5100000 CR3: 0000001fb0ed2003 CR4:
00000000003626e0
[ 6094.568232] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 6094.568261] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[ 6094.568290] Call Trace:
[ 6094.568336]  ioeventfd_write+0x51/0x80 [kvm]
[ 6094.568385]  __kvm_io_bus_write+0x88/0xb0 [kvm]
[ 6094.568417]  kvm_io_bus_write+0x43/0x60 [kvm]
[ 6094.568454]  write_mmio+0x70/0xf0 [kvm]
[ 6094.568488]  emulator_read_write_onepage+0x11e/0x330 [kvm]
[ 6094.568527]  emulator_read_write+0xca/0x180 [kvm]
[ 6094.568564]  segmented_write.isra.0+0x4a/0x60 [kvm]
[ 6094.568601]  x86_emulate_insn+0x850/0xe60 [kvm]
[ 6094.568636]  x86_emulate_instruction+0x2c7/0x780 [kvm]
[ 6094.568680]  ? kvm_io_bus_write+0x43/0x60 [kvm]
[ 6094.569821]  kvm_arch_vcpu_ioctl_run+0xeb9/0x1770 [kvm]
[ 6094.570963]  kvm_vcpu_ioctl+0x209/0x590 [kvm]
[ 6094.572099]  ksys_ioctl+0x82/0xc0
[ 6094.573208]  __x64_sys_ioctl+0x16/0x20
[ 6094.574294]  do_syscall_64+0x4d/0x90
[ 6094.575348]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 6094.576388] RIP: 0033:0x7f30c2bac3bb
[ 6094.577422] Code: 0f 1e fa 48 8b 05 dd aa 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d ad aa 0c 00 f7 d8 64 89 01 48
[ 6094.579603] RSP: 002b:00007f30b8b77668 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 6094.580713] RAX: ffffffffffffffda RBX: 000056277c8e4ae0 RCX:
00007f30c2bac3bb
[ 6094.581835] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001e
[ 6094.582951] RBP: 00007f30c010a000 R08: 000056277aebebf0 R09:
0000000000000000
[ 6094.584028] R10: 0000000000000001 R11: 0000000000000246 R12:
0000000000000001
[ 6094.585078] R13: 00007f30c010b001 R14: 0000000000000000 R15:
000056277b358a00
[ 6094.586103] ---[ end trace dab8395baf5baf8c ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
