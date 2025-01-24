Return-Path: <kvm+bounces-36528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E1BA1B720
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:41:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4C2F3AE822
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE77612B169;
	Fri, 24 Jan 2025 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="inS8w/Eu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8859E78F57
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725982; cv=none; b=VjJ0bqWXRQM3WhewuedR4CtIOUmUIHEfwuKcCFvYe2CURXkwyJ70viMPHXVLrYvCS/nE09ztXIAXY6NS5R4z6lGqG+k+1w2FIQxX776x1YdQkj8kOtWewp5SSK9oHsZqkGqq/MxWt0SllcI1vj18d2yNAnr1rNdnhmGesldhUBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725982; c=relaxed/simple;
	bh=JHF1vMxHHuj0FYNR2BGp2AiJdQc3vac86ItjEKJ+pD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GqqPcUQ4WIite7Gh8ky4DEh3nSlS8hFYCN/dvtUcMOyXsVuw3OZToqGOEb1YgmnwNnUCg6kcsUwV7UFwH8TS1eExUe90Drk+LyoWulYGb01Ua9g1HQGKzUz8kSIz2x/8GVgMbZT9Rg/Id9If/ID+R8ubeSKlOb1o9YiDiHNwsRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=inS8w/Eu; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725981; x=1769261981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JHF1vMxHHuj0FYNR2BGp2AiJdQc3vac86ItjEKJ+pD0=;
  b=inS8w/EutAdNd1VoAUD9Nfk9Wkcrgjm1+yKWWQxaDCBVf8ms2YX8gb76
   smLtmgMKGspeCpp1a3Gzt9f0BPNqxZ2F8ycQSaY9rLRy1BvJFASd7/PDi
   uss4FiJSVmkYnLiW/KVwFT9c5RnKV/iv201WWdeoiszpF31zogwbJHMX8
   mVFkt0Fo8V+KGDUPPj6OTFxk3r70lKm+kQ9nEjaZpwI7lTFLa02z7ZA7H
   P7ZDeXLHGbTj84gU8rn5YnY4FIncYdTqbqUhZw8/KCLCtgZJxcBLpv+8G
   g8UtXtQdJ4Qf/1NDIiP5bGXKAmAbPxVgIgjHTt0w7UqYo7aIdY5up3JSC
   w==;
X-CSE-ConnectionGUID: Mzv+/fBYRKmrVfH1AoXgeA==
X-CSE-MsgGUID: t9DOyeP/Q1WkkGhvIBIerA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246570"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246570"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:41 -0800
X-CSE-ConnectionGUID: iEx0mq4JTdunSL074XNwlQ==
X-CSE-MsgGUID: sS3NY+sbRGuUvu/Siphqcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804453"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:36 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 42/52] i386/tdx: Apply TDX fixed0 and fixed1 information to supported CPUIDs
Date: Fri, 24 Jan 2025 08:20:38 -0500
Message-Id: <20250124132048.3229049-43-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX architecture forcibly sets some CPUID bits for TD guest that VMM
cannot disable it. It also disallows some CPUID bits though they might
be supported for VMX VMs.

The fixed0 and fixed1 bits may vary on different TDX module and on
different host. It's a huge burden to maintain all combination. To
simplify it, hardcode the fixed0 and fixed1 CPUID bits that irrelative
with host in QEMU based on a new enough TDX module version.

Ideally, future TDX module can expose such fixed0 and fixed1 information
via some interface, then KVM can reported them to QEMU.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.h          |   2 +
 target/i386/kvm/kvm.c      |   2 +-
 target/i386/kvm/kvm_i386.h |   8 +++
 target/i386/kvm/tdx.c      | 102 +++++++++++++++++++++++++++++++++++++
 target/i386/sev.c          |   5 --
 5 files changed, 113 insertions(+), 6 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index ca6295605985..8b63685e64e1 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -856,6 +856,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_0_EBX_SMAP              (1U << 20)
 /* AVX-512 Integer Fused Multiply Add */
 #define CPUID_7_0_EBX_AVX512IFMA        (1U << 21)
