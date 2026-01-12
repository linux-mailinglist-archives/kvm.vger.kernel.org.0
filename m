Return-Path: <kvm+bounces-67867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E8FD3D15F69
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:21:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9C98D303076C
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE2423184A;
	Tue, 13 Jan 2026 00:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DX7+eDUh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267C2275AFB;
	Tue, 13 Jan 2026 00:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263528; cv=none; b=FXc2b6qrOwY82896ffLQj3tObJS6jOnImvOp0Ib7ipmq/14mv20zmPN6CfgRp4n83AhIx+Ha77vSFvimWBzm5nwtG0+wKKl91ZtjHOi8x17+uJpkcOdTpRnzujC0vlw21Wb2kVxmIAWvZclJGMZPIV0Mq511ZntboKnYWVPjW4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263528; c=relaxed/simple;
	bh=JpLi1y3bTBto11eIj/IZX9rGESLc5O0rTqB+8uIQlRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzuA3xbDj/21UiHBtfOB+c0AyzuIHff4RnRe+zslFBbFDCI+l7akCeEzQ8BigsPNrKtXyjR8Jv7/149iQb6Q6vgU2Kl/0bsuV2YPpfyOEKfi0+CTVnBeXTUQLVT356Owb5ii1sVKWDGYF9WCFEQeLJxNn60eGHOp18pN0P7uxQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DX7+eDUh; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263526; x=1799799526;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JpLi1y3bTBto11eIj/IZX9rGESLc5O0rTqB+8uIQlRo=;
  b=DX7+eDUhxNQe9TnQkKgo80RPD9TNQVjwEAV7/SZ3Dx2E8ychFo3eM10G
   EvDI/g0bYbhGC8/mfJqyBqq+barWez/0xiPmMM1CLAxPjZLWVJUeRYmfZ
   CE1TpOiL1m51tjh1d2YtL754C41kgxmsf3BDrBg9ddQy5fn9JhpqizFda
   1l5qLmNaYgB6phOBI5sFfdxPXZzaTYbITtm00CVismbd7quJaP1FDFiOa
   ZpxOU72AdvcIvFA9fRmByPW5FkpRUUxkHp4zwTBlnFlsUXQ0XFvxqkHrU
   RekGRS/3u1NdNfwFYsZWHD2buq2LNSEiVDIeNuTKx2oJa/jb3kn6i8n3S
   g==;
X-CSE-ConnectionGUID: 8ztpyKM2Syas+BaTA5buZg==
X-CSE-MsgGUID: kbQg/YxaS1CWqfMSsNAOeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264285"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264285"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:45 -0800
X-CSE-ConnectionGUID: GKYDSFwIR2SrnU51R4SxjQ==
X-CSE-MsgGUID: 3LJtUmXeQLiiz8/43KGgEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042307"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:46 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com,
	Peter Fang <peter.fang@intel.com>
Subject: [PATCH v2 14/16] KVM: x86: Expose APX foundational feature bit to guests
Date: Mon, 12 Jan 2026 23:54:06 +0000
Message-ID: <20260112235408.168200-15-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112235408.168200-1-chang.seok.bae@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peter Fang <peter.fang@intel.com>

Add the APX xfeature bit to the list of supported XCR0 components and
expose the APX feature to guests. Update the maximum supported CPUID leaf
to 0x29 to include the APX leaf. On SVM systems, ensure that the feature
is not advertised as EGPR support is not yet supported.

No APX sub-features are enumerated yet. Those will be exposed in a
separate patch.

Signed-off-by: Peter Fang <peter.fang@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
V1 -> V2: Exclude the APX CPUID definition as patch8 includes it now
---
 arch/x86/kvm/cpuid.c   | 8 +++++++-
 arch/x86/kvm/svm/svm.c | 8 ++++++++
 arch/x86/kvm/x86.c     | 3 ++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 88a5426674a1..5431e31a4851 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1038,6 +1038,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX_VNNI_INT16),
 		F(PREFETCHITI),
 		F(AVX10),
+		SCATTERED_F(APX),
 	);
 
 	kvm_cpu_cap_init(CPUID_7_2_EDX,
@@ -1401,7 +1402,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	switch (function) {
 	case 0:
 		/* Limited to the highest leaf implemented in KVM. */
-		entry->eax = min(entry->eax, 0x24U);
+		entry->eax = min(entry->eax, 0x29U);
 		break;
 	case 1:
 		cpuid_entry_override(entry, CPUID_1_EDX);
@@ -1646,6 +1647,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = 0;
 		break;
 	}
+	case 0x29: {
+		/* No APX sub-features are supported yet */
+		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		break;
+	}
 	case KVM_CPUID_SIGNATURE: {
 		const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
 		entry->eax = KVM_CPUID_FEATURES;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a06e5a24b808..9c76ea7a4231 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5284,6 +5284,14 @@ static __init void svm_set_cpu_caps(void)
 	 */
 	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
+
+	/*
+	 * If the APX xfeature bit is not supported, meaning that VMCB
+	 * support for EGPRs is unavailable, then the APX feature should
+	 * not be exposed to the guest.
+	 */
+	if (!(kvm_caps.supported_xcr0 & XFEATURE_MASK_APX))
+		kvm_cpu_cap_clear(X86_FEATURE_APX);
 }
 
 static __init int svm_hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 189a03483d03..67b3312ab737 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -214,7 +214,8 @@ static DEFINE_PER_CPU(struct kvm_user_return_msrs, user_return_msrs);
 #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
-				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
+				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE \
+				| XFEATURE_MASK_APX)
 
 #define XFEATURE_MASK_CET_ALL	(XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
 /*
-- 
2.51.0


