Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60849DCAA2
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbfJRQNa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 18 Oct 2019 12:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbfJRQNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 12:13:30 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205247] New: Kernel panic in network code when booting Windows
 10 kvm guest
Date:   Fri, 18 Oct 2019 16:13:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: alvinhochun@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-205247-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205247

            Bug ID: 205247
           Summary: Kernel panic in network code when booting Windows 10
                    kvm guest
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.3.6
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: alvinhochun@gmail.com
        Regression: No

Panic on Arch Linux booting a Windows 10 VM with virt-manager defaults:

[  178.407895] BUG: kernel NULL pointer dereference, address: 0000000000000006
[  178.407982] #PF: supervisor write access in kernel mode
[  178.408037] #PF: error_code(0x0002) - not-present page
[  178.408090] PGD 0 P4D 0 
[  178.408125] Oops: 0002 [#1] PREEMPT SMP PTI
[  178.408173] CPU: 6 PID: 1095 Comm: CPU 1/KVM Kdump: loaded Not tainted
5.3.6-arch1-1-custom #2
[  178.408255] Hardware name: LENOVO 20L5CTO1WW/20L5CTO1WW, BIOS N24ET51W (1.26
) 08/30/2019
[  178.408342] RIP: 0010:ip_do_fragment+0x252/0x500
[  178.408394] Code: 48 8d 74 24 20 48 89 ef e8 5b fc ff ff 49 89 c6 48 3d 00
f0 ff ff 77 39 0f b7 45 3c 66 41 89 46 3c a8 40 74 0a 48 8b 44 24 20 <66> 83 48
06 40 45 85 ff 75 9a 48 89 ef e8 dc ec ff ff 4c 89 f2 4c
[  178.408563] RSP: 0018:ffff9ea981457788 EFLAGS: 00010202
[  178.408618] RAX: 0000000000000000 RBX: ffffffffb0cf9e00 RCX:
00000000ffff1ebe
[  178.408687] RDX: ffff97d070aa0054 RSI: ffff97d070aa2642 RDI:
ffff97d070aa0050
[  178.408756] RBP: ffff97d063a80300 R08: 00000000000006c0 R09:
ffff97d077006a00
[  178.408826] R10: ffff97d070aa208e R11: ffff97d063a80700 R12:
0000000000000000
[  178.408895] R13: ffffffffaffe9950 R14: ffff97d063a80d00 R15:
0000000000000000
[  178.408965] FS:  00007f3b0c5ff700(0000) GS:ffff97d07a580000(0000)
knlGS:0000000000000000
[  178.409044] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  178.409103] CR2: 0000000000000006 CR3: 000000066f028002 CR4:
00000000003626e0
[  178.409172] Call Trace:
[  178.409213]  ip_output+0x94/0x130
[  178.409256]  ? __ip_finish_output+0x1b0/0x1b0
[  178.409306]  ip_forward+0x31a/0x4b0
[  178.409348]  ? ip_defrag.cold+0x44/0x44
[  178.409393]  ip_rcv+0x7c/0x130
[  178.409432]  ? ip_rcv_finish_core.isra.0+0x3f0/0x3f0
[  178.409488]  __netif_receive_skb_one_core+0x80/0x90
[  178.409542]  netif_receive_skb_internal+0x93/0xe0
[  178.409594]  netif_receive_skb+0x18/0xd0
[  178.409655]  br_pass_frame_up+0xee/0x1a0 [bridge]
[  178.409720]  ? br_port_flags_change+0x40/0x40 [bridge]
[  178.409785]  br_handle_frame_finish+0x18a/0x450 [bridge]
[  178.409875]  br_handle_frame+0x23b/0x390 [bridge]
[  178.409940]  ? br_handle_local_finish+0x20/0x20 [bridge]
[  178.409997]  __netif_receive_skb_core+0x2e3/0xd70
[  178.410052]  __netif_receive_skb_one_core+0x37/0x90
[  178.410105]  netif_receive_skb_internal+0x93/0xe0
[  178.410157]  netif_receive_skb+0x18/0xd0
[  178.410205]  tun_get_user+0xfb8/0x10b0 [tun]
[  178.410279]  tun_chr_write_iter+0x46/0x70 [tun]
[  178.410360]  do_iter_readv_writev+0x166/0x1e0
[  178.410432]  do_iter_write+0x7d/0x190
[  178.410475]  vfs_writev+0xbd/0x130
[  178.410523]  ? __fget+0x71/0xa0
[  178.410561]  do_writev+0x73/0x120
[  178.410604]  do_syscall_64+0x5f/0x1c0
[  178.410649]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  178.410704] RIP: 0033:0x7f3b114ae36d
[  178.410747] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 ca f7 f8 ff
8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 14 00 00 00 0f 05 <48> 3d 00
f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 fe f7 f8 ff 48
[  178.410916] RSP: 002b:00007f3b0c5fc580 EFLAGS: 00000293 ORIG_RAX:
0000000000000014
[  178.410992] RAX: ffffffffffffffda RBX: 0000000000000003 RCX:
00007f3b114ae36d
[  178.411062] RDX: 0000000000000003 RSI: 00007f3b0c5fc730 RDI:
0000000000000024
[  178.411131] RBP: 00007f3b0e642c80 R08: 0000000000000000 R09:
0000000000000000
[  178.411201] R10: 0000000000000003 R11: 0000000000000293 R12:
00007f3b0e642c80
[  178.411270] R13: 00007f3b0c5fc730 R14: 00007f3b0c5fc730 R15:
0000000000000000
[  178.411343] Modules linked in: xt_CHECKSUM xt_MASQUERADE xt_conntrack
ipt_REJECT nf_reject_ipv4 xt_tcpudp ip6table_mangle ip6table_nat iptable_mangle
iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c tun
bridge ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter fuse
8021q garp mrp stp llc ccm iwlmvm snd_usb_audio snd_usbmidi_lib snd_rawmidi
snd_seq_device mac80211 snd_soc_skl x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel snd_soc_hdac_hda joydev snd_hda_ext_core mousedev
snd_soc_skl_ipc snd_soc_sst_ipc kvm snd_soc_sst_dsp rmi_smbus
snd_soc_acpi_intel_match rmi_core snd_soc_acpi snd_soc_core uvcvideo sd_mod
btusb ses enclosure btrtl scsi_transport_sas snd_hda_codec_hdmi btbcm libarc4
btintel videobuf2_vmalloc iwlwifi bluetooth ax25 videobuf2_memops snd_compress
irqbypass videobuf2_v4l2 ac97_bus videobuf2_common snd_hda_codec_realtek
snd_pcm_dmaengine crct10dif_pclmul snd_hda_codec_generic videodev snd_hda_intel
crc32_pclmul ghash_clmulni_intel
[  178.411409]  snd_hda_codec hid_generic usbhid mc iTCO_wdt aesni_intel
ecdh_generic hid ecc mei_hdcp intel_rapl_msr iTCO_vendor_support wmi_bmof
intel_wmi_thunderbolt snd_hda_core aes_x86_64 crypto_simd cfg80211 cryptd uas
glue_helper snd_hwdep intel_cstate nls_iso8859_1 usb_storage nls_cp437 snd_pcm
intel_uncore thinkpad_acpi vfat fat e1000e intel_rapl_perf pcspkr nvram
scsi_mod input_leds psmouse tpm_crb mei_me ledtrig_audio snd_timer i2c_i801
ucsi_acpi mei processor_thermal_device rfkill typec_ucsi tpm_tis
intel_rapl_common tpm_tis_core intel_pch_thermal intel_xhci_usb_role_switch
roles intel_soc_dts_iosf typec snd int3403_thermal tpm battery
int340x_thermal_zone ac soundcore int3400_thermal wmi acpi_thermal_rel evdev
rng_core mac_hid crypto_user ip_tables x_tables ext4 crc32c_generic crc16
mbcache jbd2 dm_mod serio_raw xhci_pci atkbd xhci_hcd libps2 crc32c_intel i8042
serio i915 intel_gtt i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
sysimgblt fb_sys_fops drm agpgart
[  195.493302] CR2: 0000000000000006
[  195.493308] INFO: NMI handler (kgdb_nmi_handler) took too long to run:
17080.282 msecs

