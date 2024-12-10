Return-Path: <kvm+bounces-33349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A2CD9EA3C1
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 093601886478
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0D822612;
	Tue, 10 Dec 2024 00:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KcKA1Lzz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE213C0C;
	Tue, 10 Dec 2024 00:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791671; cv=none; b=HMKvWHbsrwd74A48hw30fUOrEJJUeOHetzZc1p8V2OiWn0MHe6PN8A3wt8UQ9/FpMsx7cdibY49UQhxrCoVpCsGITHwSv+lUqhybglFMB6i6UddAP47Ec6PcSwyDWa0W3qwY7EvSN5Zr1Cx3RI4uDayRbnBSCl3SDSikx/vJjEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791671; c=relaxed/simple;
	bh=Wj4vkYF6723arc9SmvxFU6tp8n06YCEIRGKKNIL32bY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RU0/bpJEa4GVlFd/TsaMGeMr8xLaVb5tdSwLctpfzlRavLDj9fJrMKI0+KVsT3EuOez8cDJs6iabYVXEOWecCqDG9ZzwgqL0vulHQd14H//WHf+QkiCH4kx6xXWWWaU6McUFo6mXBZQg2ZotazxPGLSxVq0Jkv/icxvK7KXEi+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KcKA1Lzz; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791670; x=1765327670;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Wj4vkYF6723arc9SmvxFU6tp8n06YCEIRGKKNIL32bY=;
  b=KcKA1LzzljYG3Kn2ySvwnqHV5ohuOEVISOoZdJzrDygaUB7BkJaXclY5
   x55qMMwZZPlICOtPxsrKPLWpU/gUUpJZImFOiPiB6tW39acSjA2gR+veH
   9QnJRhW9BaZF1dtl+1vpcQSN/iMYQfKlA07dejY0qdgui9bFIjUnza7wT
   xIYFHmv9DEYVFlvg9a6M/t8csACWOg0xvPAM/1w3uBOa+72qvMFq83X+n
   9P6H2zQB7YUi8kaPUaXINO58JoGXlN4vwCd8DiBSf13BEiGZhYA8sfv4B
   8XbTKTWFCs9R3JSG/T69nyzGdlF4iN+ruTolstQLPCx7Es1fpZKZ29OUv
   w==;
X-CSE-ConnectionGUID: f100if04Tym/h8GZtAnRhQ==
X-CSE-MsgGUID: eGqyjBP4SBisIUHy/UIPvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793670"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793670"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:47:49 -0800
X-CSE-ConnectionGUID: NCTZUET+R0COO+KguwaATA==
X-CSE-MsgGUID: jfcxgcm+RlmxvhwB/wCmQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96032997"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:47:44 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 00/18] KVM: TDX: TDX "the rest" part
Date: Tue, 10 Dec 2024 08:49:26 +0800
Message-ID: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This patch series is the last part needed of the basic support to run a
functioning TD VM, including DRs switch, EPT violation/misconfig handling,
the support for several TDVMCALL leaves, a bunch of wrappers to ignore the
operations which are not supported by TDX guests, and the document.

We would like get maintainers/reviewers feedback of the implementation,
considering there are several pre-req series ongoing, we don't think it is
ready for kvm-coco-queue yet.

Base of this series
===================
This series is based off of a kvm-coco-queue commit and some pre-req series:
1. commit ee69eb746754 ("KVM: x86/mmu: Prevent aliased memslot GFNs") (in
   kvm-coco-queue).
2. v7 of "TDX host: metadata reading tweaks and bug fixes and info dump" [0]
3. v1 of "KVM: VMX: Initialize TDX when loading KVM module" [1]
4. v2 of “TDX vCPU/VM creation” [2]
5. v2 of "TDX KVM MMU part 2" [3]
6  v1 of "TDX vcpu enter/exit" [4] with a few fixups based on review feedbacks.
7. v4 of "KVM: x86: Prep KVM hypercall handling for TDX" [5]
8. v1 of "KVM: TDX: TDX hypercalls may exit to userspace" [6]
9. v1 of "KVM: TDX: TDX interrupts" [7]

Debug Register switch
=====================
Skip guest DRs save/restore for TDX guest because TDX-SEAM unconditionally
saves/restores guest DRs on TD exit/enter, and resets DRs to architectural
INIT state on TD exit.

EPT violation
=============
EPT violation for TDX will trigger X86 MMU code.
Note that instruction fetch from shared memory is not allowed for TDX guests,
if it occurs, treat it as broken hardware, bug the VM and return error.

EPT misconfiguration
====================
EPT misconfiguration shouldn't happen for TDX guests. If it occurs, bug the
VM and return error.

TDVMCALL support
================
Supports are added to allow TDX guests to issue CPUID, HLT, RDMSR/WRMSR and
GetTdVmCallInfo via TDVMCALL.

CPUID
-----
For TDX, most CPUID leaf/sub-leaf combinations are virtualized by the TDX
module while some trigger #VE.  On #VE, TDX guest can issue a TDVMCALL with
the leaf Instruction.CPUID to request VMM to emulate CPUID operation.

HLT
---
TDX guest can issue a TDVMCALL with HLT, which passes the interrupt blocked
flag. Whether the interrupt is allowed or not is depending on the interrupt
blocked flag.  For NMI, KVM can't get the NMI blocked status of TDX guest,
it always assumes NMI is allowed.

MSRs
----
Some MSRs are virtualized by TDX module directly, while some MSRs will
trigger #VE when guest accesses them.  On #VE, TDX guests can issue a
TDVMCALL with WRMSR or RDMSR to request emulation in VMM.

