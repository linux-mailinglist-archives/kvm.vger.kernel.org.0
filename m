Return-Path: <kvm+bounces-65719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 43DBBCB4E55
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1E78E300AFCD
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D680529D270;
	Thu, 11 Dec 2025 06:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iAsnjaNX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC2B29C33D
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435513; cv=none; b=U0Uki6PjhKXTBpvKvhYdq93bkVIYADDhNVbU9H96uQdnEiNl3YT4pD9cA/Q7rD1y4XifhfLkW1ZDWsaJG6IuUnx5LwpkHRwHGueBB5eOM/zkGIgj0pkvN6/LvzFj10pCZXpvIaTuvWjvV7AeQUDVw7IQ3MBI9vSFIM2qizKRs38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435513; c=relaxed/simple;
	bh=E4QXRd1fRQK9Y99cANUkpLFWWjCvi6B67GlqLu3xDec=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JyxQZO/zGL1089vXXu8F5cEVTXIZiMurFsEVMR+9Y4NGlUMrxB3D9ceBR6kmjW5eDisQxTJnsG0VAHKaJqv1mpeU1hfNJj0IRHyJUAtfcKw5SFPw0zMEN6iZ+51KOF2OUmkfeJ9QmY0aVEkNZzdgcFvGZAh2HBM6+jFDI+KRNf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iAsnjaNX; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765435512; x=1796971512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E4QXRd1fRQK9Y99cANUkpLFWWjCvi6B67GlqLu3xDec=;
  b=iAsnjaNXVheH1uEJThHrkdpC4pOPYmyaj/gOFYN6ea0MRJ4xzPd4SWJt
   xgVncaB+wFOP9fSzd8ZBVQJPF0YZJbzNyyCQtkZTXxfUa2/6T0mMce4Ay
   hLbMa+PL0fhGF6PsW3EOCw8G4chvtuvTyEz4fok7+WmID0Vbp5Ig8b/Tv
   inFETd/58ysf3wJYUPF1PftAj6tcFDXEQEPnBxk8pgBgJjtrYuGG7AA4H
   b8bOelcGHlAKrs0vmM8XtBPycNvqjkbhDyDq2rCcT4qSEfpueai4E5dCZ
   UbpXG9pey6MCQbsy3FIiRuuse1gdX2hBJ0+2PkMSjqvCEOVHCIQ9bW8vy
   Q==;
X-CSE-ConnectionGUID: wAcDBMfPTtmefZRj0WXf/Q==
X-CSE-MsgGUID: vNpegVTWTYK8/fwTcC0Z5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67584424"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67584424"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 22:45:12 -0800
X-CSE-ConnectionGUID: egJtxu8RSyKOrRdIIqZ7GQ==
X-CSE-MsgGUID: ofOUHvPbRyW9Aepto2FQ9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196494919"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 10 Dec 2025 22:45:08 -0800
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
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 1/9] i386/cpu: Add APX EGPRs into xsave area
Date: Thu, 11 Dec 2025 15:09:34 +0800
Message-Id: <20251211070942.3612547-2-zhao1.liu@intel.com>
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
index 33350602edd3..932982bd5dd6 100644
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
 
@@ -636,7 +638,8 @@ typedef enum X86Seg {
                                  XSTATE_BNDCSR_MASK | XSTATE_OPMASK_MASK | \
                                  XSTATE_ZMM_Hi256_MASK | \
                                  XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK | \
-                                 XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK)
+                                 XSTATE_XTILE_CFG_MASK | \
+                                 XSTATE_XTILE_DATA_MASK | XSTATE_APX_MASK)
 
 /* CPUID feature bits available in XSS */
 #define CPUID_XSTATE_XSS_MASK   (XSTATE_ARCH_LBR_MASK | XSTATE_CET_U_MASK | \
@@ -1039,6 +1042,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_1_EDX_PREFETCHITI       (1U << 14)
 /* Support for Advanced Vector Extensions 10 */
 #define CPUID_7_1_EDX_AVX10             (1U << 19)
+/* Support for Advanced Performance Extensions  */
+#define CPUID_7_1_EDX_APX               (1U << 21)
 
 /* Indicate bit 7 of the IA32_SPEC_CTRL MSR is supported */
 #define CPUID_7_2_EDX_PSFD              (1U << 0)
@@ -1681,6 +1686,8 @@ typedef struct {
 
 #define ARCH_LBR_NR_ENTRIES 32
 
+#define EGPR_NUM  16
+
 /* CPU can't have 0xFFFFFFFF APIC ID, use that value to distinguish
  * that APIC ID hasn't been set yet
  */
@@ -1791,6 +1798,11 @@ typedef struct XSaveXTILEDATA {
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
@@ -1803,6 +1815,7 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveCETS) != 0x18);
 QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
+QEMU_BUILD_BUG_ON(sizeof(XSaveAPX) != 0x80);
 
 typedef struct ExtSaveArea {
     uint32_t offset, size;
@@ -1817,7 +1830,7 @@ typedef struct ExtSaveArea {
     const FeatureMask features[2];
 } ExtSaveArea;
 
-#define XSAVE_STATE_AREA_COUNT (XSTATE_XTILE_DATA_BIT + 1)
+#define XSAVE_STATE_AREA_COUNT (XSTATE_APX_BIT + 1)
 
 extern ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT];
 
-- 
2.34.1


