Return-Path: <kvm+bounces-12348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66060881BCC
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 05:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 886701C213B2
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 04:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACECC121;
	Thu, 21 Mar 2024 04:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUmeOlu0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6456BA56
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 04:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710994158; cv=none; b=sskY1zcyxKXo/5unP0OIxDLOJfsgqv3I/v74+VupQ2Mnk9JHsr/cqGzz7407z4Hu96sluuZRZ8zRd0SGPQ/VtZDlZR9RQJaNfOcwcris7ZnU8ZBVYxX0Z9SVvayOgIDNHp0lFXfW5JngsaMXQ57YBGGcFJVUvGM0mTSafHrrSxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710994158; c=relaxed/simple;
	bh=ooYwMhdUeonzpaiGLYYT5JxOyWP9ZlsBDvaXa6k7+Hs=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DvIKm22oRKGJQqOkwvHfN2UXY01Y0RNbLEo8ZMa+ybBfQYvoFaIhgrI3+sHoFGLtRON+zYx14/+3XCHE63sKK4/RmIbdxp+pqQokL7y1FaDKqkiQnWsJiIv4WdirMCFZU+jH9MVMLFH/6QqsYWG9Djy+diQJiwhydXNfVVtDQrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUmeOlu0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6ED4CC43390
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 04:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710994157;
	bh=ooYwMhdUeonzpaiGLYYT5JxOyWP9ZlsBDvaXa6k7+Hs=;
	h=From:To:Subject:Date:From;
	b=hUmeOlu0bgZhDzNqftGOebj8qbw1t5SUamOarMMw0/D/vM2RtmzjTQO9jihxuuTkQ
	 FjQ0nRb4f9nM3kFZi0u9WNfuXuKrEdneupp5xV/SpTIi+o4J3Um3dpCzQsqOgdJw96
	 bi6B1DEu3PvTW9aAmSJTSJpmjhn9Nx+UigLCZIZsUU5xRtdYXOoI3XC1EZrcJ75rv2
	 nL32D4fwq+jM09ExTXew4UUxEjvm3Uwlt+QuDxcrEb4FIVlTp9m3Xi6tbot35okHHg
	 gIIKFBhQJlpOSHuUpTxHDej2IXX3fL2lzZPPg3pOmhW/gqOqHWFyzj47cKvE823QhO
	 aVP97mS3smSng==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 62091C53BCD; Thu, 21 Mar 2024 04:09:17 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218621] New: WARNING: CPU: 5 PID: 11173 at
 arch/x86/kvm/x86.c:12251 kvm_vcpu_reset+0x3b0/0x610 [kvm]
Date: Thu, 21 Mar 2024 04:09:17 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218621-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218621

            Bug ID: 218621
           Summary: WARNING: CPU: 5 PID: 11173 at arch/x86/kvm/x86.c:12251
                    kvm_vcpu_reset+0x3b0/0x610 [kvm]
           Product: Virtualization
           Version: unspecified
          Hardware: AMD
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ne-vlezay80@yandex.ru
        Regression: No

[15868.125746] Modules linked in: act_mirred act_vlan cls_matchall sch_ingr=
ess
dummy vhost_net vhost vhost_iotlb tap bridge stp llc tun fuse qrtr bnep
bluetooth ecdh_generic rfkill ecc uinput nfsd auth_rpcgss nfs_acl nfs lockd
grace netfs sunrpc lp dm_crypt dm_mod uvcvideo videobuf2_vmalloc uvc
videobuf2_memops videobuf2_v4l2 snd_usb_audio snd_usbmidi_lib videodev
snd_rawmidi videobuf2_common snd_seq_device ppdev mc joydev edac_mce_amd
kvm_amd ccp rng_core snd_hda_codec_realtek snd_hda_codec_generic kvm
snd_hda_codec_hdmi irqbypass snd_hda_intel snd_intel_dspcfg snd_intel_sdw_a=
cpi
pcspkr serio_raw wmi_bmof snd_hda_codec acpi_cpufreq fam15h_power k10temp
sp5100_tco watchdog snd_hda_core snd_hwdep snd_pcm snd_timer evdev parport_=
pc
parport asus_atk0110 snd nvidiafb vgastate soundcore fb_ddc squashfs loop
overlay ext4 crc16 mbcache jbd2 efivarfs raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_gene=
ric
raid0 raid1 md_mod sg hid_generic usbhid hid nouveau sd_mod t10_pi
[15868.125819]  gpu_sched crc64_rocksoft_generic drm_gpuvm crc64_rocksoft
drm_exec crc_t10dif sr_mod mxm_wmi crct10dif_generic drm_ttm_helper cdrom
crct10dif_pclmul crc64 crct10dif_common ttm crc32_pclmul crc32c_intel video
ghash_clmulni_intel i2c_algo_bit r8169 ahci sha512_ssse3 ohci_pci ata_gener=
ic
drm_display_helper ohci_hcd xhci_pci sha256_ssse3 ehci_pci realtek
xhci_pci_renesas libahci pata_atiixp drm_kms_helper xhci_hcd ehci_hcd libata
sha1_ssse3 psmouse mdio_devres drm e1000e usbcore scsi_mod libphy i2c_piix4=
 cec
