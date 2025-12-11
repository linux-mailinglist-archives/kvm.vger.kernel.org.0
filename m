Return-Path: <kvm+bounces-65704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC45CB4CFB
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D55A300E01C
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF3229B77E;
	Thu, 11 Dec 2025 05:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KXKLPKHS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4835C288C0E
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431846; cv=none; b=Vh+oA6JItpVHhj9Tm0N7o0VZQQaMSP1jqvW+2FJOF4MbuYGvHoWQM0hgVVMcl9GuAsPNEd5ikrVVYoGGorj+ad1GyDi4JqRPn0ILJ9u/YkWsbAc7o/0u/lA8LZaVejQlEsOBkhHzveCi/jHLXbMriDVn8Co+X39UpV6NC4BaE9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431846; c=relaxed/simple;
	bh=ei4jy82TLUyU3gpgqSjMGkn3ky3SGOs5VuaVHpOYPJ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GunxkILuhMhrN89fyNRW+6SN9bww1KKk8ElCHJsDv65tuYXxgQu1wd/GMq4s8r6a+MCQ/AkFv6k0GBzefptWActghKOdqyvFPQgchez3N9jtja4K61RqYWIbcmLLDZEY725b/C2/Oo5DmeASjuK1QGy8KpkDcsyS1QcHquOc38M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KXKLPKHS; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431845; x=1796967845;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ei4jy82TLUyU3gpgqSjMGkn3ky3SGOs5VuaVHpOYPJ4=;
  b=KXKLPKHSl0PXOugYnP3vve6Osv46bCiZWRMNAu3wOigNTPPWSR/yASWl
   TMRuI89psLhSLqwcJH/p0F7f6TY/Npl07wxIQMrS4B1Zmvk0YxWIzHGoX
   3W+dIcxk4CtF5Zq3Gq7OeciWBsuIZXlu6YDz7s8w+c04CIg4KGPRnQRe4
   OkCojaW7udbK8p+o0/TstIv91r4Nm9fhqRbXRzJuNcJoNh3yy9s4AZh2V
   FdrVjLBdKYn7NeWquS4PJqCqpusURIHVzwXGkOueWJY9gXDudpOlPO/Wp
   I0Nehpmse1h54iDG6eFGXjPTu45iJcF5hcR3OrnOLDEnugGD8KswlQR4J
   g==;
X-CSE-ConnectionGUID: jKgyPuqqQKm79ssvE8X85g==
X-CSE-MsgGUID: hPz6PQpISyC60ZS5xZNG+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409908"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409908"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:04 -0800
X-CSE-ConnectionGUID: 8+jLiWf2TQGhwHoZq1oL4Q==
X-CSE-MsgGUID: 6XziEBl/SISQy6TNmNeizQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366122"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:44:00 -0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 11/22] i386/cpu: Enable xsave support for CET states
Date: Thu, 11 Dec 2025 14:07:50 +0800
Message-Id: <20251211060801.3600039-12-zhao1.liu@intel.com>
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

From: Yang Weijiang <weijiang.yang@intel.com>

Add CET_U/S bits in xstate area and report support in xstate
feature mask.
MSR_XSS[bit 11] corresponds to CET user mode states.
MSR_XSS[bit 12] corresponds to CET supervisor mode states.

CET Shadow Stack(SHSTK) and Indirect Branch Tracking(IBT) features
are enumerated via CPUID.(EAX=07H,ECX=0H):ECX[7] and EDX[20]
respectively, two features share the same state bits in XSS, so
if either of the features is enabled, set CET_U and CET_S bits
together.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v2:
 - Rename XSavesCETU/XSavesCETS to XSaveCETU/XSaveCETS.
 - Refine the comments.
 - Drop ".offset = 0" and its comment.
 - Re-describe xstate dependencies via features array.
 - Drop "cet-u" & "cet-s" enumeration from FEAT_XSAVE_XSS_LO's
   feat_name array sicne currently xsave doesn't use named features.
---
 target/i386/cpu.c | 14 ++++++++++++++
 target/i386/cpu.h | 26 +++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d2a89c03caec..4d29e784061c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2078,6 +2078,20 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
             { FEAT_7_0_ECX,         CPUID_7_0_ECX_PKU },
         },
     },