Operations ignored
==================
TDX protects TDX guest state from VMM, and some features are not supported
by TDX guest, a bunch of operations are ignored for TDX guests, including:
accesses to CPU state, VMX preemption timer, accesses to TSC offset or 
multiplier, setup MCE for LMCE enable/disable, and hypercall patching.

Notable changes since v19 [8]
=========================
There are a several minor changes across the patches. A few more structural
changes are highlighted below.

MTRR MSR support is dropped
---------------------------
TDX forces the MTRR CPUID feature bit on when exposed to TDX guests, but
VMM/TDX module can't fully architecturally virtualize it. Changing the
setting of MTRR will trigger setting of CR0.CD to 1, which causes #VE in
TDX guest. 
Previously in v19, there is some incomplete support for MTRR MSRs
emulation in KVM because TDVF and Linux guest will still need to access some
MTRR MSRs, and it requires Linux guest kernel to boot with an additional
option "clearcpuid=mtrr" as a workaround to avoid triggering #VE.
After commit 3a3b12c [9] of edk2, TDVF will not use MTRR MSRs at all.
After commit 8e690b8 [10] of Linux kernel, Linux TDX guest will not use MTRR
MSRs at all.
So, MTRR MSR emulation in KVM for TDX guests has been dropped.
It will require TDVF built after commit 3a3b12c.
For Linux guest:
- If it is built before commit 8e690b8, "clearcpuid=mtrr" is needed as a
  workaround.
- If it is built after commit 8e690b8, "clearcpuid=mtrr" is not needed.

Detect unexpected SEPT violations due to pending SPTEs
------------------------------------------------------
This is new added.
A TDX guest can be configured not to receive #VE by setting SEPT_VE_DISABLE
to 1 in tdh_mng_init() or modifying pending_ve_disable to 1 in TDCS when
flexible_pending_ve is permitted.  If so, the TDX guest is supposed to
accept a private page before accessing it.  If such SEPT violation due to
pending SPTEs occurs, it is the TDX guest's fault, make the VM dead.

Repos
=====
The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-12-09-the-rest

A matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v6.1

Testing 
=======
It has been tested as part of the development branch for the TDX base
series. The testing consisted of TDX kvm-unit-tests and booting a Linux
TD, and TDX enhanced KVM selftests.

[0] https://lore.kernel.org/kvm/cover.1731318868.git.kai.huang@intel.com
[1] https://lore.kernel.org/kvm/cover.1730120881.git.kai.huang@intel.com
[2] https://lore.kernel.org/kvm/20241030190039.77971-1-rick.p.edgecombe@intel.com
[3] https://lore.kernel.org/kvm/20241112073327.21979-1-yan.y.zhao@intel.com
[4] https://lore.kernel.org/kvm/20241121201448.36170-1-adrian.hunter@intel.com
[5] https://lore.kernel.org/kvm/20241128004344.4072099-1-seanjc@google.com
[6] https://lore.kernel.org/kvm/20241201035358.2193078-1-binbin.wu@linux.intel.com
[7] https://lore.kernel.org/kvm/20241209010734.3543481-1-binbin.wu@linux.intel.com
[8] https://lore.kernel.org/kvm/cover.1708933498.git.isaku.yamahata@intel.com
[9] https://github.com/tianocore/edk2/commit/3a3b12cbdae2e89b0e365eb01c378891d0d9037c
[10] https://github.com/torvalds/linux/commit/8e690b817e38769dc2fa0e7473e5a5dc1fc25795

Isaku Yamahata (17):
  KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched
    behavior
  KVM: TDX: Handle EPT violation/misconfig exit
  KVM: TDX: Handle TDX PV CPUID hypercall
  KVM: TDX: Handle TDX PV HLT hypercall
  KVM: x86: Move KVM_MAX_MCE_BANKS to header file
  KVM: TDX: Implement callbacks for MSR operations
  KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
  KVM: TDX: Enable guest access to LMCE related MSRs
  KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
  KVM: TDX: Add methods to ignore accesses to CPU state
  KVM: TDX: Add method to ignore guest instruction emulation
  KVM: TDX: Add methods to ignore VMX preemption timer
  KVM: TDX: Add methods to ignore accesses to TSC
  KVM: TDX: Ignore setting up mce
  KVM: TDX: Add a method to ignore hypercall patching
  KVM: TDX: Make TDX VM type supported
  Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)

Yan Zhao (1):
  KVM: TDX: Detect unexpected SEPT violations due to pending SPTEs

 Documentation/virt/kvm/api.rst           |   9 +-
 Documentation/virt/kvm/x86/index.rst     |   1 +
 Documentation/virt/kvm/x86/intel-tdx.rst | 357 ++++++++++++++++++
 arch/x86/include/asm/kvm_host.h          |  11 +-
 arch/x86/include/asm/shared/tdx.h        |   1 +
 arch/x86/include/asm/vmx.h               |   2 +
 arch/x86/kvm/vmx/main.c                  | 453 +++++++++++++++++++++--
 arch/x86/kvm/vmx/posted_intr.c           |   3 +-
 arch/x86/kvm/vmx/tdx.c                   | 286 +++++++++++++-
 arch/x86/kvm/vmx/tdx.h                   |   6 +
 arch/x86/kvm/vmx/tdx_arch.h              |  13 +
 arch/x86/kvm/vmx/x86_ops.h               |  10 +
 arch/x86/kvm/x86.c                       |   5 +-
 arch/x86/kvm/x86.h                       |   2 +
 14 files changed, 1109 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/virt/kvm/x86/intel-tdx.rst

-- 
2.46.0


