Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952F03BC2CC
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 20:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhGESow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 14:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhGESow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 14:44:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3EEA1613AE
        for <kvm@vger.kernel.org>; Mon,  5 Jul 2021 18:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625510535;
        bh=aFzztdOmDXQwsaeMnxcbNs7EY+I2TDdmEK7THAWnlMQ=;
        h=From:To:Subject:Date:From;
        b=fRUekc5ez0SpxxmcF7ZRhXswUVh+cU5zwMlSR7EWku8a+IFvswhAuUlEZcs0hmRFf
         RQThneMFb0itV2jBXtILXWCUdeHONSRYp6YIBzfgcd/OUHwHB9A0eCMbKG+p1x/GlP
         xoScCkfNwoaAOdWuatrfmBkWFllV5YgF3+z1w5n9pxdiy1l7IyskxZ/a6U5OqyLTHZ
         eggs6F0f4j8c7H+nKa4uXFBcUsfFVbZ9ebuzwzDdItRIRW61nevH855YXq354tBMtK
         7Q3WLqCigOBxDyCiGmxbjFHj40ztdRnwPN8viWSy6op02jNRkcmGHqN6nyV2A02gDb
         2AYLzRm72RGmg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 3239D61221; Mon,  5 Jul 2021 18:42:15 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213643] New: crash when running ubuntu VM with libvirtd
Date:   Mon, 05 Jul 2021 18:42:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zebul666@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-213643-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213643

            Bug ID: 213643
           Summary: crash when running ubuntu VM with libvirtd
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.12.14-zen1-1-zen
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zebul666@hotmail.com
        Regression: No

This occured when running an ubuntu VM on archlinux using the zen kernel ke=
rnel
5.12.14-zen1-1-zen