+    [XSTATE_CET_U_BIT] = {
+        .size = sizeof(XSaveCETU),
+        .features = {
+            { FEAT_7_0_ECX,         CPUID_7_0_ECX_CET_SHSTK },
+            { FEAT_7_0_EDX,         CPUID_7_0_EDX_CET_IBT },
+        },
+    },
+    [XSTATE_CET_S_BIT] = {
+        .size = sizeof(XSaveCETS),
+        .features = {
+            { FEAT_7_0_ECX,         CPUID_7_0_ECX_CET_SHSTK },
+            { FEAT_7_0_EDX,         CPUID_7_0_EDX_CET_IBT },
+        },
+    },
     [XSTATE_ARCH_LBR_BIT] = {
         .size = sizeof(XSaveArchLBR),
         .features = {
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 3d74afc5a8e7..bc3296a3c6f0 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -589,6 +589,8 @@ typedef enum X86Seg {
 #define XSTATE_Hi16_ZMM_BIT             7
 #define XSTATE_PT_BIT                   8
 #define XSTATE_PKRU_BIT                 9
+#define XSTATE_CET_U_BIT                11
+#define XSTATE_CET_S_BIT                12
 #define XSTATE_ARCH_LBR_BIT             15
 #define XSTATE_XTILE_CFG_BIT            17
 #define XSTATE_XTILE_DATA_BIT           18
@@ -603,6 +605,8 @@ typedef enum X86Seg {
 #define XSTATE_Hi16_ZMM_MASK            (1ULL << XSTATE_Hi16_ZMM_BIT)
 #define XSTATE_PT_MASK                  (1ULL << XSTATE_PT_BIT)
 #define XSTATE_PKRU_MASK                (1ULL << XSTATE_PKRU_BIT)
+#define XSTATE_CET_U_MASK               (1ULL << XSTATE_CET_U_BIT)
+#define XSTATE_CET_S_MASK               (1ULL << XSTATE_CET_S_BIT)
 #define XSTATE_ARCH_LBR_MASK            (1ULL << XSTATE_ARCH_LBR_BIT)
 #define XSTATE_XTILE_CFG_MASK           (1ULL << XSTATE_XTILE_CFG_BIT)
 #define XSTATE_XTILE_DATA_MASK          (1ULL << XSTATE_XTILE_DATA_BIT)
@@ -625,7 +629,8 @@ typedef enum X86Seg {
                                  XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK)
 
 /* CPUID feature bits available in XSS */
-#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
+#define CPUID_XSTATE_XSS_MASK   (XSTATE_ARCH_LBR_MASK | XSTATE_CET_U_MASK | \
+                                 XSTATE_CET_S_MASK)
 
 #define CPUID_XSTATE_MASK       (CPUID_XSTATE_XCR0_MASK | CPUID_XSTATE_XSS_MASK)
 
@@ -904,6 +909,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_0_ECX_WAITPKG           (1U << 5)
 /* Additional AVX-512 Vector Byte Manipulation Instruction */
 #define CPUID_7_0_ECX_AVX512_VBMI2      (1U << 6)
+/* Control-flow enforcement technology: shadow stack */
+#define CPUID_7_0_ECX_CET_SHSTK         (1U << 7)
 /* Galois Field New Instructions */
 #define CPUID_7_0_ECX_GFNI              (1U << 8)
 /* Vector AES Instructions */
@@ -951,6 +958,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_0_EDX_TSX_LDTRK         (1U << 16)
 /* Architectural LBRs */
 #define CPUID_7_0_EDX_ARCH_LBR          (1U << 19)
+/* Control-flow enforcement technology: indirect branch tracking */
+#define CPUID_7_0_EDX_CET_IBT           (1U << 20)
 /* AMX_BF16 instruction */
 #define CPUID_7_0_EDX_AMX_BF16          (1U << 22)
 /* AVX512_FP16 instruction */
@@ -1737,6 +1746,19 @@ typedef struct XSavePKRU {
     uint32_t padding;
 } XSavePKRU;
 
+/* Ext. save area 11: CET_U state */
+typedef struct XSaveCETU {
+    uint64_t u_cet;
+    uint64_t pl3_ssp;
+} XSaveCETU;
+
+/* Ext. save area 12: CET_S state */
+typedef struct XSaveCETS {
+    uint64_t pl0_ssp;
+    uint64_t pl1_ssp;
+    uint64_t pl2_ssp;
+} XSaveCETS;
+
 /* Ext. save area 15: Arch LBR state */
 typedef struct XSaveArchLBR {
     uint64_t lbr_ctl;
@@ -1764,6 +1786,8 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveOpmask) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
 QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
 QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
+QEMU_BUILD_BUG_ON(sizeof(XSaveCETU) != 0x10);
+QEMU_BUILD_BUG_ON(sizeof(XSaveCETS) != 0x18);
 QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
-- 
2.34.1


