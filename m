Return-Path: <kvm+bounces-65726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DFA3CB4E5E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:45:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E8C58300161B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AB14192B75;
	Thu, 11 Dec 2025 06:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kz7pC3YF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DFE29E101
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435537; cv=none; b=p0UapKh4osI+BejbViCVm5QX3fxMvDvZObDpdEC+wq9PEIVEzK1suUTiPjJ5X3E/luxOrxaOcMMeV5Spgs8pSffdTM9SsVLBSQ9ToFNm0NEGYW28Ax2uniyn/omgMqGGKQrPxIIhf9Ui2dLlzH5kdlq/WTanm12GQiKicFDeA3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435537; c=relaxed/simple;
	bh=SoPUW7s8m7Zbb2AHKcPy4PtSaPvg6j8vtL8RcooJABk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PNnEG7X4KHwRcetnLqqciqJFzLNAPWbQwWLZF6O0I7K/UNLPfkKa1gAY3HKsPa7Do1lQMoSAVO2IsFfMiEdmBELQSunDFs2zR5i4YWMPdOqz1mwWgFyXwsLjIsczKFNs6jSBQ3bSwWjh8uCq2qXbXQpzPg5SAW3ixVZ2/q1vXOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kz7pC3YF; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765435536; x=1796971536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SoPUW7s8m7Zbb2AHKcPy4PtSaPvg6j8vtL8RcooJABk=;
  b=kz7pC3YFB8X5XpMoF6W3Su/Ncmh2Yh0G+KcuoS3mFyivnFjhvhCZkfta
   nKKsNKyKBHQv3t/uPALG76OnoxGvc2GY8UMMp83FoJSVMrxF/XAi+crNM
   GMpsSQfxE1WRpzZVx4rsX+1Dq5TV9g1nzHJiiv9BtgXT9nYRf8eckbO/N
   cMfro5zp634ZLHb6Tvz1KkWxS7mjtlQvv6/aeT9i5W/1QfXQ3KP435Ldm
   XUmtUiVKu/3V58ExVTYNJB8bNkVz+4eVw949ltPaCI95Luw0omcjc3awM
   crWj8CDV+5mUZwSQHy4XW1KAL5PpMij2QyEJ78KuHTRsJ3BaFzYdn+HgZ
   w==;
X-CSE-ConnectionGUID: 9zSaRUIBT5WQzpE/7zdD0A==
X-CSE-MsgGUID: Ta/Qgd73TWmHUDNcP3GNnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67584496"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67584496"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 22:45:36 -0800
X-CSE-ConnectionGUID: Oid8Gc01TX6KT8JnEglytg==
X-CSE-MsgGUID: errF4pMnTDGXhTGpe7wuWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196495029"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 10 Dec 2025 22:45:32 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Fang <peter.fang@intel.com>
Subject: [PATCH v2 8/9] i386/cpu: Support APX CPUIDs
Date: Thu, 11 Dec 2025 15:09:41 +0800
Message-Id: <20251211070942.3612547-9-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211070942.3612547-1-zhao1.liu@intel.com>
References: <20251211070942.3612547-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

APX is enumerated by CPUID.(EAX=0x7, ECX=1).EDX[21]. And this feature
bit also indicates the existence of dedicated CPUID leaf 0x29, called
the Intel APX Advanced Performance Extensions Leaf.

This new CPUID leaf now is populated with enumerations for a select
set of Intel APX sub-features.

CPUID.(EAX=0x29, ECX=0)
 - EAX
   * Maximum Subleaf CPUID.(EAX=0x29, ECX=0).EAX[31:0] = 0
 - EBX
   * Reserved CPUID.(EAX=0x29, ECX=0).EBX[31:1] = 0
   * APX_NCI_NDD_NF CPUID.(EAX=0x29, ECX=0).EBX[0:0] = 1, which
     enumerates the presence of New Conditional Instructions (NCIs),
     explicit New Data Destination (NDD) controls, and explicit Flags
     Suppression (NF) controls for select sets of EVEX-encoded Intel
     APX instructions (present in EVEX map=4, and EVEX map=2 0x0F38).
 - ECX
   * Reserved CPUID.(EAX=0x29, ECX=0).ECX[31:0] = 0
 - EDX
   * Reserved CPUID.(EAX=0x29, ECX=0).EDX[31:0] = 0

