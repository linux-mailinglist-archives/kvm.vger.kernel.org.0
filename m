Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71155BB9FB
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 20:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIQSsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Sep 2022 14:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiIQSsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Sep 2022 14:48:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE352C129
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 11:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6D4FB80DE0
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 18:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C1DEC433B5
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663440486;
        bh=Fcq46GPQJuxydehAS0y2xEwspC/uJWEEz0YQw3MBGmc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EdtcsYY0MqSqAAlzmnpSf09giCfQUjWfsQXWAJc4X2DiN9hAY+qlpz0BhzjvkMP+M
         qFtqRMD/XkR9ClyBVGWGAXhz7bojLpIioLk7n2DB78XtWhiFNBGQG+aB8gvz4pmiBz
         Qv1aSrsTAga2G+0UVLYImEG8BygZbJZZYpINd6dIW8WNiyaNyMFOTPFUG9rRtdkQul
         UFiXeencyPGvS6Z0+uoPeJSBtxc7Fn6138xjCT8rK4ICBpnRSP6dzNViojKkKzq4vX
         hEqHXJZR86khWbutTzecGoP9Pqo6tx1ZL4nqaWJMmWu/n1nFsRHoRoQFg2GoOQaBDy
         JkrfMuw64dCgw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5D604C05F8A; Sat, 17 Sep 2022 18:48:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216498] Can't load kvmgt anymore (works with 5.18)
Date:   Sat, 17 Sep 2022 18:48:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dion@inhex.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_regression
Message-ID: <bug-216498-28872-iU7TBQFyFQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216498-28872@https.bugzilla.kernel.org/>
References: <bug-216498-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216498

