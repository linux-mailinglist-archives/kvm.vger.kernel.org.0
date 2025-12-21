Return-Path: <kvm+bounces-66456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 491A7CD3BE5
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70E66303C828
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AEB24728E;
	Sun, 21 Dec 2025 04:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="heWdaiOm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953AF22259F;
	Sun, 21 Dec 2025 04:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291516; cv=none; b=mFDly0CwXbnXHSLh0BV52aozECLISRDm5MG576RqBRuMnwN6KwNYcZIM7tVuqkRV6UwAbK2KcRW8L92RKBxPr+vVsQTEJhiPz6ltFotCvUDsecu+bdGBfFCrRwo1yRDMcmLF8yl8E+AEeGg0nEAZg1EbzQZJw7if+5vC503w7ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291516; c=relaxed/simple;
	bh=r2W+MiQjMRr3g0JWHIAQin0ANiKKEp73CXKO3uMG2X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrsYxEmTN6A4a8/ey7BP3VxnGqH9fB1qxaDeOIuSHOTgwb8rfokQgYCsr4Vv7Upym9w6c1PCDKyoEj8JBl0oJ3okx9nhbYAcSG0p0GjQx80Ljce2B10IyDeJ2udwkOu7FWpc7sAxSQf6s9TP0cxNar53rf+1M68GC6WaSkCb8zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=heWdaiOm; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291514; x=1797827514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r2W+MiQjMRr3g0JWHIAQin0ANiKKEp73CXKO3uMG2X0=;
  b=heWdaiOm/03/23B2/si571/p9LSXPfWdY4MBujporpxzSr0zVvnJB3ay
   C5Q/ykVJWjLSXNTkc0AoBM9aWKwCJv/pbhwO7ha7hHJZK8Oc2fYM0zP2S
   67rePUTSb9rTPzG9fkIoWP9i7PRghoHOH2Q6EW2zrAcTNSEkZWw+h8NQ5
   lshOTIyOIZ9MVO5qwYUmQajDCV6LQbnZjBipfAZ9QLfm6Injec+ArE8nF
   TZ0whuSsfWl8w2NKEwPG4LDby+vXF6XqT7oKPhCuReAu5Wa8Bnjujq2ps
   qGLpEsboWkKdVfjLTg5mHo8jETxpV97S1o8MUOI/Or7Bhr3Q6iJaDhvtc
   g==;
X-CSE-ConnectionGUID: yhLHzBrbRnuh+VivYDYYRg==
X-CSE-MsgGUID: waJNr1sDT+ehisT+h2sgPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132439"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132439"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:54 -0800
X-CSE-ConnectionGUID: AY+d8QEfT7i8POzcMjX2jA==
X-CSE-MsgGUID: ex1Grc/kTEmwFSoNk5gDeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229885052"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:54 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com,
	Peter Fang <peter.fang@intel.com>
Subject: [PATCH 14/16] KVM: x86: Expose APX foundational feature bit to guests
Date: Sun, 21 Dec 2025 04:07:40 +0000
Message-ID: <20251221040742.29749-15-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peter Fang <peter.fang@intel.com>

Add the APX xfeature bit to the list of supported XCR0 components and
expose the APX feature to guests. Define the APX CPUID feature bits and
update the maximum supported CPUID leaf to 0x29 to include the APX leaf.
On SVM systems, ensure that the feature is not advertised as EGPR support
is not yet supported.

No APX sub-features are enumerated yet. Those will be exposed in a
separate patch.

Signed-off-by: Peter Fang <peter.fang@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
No change since last version
---
 arch/x86/kvm/cpuid.c         | 8 +++++++-
 arch/x86/kvm/reverse_cpuid.h | 2 ++
 arch/x86/kvm/svm/svm.c       | 8 ++++++++
 arch/x86/kvm/x86.c           | 3 ++-
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d563a948318b..55b32784c392 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1031,6 +1031,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX_VNNI_INT16),
 		F(PREFETCHITI),
 		F(AVX10),
+		SCATTERED_F(APX),
 	);
 
 	kvm_cpu_cap_init(CPUID_7_2_EDX,
@@ -1394,7 +1395,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	switch (function) {
 	case 0:
 		/* Limited to the highest leaf implemented in KVM. */
-		entry->eax = min(entry->eax, 0x24U);
+		entry->eax = min(entry->eax, 0x29U);
 		break;
 	case 1:
 		cpuid_entry_override(entry, CPUID_1_EDX);
@@ -1639,6 +1640,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 81b4a7acf72e..e538b5444919 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -35,6 +35,7 @@
 #define X86_FEATURE_AVX_VNNI_INT16      KVM_X86_FEATURE(CPUID_7_1_EDX, 10)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 #define X86_FEATURE_AVX10               KVM_X86_FEATURE(CPUID_7_1_EDX, 19)
+#define KVM_X86_FEATURE_APX             KVM_X86_FEATURE(CPUID_7_1_EDX, 21)
 
 /* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
 #define X86_FEATURE_INTEL_PSFD		KVM_X86_FEATURE(CPUID_7_2_EDX, 0)
@@ -125,6 +126,7 @@ static __always_inline u32 __feature_translate(int x86_feature)
 	KVM_X86_TRANSLATE_FEATURE(SGX1);
 	KVM_X86_TRANSLATE_FEATURE(SGX2);
 	KVM_X86_TRANSLATE_FEATURE(SGX_EDECCSSA);
+	KVM_X86_TRANSLATE_FEATURE(APX);
 	KVM_X86_TRANSLATE_FEATURE(CONSTANT_TSC);
 	KVM_X86_TRANSLATE_FEATURE(PERFMON_V2);
 	KVM_X86_TRANSLATE_FEATURE(RRSBA_CTRL);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 85a150e763b2..afc99afa8dea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5282,6 +5282,14 @@ static __init void svm_set_cpu_caps(void)
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
index 0c677af83ee4..8b8a532c98eb 100644
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