Note, APX_NCI_NDD_NF is documented as always enabled for Intel
processors since APX spec (revision v7.0). Now any Intel processor
that enumerates support for APX_F (CPUID.(EAX=0x7, ECX=1).EDX[21])
will also enumerate support for APX_NCI_NDD_NF.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Co-developed-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
Co-developed-by: Peter Fang <peter.fang@intel.com>
Signed-off-by: Peter Fang <peter.fang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 40 +++++++++++++++++++++++++++++++++++++++-
 target/i386/cpu.h |  8 ++++++++
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 16bc4b18266c..9cc553a86442 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1036,6 +1036,7 @@ void x86_cpu_vendor_words2str(char *dst, uint32_t vendor1,
 #define TCG_SGX_12_0_EBX_FEATURES 0
 #define TCG_SGX_12_1_EAX_FEATURES 0
 #define TCG_24_0_EBX_FEATURES 0
+#define TCG_29_0_EBX_FEATURES 0
 
 #if defined CONFIG_USER_ONLY
 #define CPUID_8000_0008_EBX_KERNEL_FEATURES (CPUID_8000_0008_EBX_IBPB | \
@@ -1301,7 +1302,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "amx-complex", NULL, "avx-vnni-int16", NULL,
             NULL, NULL, "prefetchiti", NULL,
             NULL, NULL, NULL, "avx10",
-            NULL, NULL, NULL, NULL,
+            NULL, "apx", NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
         },
@@ -1345,6 +1346,25 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         },
         .tcg_features = TCG_24_0_EBX_FEATURES,
     },
+    [FEAT_29_0_EBX] = {
+        .type = CPUID_FEATURE_WORD,
+        .feat_names = {
+            "apx-nci-ndd-nf", NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+        },
+        .cpuid = {
+            .eax = 0x29,
+            .needs_ecx = true, .ecx = 0,
+            .reg = R_EBX,
+        },
+        .tcg_features = TCG_29_0_EBX_FEATURES,
+    },
     [FEAT_8000_0007_EDX] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
@@ -1996,6 +2016,10 @@ static FeatureDep feature_dependencies[] = {
         .from = { FEAT_7_1_EDX,             CPUID_7_1_EDX_AVX10 },
         .to = { FEAT_24_0_EBX,              ~0ull },
     },
+    {
+        .from = { FEAT_7_1_EDX,             CPUID_7_1_EDX_APX },
+        .to = { FEAT_29_0_EBX,              ~0ull },
+    },
 };
 
 typedef struct X86RegisterInfo32 {
@@ -8411,6 +8435,15 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
         break;
     }
+    case 0x29:
+        *eax = 0;
+        *ebx = 0;
+        *ecx = 0;
+        *edx = 0;
+        if ((env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_APX) && count == 0) {
+            *ebx = env->features[FEAT_29_0_EBX];
+        }
+        break;
     case 0x40000000:
         /*
          * CPUID code in kvm_arch_init_vcpu() ignores stuff
@@ -9190,6 +9223,11 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
             x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x24);
         }
 
+        /* Advanced Performance Extensions (APX) requires CPUID[0x29] */
+        if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_APX) {
+            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x29);
+        }
+
         /* SVM requires CPUID[0x8000000A] */
         if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM) {
             x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000000A);
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index edc18e4b3da8..08216b343afa 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -710,6 +710,7 @@ typedef enum FeatureWord {
     FEAT_7_1_EDX,       /* CPUID[EAX=7,ECX=1].EDX */
     FEAT_7_2_EDX,       /* CPUID[EAX=7,ECX=2].EDX */
     FEAT_24_0_EBX,      /* CPUID[EAX=0x24,ECX=0].EBX */
+    FEAT_29_0_EBX,      /* CPUID[EAX=0x29,ECX=0].EBX */
     FEATURE_WORDS,
 } FeatureWord;
 
@@ -1092,6 +1093,13 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
                                          CPUID_24_0_EBX_AVX10_256 | \
                                          CPUID_24_0_EBX_AVX10_512)
 
+/*
+ * New Conditional Instructions (NCIs), explicit New Data Destination (NDD)
+ * controls, and explicit Flags Suppression (NF) controls for select sets of
+ * EVEX-encoded Intel APX instructions
+ */
+#define CPUID_29_0_EBX_APX_NCI_NDD_NF         (1U << 0)
+
 /* RAS Features */
 #define CPUID_8000_0007_EBX_OVERFLOW_RECOV    (1U << 0)
 #define CPUID_8000_0007_EBX_SUCCOR      (1U << 1)
-- 
2.34.1