----


crash> bt
PID: 1095   TASK: ffff97d06f040000  CPU: 6   COMMAND: "CPU 1/KVM"
 #0 [ffff9ea9814574d0] machine_kexec at ffffffffaf865950
 #1 [ffff9ea981457530] __crash_kexec at ffffffffaf93fdf8
 #2 [ffff9ea9814575f8] crash_kexec at ffffffffaf940ad5
 #3 [ffff9ea981457608] oops_end at ffffffffaf82d672
 #4 [ffff9ea981457628] no_context at ffffffffaf8757dc
 #5 [ffff9ea9814576a0] do_page_fault at ffffffffaf8763d1
 #6 [ffff9ea9814576d0] page_fault at ffffffffb02012ee
    [exception RIP: ip_do_fragment+594]
    RIP: ffffffffaffea6c2  RSP: ffff9ea981457788  RFLAGS: 00010202
    RAX: 0000000000000000  RBX: ffffffffb0cf9e00  RCX: 00000000ffff1ebe
    RDX: ffff97d070aa0054  RSI: ffff97d070aa2642  RDI: ffff97d070aa0050
    RBP: ffff97d063a80300   R8: 00000000000006c0   R9: ffff97d077006a00
    R10: ffff97d070aa208e  R11: ffff97d063a80700  R12: 0000000000000000
    R13: ffffffffaffe9950  R14: ffff97d063a80d00  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff9ea981457808] ip_output at ffffffffaffec8b4
 #8 [ffff9ea981457878] ip_forward at ffffffffaffe80fa
 #9 [ffff9ea9814578e8] ip_rcv at ffffffffaffe6b3c
