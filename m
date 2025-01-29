Return-Path: <kvm+bounces-36826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A508AA21A90
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:59:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C12403A250A
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 09:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E081B041F;
	Wed, 29 Jan 2025 09:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nnI5pMAj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF271A9B27;
	Wed, 29 Jan 2025 09:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144777; cv=none; b=B5AROZ3AonrUN/L9SvA+vrsYWO5pvsos19NXcCrTOGwuESbd3XnGBkH6etyvCGGPb0Zn69utSofKy/XbTSp+4+5mWT2DiQJajN1mXsnZ0av3UMa7AKHqlErZf3WRo2tCoDjLGFn1KMs0vkH6ROHjo4YnuyY94SCGOFa/MISPNiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144777; c=relaxed/simple;
	bh=L3C9yPv0QWVZBDEitj5aX9sqBG78KcbSOAKlxpOfCgo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qZHDZ1zlj+Jnd75niC8ZOlUNOJmn/GwseQMcczgFQ5JmlUM74Ay3RUrqTqeGUc+spuC8EYlu+Izskg9ILDUfdtwwu5cTUXFy7b0LHAvFIX7LrAu1vkUdS2I6nT+8qm3uVlk2sBJp8dAStr0k07VNzp5ZWu5lh4zy2/mK8XgtcBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nnI5pMAj; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144775; x=1769680775;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L3C9yPv0QWVZBDEitj5aX9sqBG78KcbSOAKlxpOfCgo=;
  b=nnI5pMAjjuDIkdbNAquh4UoByuc2lvoMcaS+4Y8KxKnT5NZ947QOabbA
   1oYdfAMyVDnOUDpa5tH/oo7DRyHoJ3aP2rLSgtfHBNFMjmTrhAUj7RTlU
   JUYfPzFRxzhTY4vGCbwY14AZ/Bxg/AOcpMDqR7aJvbN+aFpX+LWpHP6/4
   u/7Dszrl8cZlQAjHdE0sMQCx7EIuQBo8epaCX1Q6tMT84OhB6VojgoIjm
   8lmKtQEFGu4Tw0aR85bjbWJuzHn9B5uZfuP3JbRVL/A4EjwO4wL3RzNTe
   ZzFRzNSRpbseoxXJRD9X9u5us9UmuPGwyT7PDswPFxqAdCGVsam0UcexH
   A==;
X-CSE-ConnectionGUID: 3P6YJHA/QmuZPkdaZ2fheQ==
X-CSE-MsgGUID: jZ8GqfMVREKIgSS50qZBGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50035911"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50035911"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:19 -0800
X-CSE-ConnectionGUID: GUTfD89PQDy2g4Iqgkhrzg==
X-CSE-MsgGUID: 1quDGBT7Sw2+DuOeNDZUrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262630"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:14 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH V2 00/12] KVM: TDX: TD vcpu enter/exit
Date: Wed, 29 Jan 2025 11:58:49 +0200
Message-ID: <20250129095902.16391-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi

Changes in V2:

  Note, in addition to addressing replies to version 1, there are changes
  suggested by Sean here:

    https://lore.kernel.org/r/Z1suNzg2Or743a7e@google.com

  Patches are re-based on kvm-coco-queue plus:

    latest TDX MMU Part 2 series
    latest TDX vCPU/VM creation series

  x86/virt/tdx: Make tdh_vp_enter() noinstr
  KVM: x86: Allow the use of kvm_load_host_xsave_state() with
            guest_state_protected
  KVM: TDX: Set arch.has_protected_state to true
  KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct
    New patches

  KVM: TDX: Implement TDX vcpu enter/exit path
    Move VCPU_TD_STATE_INITIALIZED check to tdx_vcpu_pre_run() (Xiaoyao)
    Check TD_STATE_RUNNABLE also in tdx_vcpu_pre_run() (Yan)
    Add back 'noinstr' for tdx_vcpu_enter_exit() (Sean)
    Add WARN_ON_ONCE if force_immediate_exit (Sean)
    Add vp_enter_args to vcpu_tdx to store the input/output arguments for
    tdh_vp_enter().
    Don't copy arguments to/from vcpu->arch.regs[] unconditionally. (Sean)

  KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
    Use 1 variable named 'guest_state_loaded' to track host state
    save/restore (Sean)
    Rebased due to moving guest_state_loaded/msr_host_kernel_gs_base
    to struct vcpu_vt.

  KVM: TDX: restore host xsave state when exit from the guest TD
    Drop PT and CET feature flags (Chao)
    Use cpu_feature_enabled() instead of static_cpu_has() (Chao)
    Restore PKRU only if the host value differs from defined
    exit value (Chao)
    Use defined masks to separate XFAM bits into XCR0/XSS (Adrian)
    Use existing kvm_load_host_xsave_state() in place of
    tdx_restore_host_xsave_state() by defining guest CR4, XCR0, XSS
    and PKRU (Sean)
    Do not enter if vital guest state is invalid (Adrian)

  KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o wrmsr
  KVM: TDX: restore user ret MSRs
    No changes

  KVM: TDX: Disable support for TSX and WAITPKG
  KVM: TDX: Save and restore IA32_DEBUGCTL
    New patches

  KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched behavior
    Moved from TDX "the rest" to "TD vcpu enter/exit"


This patch series introduces callbacks to facilitate the entry of a TD VCPU
and the corresponding save/restore of host state.

The "outstanding things still to do" from V1 are now all done.  Refer V1
cover letter:

  https://lore.kernel.org/20241121201448.36170-1-adrian.hunter@intel.com

So the patches are ready for hand off to Paolo.

Overview

A TD VCPU is entered via the SEAMCALL TDH.VP.ENTER. The TDX Module manages
the save/restore of guest state and, in conjunction with the SEAMCALL
interface, handles certain aspects of host state. However, there are
specific elements of the host state that require additional attention, as
detailed in the Intel TDX ABI documentation for TDH.VP.ENTER.

TDX is quite different from VMX in this regard.  For VMX, the host VMM is
heavily involved in restoring, managing and saving guest CPU state, whereas
for TDX this is handled by the TDX Module.  In that way, the TDX Module can
protect the confidentiality and integrity of TD CPU state.

The TDX Module does not save/restore all host CPU state because the host
VMM can do it more efficiently and selectively.  CPU state referred to
below is host CPU state.  Often values are already held in memory so no
explicit save is needed, and restoration may not be needed if the kernel
is not using a feature.

Key Details

Argument Passing: Similar to other SEAMCALLs, TDH.VP.ENTER passes
arguments through General Purpose Registers (GPRs). For the special case
of the TD guest invoking TDG.VP.VMCALL, nearly any GPR can be used,
as well as XMM0 to XMM15. Notably, RBP is not used, and Linux mandates the
TDX Module feature NO_RBP_MOD, which is enforced elsewhere. Additionally,
XMM registers are not required for the existing Guest Hypervisor
Communication Interface and are handled by existing KVM code should they be
modified by the guest.

Debug Register Handling: After TDH.VP.ENTER returns, registers DR0, DR1,
DR2, DR3, DR6, and DR7 are set to their architectural INIT values. Existing
KVM code already handles the restoration of host values as needed, refer
vcpu_enter_guest() which calls hw_breakpoint_restore().

MSR Restoration: Certain Model-Specific Registers (MSRs) need to be
restored post TDH.VP.ENTER. The Intel TDX ABI documentation provides a
detailed list in the msr_preservation.json file. Most MSRs do not require
restoration if the guest is not utilizing the corresponding feature. The
following features are currently assumed to be unsupported, and their MSRs
are not restored:
  PERFMON            (TD ATTRIBUTES[63])
  LBRs               (XFAM[15])
  User Interrupts    (XFAM[14])
  Intel PT           (XFAM[8])
  CET                (XFAM[11-12])

Remaining host MSR/Register Handling:

MSR IA32_XFD is already restored by KVM, refer to kvm_put_guest_fpu().
The TDX Module sets MSR IA32_XFD_ERR to its RESET value (0) which is
fine for the kernel.

