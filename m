Return-Path: <kvm+bounces-63492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E178C67BD9
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:36:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id BA9A32990F
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 06:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1BB2EACF2;
	Tue, 18 Nov 2025 06:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S9OpqpNH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCB52E973C
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 06:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763447765; cv=none; b=UDAhD3wsfE4rAGIbNqpDAHwhP1WOlpAsR82fnX25vv8/ThvwvS7bGg+MmvJ9pLLLGomH3ipifm/LjSu3znEarFCsjM/95M+zKK9OkICofQOSBB+JrnnBZwV1dpsEiwIhHQa6oXT1C/mSwCOMTXVawX1bRCm53LZhrUtxga5t2rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763447765; c=relaxed/simple;
	bh=3SBdBPQBRxL5z9Idz9iWiTCAiuxoH88bRpb2EOhC/tU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LCi7oJ50JLcU0rv0faqY2bKqIV21u5IDlZ8CHqZ7362yP1NzTNZCdLVA5xEPqVgkDpu8yUQd3KWrjhM6nJHGijDsqtK94T7iwsJ1zT/6ORmg4xVdkyHXBC/wGd1KQh78AdcnLG6dhtU5h4AlONTNWicFRN4+KPoPKOkMJFRzC0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S9OpqpNH; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763447764; x=1794983764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3SBdBPQBRxL5z9Idz9iWiTCAiuxoH88bRpb2EOhC/tU=;
  b=S9OpqpNHsVgh7lAWXZoEnfWwbV0j8fuqFwdykI8bimcdMIqpwbJ7MWyM
   K8T4o9yQKfaA9mXNN+sL8l1VEoqC0Vj/hxGW3Ew9uRSsbWBJJY5+1HzsV
   +V87yWlaWqaj7589f19DLiGnbMbdE45ubfuv8reCo829EjnSDBx3ZY2vG
   trdeD1NNQqHF1xnAY9/DymoRquSgNJtCLSDs76OEUv/dxcxfXtEGaxf7s
   6O/xJlXsLkeBksnc+saIvsuobZfRleo2NseYC+OAkrhffmgdJG+DMg/Pr
   5RWov3iR3Omj3OU9vi4HGZKtsgwiXR0wIo/uq3pmgEb7g8Gq/Jz/uk3UR
   A==;
X-CSE-ConnectionGUID: NJxZUxp/SzOdZVJ8bEJBBQ==
X-CSE-MsgGUID: ziLFUedjRZ2ggmQ5Ajl25w==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="82850942"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="82850942"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 22:36:04 -0800
X-CSE-ConnectionGUID: QKH0LtM+Q9K2rg0wDDzQzg==
X-CSE-MsgGUID: 2Dp6btboRKSwTvu5x3nGyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="189962637"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 17 Nov 2025 22:36:01 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 1/5] i386/cpu: Add APX EGPRs into xsave area
Date: Tue, 18 Nov 2025 14:58:13 +0800
Message-Id: <20251118065817.835017-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118065817.835017-1-zhao1.liu@intel.com>
References: <20251118065817.835017-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zide Chen <zide.chen@intel.com>

APX feature bit is in CPUID_7_1_EDX[21], and APX has EGPR component with
index 19 in xstate area, EGPR component has 16 64bit regs. Add EGRP
component into xstate area.

Note, APX re-uses the 128-byte XSAVE area that had been previously
allocated by MPX which has been deprecated on Intel processors, so check
whether APX and MPX are set at the same for Guest, if this case happens,
mask off them both to avoid conflict for xsave area.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 25 +++++++++++++++++++++++++
 target/i386/cpu.h | 17 +++++++++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 84adfaf99dc8..16bc4b18266c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2111,6 +2111,12 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
             { FEAT_7_0_EDX,         CPUID_7_0_EDX_AMX_TILE },
         },
     },
+    [XSTATE_APX_BIT] = {
+        .size = sizeof(XSaveAPX),
+        .features = {
+            { FEAT_7_1_EDX,         CPUID_7_1_EDX_APX },
+        },
+    },
 };
 
 uint32_t xsave_area_size(uint64_t mask, bool compacted)
@@ -9116,6 +9122,25 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
         env->features[FEAT_KVM] = 0;
     }
 
