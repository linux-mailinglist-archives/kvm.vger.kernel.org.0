Return-Path: <kvm+bounces-39439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9ABA470CF
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:19:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D31D416E53C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CCDB13AA31;
	Thu, 27 Feb 2025 01:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C19wVxQU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D3C482EB;
	Thu, 27 Feb 2025 01:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619134; cv=none; b=Nn1ZB/0hcvUZ9Az7wgCgoT6NTr6krsIOJD6uYDpfUk/3PF1r0hM5hzcjCSRz4WsM5E4+FXWQpDswppYxiEEfWvds6dWfRLpEVIQZfbgpARDM6zMPiy2MpO9b4D6PZX3ElQr28PR7LhrsQAsFTcvS4ShS2Qk8GXv0FgSdP9pZWcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619134; c=relaxed/simple;
	bh=BpzZmI2O2fbXdMpIbvZS+E9MGmSSlZxok3GGQxKhq7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBKDmtk8gt4O5TqOz+mRY/Sgns5FaPkNEX/UZ3CcZNsyPwiTgN0fE6oPdOS1l7wcWTxk2h/uov/NBVyygZxdAwHXRlHwjLVFs3yw2Gi3yPeQ0NTsFgYP0pWE+m3LDJKog8y9oYE1HMaJ0P0eqMKDSBVCK7uxbDOhF7Aw79hwq2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C19wVxQU; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619133; x=1772155133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BpzZmI2O2fbXdMpIbvZS+E9MGmSSlZxok3GGQxKhq7Y=;
  b=C19wVxQUB3KGuCCqCBJgiJ0qHfKYERcDZy/u0qWcLF4SmMw0snKkWb33
   yvLhvK1nqjvI9OMxKT2A5ySrUxpnPJmpqbrW9PbHtsujWv8Khy70Be7t0
   D2NL+RDdOHW3SJ1geqR8XV0N9lw97mytl4oHtwnMkb8VGlDZ6L2+IqkLG
   kVQCEN2aKPU9+c4l+HpwC8VVeB9tCTq+1IZHvP2M2YGEjTDaTo2GVFcAi
   T83Wg+MCRsba1ZuxEQqKMk89K5U0kDvU6Np+fPtuB22WyvJLvKArufEMo
   Aj9LgFFiHQ+3bI0beQMpWwETi+A9v2V/4jHCiT6sPi/VkQA5KCnsn928q
   w==;
X-CSE-ConnectionGUID: gyYyzBKNSQGYZ7T3pJydEw==
X-CSE-MsgGUID: Hxu4wBqnQwuOcavfmQn2VQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959586"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959586"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:18:53 -0800
X-CSE-ConnectionGUID: 23tYVhGLR96LIp8r/Rju0A==
X-CSE-MsgGUID: vHLmkKCoTUiHBeFZLSCwUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674832"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:18:49 -0800
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
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 01/20] KVM: TDX: Handle EPT violation/misconfig exit
Date: Thu, 27 Feb 2025 09:20:02 +0800
Message-ID: <20250227012021.1778144-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

For TDX, on EPT violation, call common __vmx_handle_ept_violation() to
trigger x86 MMU code; on EPT misconfiguration, bug the VM since it
shouldn't happen.

EPT violation due to instruction fetch should never be triggered from
shared memory in TDX guest.  If such EPT violation occurs, treat it as
broken hardware.

EPT misconfiguration shouldn't happen on neither shared nor secure EPT for
TDX guests.
- TDX module guarantees no EPT misconfiguration on secure EPT.  Per TDX
  module v1.5 spec section 9.4 "Secure EPT Induced TD Exits":
  "By design, since secure EPT is fully controlled by the TDX module, an
  EPT misconfiguration on a private GPA indicates a TDX module bug and is
  handled as a fatal error."
- For shared EPT, the MMIO caching optimization, which is the only case
  where current KVM configures EPT entries to generate EPT
  misconfiguration, is implemented in a different way for TDX guests.  KVM
  configures EPT entries to non-present value without suppressing #VE bit.
  It causes #VE in the TDX guest and the guest will call TDG.VP.VMCALL to
  request MMIO emulation.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