MSR IA32_DEBUGCTL is addressed in patch "KVM: TDX: Save and restore
IA32_DEBUGCTL".

MSR IA32_UARCH_MISC_CTL is not utilized by the kernel, so it is fine if
the TDX Module sets it to it's RESET value.

MSR IA32_KERNEL_GS_BASE is addressed in patch "KVM: TDX: vcpu_run:
save/restore host state (host kernel gs)".

MSRs IA32_XSS and XCRO are handled in patch "KVM: TDX: restore host xsave
state when exiting from the guest TD".

MSRs IA32_STAR, IA32_LSTAR, IA32_FMASK, and IA32_TSC_AUX are handled in
patch "KVM: TDX: restore user ret MSRs".

MSR IA32_TSX_CTRL and MSR IA32_UMWAIT_CONTROL are addressed in patch
"KVM: TDX: Disable support for TSX and WAITPKG"

Protecting Host CPU State

These patches completely protect host CPU state.  The host CPU state
that can be affected is determined by the TD configuration, especially
XFAM, TD attributes and CPUID.

Should any vital guest information be found to conflict with TD
configuration, VCPU entry is blocked by checks in
tdx_guest_state_is_invalid().

Base

This series is based on kvm-coco-queue plus:

      latest TDX MMU Part 2 series
      latest TDX vCPU/VM creation series

Due to "KVM: VMX: Move common fields of struct", subsequent patches require
changes to use new struct vcpu_vt, refer to the full KVM branch below.

It requires TDX module 1.5.06.00.0744 [1], or later. This is due to removal
of the workarounds for the lack of the NO_RBP_MOD feature required by the
kernel. Now NO_RBP_MOD is enabled (in VM/vCPU creation patches), and this
particular version of the TDX module has a required NO_RBP_MOD related bug
fix.
A working edk2 commit is 95d8a1c ("UnitTestFrameworkPkg: Use TianoCore
mirror of subhook submodule").

Testing

The series has been tested as part of the development branch for the TDX
base series. The testing consisted of TDX kvm-unit-tests and booting a
Linux TD, and TDX enhanced KVM selftests.

The full KVM branch is here:

  https://github.com/intel/tdx/tree/tdx_kvm_dev-2025-01-28.2

Matching QEMU: TBD

[1] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06


Adrian Hunter (4):
      x86/virt/tdx: Make tdh_vp_enter() noinstr
      KVM: TDX: Set arch.has_protected_state to true
      KVM: TDX: Disable support for TSX and WAITPKG
      KVM: TDX: Save and restore IA32_DEBUGCTL

Binbin Wu (1):
      KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct

Chao Gao (1):
      KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o wrmsr

Isaku Yamahata (5):
      KVM: TDX: Implement TDX vcpu enter/exit path
      KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
      KVM: TDX: restore host xsave state when exit from the guest TD
      KVM: TDX: restore user ret MSRs
      KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched behavior

Sean Christopherson (1):
      KVM: x86: Allow the use of kvm_load_host_xsave_state() with guest_state_protected

 arch/x86/include/asm/kvm_host.h  |  12 +-
 arch/x86/kvm/svm/svm.c           |   7 +-
 arch/x86/kvm/vmx/common.h        |  68 +++++++++++
 arch/x86/kvm/vmx/main.c          |  48 +++++++-
 arch/x86/kvm/vmx/nested.c        |  10 +-
 arch/x86/kvm/vmx/posted_intr.c   |  18 +--
 arch/x86/kvm/vmx/tdx.c           | 258 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h           |  19 +--
 arch/x86/kvm/vmx/vmx.c           |  99 +++++++--------
 arch/x86/kvm/vmx/vmx.h           | 104 ++++++----------
 arch/x86/kvm/vmx/x86_ops.h       |  11 ++
 arch/x86/kvm/x86.c               |  46 +++++--
 arch/x86/virt/vmx/tdx/seamcall.S |   3 +
 arch/x86/virt/vmx/tdx/tdx.c      |   2 +-
 14 files changed, 535 insertions(+), 170 deletions(-)


Regards
Adrian

