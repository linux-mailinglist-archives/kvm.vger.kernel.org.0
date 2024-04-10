Return-Path: <kvm+bounces-14129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA3789FA07
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:37:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8DB71C21CEE
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18776171665;
	Wed, 10 Apr 2024 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lCGZxp2A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B20E171073;
	Wed, 10 Apr 2024 14:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759749; cv=none; b=Mi2SRbY8zYGWBl92ePSJcoemlpnwWbZO2N1rJXhvMBfNt7NnxtWj1ZpBMq1IjtPKZ/Zwe+5IQZMmY5ZC3GatdMEob8M8eCbKIToO57PtAkoV1SpFrh2SkwxGDJAQvOn1KgK6IajpF/10wxirMrw0W6HBghuc6Em3KuLirQScHMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759749; c=relaxed/simple;
	bh=cNmQuaykUjTgsyzqvPplWtqyCHJnkZzmlTH0JBz+nLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UsQ95Fc6cG57ZuxZUbZKnD8Mc+uu2StANFWhoW3cd+4mC1QvtvpsGmCZ72Zjv1m8h2DS3YDrX7WEWDCTu11gRk0YWlGC14zR6QPzz5i08A0EtFvZxul2nRUh+lrfoHF8BmMAx06HazotNk3p6tWVGUEYOHYdeSRx9AZ9VCToXYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lCGZxp2A; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759748; x=1744295748;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cNmQuaykUjTgsyzqvPplWtqyCHJnkZzmlTH0JBz+nLo=;
  b=lCGZxp2AyCz0akdj0i2R6xQOr1+EasjmpVgQtGSWVTbgI9aT9kQVGba/
   RKyl8PEun4nMFGBi3p6JjSPsSImtCMqVo+YEgG67sYV3hiZhO02hy78Tj
   WkwJYol35VYrua7PDvRg20jjR8VyPr9zuyVnYyJSjqs8Ck8IMPyycQNqz
   HOnVrZL1yaALl9mC3t3bYn+KmNUa+NQ0ZU1cHf3Lw/LED3HBOxnTNPojt
   YA/jbVYfBGFATakEungD8Qn1HR/b2iXRxRSwMCRM4QOgI/SCkZSfEN5mT
   EMlfm85zvu7NaRHT9l1dv6ceU5ychHgQbafL8OznQHpsFVN7DlA8ZTRxg
   Q==;
X-CSE-ConnectionGUID: czqyFYuYQMmRDR6Mj/DOvg==
X-CSE-MsgGUID: IenEcrmVQticxcAo6cSmYQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837825"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837825"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:47 -0700
X-CSE-ConnectionGUID: Tn8qKJ3gTMWjFjTSOLn5OQ==
X-CSE-MsgGUID: 6GtUDP+sTR+kGaglm+pz9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095520"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:43 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: daniel.sneddon@linux.intel.com,
	pawan.kumar.gupta@linux.intel.com,
	Zhang Chen <chen.zhang@intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH v3 07/10] KVM: x86: Advertise ARCH_CAP_VIRTUAL_ENUM support
Date: Wed, 10 Apr 2024 22:34:35 +0800
Message-Id: <20240410143446.797262-8-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240410143446.797262-1-chao.gao@intel.com>
References: <20240410143446.797262-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Chen <chen.zhang@intel.com>

Bit 63 of IA32_ARCH_CAPABILITIES MSR indicates availablility of the
VIRTUAL_ENUMERATION_MSR (index 0x50000000) which enumerates features
like e.g., mitigation enumeration that in turn is used for the guest to
report software mitigations it is using.

Advertise ARCH_CAP_VIRTUAL_ENUM support for VMX and emulate read/write
of the VIRTUAL_ENUMERATION_MSR. Now VIRTUAL_ENUMERATION_MSR is always 0.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  2 ++
 arch/x86/kvm/x86.c     | 16 +++++++++++++++-
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d1a9f9951635..e3406971a8b7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4288,6 +4288,7 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
+	case MSR_VIRTUAL_ENUMERATION:
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		return false;
 	case MSR_IA32_SMBASE:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cdfcc1290d82..dcb06406fd09 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1955,6 +1955,8 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 	return !(msr->data & ~valid_bits);
 }
 
+#define VIRTUAL_ENUMERATION_VALID_BITS	0ULL
+
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
@@ -1962,6 +1964,9 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 		if (!nested)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
+	case MSR_VIRTUAL_ENUMERATION:
+		msr->data = VIRTUAL_ENUMERATION_VALID_BITS;
+		return 0;
 	default:
 		return KVM_MSR_RET_INVALID;
 	}
@@ -2113,6 +2118,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
+	case MSR_VIRTUAL_ENUMERATION:
+		if (!msr_info->host_initiated &&
+		    !(vcpu->arch.arch_capabilities & ARCH_CAP_VIRTUAL_ENUM))
+			return 1;
+		msr_info->data = vmx->msr_virtual_enumeration;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2457,6 +2468,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
+	case MSR_VIRTUAL_ENUMERATION:
+		if (!msr_info->host_initiated)
+			return 1;
+		if (data & ~VIRTUAL_ENUMERATION_VALID_BITS)
+			return 1;
+
+		vmx->msr_virtual_enumeration = data;
+		break;
 
 	default:
 	find_uret_msr:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a4dfe538e5a8..0519cf6187ac 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -294,6 +294,8 @@ struct vcpu_vmx {
 	u64		      force_spec_ctrl_mask;
 	u64		      force_spec_ctrl_value;
 
+	u64                   msr_virtual_enumeration;
+
 	u32		      msr_ia32_umwait_control;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a59b5a93d0e..4721b6fe7641 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1564,6 +1564,7 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
+	MSR_VIRTUAL_ENUMERATION,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -1579,6 +1580,7 @@ static const u32 msr_based_features_all_except_vmx[] = {
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
 	MSR_IA32_PERF_CAPABILITIES,
+	MSR_VIRTUAL_ENUMERATION,
 };
 
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
@@ -1621,7 +1623,8 @@ static bool kvm_is_immutable_feature_msr(u32 msr)
 	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
 	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
 	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | ARCH_CAP_GDS_NO | \
-	 ARCH_CAP_RFDS_NO | ARCH_CAP_RFDS_CLEAR | ARCH_CAP_BHI_NO)
+	 ARCH_CAP_RFDS_NO | ARCH_CAP_RFDS_CLEAR | ARCH_CAP_BHI_NO | \
+	 ARCH_CAP_VIRTUAL_ENUM)
 
 static u64 kvm_get_arch_capabilities(void)
 {
@@ -1635,6 +1638,17 @@ static u64 kvm_get_arch_capabilities(void)
 	 */
 	data |= ARCH_CAP_PSCHANGE_MC_NO;
 
+	/*
+	 * Virtual enumeration is a paravirt feature. The only usage for now
+	 * is to bridge the gap caused by microarchitecture changes between
+	 * different Intel processors. And its usage is linked to "virtualize
+	 * IA32_SPEC_CTRL" which is a VMX feature. Whether AMD SVM can benefit
+	 * from the same usage and how to implement it is still unclear. Limit
+	 * virtual enumeration to VMX.
+	 */
+	if (static_call(kvm_x86_has_emulated_msr)(NULL, MSR_VIRTUAL_ENUMERATION))
+		data |= ARCH_CAP_VIRTUAL_ENUM;
+
 	/*
 	 * If we're doing cache flushes (either "always" or "cond")
 	 * we will do one whenever the guest does a vmlaunch/vmresume.
-- 
2.39.3


