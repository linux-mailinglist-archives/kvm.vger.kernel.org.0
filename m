Return-Path: <kvm+bounces-19181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2808B902014
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EBFC284161
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 11:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC6E78C9C;
	Mon, 10 Jun 2024 11:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oTl5w5oy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0127A71743
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 11:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718017427; cv=none; b=peix/KvZw3t/8eHq4p1ueu2axenapgmbLrIOho5MleextWU/2GQTEDoDLBGa/2C6NaeHpZhjzfq4ydBy5p3QmBKcvAxawpzvPXDjZpMu1Hn99yk1A5PowldFfdhBFxUnK+cRw1IwLRSKLI5/IygO9KyZKMrsz0ul9rz02/kao/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718017427; c=relaxed/simple;
	bh=xeWGAG32EtUo64GM/RtCIX8m2vLhhdN56Vm+d8mBpdk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lUyFXRlHDOJ+sm4C58dDtDEfzZPHgesU6O55CESnlGY2gtt3ypM5zxfnh5YVvMgFgJrqloJCleQ7LHP6fQGl9PY3b0b3z/Db3JwTRf6WL39ZvBK2DoEuEyhLVsv+Lwwt4ePuaEikHjlLEvmnwVFOxt+n4Yv7kDUQ+gX6G7pkOpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oTl5w5oy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C21AEC4AF1A
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 11:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718017426;
	bh=xeWGAG32EtUo64GM/RtCIX8m2vLhhdN56Vm+d8mBpdk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oTl5w5oycxDIWx/sGj3v9CalRGpAYUyfemTO4G0ud+l5UstlJKyD82ghcAdzJBHgt
	 1R7bQtB8q1ROt2YMRsO4d2YfK2y7U5eZtVA2N49IFeUrlNlCaZ1phNztWgPaSFtCeb
	 leiVOm1w+QUDYtoQPgfCzVA2EX8Gy+tg9XmoWAP6ASBtDwtkxx+Uh9O2vlJlabU9FA
	 8KU7C7idljv2fTpjOdIpR5jPwHCulDSODMYJnTY4XX0P1bfoWXtjFjASGluDx/ixuy
	 DcgwhoxzI+XSHAREF5xx6dTVYxuZi/YeTnhNkKLIjvt89M4SvaBpjnytjvfHjoU+hZ
	 nV5fCQ9DR/vYg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AECB1C53BB8; Mon, 10 Jun 2024 11:03:46 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218949] Kernel panic after upgrading to 6.10-rc2
Date: Mon, 10 Jun 2024 11:03:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: badouri.g@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218949-28872-vNF0xS1i0R@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218949-28872@https.bugzilla.kernel.org/>
References: <bug-218949-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218949

--- Comment #2 from Gino Badouri (badouri.g@gmail.com) ---
Alright, it's not a regression in the kernel but caused by a bios update (I
guess).
I get the same on my previous kernel 6.9.0-rc1.
Both my 6.9.0-rc1 6.10.0-rc2 kernels are vanilla builds from kernel.org
(unpatched).

After updating the bios/firmware of my mainboard Asus ROG Zenith II Extreme
from 1802 to 2102, it always seems to spawn the error:

