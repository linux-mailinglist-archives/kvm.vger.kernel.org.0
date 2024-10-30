Return-Path: <kvm+bounces-30091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AAB39B6CA3
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1DCE1F21BF2
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F5821A71D;
	Wed, 30 Oct 2024 19:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C0AgSYH/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20887219485;
	Wed, 30 Oct 2024 19:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314870; cv=none; b=oL/B201mPIN81HsdxYb0pe169F0ELxuHcuiIzax9A87iZxwkYFI1lRu/p1YvPI2jYxOqv07v+o/frPcZEwmc23tkLUo/O5BJLMCt91QXE2iG5IOHVhWvFYSGkiduFL2dQBDy8heFM+wUTYZ7mzTmF4VB/S4nJ17EyCnIcJ2hK4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314870; c=relaxed/simple;
	bh=ltoCTvaZo6xvLJEibxTPWANAwGnhjBVURGUrfWmgb/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feI0F6WQxQm9XsGFRc/7tcVpvG6PCQUYSo6KICsoma5V+CJylF7KGsW8pVs9H4NXe3UJ+dllRXBz8TLQ9kk2ycdAIbolQiulGgXvx+jZl8H8EvGlepCv33SliFvkKmBICkWjOGy0WmIuKInfhoTiR5cVx9WL47Isi8k3FCk/Glo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C0AgSYH/; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314868; x=1761850868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ltoCTvaZo6xvLJEibxTPWANAwGnhjBVURGUrfWmgb/Q=;
  b=C0AgSYH/gw75UDIVm3Q5CSiignhlkbuiKjWYpj3Y8oz+nq7ukGcTNgZb
   IVSWDGjcG9WPt8Ya7X4fQDbA7VDlg7E4YW1Sdf+XOQMtHRIYV1wG73yUg
   bWtcUFRsoUBcFVCFMECoAGUa+J9edTOiHItugUocbKQY3PD4kBiU5LUUa
   wASW8ID499j8LySLkX4zzFDBtN5JPTSo+apdU6Or3yJrhuzz+Z8pINpKc
   Uhiq5p8d3ovy+vWyKH6sCqrBuC5Pac2Y7X1RvhG4ZUSC6EgbFYdNz4jJK
   Ho4fgerXtZGHZdTdJP9POPhYk50xqvyGEqm3iUvNNsWLAd8H9seeWP1sv
   g==;
X-CSE-ConnectionGUID: Ro1y/o+TRWS62GQ98mzi+Q==
X-CSE-MsgGUID: Yf2C/cI1S5Sr3sajRHpfXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678780"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678780"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:01 -0700
X-CSE-ConnectionGUID: P29XC3duT0G8Znl/ysVwgw==
X-CSE-MsgGUID: E244EQLmTCiIOF4pRXz5yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499389"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:01 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 12/25] KVM: TDX: Define TDX architectural definitions
Date: Wed, 30 Oct 2024 12:00:25 -0700
Message-ID: <20241030190039.77971-13-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Define architectural definitions for KVM to issue the TDX SEAMCALLs.

Structures and values that are architecturally defined in the TDX module
specifications the chapter of ABI Reference.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
uAPI breakout v2:
 - Use TDX 1.5 naming of config_flags instead of exec_controls (Xiaoyao)

uAPI breakout v1:
 - Remove macros no longer needed due to reading metadata done in TDX
   host code:
   - Metadata field ID macros, bit definitions
   - TDX_MAX_NR_CPUID_CONFIGS
 - Drop unused defined (Kai)
 - Fix bisectability issues in headers (Kai)
 - Remove TDX_MAX_VCPUS define (Kai)
 - Remove unused TD_EXIT_OTHER_SMI_IS_MSMI define.
 - Move TDX vm type to separate patch
 - Move unions in tdx_arch.h to where they are introduced (Sean)

v19:
- drop tdvmcall constants by Xiaoyao

v18:
- Add metadata field id
---
 arch/x86/kvm/vmx/tdx.h      |   2 +
 arch/x86/kvm/vmx/tdx_arch.h | 158 ++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index e6a232d58e6a..1d6fa81a072d 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -1,6 +1,8 @@
 #ifndef  __KVM_X86_VMX_TDX_H
 #define __KVM_X86_VMX_TDX_H
 