#10 [ffff9ea981457958] __netif_receive_skb_one_core at ffffffffaff6f9f0
#11 [ffff9ea981457980] netif_receive_skb_internal at ffffffffaff6fb13
#12 [ffff9ea9814579b0] netif_receive_skb at ffffffffaff6fb78
#13 [ffff9ea9814579c8] br_pass_frame_up at ffffffffc13c15ee [bridge]
#14 [ffff9ea981457a40] br_handle_frame_finish at ffffffffc13c182a [bridge]
#15 [ffff9ea981457a98] br_handle_frame at ffffffffc13c1deb [bridge]
#16 [ffff9ea981457b38] __netif_receive_skb_core at ffffffffaff6eee3
#17 [ffff9ea981457bf8] __netif_receive_skb_one_core at ffffffffaff6f9a7
#18 [ffff9ea981457c20] netif_receive_skb_internal at ffffffffaff6fb13
#19 [ffff9ea981457c50] netif_receive_skb at ffffffffaff6fb78
#20 [ffff9ea981457c68] tun_get_user at ffffffffc13f5098 [tun]
#21 [ffff9ea981457d58] tun_chr_write_iter at ffffffffc13f5996 [tun]
#22 [ffff9ea981457d80] do_iter_readv_writev at ffffffffafab3cd6
#23 [ffff9ea981457dc8] do_iter_write at ffffffffafab53ed
#24 [ffff9ea981457df8] vfs_writev at ffffffffafab55dd
#25 [ffff9ea981457ef0] do_writev at ffffffffafab56c3
#26 [ffff9ea981457f30] do_syscall_64 at ffffffffaf80454f
#27 [ffff9ea981457f50] entry_SYSCALL_64_after_hwframe at ffffffffb020008c
    RIP: 00007f3b114ae36d  RSP: 00007f3b0c5fc580  RFLAGS: 00000293
    RAX: ffffffffffffffda  RBX: 0000000000000003  RCX: 00007f3b114ae36d
    RDX: 0000000000000003  RSI: 00007f3b0c5fc730  RDI: 0000000000000024
    RBP: 00007f3b0e642c80   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000003  R11: 0000000000000293  R12: 00007f3b0e642c80
    R13: 00007f3b0c5fc730  R14: 00007f3b0c5fc730  R15: 0000000000000000
    ORIG_RAX: 0000000000000014  CS: 0033  SS: 002b

----


(gdb) disas /m ip_do_fragment
Dump of assembler code for function ip_do_fragment:
[...snip]
665     static void ip_frag_ipcb(struct sk_buff *from, struct sk_buff *to,

666                              bool first_frag, struct ip_frag_state *state)
667     {
668             /* Copy the flags to each fragment. */
669             IPCB(to)->flags = IPCB(from)->flags;

670     
671             if (IPCB(from)->flags & IPSKB_FRAG_PMTU)
   0xffffffff817ea6b9 <+585>:   test   $0x40,%al
   0xffffffff817ea6bb <+587>:   je     0xffffffff817ea6c7 <ip_do_fragment+599>

672                     state->iph->frag_off |= htons(IP_DF);
   0xffffffff817ea6bd <+589>:   mov    0x20(%rsp),%rax
   0xffffffff817ea6c2 <+594>:   orw    $0x40,0x6(%rax)
[...snip]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
