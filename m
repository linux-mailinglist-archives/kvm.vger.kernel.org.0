Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB01D1C28E9
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 01:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgEBX2g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 2 May 2020 19:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbgEBX2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 19:28:36 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207551] New: unable to handle kernel paging request for VMX
Date:   Sat, 02 May 2020 23:28:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tobias.urdin@binero.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-207551-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207551

            Bug ID: 207551
           Summary: unable to handle kernel paging request for VMX
           Product: Virtualization
           Version: unspecified
    Kernel Version: 4.19.120
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: tobias.urdin@binero.com
        Regression: No

When upgrading from 4.19.118 to either 4.19.119 or 4.19.120 we can no longer
start our virtual machines without the kernel crashing.

4.19.120-1.el7.x86_64

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 85
model name      : Intel(R) Xeon(R) Bronze 3104 CPU @ 1.70GHz
stepping        : 4
microcode       : 0x2000064
cpu MHz         : 1149.078
cache size      : 8448 KB
physical id     : 0
siblings        : 6
core id         : 0
cpu cores       : 6
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 22
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb
rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch
cpuid_fault epb cat_l3 cdp_l3 invpcid_single pti intel_ppin ssbd mba ibrs ibpb
stibp tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 hle
avx2 smep bmi2 erms invpcid rtm cqm mpx rdt_a avx512f avx512dq rdseed adx smap
clflushopt clwb intel_pt avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1
xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local dtherm arat pln pts
pku ospke md_clear flush_l1d
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds
swapgs taa itlb_multihit
bogomips        : 3400.00
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:

[  283.392280] BUG: unable to handle kernel paging request at 0000000000005ae0
[  283.392319] PGD 0 P4D 0
[  283.392335] Oops: 0000 [#1] SMP PTI
[  283.392355] CPU: 1 PID: 12345 Comm: CPU 0/KVM Kdump: loaded Not tainted
4.19.120-1.el7.x86_64 #1
[  283.392393] Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 1.4.9
06/29/2018
[  283.392434] RIP: 0010:vmx_vcpu_run+0x417/0xd10 [kvm_intel]
[  283.392460] Code: ed 45 31 f6 45 31 ff 0f 20 d0 48 89 81 e0 02 00 00 31 c0
31 db 31 c9 31 d2 31 f6 31 ff 31 ed 5d 5a f6 05 a2 6b 01 00 10 74 1b <48> 8b 81
e0 5a 00 00 48 8b 40 30 48 8b 80 08 08 00 00 f6 c4 01 0f
[  283.392538] RSP: 0018:ffffc90002dabc88 EFLAGS: 00010002
[  283.392563] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000000
[  283.392594] RDX: 0000000000006c14 RSI: 0000000000000000 RDI:
0000000000000000
[  283.392625] RBP: ffffc90002dabce8 R08: 0000000000000000 R09:
0000000000000000
[  283.392657] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[  283.392688] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[  283.392720] FS:  00007f1b461b5700(0000) GS:ffff88846fe40000(0000)
knlGS:0000000000000000
[  283.392755] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  283.392781] CR2: 0000000000005ae0 CR3: 00000003ee210004 CR4:
00000000007626e0
[  283.392812] PKRU: 55555554
[  283.392826] Call Trace:
[  283.392847]  ? vmx_prepare_switch_to_guest+0x136/0x320 [kvm_intel]
[  283.392905]  vcpu_enter_guest+0x989/0x1490 [kvm]
[  283.392947]  kvm_arch_vcpu_ioctl_run+0x352/0x550 [kvm]
[  283.392986]  kvm_vcpu_ioctl+0x3d5/0x650 [kvm]
[  283.393010]  ? __seccomp_filter+0x49/0x470
[  283.393033]  ? __fpu__restore_sig+0x90/0x500
[  283.393055]  do_vfs_ioctl+0xaa/0x620
[  283.393075]  ? __audit_syscall_entry+0xdd/0x130
[  283.393097]  ksys_ioctl+0x67/0x90
[  283.393114]  __x64_sys_ioctl+0x1a/0x20
[  283.393135]  do_syscall_64+0x60/0x1b0
[  283.393154]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  283.393178] RIP: 0033:0x7f1b608fe2b7
[  283.393196] Code: 44 00 00 48 8b 05 b9 1b 2d 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 89 1b 2d 00 f7 d8 64 89 01 48
[  283.393275] RSP: 002b:00007f1b461b1a98 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  283.393309] RAX: ffffffffffffffda RBX: 00005631b507c000 RCX:
00007f1b608fe2b7
[  283.393340] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
0000000000000029
[  283.393371] RBP: 00005631b507c09b R08: 00005631b1abf710 R09:
0000000000000006
[  283.393403] R10: 0000000000000000 R11: 0000000000000246 R12:
00005631b1aa5540
[  283.394352] R13: 0000000000801000 R14: 00007f1b679c6000 R15:
00005631b507c000
[  283.395298] Modules linked in: vhost_net vhost tap tun nf_conntrack_netlink
nfnetlink binfmt_misc ip6table_raw xt_CT xt_mac xt_comment xt_physdev
xt_conntrack veth iptable_raw ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter 8021q garp mrp sch_ingress bonding vxlan
ip6_udp_tunnel udp_tunnel openvswitch nsh nf_nat_ipv6 nf_nat_ipv4 nf_conncount
nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ib_isert iscsi_target_mod
ib_srpt target_core_mod ib_srp scsi_transport_srp i40iw rpcrdma sunrpc rdma_ucm
ib_uverbs ib_iser rdma_cm iw_cm ib_umad libiscsi ib_ipoib scsi_transport_iscsi
ib_cm iTCO_wdt iTCO_vendor_support dcdbas mlx4_ib skx_edac nfit
x86_pkg_temp_thermal intel_powerclamp coretemp ib_core kvm_intel kvm irqbypass
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel
[  283.402840]  crypto_simd cryptd glue_helper intel_cstate intel_rapl_perf
joydev input_leds pcspkr sg mei_me mei i2c_i801 lpc_ich mfd_core ipmi_si
ipmi_devintf ipmi_msghandler acpi_power_meter pcc_cpufreq ip_tables xfs
libcrc32c mlx4_en sd_mod mlx4_core mgag200 crc32c_intel drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ahci libahci igb i40e ptp
pps_core dca drm i2c_algo_bit libata dm_mirror dm_region_hash dm_log dm_mod
[  283.407641] CR2: 0000000000005ae0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