[ 1150.380137] ------------[ cut here ]------------
[ 1150.380141] Unpatched return thunk in use. This should not happen!
[ 1150.380144] WARNING: CPU: 3 PID: 4849 at arch/x86/kernel/cpu/bugs.c:2935
__warn_thunk+0x40/0x50
[ 1150.380152] Modules linked in: veth rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs
lockd grace netfs ebtable_filter ebtables ip_set ip6table_raw iptable_raw
ip6table_filter ip6_tables iptable_filter nf_tables scsi_transport_iscsi
bonding tls softdog sunrpc nfnetlink_log nfnetlink binfmt_misc amd_atl
intel_rapl_msr intel_rapl_common edac_mce_amd kvm_amd kvm crct10dif_pclmul
polyval_clmulni polyval_generic ghash_clmulni_intel sha256_ssse3 sha1_ssse3
aesni_intel eeepc_wmi crypto_simd asus_wmi cryptd platform_profile
sparse_keymap asus_ec_sensors video pcspkr rapl ccp mxm_wmi wmi_bmof k10temp
mac_hid vfio_pci vfio_pci_core vfio_iommu_type1 vfio iommufd vhost_net vhost
vhost_iotlb tap nct6775 nct6775_core hwmon_vid lm75 drm efi_pstore dmi_sysfs
ip_tables x_tables autofs4 btrfs blake2b_generic xor raid6_pq simplefb
dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c igb xhci_p=
ci
atlantic nvme ahci crc32_pclmul xhci_pci_renesas i2c_algo_bit libahci dca
macsec nvme_core xhci_hcd i2c_piix4 wmi
[ 1150.380266] CPU: 3 PID: 4849 Comm: CPU 0/KVM Not tainted 6.9.0-rc1 #1
[ 1150.380269] Hardware name: ASUS System Product Name/ROG ZENITH II EXTREM=
E,
BIOS 2102 02/16/2024
[ 1150.380271] RIP: 0010:__warn_thunk+0x40/0x50
[ 1150.380275] Code: 96 f1 fe 00 83 e3 01 74 0e 48 8b 5d f8 c9 31 f6 31 ff =
e9
43 1c 08 01 48 c7 c7 b8 f2 f4 9e c6 05 56 61 4c 02 01 e8 00 b1 07 00 <0f> 0=
b 48
8b 5d f8 c9 31 f6 31 ff e9 20 1c 08 01 90 90 90 90 90 90
[ 1150.380278] RSP: 0018:ffffb478c2ce3ca8 EFLAGS: 00010046
[ 1150.380281] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000000
[ 1150.380283] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[ 1150.380285] RBP: ffffb478c2ce3cb0 R08: 0000000000000000 R09:
0000000000000000
[ 1150.380287] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff91f80e948000
[ 1150.380289] R13: 0000000000000000 R14: ffffb478c4ab5000 R15:
ffff91f80e948038
[ 1150.380291] FS:  00007f74baa006c0(0000) GS:ffff9216bd980000(0000)
knlGS:0000000000000000
[ 1150.380293] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1150.380295] CR2: 0000000000000000 CR3: 0000000106750000 CR4:
0000000000350ef0
[ 1150.380298] Call Trace:
[ 1150.380300]  <TASK>
[ 1150.380304]  ? show_regs+0x6c/0x80
[ 1150.380309]  ? __warn+0x88/0x140
[ 1150.380312]  ? __warn_thunk+0x40/0x50
[ 1150.380316]  ? report_bug+0x182/0x1b0
[ 1150.380322]  ? handle_bug+0x46/0x90
[ 1150.380325]  ? exc_invalid_op+0x18/0x80
[ 1150.380329]  ? asm_exc_invalid_op+0x1b/0x20
[ 1150.380336]  ? __warn_thunk+0x40/0x50
[ 1150.380341]  ? __warn_thunk+0x40/0x50
[ 1150.380344]  warn_thunk_thunk+0x16/0x30
[ 1150.380351]  svm_vcpu_enter_exit+0x71/0xc0 [kvm_amd]
[ 1150.380364]  svm_vcpu_run+0x1e7/0x850 [kvm_amd]
[ 1150.380377]  kvm_arch_vcpu_ioctl_run+0xca3/0x16d0 [kvm]
[ 1150.380458]  kvm_vcpu_ioctl+0x295/0x800 [kvm]
[ 1150.380522]  ? srso_return_thunk+0x5/0x5f
[ 1150.380526]  ? __x64_sys_ioctl+0xbb/0xf0
[ 1150.380530]  ? srso_return_thunk+0x5/0x5f
[ 1150.380533]  ? syscall_exit_to_user_mode+0x75/0x1b0
[ 1150.380537]  ? srso_return_thunk+0x5/0x5f
[ 1150.380541]  ? do_syscall_64+0x84/0x140
[ 1150.380544]  ? srso_return_thunk+0x5/0x5f
[ 1150.380547]  ? do_syscall_64+0x84/0x140
[ 1150.380550]  ? switch_fpu_return+0x50/0xe0
[ 1150.380555]  __x64_sys_ioctl+0xa3/0xf0
[ 1150.380559]  do_syscall_64+0x78/0x140
[ 1150.380563]  ? srso_return_thunk+0x5/0x5f
[ 1150.380566]  ? do_syscall_64+0x84/0x140
[ 1150.380569]  entry_SYSCALL_64_after_hwframe+0x6c/0x74
[ 1150.380573] RIP: 0033:0x7f74cbb8cc5b
[ 1150.380592] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 =
00
00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c=
2 3d
00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[ 1150.380595] RSP: 002b:00007f74ba9fb060 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 1150.380598] RAX: ffffffffffffffda RBX: 000056062f0cf7e0 RCX:
00007f74cbb8cc5b
[ 1150.380600] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001f
[ 1150.380602] RBP: 000000000000ae80 R08: 0000000000000000 R09:
0000000000000000
[ 1150.380604] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[ 1150.380606] R13: 0000000000000007 R14: 00007ffc10a8f820 R15:
00007f74ba200000
[ 1150.380612]  </TASK>
[ 1150.380613] ---[ end trace 0000000000000000 ]---

This happens when just starting the VM.
Command line: BOOT_IMAGE=3D/boot/vmlinuz-6.9.0-rc1 root=3D/dev/mapper/pve-r=
oot ro
quiet iommu=3Dpt amd_iommu=3Don kvm_amd.npt=3D1 video=3Dvesafb:off video=3D=
efifb:off
video=3Dsimplefb:off nomodeset initcall_blacklist=3Dsysfb_init
modprobe.blacklist=3Dnouveau modprobe.blacklist=3Damdgpu modprobe.blacklist=
=3Dradeon
modprobe.blacklist=3Dnvidia amd_pstate=3Dguided

I've attached a screenshot of the settings for the VM.

I believe the new bios updates the AGESA firmware from version:
V9CastlePeakPI-SP3r3-1.0.0.9
To:
CastlePeakPI-SP3r3 1.0.0.A (2023-11-21)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