+#include "tdx_arch.h"
+
 #ifdef CONFIG_INTEL_TDX_HOST
 void tdx_bringup(void);
 void tdx_cleanup(void);
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
new file mode 100644
index 000000000000..84af7666e958
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -0,0 +1,158 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* architectural constants/data definitions for TDX SEAMCALLs */
+
+#ifndef __KVM_X86_TDX_ARCH_H
+#define __KVM_X86_TDX_ARCH_H
+
+#include <linux/types.h>
+
+#define TDX_VERSION_SHIFT		16
+
+/*
+ * TDX SEAMCALL API function leaves
+ */
+#define TDH_VP_ENTER			0
+#define TDH_MNG_ADDCX			1
+#define TDH_MEM_PAGE_ADD		2
+#define TDH_MEM_SEPT_ADD		3
+#define TDH_VP_ADDCX			4
+#define TDH_MEM_PAGE_AUG		6
+#define TDH_MEM_RANGE_BLOCK		7
+#define TDH_MNG_KEY_CONFIG		8
+#define TDH_MNG_CREATE			9
+#define TDH_VP_CREATE			10
+#define TDH_MNG_RD			11
+#define TDH_MR_EXTEND			16
+#define TDH_MR_FINALIZE			17
+#define TDH_VP_FLUSH			18
+#define TDH_MNG_VPFLUSHDONE		19
+#define TDH_MNG_KEY_FREEID		20
+#define TDH_MNG_INIT			21
+#define TDH_VP_INIT			22
+#define TDH_VP_RD			26
+#define TDH_MNG_KEY_RECLAIMID		27
+#define TDH_PHYMEM_PAGE_RECLAIM		28
+#define TDH_MEM_PAGE_REMOVE		29
+#define TDH_MEM_SEPT_REMOVE		30
+#define TDH_SYS_RD			34
+#define TDH_MEM_TRACK			38
+#define TDH_MEM_RANGE_UNBLOCK		39
+#define TDH_PHYMEM_CACHE_WB		40
+#define TDH_PHYMEM_PAGE_WBINVD		41
+#define TDH_VP_WR			43
+
+/* TDX control structure (TDR/TDCS/TDVPS) field access codes */
+#define TDX_NON_ARCH			BIT_ULL(63)
+#define TDX_CLASS_SHIFT			56
+#define TDX_FIELD_MASK			GENMASK_ULL(31, 0)
+
+#define __BUILD_TDX_FIELD(non_arch, class, field)	\
+	(((non_arch) ? TDX_NON_ARCH : 0) |		\
+	 ((u64)(class) << TDX_CLASS_SHIFT) |		\
+	 ((u64)(field) & TDX_FIELD_MASK))
+
+#define BUILD_TDX_FIELD(class, field)			\
+	__BUILD_TDX_FIELD(false, (class), (field))
+
+#define BUILD_TDX_FIELD_NON_ARCH(class, field)		\
+	__BUILD_TDX_FIELD(true, (class), (field))
+
+
+/* Class code for TD */
+#define TD_CLASS_EXECUTION_CONTROLS	17ULL
+
+/* Class code for TDVPS */
+#define TDVPS_CLASS_VMCS		0ULL
+#define TDVPS_CLASS_GUEST_GPR		16ULL
+#define TDVPS_CLASS_OTHER_GUEST		17ULL
+#define TDVPS_CLASS_MANAGEMENT		32ULL
+
+enum tdx_tdcs_execution_control {
+	TD_TDCS_EXEC_TSC_OFFSET = 10,
+};
+
+/* @field is any of enum tdx_tdcs_execution_control */
+#define TDCS_EXEC(field)		BUILD_TDX_FIELD(TD_CLASS_EXECUTION_CONTROLS, (field))
+
+/* @field is the VMCS field encoding */
+#define TDVPS_VMCS(field)		BUILD_TDX_FIELD(TDVPS_CLASS_VMCS, (field))
+
+/* @field is any of enum tdx_guest_other_state */
+#define TDVPS_STATE(field)		BUILD_TDX_FIELD(TDVPS_CLASS_OTHER_GUEST, (field))
+#define TDVPS_STATE_NON_ARCH(field)	BUILD_TDX_FIELD_NON_ARCH(TDVPS_CLASS_OTHER_GUEST, (field))
+
+/* Management class fields */
+enum tdx_vcpu_guest_management {
+	TD_VCPU_PEND_NMI = 11,
+};
+
+/* @field is any of enum tdx_vcpu_guest_management */
+#define TDVPS_MANAGEMENT(field)		BUILD_TDX_FIELD(TDVPS_CLASS_MANAGEMENT, (field))
+
+#define TDX_EXTENDMR_CHUNKSIZE		256
+
+struct tdx_cpuid_value {
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+} __packed;
+
+#define TDX_TD_ATTR_DEBUG		BIT_ULL(0)
+#define TDX_TD_ATTR_SEPT_VE_DISABLE	BIT_ULL(28)
+#define TDX_TD_ATTR_PKS			BIT_ULL(30)
+#define TDX_TD_ATTR_KL			BIT_ULL(31)
+#define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
+
+/*
+ * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
+ */
+struct td_params {
+	u64 attributes;
+	u64 xfam;
+	u16 max_vcpus;
+	u8 reserved0[6];
+
+	u64 eptp_controls;
+	u64 config_flags;
+	u16 tsc_frequency;
+	u8  reserved1[38];
+
+	u64 mrconfigid[6];
+	u64 mrowner[6];
+	u64 mrownerconfig[6];
+	u64 reserved2[4];
+
+	union {
+		DECLARE_FLEX_ARRAY(struct tdx_cpuid_value, cpuid_values);
+		u8 reserved3[768];
+	};
+} __packed __aligned(1024);
+
+/*
+ * Guest uses MAX_PA for GPAW when set.
+ * 0: GPA.SHARED bit is GPA[47]
+ * 1: GPA.SHARED bit is GPA[51]
+ */
+#define TDX_CONFIG_FLAGS_MAX_GPAW      BIT_ULL(0)
+
+/*
+ * TDH.VP.ENTER, TDG.VP.VMCALL preserves RBP
+ * 0: RBP can be used for TDG.VP.VMCALL input. RBP is clobbered.
+ * 1: RBP can't be used for TDG.VP.VMCALL input. RBP is preserved.
+ */
+#define TDX_CONFIG_FLAGS_NO_RBP_MOD	BIT_ULL(2)
+
+
+/*
+ * TDX requires the frequency to be defined in units of 25MHz, which is the
+ * frequency of the core crystal clock on TDX-capable platforms, i.e. the TDX
+ * module can only program frequencies that are multiples of 25MHz.  The
+ * frequency must be between 100mhz and 10ghz (inclusive).
+ */
+#define TDX_TSC_KHZ_TO_25MHZ(tsc_in_khz)	((tsc_in_khz) / (25 * 1000))
+#define TDX_TSC_25MHZ_TO_KHZ(tsc_in_25mhz)	((tsc_in_25mhz) * (25 * 1000))
+#define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
+#define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
+
+#endif /* __KVM_X86_TDX_ARCH_H */
-- 
2.47.0


