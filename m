Return-Path: <kvm+bounces-51568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 235B6AF8CBB
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B88555A4CBD
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929E52877F9;
	Fri,  4 Jul 2025 08:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SdZcmBoL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF4528688D;
	Fri,  4 Jul 2025 08:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619038; cv=none; b=lN+73lbocWv3xGpN/t/32VxMO0AIzEBspuyy6TdXNk6MjNcFlZXoeEA9lhv5uh91P9Nn8tepc2rjSLCkVdNoMk3sVy+u6eG8oPK+xG/ImoGQLmmQ/5joziIQnPV2MGYsdNsBRIpINiOipYcg/B5jxInMjzluUhRyR1+oUxHFtBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619038; c=relaxed/simple;
	bh=A2wv0IZfdbxzU81ud5vuwnzI9si9a6zbVp0UNJnJUQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DE+wG6VyMl/+Vh8/q79/mfmkWqWN0ku4KuWzT8nhOJ1I7oM8xc4THulHLIRfh6l8c8vKb0gEzJXFLvrk+RjlhDY+2cVAuMl/uVsAeJRgbWkCpWaRfQPD+jjIJ2z6OJDTbJHXdwFMgPwap9hHYI+ns0T/636DcUIcr/NdqAXQtPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SdZcmBoL; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619037; x=1783155037;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=A2wv0IZfdbxzU81ud5vuwnzI9si9a6zbVp0UNJnJUQE=;
  b=SdZcmBoL8qLGArFvq0RFh0J3uJPxh3wVCtuoS4rKImUdlWPowFXM14r2
   qzOBqkXkhTcSvhnHHd34feiFcRYSc5iSWmq/OnU2dWbS0D7Bm5OZrLjha
   aArbpxY7MMyJExLL/TMPGvp3r2Ccv9kOuLibwx8ACaeTNGqK8Y8o3yEks
   2rNhCkKcXRSsRDX5PFxM9lJ+tYqIdVatXXCsgd5Xyz0X2ANYf/9UBq/VT
   plgQpvqUb0NeVbtUvUVBwVZgqBw7/qZ/xprgjInFdO62McIAGsBWLxMYf
   es6h1UIamYuRxEh2zFOJTDFsRDXLLwWAphGUlCq9lD8oM6QDS5dVToeyr
   w==;
X-CSE-ConnectionGUID: 3YtK3zI+QfuiPudA4bQj3g==
X-CSE-MsgGUID: H0QbiduGSJ6fkerunb7EXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391559"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391559"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:35 -0700
X-CSE-ConnectionGUID: OYriw+5qRbiQix6MwFS6HA==
X-CSE-MsgGUID: EobLxaQlQTiqWEXQdZ1nhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154721943"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:34 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v11 00/23] Enable CET Virtualization
Date: Fri,  4 Jul 2025 01:49:31 -0700
Message-ID: <20250704085027.182163-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The FPU support for CET virtualization has already been merged into the tip
tree. This v11 adds Intel CET virtualization in KVM and is based on
tip/master plus Sean's MSR cleanups. For your convenience, it is also
available at

  https://github.com/gaochaointel/linux-dev cet-v11

Changes in v11 (Most changes are suggested by Sean. Thanks!):
1. Rebased onto the latest tip tree + Sean's MSR cleanups
2. Made patch 1's shortlog informative and accurate
3. Slotted in two cleanup patches from Sean (patch 3/4)
4. Used KVM_GET/SET_ONE_REG ioctl for userspace to read/write SSP.
   still assigned a KVM-defined MSR index for SSP but the index isn't
   part of uAPI now.
5. Used KVM_MSR_RET_UNSUPPORTED to reject accesses to unsupported CET MSRs
6. Synthesized triple-fault when reading/writing SSP failed during
   entering into SMM or exiting from SMM
7. Removed an inappropriate "quirk" in v10 that advertised IBT to userspace
   when the hardware supports it but the host does not enable it.
8. Disabled IBT/SHSTK explicitly for SVM to avoid them being enabled on
   AMD CPU accidentally before AMD CET series lands. Because IBT/SHSTK are
   advertised in KVM x86 common code but only Intel support is added by
   this series.
9. Re-ordered "Don't emulate branch instructions" (patch 18) before
   advertising CET support to userspace.
10.Added consistency checks for CR4.CET and other CET MSRs during VM-entry
   (patches 22-23)

Control-flow Enforcement Technology (CET) is a kind of CPU feature used
to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP) attacks.
It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
style control-flow subversion attacks.

Shadow Stack (SHSTK):
  A shadow stack is a second stack used exclusively for control transfer
  operations. The shadow stack is separate from the data/normal stack and
  can be enabled individually in user and kernel mode. When shadow stack
  is enabled, CALL pushes the return address on both the data and shadow
  stack. RET pops the return address from both stacks and compares them.
  If the return addresses from the two stacks do not match, the processor
  generates a #CP.

Indirect Branch Tracking (IBT):
  IBT introduces new instruction(ENDBRANCH)to mark valid target addresses
  of indirect branches (CALL, JMP etc...). If an indirect branch is
  executed and the next instruction is _not_ an ENDBRANCH, the processor
  generates a #CP. These instruction behaves as a NOP on platforms that
  doesn't support CET.

CET states management:
======================
KVM cooperates with host kernel FPU framework to manage guest CET registers.
With CET supervisor mode state support in this series, KVM can save/restore
full guest CET xsave-managed states.