ptp scsi_common rc_core usb_common pps_core wmi button aesni_intel crypto_s=
imd
cryptd
[15868.125862] CPU: 5 PID: 11173 Comm: qemu-system-x86 Not tainted 6.8.1 #3
[15868.125865] Hardware name: System manufacturer System Product Name/M5A78=
L-M
PLUS/USB3, BIOS 0502    11/18/2016
[15868.125867] RIP: 0010:kvm_vcpu_reset+0x3b0/0x610 [kvm]
[15868.125954] Code: 00 00 00 48 8b 44 24 10 65 48 2b 04 25 28 00 00 00 0f =
85
68 02 00 00 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f e9 b0 ae 28 dc <0f> 0=
b e9
d9 fc ff ff 4c 89 e6 48 89 df 81 e6 00 00 00 60 48 83 ce
[15868.125957] RSP: 0018:ffffbad403967cb0 EFLAGS: 00010202
[15868.125959] RAX: 0000000000000002 RBX: ffff90540eab19a0 RCX:
0000000000000000
[15868.125961] RDX: 0000000000000001 RSI: 0000000000000008 RDI:
00000000ffffffff
[15868.125962] RBP: 0000000000000001 R08: 0000000000000000 R09:
0000000000000000
[15868.125964] R10: ffff905452a0ad10 R11: 0000000000000000 R12:
0000000000000010
[15868.125965] R13: 0000000000000001 R14: 0000000000000000 R15:
ffff90540eab19d8
[15868.125967] FS:  00007f8085a006c0(0000) GS:ffff90591fd40000(0000)
knlGS:0000000000000000
[15868.125969] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15868.125970] CR2: 0000000000000000 CR3: 000000010d70c000 CR4:
00000000000406f0
[15868.125972] Call Trace:
[15868.125975]  <TASK>
[15868.125976]  ? kvm_vcpu_reset+0x3b0/0x610 [kvm]
[15868.126063]  ? __warn+0x7d/0x130
[15868.126069]  ? kvm_vcpu_reset+0x3b0/0x610 [kvm]
[15868.126166]  ? report_bug+0x18d/0x1c0
[15868.126173]  ? handle_bug+0x41/0x70
[15868.126177]  ? exc_invalid_op+0x13/0x60
[15868.126181]  ? asm_exc_invalid_op+0x16/0x20
[15868.126187]  ? kvm_vcpu_reset+0x3b0/0x610 [kvm]
[15868.126286]  shutdown_interception+0x32/0x50 [kvm_amd]
[15868.126301]  kvm_arch_vcpu_ioctl_run+0x6d3/0x1680 [kvm]
[15868.126392]  kvm_vcpu_ioctl+0x247/0x6f0 [kvm]
[15868.126467]  __x64_sys_ioctl+0x93/0xd0
[15868.126472]  do_syscall_64+0x89/0x1b0
[15868.126475]  ? fpregs_assert_state_consistent+0x22/0x50
[15868.126479]  ? syscall_exit_to_user_mode+0x81/0x210
[15868.126482]  ? do_syscall_64+0x95/0x1b0
[15868.126484]  ? fpregs_assert_state_consistent+0x22/0x50
[15868.126486]  ? syscall_exit_to_user_mode+0x81/0x210
[15868.126488]  ? do_syscall_64+0x95/0x1b0
[15868.126490]  ? fpregs_assert_state_consistent+0x22/0x50
[15868.126493]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[15868.126496] RIP: 0033:0x7f8088c5fb3b
[15868.126499] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 =
00
00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c=
2 3d
00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[15868.126501] RSP: 002b:00007f80859ff530 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[15868.126504] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007f8088c5fb3b
[15868.126506] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
0000000000000017
[15868.126507] RBP: 00005595d9dd7450 R08: 0000000000000000 R09:
0000000000000000
[15868.126509] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[15868.126510] R13: 0000000000000001 R14: 0000000000000001 R15:
0000000000000000
[15868.126513]  </TASK>
[15868.126514] ---[ end trace 0000000000000000 ]---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

