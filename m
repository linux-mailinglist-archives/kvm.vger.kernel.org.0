Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784982142B1
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 04:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgGDCzo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 3 Jul 2020 22:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgGDCzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 22:55:44 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208427] New: kvm network cause kernel panic
Date:   Sat, 04 Jul 2020 02:55:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: jingnan.si+kernel@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-208427-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208427

            Bug ID: 208427
           Summary: kvm network cause kernel panic
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.6.0-2-amd64, 5.7.0-1-amd64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: jingnan.si+kernel@gmail.com
        Regression: No

Created attachment 290089
  --> https://bugzilla.kernel.org/attachment.cgi?id=290089&action=edit
dmesg file from kdump

radmom panic kernel after using the network for a while in guests (2 window 10,
1 Mac, 1 Arch Linux)

attached kdump dmesg file, kernel core dump is too big to attach, upload to
gdrive

https://drive.google.com/file/d/1Ia6gQCcmDBeB_RHQhhj3-JSUountxvcL/view?usp=sharing


[ 2788.863674] kvm [45322]: vcpu7, guest rIP: 0x7fdf49237ad5 ignored rdmsr:
0x122
[ 2789.129391] BUG: unable to handle page fault for address: 0000000100000002
[ 2789.129395] #PF: supervisor read access in kernel mode
[ 2789.129396] #PF: error_code(0x0000) - not-present page
[ 2789.129398] PGD 0 P4D 0
[ 2789.129401] Oops: 0000 [#1] SMP NOPTI
[ 2789.129404] CPU: 12 PID: 45373 Comm: vhost-45322 Kdump: loaded Tainted: P   
       OE     5.7.0-1-amd64 #1 Debian 5.7.6-1
[ 2789.129406] Hardware name: Gigabyte Technology Co., Ltd. B450 AORUS M/B450
AORUS M, BIOS F50 11/27/2019
[ 2789.129414] RIP: 0010:__cgroup_bpf_run_filter_skb+0x11e/0x3d0
[ 2789.129417] Code: b7 02 00 00 49 8d 47 30 bb 01 00 00 00 48 89 44 24 08 49
8b 45 08 65 48 89 05 3e 9f e5 60 49 8b 45 10 65 48 89 05 3a 9f e5 60 <41> f6 46
02 08 0f 85 01 01 00 00 0f 1f 44 00 00 49 8b 46 30 49 8d
[ 2789.129419] RSP: 0018:ffffb2e60babf7d8 EFLAGS: 00010206
[ 2789.129421] RAX: ffff8ef99a5cf418 RBX: 0000000000000001 RCX:
0000000000000034
[ 2789.129422] RDX: 0000000000000000 RSI: ffff8efd05df9000 RDI:
ffff8ef99a7708c0
[ 2789.129424] RBP: ffff8efd0a74ea00 R08: ffff8efce4a7d180 R09:
0000000000000001
[ 2789.129425] R10: 017aa8c0857aa8c0 R11: 0000000000000000 R12:
0000000000000004
[ 2789.129426] R13: ffff8ef99a5cf410 R14: 0000000100000000 R15:
ffff8efd0a74ea00
[ 2789.129429] FS:  0000000000000000(0000) GS:ffff8efd1eb00000(0000)
knlGS:0000000000000000
[ 2789.129430] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2789.129431] CR2: 0000000100000002 CR3: 0000000f1b932000 CR4:
00000000003406e0
[ 2789.129432] Call Trace:
[ 2789.129445]  ? nf_conntrack_tcp_packet+0x545/0x1840 [nf_conntrack]
[ 2789.129449]  sk_filter_trim_cap+0xd7/0x210
[ 2789.129452]  ? tcp_v4_inbound_md5_hash+0x4c/0x160
[ 2789.129455]  tcp_v4_rcv+0xb53/0xd70
[ 2789.129458]  ip_protocol_deliver_rcu+0x2b/0x1b0
[ 2789.129460]  ip_local_deliver_finish+0x44/0x50
[ 2789.129462]  ip_local_deliver+0xe5/0xf0
[ 2789.129464]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[ 2789.129466]  ip_rcv+0xbc/0xd0
[ 2789.129468]  ? ip_rcv_finish_core.isra.0+0x410/0x410
[ 2789.129471]  __netif_receive_skb_one_core+0x87/0xa0
[ 2789.129473]  netif_receive_skb+0x37/0x140
[ 2789.129475]  ? nf_hook_slow+0x40/0xb0
[ 2789.129483]  br_pass_frame_up+0x133/0x150 [bridge]
[ 2789.129491]  ? br_port_flags_change+0x40/0x40 [bridge]
[ 2789.129498]  br_handle_frame_finish+0x179/0x440 [bridge]
[ 2789.129501]  ? try_to_wake_up+0x218/0x660
[ 2789.129507]  br_handle_frame+0x247/0x370 [bridge]
[ 2789.129510]  ? swake_up_locked.part.0+0x1b/0x40
[ 2789.129511]  ? swake_up_one+0x28/0x40
[ 2789.129514]  __netif_receive_skb_core+0x2ee/0x1050
[ 2789.129538]  ? kvm_irq_delivery_to_apic_fast+0xfc/0x150 [kvm]
[ 2789.129541]  __netif_receive_skb_one_core+0x3d/0xa0
[ 2789.129543]  netif_receive_skb+0x37/0x140
[ 2789.129546]  ? __build_skb+0x1f/0x50
[ 2789.129550]  tun_sendmsg+0x419/0x860 [tun]
[ 2789.129554]  vhost_tx_batch.isra.0+0x5d/0xe0 [vhost_net]
[ 2789.129557]  handle_tx_copy+0x16d/0x570 [vhost_net]
[ 2789.129562]  handle_tx+0xa5/0xe0 [vhost_net]
[ 2789.129566]  vhost_worker+0xac/0x100 [vhost]
[ 2789.129570]  kthread+0xf9/0x130
[ 2789.129574]  ? log_used.part.0+0x20/0x20 [vhost]
[ 2789.129576]  ? kthread_park+0x90/0x90
[ 2789.129579]  ret_from_fork+0x22/0x40
[ 2789.129581] Modules linked in: rpcsec_gss_krb5 vhost_net vhost tap
vhost_iotlb xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp nft_compat nft_counter nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink tun bridge stp llc
eeprom binfmt_misc nvidia_drm(POE) drm_kms_helper cec nvidia_modeset(POE)
dm_raid dm_cache_smq dm_cache dm_persistent_data dm_bio_prison dm_bufio
edac_mce_amd kvm_amd kvm irqbypass ghash_clmulni_intel snd_hda_codec_realtek
snd_hda_codec_generic ledtrig_audio snd_hda_codec_hdmi nls_a
scii nls_cp437 aesni_intel snd_hda_intel vfat snd_intel_dspcfg libaes fat
crypto_simd snd_hda_codec cryptd glue_helper snd_usb_audio snd_hda_core
snd_usbmidi_lib uvcvideo snd_rawmidi snd_hwdep videobuf2_vmalloc snd_seq_device
efi_pstore videobuf2_memops nvidia(POE) snd_pcm videobuf2
_v4l2 snd_timer 88x2bu(OE) videobuf2_common wmi_bmof efivars sp5100_tco
videodev snd pcspkr ipmi_devintf joydev k10temp watchdog ccp mc cfg80211
[ 2789.129613]  ipmi_msghandler soundcore sg rfkill tpm_crb tpm_tis
tpm_tis_core tpm rng_core evdev acpi_cpufreq nfsd auth_rpcgss nfs_acl
parport_pc lockd drm ppdev grace lp parport sunrpc efivarfs ip_tables x_tables
autofs4 ext4 crc16 mbcache jbd2 btrfs blake2b_generic zstd_decompr
ess zstd_compress dm_mod raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath
linear md_mod hid_apple hid_generic usbhid hid sd_mod xhci_pci xhci_hcd ahci
libahci libata nvme usbcore crc32_pclmul nvme_c
ore crc32c_intel scsi_mod i2c_piix4 t10_pi crc_t10dif crct10dif_generic
r8168(OE) crct10dif_pclmul usb_common wmi crct10dif_common gpio_amdpt
gpio_generic button
[ 2789.129643] CR2: 0000000100000002

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
