Return-Path: <kvm+bounces-33352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E88D09EA3C8
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:48:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E158F167075
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C636143736;
	Tue, 10 Dec 2024 00:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="InL111gK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA155130E27;
	Tue, 10 Dec 2024 00:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791681; cv=none; b=JDr5u/btpECDKB6oERg62kD6qH2lqQMFSNw98oEERkj9Lw8nF9O7tZ1u8lJ47QXQpmEv9LnyoVHY5Mki59L5OOJ+vvLKQzq7schusViWBO0qOAUeZbjLH2qdRLXYfwar4APYawzk8gVOOjSdvc6Uy4IV3ggpuUORnCgsdp2owiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791681; c=relaxed/simple;
	bh=PPv9bUtXMfcaRh4a+/udp92Rcvcy+pazYoHCs/v8+OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEtzXqZNrK77ECPjEk8XV4/OQv+rM6EHV9RetSKHsHjfTyt5FEf1iRk6usedfXBOUQCJ+ahPrRZaHumcMacMbvwv6GD0M6qgRoz0v2ErrAjbQTYgMFXtKtfZH/k4i9IuO4HKmXnDQSUtUF4wqx/YUtBxWWdzHQPtFSJX7HKHcqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=InL111gK; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791680; x=1765327680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PPv9bUtXMfcaRh4a+/udp92Rcvcy+pazYoHCs/v8+OA=;
  b=InL111gKiCJRRvQkndWjD37xHnQlJfl6TMzOyrH+1pVncKDPiJI5NZBa
   lhiJrBiFgT0y7PZ5V2uKFfxik+qbntUadt7xKIsNa5WhT0tNxqEhzYPHW
   gnKIlyNxQf2LRm03oxNf34W2Z+OIhxXg1ACI3YQp4xoeEqHmhaDBnyDPV
   9eX7+/8p6UcomVzWPUzfsuhCUed89JWTMzsL+KS02LaI2/CPQggbbxuk3
   QyM/MjV5sZCUKc9UUZaA/CMkGO4d5ZsiOQZLs4Z+oQnkXPZdHxkrdsDZl
   fUmUYi8rdKtKVvrIGJdyIai/IF98ZxssJsq4ifIcGU42iCG77dgZaY70d
   w==;
X-CSE-ConnectionGUID: yZorrUv0SQyWR1mBdm3QZg==
X-CSE-MsgGUID: Ov2RD2kqTuSJqR26ZTdmqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793694"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793694"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:00 -0800
X-CSE-ConnectionGUID: nSr9tx8hTPS2+Gvc49WZqg==
X-CSE-MsgGUID: abC5L7DbSBCKtU7awHVS+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033017"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:47:56 -0800
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
Subject: [PATCH 03/18] KVM: TDX: Detect unexpected SEPT violations due to pending SPTEs
Date: Tue, 10 Dec 2024 08:49:29 +0800
Message-ID: <20241210004946.3718496-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
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
TDX "the rest" breakout:
- New patch
---
 arch/x86/include/asm/vmx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 20 +++++++++++++++++++-
 arch/x86/kvm/vmx/tdx_arch.h |  2 ++
 3 files changed, 23 insertions(+), 1 deletion(-)

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
index aecf52dda00d..96b05e445837 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1770,11 +1770,29 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
 
+static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcpu)
+{
+	u64 eeq_type = tdexit_ext_exit_qual(vcpu) & TDX_EXT_EXIT_QUAL_TYPE_MASK;
+	u64 eq = tdexit_exit_qual(vcpu);
+
+	if (eeq_type != TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION)
+		return false;
+
+	return !(eq & EPT_VIOLATION_RWX_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
+}
+
 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
+	gpa_t gpa = tdexit_gpa(vcpu);
 	unsigned long exit_qual;
 
-	if (vt_is_tdx_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
+	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
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
index 289728f1611f..2f9e88f497bc 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -104,6 +104,8 @@ struct tdx_cpuid_value {
 #define TDX_TD_ATTR_KL			BIT_ULL(31)
 #define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
 
+#define TDX_EXT_EXIT_QUAL_TYPE_MASK	GENMASK(3, 0)
+#define TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION  6
 /*
  * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
  */
-- 
2.46.0