Dmitry Nezhevenko (dion@inhex.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|No                          |Yes

--- Comment #2 from Dmitry Nezhevenko (dion@inhex.net) ---
[   92.987534] ------------[ cut here ]------------
[   92.987538] assign a handler to a non-tracked mmio 4ab8
[   92.987555] WARNING: CPU: 0 PID: 3660 at
drivers/gpu/drm/i915/gvt/handlers.c:124 setup_mmio_info.constprop.0+0xd5/0x=
100
[kvmgt]
[   92.987586] Modules linked in: kvmgt(+) vfio_iommu_type1 vfio mdev ctr c=
cm
z3fold lz4 lz4_compress snd_seq_dummy snd_hrtimer snd_seq snd_seq_device
xt_TCPMSS xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT xt_tcpudp
nft_compat nf_nat_tftp nf_conntrack_netbios_ns nf_conntrack_broadcast
nft_objref wireguard curve25519_x86_64 libchacha20poly1305 bridge chacha_x8=
6_64
poly1305_x86_64 libcurve25519_generic libchacha ip6_udp_tunnel udp_tunnel s=
tp
llc nf_conntrack_tftp nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib rfcomm
cmac algif_hash nft_reject_inet nf_reject_ipv4 algif_skcipher nf_reject_ipv6
af_alg nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set nf_tables nfnetlink qrtr uinput bnep snd_ctl_led
snd_soc_skl_hda_dsp snd_soc_intel_hda_dsp_common snd_soc_hdac_hdmi
snd_sof_probes sunrpc binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek
nls_ascii nls_cp437 snd_hda_codec_generic vfat snd_soc_dmic ledtrig_audio f=
at
snd_sof_pci_intel_cnl
[   92.987660]  snd_sof_intel_hda_common soundwire_intel
soundwire_generic_allocation soundwire_cadence snd_sof_intel_hda snd_sof_pci
snd_sof_xtensa_dsp snd_sof snd_sof_utils snd_soc_hdac_hda snd_hda_ext_core =
ext4
snd_soc_acpi_intel_match snd_soc_acpi mbcache joydev snd_soc_core jbd2
snd_compress btusb x86_pkg_temp_thermal intel_powerclamp soundwire_bus core=
temp
btrtl hid_multitouch btbcm snd_hda_intel iTCO_wdt intel_pmc_bxt ee1004 btin=
tel
iTCO_vendor_support mei_wdt hid_generic iwlmvm kvm_intel snd_intel_dspcfg b=
tmtk
watchdog mei_hdcp intel_rapl_msr snd_intel_sdw_acpi bluetooth mac80211
snd_hda_codec kvm libarc4 snd_hda_core snd_hwdep jitterentropy_rng irqbypass
snd_pcm iwlwifi uvcvideo crc32_pclmul sha512_ssse3 videobuf2_vmalloc
sha512_generic snd_timer videobuf2_memops videobuf2_v4l2
processor_thermal_device_pci_legacy snd processor_thermal_device
videobuf2_common ghash_clmulni_intel i2c_i801 drbg processor_thermal_rfim
hp_wmi rapl intel_cstate intel_uncore efi_pstore platform_profile
[   92.987731]  wmi_bmof soundcore i2c_smbus videodev ansi_cprng mei_me
processor_thermal_mbox ucsi_acpi processor_thermal_rapl intel_rapl_common
typec_ucsi ecdh_generic intel_lpss_pci cfg80211 mei int3403_thermal
soc_button_array ecc roles int340x_thermal_zone intel_lpss mc i2c_hid_acpi
crc16 rfkill idma64 intel_pch_thermal typec intel_soc_dts_iosf battery i2c_=
hid
int3400_thermal acpi_thermal_rel intel_hid intel_pmc_core ac sparse_keymap
acpi_pad button msr i2c_dev parport_pc ppdev lp parport fuse configfs ip_ta=
bles
x_tables autofs4 dm_crypt dm_mod efivarfs raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear md_mod
r8152 mii btrfs blake2b_generic libcrc32c crc32c_generic xor raid6_pq
zstd_compress usbhid hid uas usb_storage scsi_mod scsi_common i915 i2c_algo=
_bit
drm_buddy crc32c_intel drm_display_helper nvme nvme_core drm_kms_helper t10=
_pi
cec aesni_intel rc_core ttm xhci_pci crc64_rocksoft crc64 crc_t10dif
intel_wmi_thunderbolt xhci_hcd
[   92.987819]  crypto_simd drm evdev crct10dif_generic thunderbolt
crct10dif_pclmul cryptd serio_raw usbcore crct10dif_common usb_common wmi v=
ideo
[   92.987832] CPU: 0 PID: 3660 Comm: modprobe Tainted: G     U=20=20=20=20=
=20=20=20=20=20=20=20
5.19.0-1-amd64 #1  Debian 5.19.6-1
[   92.987836] Hardware name: HP HP EliteBook 850 G7 Notebook PC/8724, BIOS=
 S73
Ver. 01.09.00 04/07/2022
[   92.987838] RIP: 0010:setup_mmio_info.constprop.0+0xd5/0x100 [kvmgt]
[   92.987863] Code: ef e4 e6 dd 78 39 f5 77 a2 31 c0 48 83 c4 08 5b 5d 41 =
5c
41 5d 41 5e 41 5f c3 cc cc cc cc 48 c7 c7 a0 c9 8c c1 e8 ef 25 2c c1 <0f> 0=
b 48
83 c4 08 b8 ed ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f c3
[   92.987865] RSP: 0018:ffffb801c467fca8 EFLAGS: 00010286
[   92.987868] RAX: 0000000000000000 RBX: ffff8e94a7a88000 RCX:
0000000000000000
[   92.987870] RDX: 0000000000000001 RSI: ffffffff8336ed69 RDI:
00000000ffffffff
[   92.987873] RBP: 0000000000004abc R08: 0000000000000000 R09:
00000000ffffefff
[   92.987874] R10: ffffb801c467fb48 R11: ffffffff83ad1f08 R12:
0000000000000000
[   92.987876] R13: 0000000000000000 R14: 0000000000000008 R15:
0000000000000000
[   92.987878] FS:  00007fed010be440(0000) GS:ffff8e99ffe00000(0000)
knlGS:0000000000000000
[   92.987881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   92.987883] CR2: 000055dd95eb9030 CR3: 000000035e690004 CR4:
00000000003706f0
[   92.987885] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   92.987886] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   92.987888] Call Trace:
[   92.987891]  <TASK>
[   92.987894]  ? bxt_gt_disp_pwron_write+0x70/0x70 [kvmgt]
[   92.987913]  init_skl_mmio_info+0x153a/0x15b0 [kvmgt]
[   92.987926]  intel_gvt_setup_mmio_info+0x316f/0x3560 [kvmgt]
[   92.987936]  ? gen9_dbuf_ctl_mmio_write+0x40/0x40 [kvmgt]
[   92.987946]  intel_gvt_init_device+0x10a/0x3f0 [kvmgt]
[   92.987958]  intel_gvt_init_device.part.0+0xe7/0x1c0 [i915]
[   92.988058]  ? intel_vgt_balloon+0x230/0x230 [i915]
[   92.988124]  ? 0xffffffffc18f7000
[   92.988127]  intel_gvt_set_ops+0x7f/0xb0 [i915]
[   92.988187]  kvmgt_init+0x13/0x1000 [kvmgt]
[   92.988200]  do_one_initcall+0x41/0x200
[   92.988204]  ? kmem_cache_alloc_trace+0x177/0x2a0
[   92.988208]  do_init_module+0x4c/0x200
[   92.988211]  __do_sys_finit_module+0xb4/0x130
[   92.988214]  do_syscall_64+0x38/0xc0
[   92.988217]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   92.988220] RIP: 0033:0x7fed011c6ee9
[   92.988222] Code: 08 44 89 e0 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 48 =
89
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d f7 ee 0e 00 f7 d8 64 89 01 48
[   92.988223] RSP: 002b:00007ffe5d5bb848 EFLAGS: 00000246 ORIG_RAX:
0000000000000139
[   92.988225] RAX: ffffffffffffffda RBX: 000055ea7aa730b0 RCX:
00007fed011c6ee9
[   92.988226] RDX: 0000000000000000 RSI: 000055ea799924d0 RDI:
0000000000000005
[   92.988227] RBP: 000055ea799924d0 R08: 0000000000000000 R09:
000055ea7aa77760
[   92.988228] R10: 0000000000000005 R11: 0000000000000246 R12:
0000000000040000
[   92.988229] R13: 0000000000000000 R14: 000055ea7aa731e0 R15:
0000000000000000
[   92.988231]  </TASK>
[   92.988232] ---[ end trace 0000000000000000 ]---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