+/* PCOMMIT instruction */
+#define CPUID_7_0_EBX_PCOMMIT           (1U << 22)
 /* Flush a Cache Line Optimized */
 #define CPUID_7_0_EBX_CLFLUSHOPT        (1U << 23)
 /* Cache Line Write Back */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index fa46edaeac8d..17d7bf6ae9aa 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -393,7 +393,7 @@ static bool host_tsx_broken(void)
 
 /* Returns the value for a specific register on the cpuid entry
  */
-static uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg)
+uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg)
 {
     uint32_t ret = 0;
     switch (reg) {
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index dc696cb7238a..c1bafcfc9b63 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -13,8 +13,15 @@
 
 #include "system/kvm.h"
 
+#include <linux/kvm.h>
+
 #define KVM_MAX_CPUID_ENTRIES  100
 
+typedef struct KvmCpuidInfo {
+    struct kvm_cpuid2 cpuid;
+    struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
+} KvmCpuidInfo;
+
 /* always false if !CONFIG_KVM */
 #define kvm_pit_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
@@ -62,6 +69,7 @@ void kvm_update_msi_routes_all(void *private, bool global,
 struct kvm_cpuid_entry2 *cpuid_find_entry(struct kvm_cpuid2 *cpuid,
                                           uint32_t function,
                                           uint32_t index);
+uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg);
 uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
                              uint32_t cpuid_i);
 #endif /* CONFIG_KVM */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 9bdb9d795952..2d493a0dc1c6 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -440,10 +440,100 @@ static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
     x86cpu->enable_cpuid_0x1f = true;
 }
 