[binbin: rework changelog]
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- KVM_BUG_ON() and return -EIO for real EXIT_REASON_EPT_MISCONFIG. (Sean)
- Defer the handling for real EXIT_REASON_EPT_MISCONFIG until
  tdx_handle_exit() because tdx_to_vmx_exit_reason() is called by
  non-instrumentable code with interrupt disabled.
- Rebased after adding tdcall_to_vmx_exit_reason().

TDX "the rest" v1:
- Renamed from "KVM: TDX: Handle ept violation/misconfig exit" to
  "KVM: TDX: Handle EPT violation/misconfig exit" (Reinette)
- Removed WARN_ON_ONCE(1) in tdx_handle_ept_misconfig(). (Rick)
- Add comment above EPT_VIOLATION_ACC_INSTR check. (Chao)
  https://lore.kernel.org/lkml/Zgoz0sizgEZhnQ98@chao-email/
  https://lore.kernel.org/lkml/ZjiE+O9fct5zI4Sf@chao-email/
- Remove unnecessary define of TDX_SEPT_VIOLATION_EXIT_QUAL. (Sean)
- Replace pr_warn() and KVM_EXIT_EXCEPTION with KVM_BUG_ON(). (Sean)
- KVM_BUG_ON() for EPT misconfig. (Sean)
- Rework changelog.

v14 -> v15:
- use PFERR_GUEST_ENC_MASK to tell the fault is private
---
 arch/x86/kvm/vmx/tdx.c | 47 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f9eccee02a69..0e2c734070d6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -860,6 +860,12 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 			return EXIT_REASON_VMCALL;
 
 		return tdcall_to_vmx_exit_reason(vcpu);
+	case EXIT_REASON_EPT_MISCONFIG:
+		/*
+		 * Defer KVM_BUG_ON() until tdx_handle_exit() because this is in
+		 * non-instrumentable code with interrupts disabled.
+		 */
+		return -1u;
 	default:
 		break;
 	}
@@ -968,6 +974,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
 
+	if (unlikely(tdx->vp_enter_ret == EXIT_REASON_EPT_MISCONFIG))
+		return EXIT_FASTPATH_NONE;
+
 	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
 		return EXIT_FASTPATH_NONE;
 
@@ -1674,6 +1683,37 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode, trig_mode, vector);
 }
 
+static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qual;
+	gpa_t gpa = to_tdx(vcpu)->exit_gpa;
+
+	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
+		/*
+		 * Always treat SEPT violations as write faults.  Ignore the
+		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
+		 * TD private pages are always RWX in the SEPT tables,
+		 * i.e. they're always mapped writable.  Just as importantly,
+		 * treating SEPT violations as write faults is necessary to
+		 * avoid COW allocations, which will cause TDAUGPAGE failures
+		 * due to aliasing a single HPA to multiple GPAs.
+		 */
+		exit_qual = EPT_VIOLATION_ACC_WRITE;
+	} else {
+		exit_qual = vmx_get_exit_qual(vcpu);
+		/*
+		 * EPT violation due to instruction fetch should never be
+		 * triggered from shared memory in TDX guest.  If such EPT
+		 * violation occurs, treat it as broken hardware.
+		 */
+		if (KVM_BUG_ON(exit_qual & EPT_VIOLATION_ACC_INSTR, vcpu->kvm))
+			return -EIO;
+	}
+
+	trace_kvm_page_fault(vcpu, gpa, exit_qual);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
+}
+
 int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -1683,6 +1723,11 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	if (fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
+	if (unlikely(vp_enter_ret == EXIT_REASON_EPT_MISCONFIG)) {
+		KVM_BUG_ON(1, vcpu->kvm);
+		return -EIO;
+	}
+
 	/*
 	 * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
 	 * TDX_SEAMCALL_VMFAILINVALID.
@@ -1732,6 +1777,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_emulate_io(vcpu);
 	case EXIT_REASON_EPT_MISCONFIG:
 		return tdx_emulate_mmio(vcpu);
+	case EXIT_REASON_EPT_VIOLATION:
+		return tdx_handle_ept_violation(vcpu);
 	case EXIT_REASON_OTHER_SMI:
 		/*
 		 * Unlike VMX, SMI in SEAM non-root mode (i.e. when
-- 
2.46.0


