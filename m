Return-Path: <kvm+bounces-54472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF57B21AFF
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:56:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC7DA7A7018
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57B32DA74C;
	Tue, 12 Aug 2025 02:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="avOISrDp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459A113D8A4;
	Tue, 12 Aug 2025 02:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967382; cv=none; b=KTUAOM80Huq8/VTIRzlbWHpH1iBPar0Rl+r6AW8cvlmVI/4pg6dQ7yoeujgZH/n5y77FJju2bSQ412UXTrvJq03RQytEaEy5S8rhO4OTxnbkuHSZBu9l8DlcfjYR7tRyVJBzdLVgGB1MJfVHVGS5fOl3PIJYP1NIi9sKC9kb494=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967382; c=relaxed/simple;
	bh=Ko3AjVpWTBy2eVUwDGzR71/wCb7ro5IS8O7k67DJkaI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RAAo1fVE+3Uzi5iQTDPq1Muu8QEZwK9bFodZaVDcfvvOKQvQ10G3FaZ/i/Q8L2w+VqR/MIOruUZGim9qm+JJ1hphslMh/1T0ofat3ZV3bHV9AckSrTP5IMpk400rvRi8EKFAx2RDnFTrEEcu1f7SxNyn/lhCTmg2SkkTtIXmHIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=avOISrDp; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967380; x=1786503380;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ko3AjVpWTBy2eVUwDGzR71/wCb7ro5IS8O7k67DJkaI=;
  b=avOISrDpIfpSp4hBMblp7W9SzSFXRt97yGdSIUJKj8vgaHYsZfLHTV5J
   u8DaTwgrsf3Hm1rT34tjUiUFpyfEsgUmUNIaJiTrdkmJ+4WsXDIbF+5rS
   w0G27+Z7u2/9kk91HCwVX7flpbY4uFOR24GEbh7/wsD8d86nG3/mSpeRx
   JMhYFzbTFT6VjlktOjbSZmVLLHOF0XOA7zzCIRcIcI8wxVN0Itm3UFRGE
   cmStVc/AV30GRiAYuIvAHWZ6O/WV8vot87kIrcXp/4A+FC/141PWbw5Ad
   MhW8PMeJlSm1wQYBucsEHBMJYmVMdvQ3K6SfNtjjgTTv9OE56usQtGO3y
   w==;
X-CSE-ConnectionGUID: l5KQ7wiyTE6KwBa1dLYIyQ==
X-CSE-MsgGUID: v/GLx8tPR66B8NOJC5UaFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100417"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100417"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:19 -0700
X-CSE-ConnectionGUID: 57ivHpJVTwW4i8roMMMqDQ==
X-CSE-MsgGUID: ESiHzduhQFiMTCvrx2CgxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321195"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:18 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	x86@kernel.org
Subject: [PATCH v12 00/24] Enable CET Virtualization
Date: Mon, 11 Aug 2025 19:55:08 -0700
Message-ID: <20250812025606.74625-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The FPU support for CET virtualization has already been merged into 6.17-rc1.
Building on that, this series introduces Intel CET virtualization support for
KVM.

Changes in v12:
1. collect Tested-by tags from John and Mathias.
2. use less verbose names for KVM rdmsr/wrmsr emulation APIs in patch 1/2
   (Sean/Xin)
3. refer to s_cet, ssp, and ssp_table in a consistent order in patch 22
   (Xin)

Please note that I didn't include Mathias' patch, which makes CR4.CET
guest-owned. I expect that patch to be posted separately.

---
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

CET states management
=====================
KVM cooperates with host kernel FPU framework to manage guest CET registers.
With CET supervisor mode state support in this series, KVM can save/restore
full guest CET xsave-managed states.

CET user mode and supervisor mode xstates, i.e., MSR_IA32_{U_CET,PL3_SSP}
and MSR_IA32_PL{0,1,2}, depend on host FPU framework to swap guest and host
xstates. On VM-Exit, guest CET xstates are saved to guest fpu area and host
CET xstates are loaded from task/thread context before vCPU returns to
userspace, vice-versa on VM-Entry. See details in kvm_{load,put}_guest_fpu().

CET supervisor mode states are grouped into two categories : XSAVE-managed
and non-XSAVE-managed, the former includes MSR_IA32_PL{0,1,2}_SSP and are
controlled by CET supervisor mode bit(S_CET bit) in XSS, the later consists
of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL.

VMX introduces new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, to
facilitate guest/host non-XSAVES-managed states. When VMX CET entry/exit load
bits are set, guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are loaded from
equivalent fields at VM-Exit/Entry. With these new fields, such supervisor
states require no addtional KVM save/reload actions.

Tests
======
This series has successfully passed the basic CET user shadow stack test
and kernel IBT test in both L1 and L2 guests. The newly added
KVM-unit-tests [2] also passed, and its v11 has been tested with the AMD
CET series by John [3].

For your convenience, you can use my WIP QEMU [1] for testing.

[1]: https://github.com/gaochaointel/qemu-dev qemu-cet
[2]: https://lore.kernel.org/kvm/20250626073459.12990-1-minipli@grsecurity.net/
[3]: https://lore.kernel.org/kvm/aH6CH+x5mCDrvtoz@AUSJOHALLEN.amd.com/

Chao Gao (3):
  KVM: x86: Zero XSTATE components on INIT by iterating over supported
    features
  KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
  KVM: nVMX: Add consistency checks for CET states

Sean Christopherson (4):
  KVM: x86: Use double-underscore read/write MSR helpers as appropriate
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
 arch/x86/kvm/vmx/nested.c       | 175 +++++++++++++++--
 arch/x86/kvm/vmx/nested.h       |   5 +
 arch/x86/kvm/vmx/vmcs12.c       |   6 +
 arch/x86/kvm/vmx/vmcs12.h       |  14 +-
 arch/x86/kvm/vmx/vmx.c          |  85 +++++++-
 arch/x86/kvm/vmx/vmx.h          |   9 +-
 arch/x86/kvm/x86.c              | 339 +++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.h              |  61 ++++++
 17 files changed, 732 insertions(+), 92 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.47.1


