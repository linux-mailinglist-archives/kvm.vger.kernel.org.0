Return-Path: <kvm+bounces-33475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B62829EC466
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 06:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBA262822A1
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 05:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 722341C1F08;
	Wed, 11 Dec 2024 05:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qIh4k5bQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925BE4A0A
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 05:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733895667; cv=none; b=QjdvWGOdujzdh4gSji/oNqITDTN9L4vxRCQLgMG8Mr9PNeWaVK5Eni34PiUeAyoB59umNaH9cmgRVA0wVnLmO/O9JUnc3MByl885ZED7FPlO2/FRvPTzgnZWTAJbaKhShzb1QffSLE2GbaNPIldfnRsX+sEUk9Ssf+eZDiKjA4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733895667; c=relaxed/simple;
	bh=E2tvYs/stfPITYJmcpo0wWKBthEzn6b7e2gaM9NTJ0U=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eRhiqjdfNM91/xxHsqH8ZsYc1bmBpZLJG2wvRG0cPLCHwvJqeU8sXnHcnt4hpgHohdC2XAngFl4LMG4uakPmKhLhLt+DvRJ9CeNSiIHwYUbfQoNloKEIDDfzXLyMl965pZsxnqnDi2oV4VqS65zgHmko3rn0Juu9zbvCvYrfAn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qIh4k5bQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24FBAC4CEE0
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 05:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733895667;
	bh=E2tvYs/stfPITYJmcpo0wWKBthEzn6b7e2gaM9NTJ0U=;
	h=From:To:Subject:Date:From;
	b=qIh4k5bQJ852Q1JtGbFzl6zLNk5TuIe06mzA2A/66flkDghBEqUEchH7naQIpmMAI
	 RRtE9hxn8tIaqlUiAMMOHNhg5vrUUEfmlqDW2y8DE12mZi0glBRGYnljuTy4MRg9bs
	 tlRkqtweEd9Rv8z5yiASd3tjc61o/KSr2sog4Vos+np0J9dXaXdrvnubRXU5bO/AIa
	 MasMYaAXEQaIqbdmeZj/9C4hbilqn//unypKHq0agRPosnP/rRBjYeY1bDSvPXmhYw
	 oXnLAKOAl+HrNKBtwSiksVSnnh4rVvZnwR2vT8p1bxBejx0qrDc2wck88/yJ7mEDCB
	 4IqLKxKBxHZcA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 15A30C41614; Wed, 11 Dec 2024 05:41:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219588] New: [6.13.0-rc2+]WARNING: CPU: 52 PID: 12253 at
 arch/x86/kvm/mmu/tdp_mmu.c:1001 tdp_mmu_map_handle_target_level+0x1f0/0x310
 [kvm]
Date: Wed, 11 Dec 2024 05:41:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: leiyang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219588-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219588

            Bug ID: 219588
           Summary: [6.13.0-rc2+]WARNING: CPU: 52 PID: 12253 at
                    arch/x86/kvm/mmu/tdp_mmu.c:1001
                    tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: leiyang@redhat.com
        Regression: No

Hello

I hit a bug on the intel host, this problem occurs randomly:
[  406.127925] ------------[ cut here ]------------
[  406.132572] WARNING: CPU: 52 PID: 12253 at arch/x86/kvm/mmu/tdp_mmu.c:10=
01
tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]
[  406.143883] Modules linked in: vhost_net vhost vhost_iotlb tap tun isofs
cdrom bluetooth nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs netfs tls nft_=
masq
nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject nft_chain_nat nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables rpcrdma rdma_cm iw_cm
ib_cm ib_core bridge stp llc rfkill intel_rapl_msr intel_rapl_common
intel_uncore_frequency intel_uncore_frequency_common intel_ifs i10nm_edac
skx_edac_common nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp corete=
mp
kvm_intel dax_hmem pmt_telemetry cxl_acpi iTCO_wdt kvm ipmi_ssif dell_pc
iTCO_vendor_support cxl_port mgag200 cxl_core rapl isst_if_mbox_pci dell_sm=
bios
intel_sdsi isst_if_mmio pmt_class i2c_i801 i2c_algo_bit dell_wmi_descriptor=
 tg3
