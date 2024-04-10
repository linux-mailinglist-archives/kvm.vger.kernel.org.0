Return-Path: <kvm+bounces-14130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE7489FA0B
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEE7C1F25B64
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C34D16DEDC;
	Wed, 10 Apr 2024 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jf6TYLMY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2DD172766;
	Wed, 10 Apr 2024 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759753; cv=none; b=CFP7PlTG61FSPBXZK7D6FN/nU8BeMvj6wyvHSNbHksnCGejT0S0SFGphdsUgW2e6IB7zHWbI1uu/smxmf6LL2zxOlHBB/Ubdlbp9SjsT5J7vYJIgxQ2nrwEl774bgrJxpPoaJInTnr5VYjiJv/9rujpanUjoauukeZ3yjRLnKp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759753; c=relaxed/simple;
	bh=Kch3ontBrnhzONNS7yMK/xgJB/WrDka9r0jZ/w16MvY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BArdTW1TSxMXFWOrlAysVOyRDoutbpMecbEARSb6ZU1B6m3BgcRFLyRHAQp6rmxxnN0JaLcakZwFKkcUltH3Nw6S3Gtmlin2AT5WKkyD4P/fbGoQ5njzZYjClG9CYwLyqKpzFEF/coCPMJr/VnBeoZQ3kFdLf87fmLAf5TFCir0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jf6TYLMY; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759752; x=1744295752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kch3ontBrnhzONNS7yMK/xgJB/WrDka9r0jZ/w16MvY=;
  b=jf6TYLMYvgiPBz+wzU2tu9VG5BQz/7diGj2J9dUu8Y5P4CXB+590GmTz
   nJlL5CbaY0VHBiATcnVgkZuxcky8/3TEhjWbyMrvViJ1rfEoFACOI35Hv
   QIxpxGOa1cz62HMXpPNfsCnMYfN5VVQMZofgGgw6gSpscYM3B1Zd6TVc+
   9oGln6luyDSaTmad+B70VWHNva5HhHsL/JMMESsuTPZsrdx4E4GPeHA3u
   LRiH+GYT/KLmysK4JCq7iiaOlUgNJFvJNv0iMMIqzHUVUGNudbDoItKac
   n8LNLv1LTsnb04w2bm5AxJdhHtQeyBTzic4LI+YA0VCU7ksKn5gaKO0kR
   Q==;
X-CSE-ConnectionGUID: brHF9jBgRba/ng7x1x7yBg==
X-CSE-MsgGUID: uyyOIgVdQC+0mkNhWPDZ/g==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837840"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837840"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:51 -0700
X-CSE-ConnectionGUID: xyQJeQokRiWyj5uNFqeK2w==
X-CSE-MsgGUID: mTy2O/yiT6qtNIIGpZtJzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095538"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:47 -0700
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
Subject: [RFC PATCH v3 08/10] KVM: VMX: Advertise MITIGATION_CTRL support
Date: Wed, 10 Apr 2024 22:34:36 +0800
Message-Id: <20240410143446.797262-9-chao.gao@intel.com>
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

Advertise MITIGATION_CTRL support and emulate accesses to two associated
MSRs.

MITIGATION_CTRL is enumerated by bit 0 of MSR_VIRTUAL_ENUMERATION. If
supported, two virtual MSRs MSR_VIRTUAL_MITIGATION_ENUM(0x50000001) and
MSR_VIRTUAL_MITIGATION_CTRL(0x50000002) are available.

The guest can use the two MSRs to report software mitigation status.
According to this information, KVM can deploy some alternative
mitigations (e.g., hardware mitigations) for the guest if some software
mitigations are not effective on the host.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/vmx/vmx.c | 36 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h |  3 +++
 arch/x86/kvm/x86.c     |  3 +++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e3406971a8b7..8a080592aa54 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4289,6 +4289,8 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
 	case MSR_VIRTUAL_ENUMERATION:
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+	case MSR_VIRTUAL_MITIGATION_CTRL:
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		return false;
 	case MSR_IA32_SMBASE:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dcb06406fd09..cc260b14f8df 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1955,7 +1955,9 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 	return !(msr->data & ~valid_bits);
 }
 
-#define VIRTUAL_ENUMERATION_VALID_BITS	0ULL
+#define VIRTUAL_ENUMERATION_VALID_BITS	VIRT_ENUM_MITIGATION_CTRL_SUPPORT
+#define MITI_ENUM_VALID_BITS		0ULL
+#define MITI_CTRL_VALID_BITS		0ULL
 
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
@@ -1967,6 +1969,9 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 	case MSR_VIRTUAL_ENUMERATION:
 		msr->data = VIRTUAL_ENUMERATION_VALID_BITS;
 		return 0;
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+		msr->data = MITI_ENUM_VALID_BITS;
+		return 0;
 	default:
 		return KVM_MSR_RET_INVALID;
 	}
@@ -2124,6 +2129,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vmx->msr_virtual_enumeration;
 		break;
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+		if (!msr_info->host_initiated &&
+		    !(vmx->msr_virtual_enumeration & VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+			return 1;
+		msr_info->data = vmx->msr_virtual_mitigation_enum;
+		break;
+	case MSR_VIRTUAL_MITIGATION_CTRL:
+		if (!msr_info->host_initiated &&
+		    !(vmx->msr_virtual_enumeration & VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+			return 1;
+		msr_info->data = vmx->msr_virtual_mitigation_ctrl;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2476,7 +2493,23 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		vmx->msr_virtual_enumeration = data;
 		break;
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+		if (!msr_info->host_initiated)
+			return 1;
+		if (data & ~MITI_ENUM_VALID_BITS)
+			return 1;
+
+		vmx->msr_virtual_mitigation_enum = data;
+		break;
+	case MSR_VIRTUAL_MITIGATION_CTRL:
+		if (!msr_info->host_initiated &&
+		    !(vmx->msr_virtual_enumeration & VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+			return 1;
+		if (data & ~MITI_CTRL_VALID_BITS)
+			return 1;
 
+		vmx->msr_virtual_mitigation_ctrl = data;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_index);
@@ -4901,6 +4934,7 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	 */
 	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
 	vmx->pi_desc.sn = 1;
+	vmx->msr_virtual_mitigation_ctrl = 0;
 }
 
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0519cf6187ac..7be5dd5dde6c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -296,6 +296,9 @@ struct vcpu_vmx {
 
 	u64                   msr_virtual_enumeration;
 
+	u64                   msr_virtual_mitigation_enum;
+	u64                   msr_virtual_mitigation_ctrl;
+
 	u32		      msr_ia32_umwait_control;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4721b6fe7641..f55d26d7c79a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1565,6 +1565,8 @@ static const u32 emulated_msrs_all[] = {
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
 	MSR_VIRTUAL_ENUMERATION,
+	MSR_VIRTUAL_MITIGATION_ENUM,
+	MSR_VIRTUAL_MITIGATION_CTRL,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -1581,6 +1583,7 @@ static const u32 msr_based_features_all_except_vmx[] = {
 	MSR_IA32_ARCH_CAPABILITIES,
 	MSR_IA32_PERF_CAPABILITIES,
 	MSR_VIRTUAL_ENUMERATION,
+	MSR_VIRTUAL_MITIGATION_ENUM,
 };
 
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
-- 
2.39.3