2021-07-05T16:24:23+0000 kernel: BUG: kernel NULL pointer dereference, addr=
ess:
0000000000000000
2021-07-05T16:24:23+0000 kernel: #PF: supervisor read access in kernel mode
2021-07-05T16:24:23+0000 kernel: #PF: error_code(0x0000) - not-present page
2021-07-05T16:24:23+0000 kernel: PGD 0 P4D 0=20
2021-07-05T16:24:23+0000 kernel: Oops: 0000 [#1] PREEMPT SMP PTI
2021-07-05T16:24:23+0000 kernel: CPU: 1 PID: 277393 Comm: CPU 1/KVM Tainted=
: G=20
   U     OE     5.12.14-zen1-1-zen #1
2021-07-05T16:24:23+0000 kernel: Hardware name: Dell Inc. OptiPlex 7060/XXX=
XXX,
BIOS 1.12.0 05/05/2021
2021-07-05T16:24:23+0000 kernel: RIP: 0010:__list_del_entry_valid+0x25/0x90
2021-07-05T16:24:23+0000 kernel: Code: c3 0f 1f 40 00 48 8b 17 4c 8b 47 08 =
48
b8 00 01 00 00 00 00 ad de 48 39 c2 74 26 48 b8 22 01 00 00 00 00 ad de 49 =
39
c0 74 2b <49> 8b 30 48 39 fe 75 3a 48 8b 52 08 48 39 f2 75 48 b8 01 00 00 00
2021-07-05T16:24:23+0000 kernel: RSP: 0018:ffffb3dcc14830d0 EFLAGS: 00010217
2021-07-05T16:24:23+0000 kernel: RAX: dead000000000122 RBX: ffff8e3587327480
RCX: 0000000000000000
2021-07-05T16:24:23+0000 kernel: RDX: 0000000000000000 RSI: ffff8e362c76e308
RDI: ffff8e358f89a000
2021-07-05T16:24:23+0000 kernel: RBP: ffff8e358f89a010 R08: 0000000000000000
R09: 0000000000000001
2021-07-05T16:24:23+0000 kernel: R10: 0000000000000001 R11: 0000000000000000
R12: 0000000000000000
2021-07-05T16:24:23+0000 kernel: R13: ffff8e3587327488 R14: ffff8e358f89a000
R15: 000000000000000c
2021-07-05T16:24:23+0000 kernel: FS:  00007fb71bfff640(0000)
GS:ffff8e36f4440000(0000) knlGS:0000000000000000
2021-07-05T16:24:23+0000 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
2021-07-05T16:24:23+0000 kernel: CR2: 0000000000000000 CR3: 000000010ffb2006
CR4: 00000000003726e0
2021-07-05T16:24:23+0000 kernel: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
2021-07-05T16:24:23+0000 kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
2021-07-05T16:24:23+0000 kernel: Call Trace:
2021-07-05T16:24:23+0000 kernel:  z3fold_zpool_malloc+0xf5/0xa50
2021-07-05T16:24:23+0000 kernel:  zswap_frontswap_store+0x3d8/0x7a0
2021-07-05T16:24:23+0000 kernel:  __frontswap_store+0x6e/0x100
2021-07-05T16:24:23+0000 kernel:  swap_writepage+0x39/0x70
2021-07-05T16:24:23+0000 kernel:  shrink_page_list+0xd37/0x1210
2021-07-05T16:24:23+0000 kernel:  evict_lru_gen_pages+0x1942/0x1e30
2021-07-05T16:24:23+0000 kernel:  ? __activate_page+0x6cc/0xb40
2021-07-05T16:24:23+0000 kernel:  shrink_lruvec+0x2df/0xaa0
2021-07-05T16:24:23+0000 kernel:  ? mem_cgroup_iter+0xd7/0x2b0
2021-07-05T16:24:23+0000 kernel:  shrink_node+0x22e/0x870
2021-07-05T16:24:23+0000 kernel:  do_try_to_free_pages+0xda/0x4c0
2021-07-05T16:24:23+0000 kernel:  try_to_free_pages+0x224/0x530
2021-07-05T16:24:23+0000 kernel:  __alloc_pages_nodemask+0x75b/0x10e0
2021-07-05T16:24:23+0000 kernel:  ? alloc_pages_vma+0x238/0x410
2021-07-05T16:24:23+0000 kernel:  do_huge_pmd_anonymous_page+0x197/0x8b0
2021-07-05T16:24:23+0000 kernel:  handle_mm_fault+0xeca/0x1630
2021-07-05T16:24:23+0000 kernel:  __get_user_pages+0x2f4/0x830
2021-07-05T16:24:23+0000 kernel:  get_user_pages_unlocked+0xcc/0x320
2021-07-05T16:24:23+0000 kernel:  hva_to_pfn+0x102/0x480 [kvm]
2021-07-05T16:24:23+0000 kernel:  ? set_spte+0xb1/0x140 [kvm]
2021-07-05T16:24:23+0000 kernel:  try_async_pf+0xa6/0x2a0 [kvm]
2021-07-05T16:24:23+0000 kernel:  direct_page_fault+0x301/0xf50 [kvm]
2021-07-05T16:24:23+0000 kernel:  ?
kvm_mtrr_check_gfn_range_consistency+0x7f/0x370 [kvm]
2021-07-05T16:24:23+0000 kernel:  kvm_mmu_page_fault+0xcc/0x890 [kvm]
2021-07-05T16:24:23+0000 kernel:  ? vcpu_enter_guest+0xc41/0x1a30 [kvm]
2021-07-05T16:24:23+0000 kernel:  ? rcuwait_wake_up+0x2e/0x40
2021-07-05T16:24:23+0000 kernel:  vmx_handle_exit+0x120/0x7c0 [kvm_intel]
2021-07-05T16:24:23+0000 kernel:  kvm_arch_vcpu_ioctl_run+0xd0/0x8f0 [kvm]
2021-07-05T16:24:23+0000 kernel:  kvm_vcpu_ioctl+0x25b/0x600 [kvm]
2021-07-05T16:24:23+0000 kernel:  __x64_sys_ioctl+0x82/0xb0
2021-07-05T16:24:23+0000 kernel:  do_syscall_64+0x33/0x40
2021-07-05T16:24:23+0000 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
2021-07-05T16:24:23+0000 kernel: RIP: 0033:0x7fb733d9259b
2021-07-05T16:24:23+0000 kernel: Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff =
ff
ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 =
00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a5 a8 0c 00 f7 d8 64 89 01 48
2021-07-05T16:24:23+0000 kernel: RSP: 002b:00007fb71bffe578 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
2021-07-05T16:24:23+0000 kernel: RAX: ffffffffffffffda RBX: 000000000000ae80
RCX: 00007fb733d9259b
2021-07-05T16:24:23+0000 kernel: RDX: 0000000000000000 RSI: 000000000000ae80
RDI: 000000000000001a
2021-07-05T16:24:23+0000 kernel: RBP: 0000559c663794f0 R08: 0000559c6381b358
R09: 00000000ffffffff
2021-07-05T16:24:23+0000 kernel: R10: 0000000000000002 R11: 0000000000000246
R12: 0000000000000000
2021-07-05T16:24:23+0000 kernel: R13: 0000000000000006 R14: 00007fb71bfff640
R15: 0000000000000000
2021-07-05T16:24:23+0000 kernel: Modules linked in: xfs nilfs2 jfs btrfs
blake2b_generic xor raid6_pq vhost_net vhost vhost_iotlb tap tun xt_CHECKSUM
xt_MASQUERADE bridge stp llc xt_nat wireguard curve25519_x86_64
libchacha20poly1305 chacha_x86_64 poly1305_x86_64 libblake2s blake2s_x86_64
libcurve25519_generic libchacha libblake2s_generic ip6_udp_tunnel udp_tunnel
exfat rfcomm xt_multiport xt_cgroup xt_mark xt_owner ip6table_raw iptable_r=
aw
ip6table_mangle iptable_mangle ip6table_nat iptable_nat cmac algif_hash
algif_skcipher af_alg bnep snd_sof_pci_intel_cnl snd_sof_intel_hda_common
snd_hda_codec_hdmi soundwire_intel soundwire_generic_allocation
soundwire_cadence snd_sof_intel_hda snd_sof_pci snd_sof snd_sof_xtensa_dsp
soundwire_bus snd_soc_skl snd_soc_hdac_hda snd_hda_ext_core snd_soc_sst_ipc
snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi intel_rapl_msr
intel_rapl_common snd_soc_core snd_hda_codec_realtek x86_pkg_temp_thermal
snd_hda_codec_generic snd_compress ac97_bus intel_powerclamp
2021-07-05T16:24:23+0000 kernel:  ledtrig_audio coretemp snd_pcm_dmaengine
snd_hda_intel snd_intel_dspcfg kvm_intel snd_intel_sdw_acpi snd_hda_codec
snd_hda_core nls_iso8859_1 dell_wmi iTCO_wdt vfat snd_hwdep intel_pmc_bxt
dell_smbios fat ee1004 kvm snd_pcm mei_wdt mei_hdcp iTCO_vendor_support dcd=
bas
dell_wmi_sysman dell_wmi_descriptor dell_wmi_aio wmi_bmof sparse_keymap
intel_wmi_thunderbolt irqbypass rapl 88XXau(OE) intel_cstate intel_uncore e=
ssiv
pcspkr authenc snd_timer intel_spi_pci intel_spi spi_nor btusb e1000e snd b=
trtl
i2c_i801 btbcm i2c_smbus mtd btintel soundcore cfg80211 bluetooth uas mouse=
dev
mei_me tpm_crb ecdh_generic intel_lpss_pci ecc mei intel_lpss rfkill idma64
intel_pch_thermal wmi tpm_tis tpm_tis_core mac_hid acpi_pad nf_log_ipv6
ip6t_REJECT nf_reject_ipv6 xt_hl ip6t_rt nf_log_ipv4 nf_log_common ipt_REJE=
CT
nf_reject_ipv4 xt_LOG xt_limit xt_addrtype xt_tcpudp xt_conntrack
ip6table_filter ip6_tables nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_nat_ftp nf_nat nf_conntrack_ftp
2021-07-05T16:24:23+0000 kernel:  nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
libcrc32c iptable_filter dell_smm_hwmon sg crypto_user fuse bpf_preload
ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 usb_storage dm_cr=
ypt
cbc encrypted_keys dm_mod trusted tpm rng_core hid_logitech_hidpp
hid_logitech_dj usbhid crct10dif_pclmul crc32_pclmul crc32c_intel
ghash_clmulni_intel aesni_intel crypto_simd cryptd sr_mod cdrom xhci_pci
xhci_pci_renesas i915 i2c_algo_bit intel_gtt video drm_kms_helper syscopyar=
ea
sysfillrect sysimgblt fb_sys_fops cec drm agpgart
2021-07-05T16:24:23+0000 kernel: CR2: 0000000000000000
2021-07-05T16:24:23+0000 kernel: ---[ end trace b0c1037e77a42484 ]---
2021-07-05T16:24:23+0000 kernel: RIP: 0010:__list_del_entry_valid+0x25/0x90
2021-07-05T16:24:23+0000 kernel: Code: c3 0f 1f 40 00 48 8b 17 4c 8b 47 08 =
48
b8 00 01 00 00 00 00 ad de 48 39 c2 74 26 48 b8 22 01 00 00 00 00 ad de 49 =
39
c0 74 2b <49> 8b 30 48 39 fe 75 3a 48 8b 52 08 48 39 f2 75 48 b8 01 00 00 00
2021-07-05T16:24:23+0000 kernel: RSP: 0018:ffffb3dcc14830d0 EFLAGS: 00010217
2021-07-05T16:24:23+0000 kernel: RAX: dead000000000122 RBX: ffff8e3587327480
RCX: 0000000000000000
2021-07-05T16:24:23+0000 kernel: RDX: 0000000000000000 RSI: ffff8e362c76e308
RDI: ffff8e358f89a000
2021-07-05T16:24:23+0000 kernel: RBP: ffff8e358f89a010 R08: 0000000000000000
R09: 0000000000000001
2021-07-05T16:24:23+0000 kernel: R10: 0000000000000001 R11: 0000000000000000
R12: 0000000000000000
2021-07-05T16:24:23+0000 kernel: R13: ffff8e3587327488 R14: ffff8e358f89a000
R15: 000000000000000c
2021-07-05T16:24:23+0000 kernel: FS:  00007fb71bfff640(0000)
GS:ffff8e36f4440000(0000) knlGS:0000000000000000
2021-07-05T16:24:23+0000 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
2021-07-05T16:24:23+0000 kernel: CR2: 0000000000000000 CR3: 000000010ffb2006
CR4: 00000000003726e0
2021-07-05T16:24:23+0000 kernel: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
2021-07-05T16:24:23+0000 kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
2021-07-05T16:24:23+0000 kernel: note: CPU 1/KVM[277393] exited with
preempt_count 2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