+    /*
+     * Since Intel MPX had been previously deprecated, APX re-purposes the
+     * 128-byte XSAVE area that had been previously allocated by MPX (state
+     * component indices 3 and 4, making up a 128-byte area located at an
+     * offset of 960 bytes into an un-compacted XSAVE buffer), as a single
+     * state component housing 128-bytes of storage for EGPRs (8-bytes * 16
+     * registers).
+     *
+     * Check the conflict between MPX and APX before initializing xsave
+     * components.
+     */
+    if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_MPX) &&
+        (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_APX)) {
+        mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_MPX,
+            "this feature is conflict with APX");
+        mark_unavailable_features(cpu, FEAT_7_1_EDX, CPUID_7_1_EDX_APX,
+            "this feature is conflict with MPX");
+    }
+
     x86_cpu_enable_xsave_components(cpu);
 
     /* CPUID[EAX=7,ECX=0].EBX always increased level automatically: */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d8bdf342f98d..bc7e16d6e6c1 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -604,6 +604,7 @@ typedef enum X86Seg {
 #define XSTATE_ARCH_LBR_BIT             15
 #define XSTATE_XTILE_CFG_BIT            17
 #define XSTATE_XTILE_DATA_BIT           18
+#define XSTATE_APX_BIT                  19
 
 #define XSTATE_FP_MASK                  (1ULL << XSTATE_FP_BIT)
 #define XSTATE_SSE_MASK                 (1ULL << XSTATE_SSE_BIT)
@@ -620,6 +621,7 @@ typedef enum X86Seg {
 #define XSTATE_ARCH_LBR_MASK            (1ULL << XSTATE_ARCH_LBR_BIT)
 #define XSTATE_XTILE_CFG_MASK           (1ULL << XSTATE_XTILE_CFG_BIT)
 #define XSTATE_XTILE_DATA_MASK          (1ULL << XSTATE_XTILE_DATA_BIT)
+#define XSTATE_APX_MASK                 (1ULL << XSTATE_APX_BIT)
 
 #define XSTATE_DYNAMIC_MASK             (XSTATE_XTILE_DATA_MASK)
 
@@ -639,7 +641,8 @@ typedef enum X86Seg {
                                  XSTATE_BNDCSR_MASK | XSTATE_OPMASK_MASK | \
                                  XSTATE_ZMM_Hi256_MASK | \
                                  XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK | \
-                                 XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK)
+                                 XSTATE_XTILE_CFG_MASK | \
+                                 XSTATE_XTILE_DATA_MASK | XSTATE_APX_MASK)
 
 /* CPUID feature bits available in XSS */
 #define CPUID_XSTATE_XSS_MASK   (XSTATE_ARCH_LBR_MASK | XSTATE_CET_U_MASK | \
@@ -1042,6 +1045,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_1_EDX_PREFETCHITI       (1U << 14)
 /* Support for Advanced Vector Extensions 10 */
 #define CPUID_7_1_EDX_AVX10             (1U << 19)
+/* Support for Advanced Performance Extensions  */
+#define CPUID_7_1_EDX_APX               (1U << 21)
 
 /* Indicate bit 7 of the IA32_SPEC_CTRL MSR is supported */
 #define CPUID_7_2_EDX_PSFD              (1U << 0)
@@ -1684,6 +1689,8 @@ typedef struct {
 
 #define ARCH_LBR_NR_ENTRIES 32
 
+#define EGPR_NUM  16
+
 /* CPU can't have 0xFFFFFFFF APIC ID, use that value to distinguish
  * that APIC ID hasn't been set yet
  */
@@ -1794,6 +1801,11 @@ typedef struct XSaveXTILEDATA {
     uint8_t xtiledata[8][1024];
 } XSaveXTILEDATA;
 
+/* Ext. save area 19: APX state */
+typedef struct XSaveAPX {
+    uint64_t egprs[EGPR_NUM];
+} XSaveAPX;
+
 QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDCSR) != 0x40);
@@ -1806,6 +1818,7 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveCETS) != 0x18);
 QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
+QEMU_BUILD_BUG_ON(sizeof(XSaveAPX) != 0x80);
 
 typedef struct ExtSaveArea {
     uint32_t offset, size;
@@ -1820,7 +1833,7 @@ typedef struct ExtSaveArea {
     const FeatureMask features[2];
 } ExtSaveArea;
 
-#define XSAVE_STATE_AREA_COUNT (XSTATE_XTILE_DATA_BIT + 1)
+#define XSAVE_STATE_AREA_COUNT (XSTATE_APX_BIT + 1)
 
 extern ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT];
 
-- 
2.34.1


