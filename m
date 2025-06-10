Return-Path: <kvm+bounces-48767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3158AD2BD8
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 04:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8231C3A87E8
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 02:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED1324291B;
	Tue, 10 Jun 2025 02:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BrCVKHVZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D243C23D2BA;
	Tue, 10 Jun 2025 02:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521614; cv=none; b=T3Uy0wGvoB9cRd3dTIyZlmJ5JkqIXLl79mc5zdEtAJvu/SI+NPjOr1NyDrRMeyR5TmyzVTvUvBZnXzYTWX/aCmpzW8q+7nKn6PPULUTfnuXFdEBLiYT70YGHe73nBrTUwA4t8xdE+m/nxsQShgH9v5QgndE9FcqvV8KQny0mHKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521614; c=relaxed/simple;
	bh=NVTsJwWcXFDFZ4Y85Wn3fSXU/hI/TUr9NDS1bsnh/4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uMhtTjl3ANavTZ8xnZ0E+Cif9swwSwKraA6Rc253Yuj3h7TGjZ6PmtZZ3hpuiceVQDdTeNf/P+GPyLfcCkfV9I8FLAjDveoBFAhmoAMV5jtubjKK7/cN3626boYtTCgbqtq9af1nRAo9Kjy+aI9w/GKw2cuYwEVK08OXIpiU0e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BrCVKHVZ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749521612; x=1781057612;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NVTsJwWcXFDFZ4Y85Wn3fSXU/hI/TUr9NDS1bsnh/4A=;
  b=BrCVKHVZBJ3Hcay93Dh03L7wVXYrCwzUKh7gia7XNrHVHWdh2InuQP7e
   EUk/f9z2P8rAt5qVzz/4td6CPFG8pb3wDt6VT4n6Pl9ttyeqFtYfmL0LT
   nVaIEEg3e0xZVu39ke/zJA2jFzRUZ3WeLatnttW+btPBjAqvs2hnFAb2g
   VDb/5Oco7N7JgwISyNe6XH+aXiUkop0mssFdOl5FPOjxzAx7UK3sbD9A7
   LmfJkjYF4a8dA6ESUIhdzc482L16TamQ/+/8Lfj5jadkSfLkoa6QHM7+L
   gH3wYq9B+UVG/vs5ST8zb1QK8gKWMYwZGV7Q459PrUpytrrB+cOEJX7YR
   w==;
X-CSE-ConnectionGUID: mR8C8rh4RRqrdRMElsNDOA==
X-CSE-MsgGUID: ynSL9UynTw+SAfGBy7EldA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="50841170"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="50841170"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:13:31 -0700
X-CSE-ConnectionGUID: 7GAzcJjtSvyxqEu/2rAAYQ==
X-CSE-MsgGUID: JeVmcStKTXmAnOwxIfnevA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147253707"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:13:26 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	mikko.ylinen@linux.intel.com,
	linux-kernel@vger.kernel.org,
	kirill.shutemov@intel.com,
	jiewen.yao@intel.com,
	binbin.wu@linux.intel.com
Subject: [RFC PATCH 0/4] TDX attestation support and GHCI fixup
Date: Tue, 10 Jun 2025 10:14:18 +0800
Message-ID: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patch set includes TDX attestation support patch from [0] and some
fixups according to the proposed GHCI spec changes below. Tag the patch set
as RFC since it's based on the proposed GHCI spec changes. However, the
proposal and the patch set are expected to be discussed/finalized. The
attestation support and the fixups are hoped to be merged during the 6.16
merge window as part of the initial TDX support.

Paolo once suggested to implement all the TDVMCALLs defined in the current
GHCI 1.5 spec [1]. However, since there is a proposal to fix the GHCI spec
issues, this patch set doesn't implement the support for Service
SetupEventNotifyInterrupt, Instruction.WBINVD and Instruction.PCONFIG since
these TDVMCALLs have no real users for now.

Notable changes since attestation v2 [0]
========================================
- Use TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED instead of
  TDVMCALL_STATUS_INVALID_OPERAND for unsupported TDVMCALLs.
- Document the definition of "The base GHCI TDVMCALLs".
- Forward GetTdVmCallInfo to userspace with the new exit reason
  KVM_EXIT_TDX_GET_TDVMCALL_INFO when leaf (r12) input is 1 to allow
  userspace to provide the information of TDVMCALLs supported in userspace.
- Move the check of userspace's opt-in of KVM exit on KVM_HC_MAP_GPA_RANGE
  to KVM_TDX_FINALIZE_VM, since MapGPA is one of the GHCI base TDVMCALLs
  according to the proposal below.
  This requires some changes to the TDX KVM selftests cases posted [2] to
  always opt-in KVM exit on KVM_HC_MAP_GPA_RANGE before
  KVM_TDX_FINALIZE_VM.
