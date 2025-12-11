Return-Path: <kvm+bounces-65697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A37CB4CA1
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E1C1301FF7E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D45628CF56;
	Thu, 11 Dec 2025 05:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kaBwF71I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26C320F08D
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431819; cv=none; b=liRSRh4uBaKOxDs7Qa7xKdKxeJppFURmYEB/lVdsnyAeqspIXa9Z/dZjzQVr/+sF5nGtwfoysGQlXF7BJGuHCkozPNiQMvsHS0Xy/LqcTPvY6/NVI/Wrs7hcO3E+eTTSrWgUhy3ZlMi5LREwqD7iz3UD+us1Uf0bRNDiqGEA7Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431819; c=relaxed/simple;
	bh=PTGXrrw5EFr5RFekmd6pZ60Tp1rqIf+SCDaoLH0Fads=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YtIGyIc+5nhIiRg1H11ChkFurvvGv9uuPHF+gEucJW1wLGOnE8/OAvGSbSssRNAb60leqGTRsH10Igtk9TDx+kgvMrf9AdfMlvpWOqAvQkUhk62ahENswVNoQrL4gIm7N8MxIyRHFPnstngeJgyZEgpKeHvYOhESo8Ewt/pDR6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kaBwF71I; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431818; x=1796967818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PTGXrrw5EFr5RFekmd6pZ60Tp1rqIf+SCDaoLH0Fads=;
  b=kaBwF71IbsVZcQK8IRAftmYnFUCwtkQFhBuqZy93LZMw3ocEifGUHPZI
   vpwAWb5fspdXL5hZWCdoGn7ztQEQ8AXBKxNFcLEtD/JdmCLf0Z920Y/+k
   RYXRjUTcQjh/7Mzy0SkCsQKDsFpC6wCi3l9ZZxIpIKwf7Giihu/qzDVXe
   4twgbPjalYRGdR1uXRmwMGTcw4svjMumD8dePcYSdoPxAPCFNPAGAWr7S
   nPBy5pH2jT93S2gkrjWyCJi69wrcPzdfwyFq1BHYfVp+OD741Z3qe5P3c
   IioQYjqGtj2wRzC2rAiiQcnmK4ml+/Hyi0vHD3czFEF2TeEvA2mtgfFny
   g==;
X-CSE-ConnectionGUID: 7tjrDyIvQxSQYGU+QeuG3A==
X-CSE-MsgGUID: rNkwZ44PSYSZfsxlIhGPEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409830"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409830"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:43:37 -0800
X-CSE-ConnectionGUID: aVZtGk1PTIinO5yaJiDi9A==
X-CSE-MsgGUID: efhx1L+pQ3GPGp04WADedQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366017"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:33 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 04/22] i386/cpu: Make ExtSaveArea store an array of dependencies
Date: Thu, 11 Dec 2025 14:07:43 +0800
Message-Id: <20251211060801.3600039-5-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211060801.3600039-1-zhao1.liu@intel.com>
References: <20251211060801.3600039-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some XSAVE components depend on multiple features. For example, Opmask/
ZMM_Hi256/Hi16_ZMM depend on avx512f OR avx10, and for CET (which will
be supported later), cet_u/cet_s will depend on shstk OR ibt.

Although previously there's the special check for the dependencies of
AVX512F OR AVX10 on their respective XSAVE components (in
cpuid_has_xsave_feature()), to make the code more general and avoid
adding more special cases, make ExtSaveArea store a features array
instead of a single feature, so that it can describe multiple
dependencies.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Add a FIXME in x86_cpu_feature_name() as the note to improve
   the case with multiple dependencies.
