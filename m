Return-Path: <kvm+bounces-39448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69665A470E0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:21:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57D5616F157
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091FC1A5BAB;
	Thu, 27 Feb 2025 01:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QnFIBP4I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0231A0730;
	Thu, 27 Feb 2025 01:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619164; cv=none; b=KFWF6irqNeGuhQplHUc42CtwWY21J7DjCmB1kZuqpUypapHNOfnKs5RPtqtRaQGnnsy1/EwAzT/+O5bLfIjUQq3MxI1M/SOJs1l7IaU8gPl9aqUCefERUnhyyKkAJCIQsbB2syewHNFdp646202LPaclYjEhg+fTLLYOp/PO1vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619164; c=relaxed/simple;
	bh=vMUAeJTPBCoxwqnHG1I/vI/AaVpM8hcMwkiv2EGrwSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cp6+OsNYHLS0OAgUHKFaPa70UJF4W8YO9jbwgr0AGQn8i6FVp2h2xKLyAslR4odfAh6cEj8pffSjgk/0vyHQc7uMM68HxnmG9L48sc8geTOrmkD/krfVGBU6aiXVdLS3y6HNi1OTp0DYrUFnPG2wszYbRGQ0G93/jqW8iTH2gzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QnFIBP4I; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619163; x=1772155163;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vMUAeJTPBCoxwqnHG1I/vI/AaVpM8hcMwkiv2EGrwSY=;
  b=QnFIBP4Iq5FUlxuVLLTm/6/JwdFIupoFs4jjiXS9HagofIAyUNe6Rt/V
   OQTICO81E8s04joeQFgLy3L/TGjPj/PTeAkNl/OPOzzS9UVXLH2KQpEPo
   o5C3i2mHDOg/H+ydDnKg5lbFx28y/VtkT2KIxwj/M92bIgrp0IZygj+qs
   OJhr9ruah5NI/gtcNMDmhhFfyfvmEs7ZMxC7SZlxAjysF4KKVBqoOL2Fm
   ta/PG8z9NRmE4bM2EnYTotMgxD4RNlIfxYnN4VTnPFLE7C69tGQKPOoIs
   AHJeUuBUpH9xhVjxSFhfjRF3CJJcJ2Fgw/gN+r2AjxAEQbPqKLHPdXrZI
   w==;
X-CSE-ConnectionGUID: VAQziL1gQmeyGhXFnEhQxw==
X-CSE-MsgGUID: 95E1klA2TVa93KWQ1YQdqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959629"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959629"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:22 -0800
X-CSE-ConnectionGUID: B9a286aRSqSCybPrJlJGOw==
X-CSE-MsgGUID: IBjaz6nsSIqmXyBFootrVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674903"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:18 -0800
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
Subject: [PATCH v2 10/20] KVM: TDX: Enable guest access to LMCE related MSRs
Date: Thu, 27 Feb 2025 09:20:11 +0800
Message-ID: <20250227012021.1778144-11-binbin.wu@linux.intel.com>
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

Allow TDX guest to configure LMCE (Local Machine Check Event) by handling
MSR IA32_FEAT_CTL and IA32_MCG_EXT_CTL.

MCE and MCA are advertised via cpuid based on the TDX module spec.  Guest
kernel can access IA32_FEAT_CTL to check whether LMCE is opted-in by the
platform or not.  If LMCE is opted-in by the platform, guest kernel can
access IA32_MCG_EXT_CTL to enable/disable LMCE.

Handle MSR IA32_FEAT_CTL and IA32_MCG_EXT_CTL for TDX guests to avoid
failure when a guest accesses them with TDG.VP.VMCALL<MSR> on #VE.  E.g.,
Linux guest will treat the failure as a #GP(0).

Userspace VMM may not opt-in LMCE by default, e.g., QEMU disables it by
default, "-cpu lmce=on" is needed in QEMU command line to opt-in it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: rework changelog]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- No Change.

TDX "the rest" v1:
- Renamed from "KVM: TDX: Handle MSR IA32_FEAT_CTL MSR and IA32_MCG_EXT_CTL"
  to "KVM: TDX: Enable guest access to LMCE related MSRs".
- Update changelog.
- Check reserved bits are not set when set MSR_IA32_MCG_EXT_CTL.
---
 arch/x86/kvm/vmx/tdx.c | 46 +++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 85ff6e040cf3..76764bf5ba29 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2039,6 +2039,7 @@ bool tdx_has_emulated_msr(u32 index)
 	case MSR_MISC_FEATURES_ENABLES:
 	case MSR_IA32_APICBASE:
 	case MSR_EFER:
+	case MSR_IA32_FEAT_CTL:
 	case MSR_IA32_MCG_CAP:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MCG_CTL:
@@ -2071,26 +2072,53 @@ bool tdx_has_emulated_msr(u32 index)
 
 static bool tdx_is_read_only_msr(u32 index)
 {
-	return  index == MSR_IA32_APICBASE || index == MSR_EFER;
+	return  index == MSR_IA32_APICBASE || index == MSR_EFER ||
+		index == MSR_IA32_FEAT_CTL;
 }
 
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
-	if (!tdx_has_emulated_msr(msr->index))
-		return 1;
+	switch (msr->index) {
+	case MSR_IA32_FEAT_CTL:
+		/*
+		 * MCE and MCA are advertised via cpuid. Guest kernel could
+		 * check if LMCE is enabled or not.
+		 */
+		msr->data = FEAT_CTL_LOCKED;
+		if (vcpu->arch.mcg_cap & MCG_LMCE_P)
+			msr->data |= FEAT_CTL_LMCE_ENABLED;
+		return 0;
+	case MSR_IA32_MCG_EXT_CTL:
+		if (!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P))
+			return 1;
+		msr->data = vcpu->arch.mcg_ext_ctl;
+		return 0;
+	default:
+		if (!tdx_has_emulated_msr(msr->index))
+			return 1;
 
-	return kvm_get_msr_common(vcpu, msr);
+		return kvm_get_msr_common(vcpu, msr);
+	}
 }
 
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
-	if (tdx_is_read_only_msr(msr->index))
-		return 1;
+	switch (msr->index) {
+	case MSR_IA32_MCG_EXT_CTL:
+		if ((!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P)) ||
+		    (msr->data & ~MCG_EXT_CTL_LMCE_EN))
+			return 1;
+		vcpu->arch.mcg_ext_ctl = msr->data;
+		return 0;
+	default:
+		if (tdx_is_read_only_msr(msr->index))
+			return 1;
 
-	if (!tdx_has_emulated_msr(msr->index))
-		return 1;
+		if (!tdx_has_emulated_msr(msr->index))
+			return 1;
 
-	return kvm_set_msr_common(vcpu, msr);
+		return kvm_set_msr_common(vcpu, msr);
+	}
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
-- 
2.46.0