CET user mode and supervisor mode xstates, i.e., MSR_IA32_{U_CET,PL3_SSP}
and MSR_IA32_PL{0,1,2}, depend on host FPU framework to swap guest and host
xstates. On VM-Exit, guest CET xstates are saved to guest fpu area and host
CET xstates are loaded from task/thread context before vCPU returns to
userspace, vice-versa on VM-Entry. See details in kvm_{load,put}_guest_fpu().
So guest CET xstates management depends on CET xstate bits(U_CET/S_CET bit)
set in host XSS MSR.

CET supervisor mode states are grouped into two categories : XSAVE-managed
and non-XSAVE-managed, the former includes MSR_IA32_PL{0,1,2}_SSP and are
controlled by CET supervisor mode bit(S_CET bit) in XSS, the later consists
of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL.

VMX introduces new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, to
facilitate guest/host non-XSAVES-managed states. When VMX CET entry/exit load
bits are set, guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are loaded from
equivalent fields at VM-Exit/Entry. With these new fields, such supervisor
states require no addtional KVM save/reload actions.

Tests:
======================
This series passed basic CET user shadow stack test and kernel IBT test in L1
and L2 guest.
The patch series _has_ impact to existing vmx test cases in KVM-unit-tests,the
failures have been fixed here[1].
One new selftest app[2] is introduced for testing CET MSRs accessibilities.

Note, this series hasn't been tested on AMD platform yet.

To run user SHSTK test and kernel IBT test in guest, an CET capable platform
is required, e.g., Sapphire Rapids server, and follow below steps to build
the binaries:

1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.

2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
(>= 8.5.0).

3. Apply CET QEMU patches[3] before build mainline QEMU.

Check kernel selftest test_shadow_stack_64 output:
[INFO]  new_ssp = 7f8c82100ff8, *new_ssp = 7f8c82101001
[INFO]  changing ssp from 7f8c82900ff0 to 7f8c82100ff8
[INFO]  ssp is now 7f8c82101000
[OK]    Shadow stack pivot
[OK]    Shadow stack faults
[INFO]  Corrupting shadow stack
[INFO]  Generated shadow stack violation successfully
[OK]    Shadow stack violation test
[INFO]  Gup read -> shstk access success
[INFO]  Gup write -> shstk access success
[INFO]  Violation from normal write
[INFO]  Gup read -> write access success
[INFO]  Violation from normal write
[INFO]  Gup write -> write access success
[INFO]  Cow gup write -> write access success
[OK]    Shadow gup test
[INFO]  Violation from shstk access
[OK]    mprotect() test
[SKIP]  Userfaultfd unavailable.
[OK]    32 bit test

Chao Gao (3):
  KVM: x86: Zero XSTATE components on INIT by iterating over supported
    features
  KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
  KVM: nVMX: Add consistency checks for CET states

Sean Christopherson (3):
  KVM: x86: Manually clear MPX state only on INIT
  KVM: x86: Report XSS as to-be-saved if there are supported features
  KVM: x86: Load guest FPU state when access XSAVE-managed MSRs

Yang Weijiang (17):
  KVM: x86: Rename kvm_{g,s}et_msr()* to show that they emulate guest
    accesses
  KVM: x86: Add kvm_msr_{read,write}() helpers
  KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
  KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
  KVM: x86: Initialize kvm_caps.supported_xss
  KVM: x86: Add fault checks for guest CR4.CET setting
  KVM: x86: Report KVM supported CET MSRs as to-be-saved
  KVM: VMX: Introduce CET VMCS fields and control bits
  KVM: x86: Enable guest SSP read/write interface with new uAPIs
  KVM: VMX: Emulate read and write to CET MSRs
  KVM: x86: Save and reload SSP to/from SMRAM
  KVM: VMX: Set up interception for CET MSRs
  KVM: VMX: Set host constant supervisor states to VMCS fields
  KVM: x86: Don't emulate instructions guarded by CET
  KVM: x86: Enable CET virtualization for VMX and advertise to userspace
  KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1 event injection to L2
  KVM: nVMX: Enable CET support for nested guest

 arch/x86/include/asm/kvm_host.h |  16 +-
 arch/x86/include/asm/vmx.h      |   9 +
 arch/x86/include/uapi/asm/kvm.h |  13 ++
 arch/x86/kvm/cpuid.c            |  19 +-
 arch/x86/kvm/emulate.c          |  46 +++--
 arch/x86/kvm/smm.c              |  12 +-
 arch/x86/kvm/smm.h              |   2 +-
 arch/x86/kvm/svm/svm.c          |   4 +
 arch/x86/kvm/vmx/capabilities.h |   9 +
 arch/x86/kvm/vmx/nested.c       | 174 +++++++++++++++--
 arch/x86/kvm/vmx/nested.h       |   5 +
 arch/x86/kvm/vmx/vmcs12.c       |   6 +
 arch/x86/kvm/vmx/vmcs12.h       |  14 +-
 arch/x86/kvm/vmx/vmx.c          |  85 ++++++++-
 arch/x86/kvm/vmx/vmx.h          |   9 +-
 arch/x86/kvm/x86.c              | 326 ++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.h              |  61 ++++++
 17 files changed, 725 insertions(+), 85 deletions(-)

-- 
2.47.1