---
 target/i386/cpu.c | 78 ++++++++++++++++++++++++++++++++++-------------
 target/i386/cpu.h |  9 +++++-
 2 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 34a4c2410d03..e495e6d9b21c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2020,53 +2020,77 @@ static const X86RegisterInfo32 x86_reg_info_32[CPU_NB_REGS32] = {
 ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     [XSTATE_FP_BIT] = {
         /* x87 FP state component is always enabled if XSAVE is supported */
-        .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
         .size = sizeof(X86LegacyXSaveArea) + sizeof(X86XSaveHeader),
+        .features = {
+            { FEAT_1_ECX,           CPUID_EXT_XSAVE },
+        },
     },
     [XSTATE_SSE_BIT] = {
         /* SSE state component is always enabled if XSAVE is supported */
-        .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
         .size = sizeof(X86LegacyXSaveArea) + sizeof(X86XSaveHeader),
+        .features = {
+            { FEAT_1_ECX,           CPUID_EXT_XSAVE },
+        },
     },
     [XSTATE_YMM_BIT] = {
-        .feature = FEAT_1_ECX, .bits = CPUID_EXT_AVX,
         .size = sizeof(XSaveAVX),
+        .features = {
+            { FEAT_1_ECX,           CPUID_EXT_AVX },
+        },
     },
     [XSTATE_BNDREGS_BIT] = {
-        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
         .size = sizeof(XSaveBNDREG),
+        .features = {
+            { FEAT_7_0_EBX,         CPUID_7_0_EBX_MPX },
+        },
     },
     [XSTATE_BNDCSR_BIT] = {
-        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
         .size = sizeof(XSaveBNDCSR),
+        .features = {
+            { FEAT_7_0_EBX,         CPUID_7_0_EBX_MPX },
+        },
     },
     [XSTATE_OPMASK_BIT] = {
-        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
         .size = sizeof(XSaveOpmask),
+        .features = {
+            { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+        },
     },
     [XSTATE_ZMM_Hi256_BIT] = {
-        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
         .size = sizeof(XSaveZMM_Hi256),
+        .features = {
+            { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+        },
     },
     [XSTATE_Hi16_ZMM_BIT] = {
-        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
         .size = sizeof(XSaveHi16_ZMM),
+        .features = {
+            { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+        },
     },
     [XSTATE_PKRU_BIT] = {
-        .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
         .size = sizeof(XSavePKRU),
+        .features = {
+            { FEAT_7_0_ECX,         CPUID_7_0_ECX_PKU },
+        },
     },
     [XSTATE_ARCH_LBR_BIT] = {
-        .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
         .size = sizeof(XSaveArchLBR),
+        .features = {
+            { FEAT_7_0_EDX,         CPUID_7_0_EDX_ARCH_LBR },
+        },
     },
     [XSTATE_XTILE_CFG_BIT] = {
-        .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
         .size = sizeof(XSaveXTILECFG),
+        .features = {
+            { FEAT_7_0_EDX,         CPUID_7_0_EDX_AMX_TILE },
+        },
     },
     [XSTATE_XTILE_DATA_BIT] = {
-        .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
         .size = sizeof(XSaveXTILEDATA),
+        .features = {
+            { FEAT_7_0_EDX,         CPUID_7_0_EDX_AMX_TILE },
+        },
     },
 };
 
@@ -7131,16 +7155,24 @@ static inline void feat2prop(char *s)
 static const char *x86_cpu_feature_name(FeatureWord w, int bitnr)
 {
     const char *name;
-    /* XSAVE components are automatically enabled by other features,
+    /*
+     * XSAVE components are automatically enabled by other features,
      * so return the original feature name instead
      */
     if (w == FEAT_XSAVE_XCR0_LO || w == FEAT_XSAVE_XCR0_HI) {
         int comp = (w == FEAT_XSAVE_XCR0_HI) ? bitnr + 32 : bitnr;
 
-        if (comp < ARRAY_SIZE(x86_ext_save_areas) &&
-            x86_ext_save_areas[comp].bits) {
-            w = x86_ext_save_areas[comp].feature;
-            bitnr = ctz32(x86_ext_save_areas[comp].bits);
+        if (comp < ARRAY_SIZE(x86_ext_save_areas)) {
+            /*
+             * Present the first feature as the default.
+             * FIXME: select and present the one which is actually enabled
+             * among multiple dependencies.
+             */
+            const FeatureMask *fm = &x86_ext_save_areas[comp].features[0];
+            if (fm->mask) {
+                w = fm->index;
+                bitnr = ctz32(fm->mask);
+            }
         }
     }
 
@@ -8610,11 +8642,15 @@ static bool cpuid_has_xsave_feature(CPUX86State *env, const ExtSaveArea *esa)
         return false;
     }
 
-    if (env->features[esa->feature] & esa->bits) {
-        return true;
+    for (int i = 0; i < ARRAY_SIZE(esa->features); i++) {
+        if (env->features[esa->features[i].index] & esa->features[i].mask) {
+            return true;
+        }
     }
-    if (esa->feature == FEAT_7_0_EBX && esa->bits == CPUID_7_0_EBX_AVX512F
-        && (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10)) {
+
+    if (esa->features[0].index == FEAT_7_0_EBX &&
+        esa->features[0].mask == CPUID_7_0_EBX_AVX512F &&
+        (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10)) {
         return true;
     }
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index a183394eca7f..3d74afc5a8e7 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1769,9 +1769,16 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
 
 typedef struct ExtSaveArea {
-    uint32_t feature, bits;
     uint32_t offset, size;
     uint32_t ecx;
+    /*
+     * The dependencies in the array work as OR relationships, which
+     * means having just one of those features is enough.
+     *
+     * At most two features are sharing the same xsave area.
+     * Number of features can be adjusted if necessary.
+     */
+    const FeatureMask features[2];
 } ExtSaveArea;
 
 #define XSAVE_STATE_AREA_COUNT (XSTATE_XTILE_DATA_BIT + 1)
-- 
2.34.1