intel_cstate intel_vsec wmi_bmof einj platform_profile isst_if_common dcdbas
intel_uncore ipmi_si acpi_power_meter i2c_smbus sg i2c_ismt mei_me mei
acpi_ipmi pcspkr ipmi_devintf ipmi_msghandler nfsd auth_rpcgss nfs_acl fuse
loop lockd grace nfs_localio sunrpc nfnetlink xfs sd_mod
[  406.143941]  iaa_crypto ahci libahci crct10dif_pclmul crc32_pclmul idxd
crc32c_intel libata megaraid_sas ghash_clmulni_intel idxd_bus wmi
pinctrl_emmitsburg dm_mirror dm_region_hash dm_log dm_mod
[  406.251266] CPU: 52 UID: 0 PID: 12253 Comm: qemu-kvm Kdump: loaded Not
tainted 6.13.0-rc2+ #1
[  406.259802] Hardware name: Dell Inc. PowerEdge R760/0024FG, BIOS 2.1.5
03/14/2024
[  406.267298] RIP: 0010:tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]
[  406.273973] Code: 01 74 04 a8 80 74 25 48 8b 0d 54 5f 1b 00 4c 8b 04 24 =
41
bd 05 00 00 00 48 85 c8 0f 84 ee fe ff ff 49 85 c8 0f 85 e5 fe ff ff <0f> 0=
b 8d
44 d2 03 ba 01 00 00 00 49 8b 3c 24 c4 e2 f9 f7 d2 48 c1
[  406.292734] RSP: 0018:ff4af92c619cf8c0 EFLAGS: 00010246
[  406.297980] RAX: 860000025e000bf7 RBX: ff4af92c619cf920 RCX:
0400000000000000
[  406.305130] RDX: 0000000000000002 RSI: 0000000000000000 RDI:
0000000000000015
[  406.312284] RBP: ff4af92c619cf9e8 R08: 800000025e0009f5 R09:
0000000000000002
[  406.319438] R10: 000000005e000901 R11: 0000000000000001 R12:
ff1e70694fc68000
[  406.326587] R13: 0000000000000005 R14: 0000000000000000 R15:
ff4af92c619a1000
[  406.333741] FS:  00007efceb5fe6c0(0000) GS:ff1e7087bf700000(0000)
knlGS:0000000000000000
[  406.341881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  406.347632] CR2: 00007fbb241f0710 CR3: 00000001139f0003 CR4:
0000000000f73ef0
[  406.354782] PKRU: 55555554
[  406.357512] Call Trace:
[  406.359985]  <TASK>
[  406.362108]  ? show_trace_log_lvl+0x1b0/0x2f0
[  406.366491]  ? show_trace_log_lvl+0x1b0/0x2f0
[  406.370869]  ? kvm_tdp_mmu_map+0x304/0x320 [kvm]
[  406.375550]  ? tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]
[  406.381614]  ? __warn.cold+0x93/0xf4
[  406.385211]  ? tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]
[  406.391277]  ? report_bug+0xff/0x140
[  406.394876]  ? handle_bug+0x53/0x90
[  406.398382]  ? exc_invalid_op+0x17/0x70
[  406.402242]  ? asm_exc_invalid_op+0x1a/0x20
[  406.406445]  ? tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]
[  406.412511]  kvm_tdp_mmu_map+0x304/0x320 [kvm]
[  406.417020]  kvm_tdp_page_fault+0xbf/0xf0 [kvm]
[  406.421623]  kvm_mmu_do_page_fault+0x1d9/0x210 [kvm]
[  406.426657]  kvm_mmu_page_fault+0x89/0x360 [kvm]
[  406.431343]  vmx_handle_exit+0x12/0x50 [kvm_intel]
[  406.436165]  vcpu_enter_guest.constprop.0+0x5cf/0xe80 [kvm]
[  406.441806]  ? kvm_apic_update_irr+0x23/0x50 [kvm]
[  406.446667]  ? vmx_sync_pir_to_irr+0xd5/0x110 [kvm_intel]
[  406.452095]  vcpu_run+0x2f/0x240 [kvm]
[  406.455913]  kvm_arch_vcpu_ioctl_run+0x103/0x490 [kvm]
[  406.461114]  kvm_vcpu_ioctl+0x20b/0x770 [kvm]
[  406.465519]  __x64_sys_ioctl+0x94/0xc0
[  406.469288]  do_syscall_64+0x7d/0x160
[  406.472971]  ? select_idle_sibling+0x41/0x750
[  406.477350]  ? select_task_rq_fair+0x1f5/0x3b0
[  406.481821]  ? sched_clock+0x10/0x30
[  406.485417]  ? sched_clock_cpu+0xf/0x1d0
[  406.489361]  ? __smp_call_single_queue+0xab/0x110
[  406.494087]  ? ttwu_queue_wakelist+0xe5/0x100
[  406.498469]  ? try_to_wake_up+0x2a2/0x600
[  406.502499]  ? wake_up_q+0x4e/0x90
[  406.505923]  ? futex_wake+0x177/0x1a0
[  406.509608]  ? do_futex+0x125/0x190
[  406.513116]  ? __x64_sys_futex+0x127/0x1e0
[  406.517225]  ? syscall_exit_to_user_mode_prepare+0x15e/0x1a0
[  406.522899]  ? syscall_exit_to_user_mode+0x32/0x190
[  406.527799]  ? do_syscall_64+0x89/0x160
[  406.531656]  ? syscall_exit_to_user_mode_prepare+0x15e/0x1a0
[  406.537333]  ? syscall_exit_to_user_mode+0x32/0x190
[  406.542227]  ? do_syscall_64+0x89/0x160
[  406.546087]  ? exc_page_fault+0x73/0x160
[  406.550028]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  406.555100] RIP: 0033:0x7f1bbab08ebf
[  406.558721] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 =
00
00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c=
2 3d
00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  406.577484] RSP: 002b:00007efceb5fd4c0 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  406.585068] RAX: ffffffffffffffda RBX: 0000559776de3e80 RCX:
00007f1bbab08ebf
[  406.592217] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001e
[  406.599367] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[  406.606520] R10: 0000000000000000 R11: 0000000000000246 R12:
948ed561ee19de00
[  406.613670] R13: 000000000000ae80 R14: 00007efcebdffe50 R15:
fffffffffffffd10
[  406.620822]  </TASK>
[  406.623029] ---[ end trace 0000000000000000 ]---

I also can not sure it is a CPU issues or a memory issues, due to the "1225=
3"
is a active vcpu PID, so report this bug on kvm.Please correct me if I'm wr=
ong.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