+/*
+ * Fixed0 and Fixed1 bits info are grabbed from TDX 1.5.06 spec.
+ */
+KvmCpuidInfo tdx_fixed0_bits = {
+    .cpuid.nent = 3,
+    .entries[0] = {
+        .function = 0x1,
+        .index = 0x0,
+        .ecx = CPUID_EXT_VMX | CPUID_EXT_SMX,
+        .edx = CPUID_PSE36 | CPUID_IA64,
+    },
+    .entries[1] = {
+        .function = 0x7,
+        .index = 0x0,
+        .flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX,
+        .ebx = CPUID_7_0_EBX_TSC_ADJUST | CPUID_7_0_EBX_SGX |
+               CPUID_7_0_EBX_PCOMMIT,
+        .ecx = CPUID_7_0_ECX_SGX_LC | (1U << 15) | (0x1fU << 17) | (1U << 26) |
+               (1U << 29),
+        .edx = (1U << 0) | (1U << 1) | (1U << 7) | (1U << 9) | (1U << 11) |
+               (1U << 12) | (1U << 13) | (1U << 15) | (1U << 17) | (1U << 21),
+    },
+    .entries[2] = {
+        .function = 0x80000001,
+        .index = 0x0,
+        .ecx = 0xFFFFFEDE,
+        .edx = 0xD3EFF7FF,
+    },
+};
+
+KvmCpuidInfo tdx_fixed1_bits = {
+    .cpuid.nent = 6,
+    .entries[0] = {
+        .function = 0x1,
+        .index = 0,
+        .ecx = CPUID_EXT_SSE3 | CPUID_EXT_PCLMULQDQ | CPUID_EXT_DTES64 |
+               CPUID_EXT_DSCPL | CPUID_EXT_SSE3 | CPUID_EXT_CX16 |
+               CPUID_EXT_PDCM | CPUID_EXT_PCID | CPUID_EXT_SSE41 |
+               CPUID_EXT_SSE42 | CPUID_EXT_X2APIC | CPUID_EXT_MOVBE |
+               CPUID_EXT_POPCNT | CPUID_EXT_AES | CPUID_EXT_XSAVE |
+               CPUID_EXT_RDRAND | CPUID_EXT_HYPERVISOR,
+        .edx = CPUID_FP87 | CPUID_VME | CPUID_DE | CPUID_PSE | CPUID_TSC |
+               CPUID_MSR | CPUID_PAE | CPUID_MCE | CPUID_CX8 | CPUID_APIC |
+               CPUID_SEP | CPUID_MTRR | CPUID_PGE | CPUID_MCA | CPUID_CMOV |
+               CPUID_PAT | CPUID_CLFLUSH | CPUID_DTS | CPUID_MMX | CPUID_FXSR |
+               CPUID_SSE | CPUID_SSE2,
+    },
+    .entries[1] = {
+        .function = 0x6,
+        .index = 0,
+        .eax = CPUID_6_EAX_ARAT,
+    },
+    .entries[2] = {
+        .function = 0x7,
+        .index = 0,
+        .flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX,
+        .ebx = CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_FDP_EXCPTN_ONLY |
+               CPUID_7_0_EBX_SMEP | CPUID_7_0_EBX_INVPCID |
+               CPUID_7_0_EBX_ZERO_FCS_FDS | CPUID_7_0_EBX_RDSEED |
+               CPUID_7_0_EBX_SMAP | CPUID_7_0_EBX_CLFLUSHOPT |
+               CPUID_7_0_EBX_CLWB | CPUID_7_0_EBX_SHA_NI,
+        .ecx = CPUID_7_0_ECX_BUS_LOCK_DETECT | CPUID_7_0_ECX_MOVDIRI |
+               CPUID_7_0_ECX_MOVDIR64B,
+        .edx = (1U << 10) | CPUID_7_0_EDX_SPEC_CTRL | CPUID_7_0_EDX_STIBP |
+               CPUID_7_0_EDX_FLUSH_L1D | CPUID_7_0_EDX_ARCH_CAPABILITIES |
+               CPUID_7_0_EDX_CORE_CAPABILITY | CPUID_7_0_EDX_SPEC_CTRL_SSBD,
+    },
+    .entries[3] = {
+        .function = 0x7,
+        .index = 2,
+        .flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX,
+        .edx = (1U << 0) | (1U << 1) | (1U << 2) | (1U << 4),
+    },
+    .entries[4] = {
+        .function = 0x80000001,
+        .index = 0,
+        .ecx = CPUID_EXT3_LAHF_LM | CPUID_EXT3_ABM | CPUID_EXT3_3DNOWPREFETCH,
+        .edx = CPUID_EXT2_NX | CPUID_EXT2_PDPE1GB | CPUID_EXT2_RDTSCP |
+               CPUID_EXT2_LM,
+    },
+    .entries[5] = {
+        .function = 0x80000007,
+        .index = 0,
+        .edx = CPUID_APM_INVTSC,
+    },
+};
+
 static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
                                           uint32_t feature, uint32_t index,
                                           int reg, uint32_t value)
 {
+    struct kvm_cpuid_entry2 *e;
+    uint32_t fixed0, fixed1;
+
     switch (feature) {
     case 0x7:
         if (index == 0 && reg == R_EBX) {
@@ -470,6 +560,18 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
         break;
     }
 
+    e = cpuid_find_entry(&tdx_fixed0_bits.cpuid, feature, index);
+    if (e) {
+        fixed0 = cpuid_entry_get_reg(e, reg);
+        value &= ~fixed0;
+    }
+
+    e = cpuid_find_entry(&tdx_fixed1_bits.cpuid, feature, index);
+    if (e) {
+        fixed1 = cpuid_entry_get_reg(e, reg);
+        value |= fixed1;
+    }
+
     return value;
 }
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index a6c0a697250b..217b19ad7bc6 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -214,11 +214,6 @@ static const char *const sev_fw_errlist[] = {
 /* <linux/kvm.h> doesn't expose this, so re-use the max from kvm.c */
 #define KVM_MAX_CPUID_ENTRIES 100
 
-typedef struct KvmCpuidInfo {
-    struct kvm_cpuid2 cpuid;
-    struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
-} KvmCpuidInfo;
-
 #define SNP_CPUID_FUNCTION_MAXCOUNT 64
 #define SNP_CPUID_FUNCTION_UNKNOWN 0xFFFFFFFF
 
-- 
2.34.1


