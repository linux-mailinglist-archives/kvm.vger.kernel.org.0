Return-Path: <kvm+bounces-39440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3878FA470D1
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10F703B1088
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D4E14885D;
	Thu, 27 Feb 2025 01:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TZjIkrJo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A51B1459F7;
	Thu, 27 Feb 2025 01:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619137; cv=none; b=Kh9nqw+BWukursED1kl3pwEIpDj44MtRfnIXs/Z80TFz/tb3RoGqdePbgXkyEThZ8huypFz0uSAP8rHKteiCrac2+CVLuMBLynHBaHKNmGDUZH48V/2wZk8idwVHS812NN5BDZvOGY73g7GKeP2XbI93y1f5vv7T8l2EwjCWqlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619137; c=relaxed/simple;
	bh=rAInuVdG2jGTcBVvYvvjjkp1E50lnprsmHCpiiwqzNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7UWa4EM8yYvblA28iOCQin12OM6s1YwIShAcSrBnfsB7rc+FVjqn6HQ2XE2503T82TziHiHx1AmgFqGLc5FrTNACrVw8BDA5UBDTWxp/XgjzG12leCYj3G7uhXjuqdkuL3s9k6rlNyc4zZY+FcWjz5jm5Hp85bMxN8vLpKrdvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TZjIkrJo; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619136; x=1772155136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rAInuVdG2jGTcBVvYvvjjkp1E50lnprsmHCpiiwqzNY=;
  b=TZjIkrJoFEyBWLsZwZaX+hj57/IFXh3v2ZnFZe7+KSdPeSECqiCXbxQJ
   rdiyzbAWWxNmygfTtc1cyoTLEeEGqk5AumAL26ybO99LC2lWwN2OaUyOY
   j5Fv8W/C1kmaqopqFEdmEW6ifGZFFGnEucvyraDz2fB9wrhXpydaJ8rHk
   lhHpbRF88qB+VUBpQgHgFj7yn1eHfwm+Uv2uawCMD44NliUH3OIfNtk4P
   DG3CMMZF1+cxwFzanFXxCuaejo3qNiDamQoCzW16pEUf2i+oeu+dGtUHT
   8mXdbkGBxkE92IY5Zh5Ul1JkxZ91BU+Y7ZsAcCr0G7K4JvwLZrrJ37hAR
   w==;
X-CSE-ConnectionGUID: mOsAYCCtRZah4j1WUfyULQ==
X-CSE-MsgGUID: l6dyqi1UQQiHyizB0lVBLg==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959594"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959594"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:18:56 -0800
X-CSE-ConnectionGUID: JLHF8FKUTYe7njiIYsGvLw==
X-CSE-MsgGUID: kmUPc+EMRl6WFiBQdEKlXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674836"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:18:52 -0800
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
Subject: [PATCH v2 02/20] KVM: TDX: Detect unexpected SEPT violations due to pending SPTEs
Date: Thu, 27 Feb 2025 09:20:03 +0800
Message-ID: <20250227012021.1778144-3-binbin.wu@linux.intel.com>
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

From: Yan Zhao <yan.y.zhao@intel.com>

Detect SEPT violations that occur when an SEPT entry is in PENDING state
while the TD is configured not to receive #VE on SEPT violations.

A TD guest can be configured not to receive #VE by setting SEPT_VE_DISABLE
to 1 in tdh_mng_init() or modifying pending_ve_disable to 1 in TDCS when
flexible_pending_ve is permitted. In such cases, the TDX module will not
inject #VE into the TD upon encountering an EPT violation caused by an SEPT
entry in the PENDING state. Instead, TDX module will exit to VMM and set
extended exit qualification type to PENDING_EPT_VIOLATION and exit
qualification bit 6:3 to 0.

Since #VE will not be injected to such TDs, they are not able to be
notified to accept a GPA. TD accessing before accepting a private GPA
is regarded as an error within the guest.

Detect such guest error by inspecting the (extended) exit qualification
bits and make such VM dead.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- Rebased on getting exit_qualification, ext_exit_qualification.

TDX "the rest" v1:
- New patch
---
 arch/x86/include/asm/vmx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 17 +++++++++++++++++
 arch/x86/kvm/vmx/tdx_arch.h |  2 ++
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 9298fb9d4bb3..028f3b8db2af 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -585,12 +585,14 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_ACC_WRITE_BIT	1
 #define EPT_VIOLATION_ACC_INSTR_BIT	2
 #define EPT_VIOLATION_RWX_SHIFT		3
+#define EPT_VIOLATION_EXEC_R3_LIN_BIT	6
 #define EPT_VIOLATION_GVA_IS_VALID_BIT	7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
 #define EPT_VIOLATION_ACC_INSTR		(1 << EPT_VIOLATION_ACC_INSTR_BIT)
 #define EPT_VIOLATION_RWX_MASK		(VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
+#define EPT_VIOLATION_EXEC_FOR_RING3_LIN (1 << EPT_VIOLATION_EXEC_R3_LIN_BIT)
 #define EPT_VIOLATION_GVA_IS_VALID	(1 << EPT_VIOLATION_GVA_IS_VALID_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0e2c734070d6..b8701e343e80 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1683,12 +1683,29 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode, trig_mode, vector);
 }
 
+static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcpu)
+{
+	u64 eeq_type = to_tdx(vcpu)->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
+	u64 eq = vmx_get_exit_qual(vcpu);
+
+	if (eeq_type != TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION)
+		return false;
+
+	return !(eq & EPT_VIOLATION_RWX_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
+}
+
 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual;
 	gpa_t gpa = to_tdx(vcpu)->exit_gpa;
 
 	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
+		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
+			pr_warn("Guest access before accepting 0x%llx on vCPU %d\n",
+				gpa, vcpu->vcpu_id);
+			kvm_vm_dead(vcpu->kvm);
+			return -EIO;
+		}
 		/*
 		 * Always treat SEPT violations as write faults.  Ignore the
 		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index a8071409498f..fcbf0d4abc5f 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -69,6 +69,8 @@ struct tdx_cpuid_value {
 #define TDX_TD_ATTR_KL			BIT_ULL(31)
 #define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
 
+#define TDX_EXT_EXIT_QUAL_TYPE_MASK	GENMASK(3, 0)
+#define TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION  6
 /*
  * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
  */
-- 
2.46.0