- Since there is no opt-in from userspace for GetTdVmCallInfo and GetQuote,
  userspace is required to handle the exit reasons
  KVM_EXIT_TDX_GET_TDVMCALL_INFO and KVM_EXIT_TDX_GET_QUOTE as the initial
  support for TDX. To simplify the implementation in userspace, userspace
  could return TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED for GetQuote.

GHCI Change Proposal
====================
Current TDX Guest Host communication Interface (GHCI) spec[3] implies that
VMM should only return success for TDG.VP.VMCALL<GetTdVmCallInfo> if *all*
TDVMCALLs defined in the GHCI spec are supported. The spec is ambiguous on
the following perspectives:
- The description "all TDG.VP.VMCALLs defined in this specification" is not
  forward-compatible since more and more TDVMCALLs will be added when the
  GHCI spec evolves.
- It actually doesn't cover how to handle if the guest calls an unsupported
  TDVMCALL.
  Historically, KVM has returned TDVMCALL_STATUS_INVALID_OPERAND for any
  unknown TDVMCALL, as a reasonable interpretation of the ambiguous spec.
  However, TDX guests can't distinguish the error is due to the TDVMCALL is
  not supported or an invalid input of the TDVMCALL.
Also, enforce VMMs to implement the TDVMCALLs without real users is an
unnecessary burden.

To address the issues, the following are the proposed GHCI spec changes:
- Define "the GHCI base TDVMCALLs", which are: <GetTdVmCallInfo>, <MapGPA>,
  <ReportFatalError>, <Instruction.CPUID>, <#VE.RequestMMIO>,
  <Instruction.HLT>, <Instruction.IO>, <Instruction.RDMSR> and
  <Instruction.WRMSR>.
- Limit the scope of the TDG.VP.VMCALL<GetTdVmCallInfo> with leaf (R12) set
  to 0 to the GHCI base VMCALLs, so that the meaning is clear and
  unambiguous.
- Extend the TDG.VP.VMCALL<GetTdVmCallInfo> with leaf (R12) set to 1 to
  allow TDX guests to query the supported TDVMCALLs beyond the GHCI base
  TDVMCALLs.
  Use R11 - R14 to return the supported TDVMCALLs, which are defined as
  * R11
    bit 0: <GetQuote>
    bit 1: <SetupEventNotifyInterrupt>
    bit 2: <Service>
    bit 3: <MigTD>
    Other bits of R11 are reserved and must be 0.
  * R12
    bit 0: <Instruction.WBINVD>
    bit 1: <Instruction.PCONFIG>
    Other bits of R12 are reserved and must be 0.
  * R13 and R14 are reserved and must be 0.
- Add TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED to the TDVMCALL status codes for
  the ones that beyond GHCI base TDVMCALLs to indicate the subfunction is
  not supported.
  For the back-compatibility analysis, please refer to the change log of
  "KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs".

Testing
=======
This series is based on kvm/next with the commit:
- '61374cc145f4' ("Merge tag 'kvmarm-fixes-6.16-1' of
  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD").

A matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/commits/binbinwu/GetTdVmCallInfo_fixup

It requires TDX module 1.5.06.00.0744 [4], or later.
A working edk2 commit is 95d8a1c ("UnitTestFrameworkPkg: Use TianoCore
mirror of subhook submodule").

This patch series passed the TDX kvm-unit-tests, booting a Linux TD, and
TDX enhanced KVM selftests. It also passed the TDX related test cases
defined in the LKVS test suite as described in:
https://github.com/intel/lkvs/blob/main/KVM/docs/lkvs_on_avocado.md

KVM selftests patches based on the latest TDX KVM selftests patch
series [2], were used to test the flows of GetQuote, GetTdVmCallInfo with
leaf 1, unsupported TDVMCALL, and some modifications were made because the
opt-in of KVM exit on KVM_HC_MAP_GPA_RANGE should be done before
KVM_TDX_FINALIZE_VM.

[0] https://lore.kernel.org/kvm/20250416055433.2980510-1-binbin.wu@linux.intel.com
[1] https://lore.kernel.org/kvm/5e7e8cb7-27b2-416d-9262-e585034327be@redhat.com
[2] https://lore.kernel.org/kvm/20250414214801.2693294-1-sagis@google.com
[3] https://cdrdv2.intel.com/v1/dl/getContent/726792
[4] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06

Binbin Wu (4):
  KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs
  KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
  KVM: TDX: Exit to userspace for GetTdVmCallInfo
  KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE when TD finalize

 Documentation/virt/kvm/api.rst           | 44 ++++++++++++
 Documentation/virt/kvm/x86/intel-tdx.rst | 12 ++++
 arch/x86/include/asm/shared/tdx.h        |  1 +
 arch/x86/kvm/vmx/tdx.c                   | 85 +++++++++++++++++++-----
 include/uapi/linux/kvm.h                 | 14 ++++
 5 files changed, 141 insertions(+), 15 deletions(-)


base-commit: 61374cc145f4a56377eaf87c7409a97ec7a34041
-- 
2.46.0


