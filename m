Return-Path: <kvm+bounces-45949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A8EEAAFEBA
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:15:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D609E3ACF6B
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED872882DB;
	Thu,  8 May 2025 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CDn/Snhn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668662882D9
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716839; cv=none; b=eL7DhPrAgrGZrKXPfjkgZFTrn6Rp9nWpkux25AOlrdjgsrO+x/3j6bW6uVHr/Hpf3Tx8vrGPwdiqCeOgLO/4dScASng8eZONHmuX5w8IYxJDpk7y6er69d1a5Dc0MSXnaNG5UrkoKDGBlY/Mk7n1IbwD9b6gkdWG0ifcydKulok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716839; c=relaxed/simple;
	bh=Du6vBgwX3ELbsAT4zMHBQiI0xUqv4W/0NYzAkbx+b/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIaffR8xjtVzs44QWwRl9UFQfAmnmyAZWAunUdLqE4QzWwEE1jolJTpXZhEAdQxQ1v37fv4l+GFnizW4BKwt09A3khmuIIgqMQCBpFeJsPW0aALVOq+aVlloyW9wyHnXRlDdapXtzxSRqjfbfxYa3C32img1IeBsAbw7TUL6tf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CDn/Snhn; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716837; x=1778252837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Du6vBgwX3ELbsAT4zMHBQiI0xUqv4W/0NYzAkbx+b/w=;
  b=CDn/Snhn6/5Pgjlft6tz4AlVnyGpsmQozBFC7YieizXXdPa027qfrUv/
   IdtpQMXW29FboHxqphXE2Dsj9Xcz5TZDa87R6RrRKOUqhXRPOXyaQsiLl
   ETTrwYxkmTLAd1pH6jpj9E64cyfpkdzHNQbNSxvSO+X8l89RWsuGiMkLk
   mSO51UnX+ZyOS1nzfRDSS+rnZ9ml2y8MeRt7xWAFEheHtib0V7BPG6ice
   e0048LYDX2pStkcqruTzn0kartGf4SDzG014gcGO8AB4nFLMGe59qjqhw
   S5J1PCFNHEzlwLy5eiZDwsI3FNlRvX7h5sbPSWnPZYGkD6VOs2zrpETGy
   g==;
X-CSE-ConnectionGUID: SX9J0+8lT7SC39M4Sde/nw==
X-CSE-MsgGUID: ymh4Dc3iTFakE6Io0WFJUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888520"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888520"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:17 -0700
X-CSE-ConnectionGUID: Z7i8ZIcvRACUqo17Jx/NxQ==
X-CSE-MsgGUID: oqHy1oBMRReBLQ5bZnDI3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440417"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:14 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 46/55] i386/tdx: Add supported CPUID bits related to TD Attributes
Date: Thu,  8 May 2025 10:59:52 -0400
Message-ID: <20250508150002.689633-47-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For TDX, some CPUID feature bit is configured via TD attributes. They
are not covered by tdx_caps.cpuid (which only contians the directly
configurable CPUID bits), but they are actually supported when the
related attributre bit is supported.

Note, LASS and KeyLocker are not supported by KVM for TDX, nor does
QEMU support it (see TDX_SUPPORTED_TD_ATTRS). They are defined in
tdx_attrs_maps[] for the completeness of the existing TD Attribute
bits that are related with CPUID features.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.h     |  4 +++
 target/i386/kvm/tdx.c | 60 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 115137279a1a..0e984ec42bb6 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -903,6 +903,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_0_ECX_LA57              (1U << 16)
 /* Read Processor ID */
 #define CPUID_7_0_ECX_RDPID             (1U << 22)
+/* KeyLocker */
+#define CPUID_7_0_ECX_KeyLocker         (1U << 23)
 /* Bus Lock Debug Exception */
 #define CPUID_7_0_ECX_BUS_LOCK_DETECT   (1U << 24)
 /* Cache Line Demote Instruction */
@@ -963,6 +965,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_1_EAX_AVX_VNNI          (1U << 4)
 /* AVX512 BFloat16 Instruction */
 #define CPUID_7_1_EAX_AVX512_BF16       (1U << 5)
+/* Linear address space separation */
+#define CPUID_7_1_EAX_LASS              (1U << 6)
 /* CMPCCXADD Instructions */
 #define CPUID_7_1_EAX_CMPCCXADD         (1U << 7)
 /* Fast Zero REP MOVS */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index cbbbbf399309..e4ad2632a566 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -465,6 +465,34 @@ KvmCpuidInfo tdx_fixed1_bits = {
     },
 };
 
+typedef struct TdxAttrsMap {
+    uint32_t attr_index;
+    uint32_t cpuid_leaf;
+    uint32_t cpuid_subleaf;
+    int cpuid_reg;
+    uint32_t feat_mask;
+} TdxAttrsMap;
+
+static TdxAttrsMap tdx_attrs_maps[] = {
+    {.attr_index = 27,
+     .cpuid_leaf = 7,
+     .cpuid_subleaf = 1,
+     .cpuid_reg = R_EAX,
+     .feat_mask = CPUID_7_1_EAX_LASS,},
+
+    {.attr_index = 30,
+     .cpuid_leaf = 7,
+     .cpuid_subleaf = 0,
+     .cpuid_reg = R_ECX,
+     .feat_mask = CPUID_7_0_ECX_PKS,},
+
+    {.attr_index = 31,
+     .cpuid_leaf = 7,
+     .cpuid_subleaf = 0,
+     .cpuid_reg = R_ECX,
+     .feat_mask = CPUID_7_0_ECX_KeyLocker,},
+};
+
 static struct kvm_cpuid_entry2 *find_in_supported_entry(uint32_t function,
                                                         uint32_t index)
 {
@@ -501,6 +529,37 @@ static void tdx_add_supported_cpuid_by_fixed1_bits(void)
     }
 }
 
+static void tdx_add_supported_cpuid_by_attrs(void)
+{
+    struct kvm_cpuid_entry2 *e;
+    TdxAttrsMap *map;
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(tdx_attrs_maps); i++) {
+        map = &tdx_attrs_maps[i];
+        if (!((1ULL << map->attr_index) & tdx_caps->supported_attrs)) {
+            continue;
+        }
+
+        e = find_in_supported_entry(map->cpuid_leaf, map->cpuid_subleaf);
+
+        switch(map->cpuid_reg) {
+        case R_EAX:
+            e->eax |= map->feat_mask;
+            break;
+        case R_EBX:
+            e->ebx |= map->feat_mask;
+            break;
+        case R_ECX:
+            e->ecx |= map->feat_mask;
+            break;
+        case R_EDX:
+            e->edx |= map->feat_mask;
+            break;
+        }
+    }
+}
+
 static void tdx_setup_supported_cpuid(void)
 {
     if (tdx_supported_cpuid) {
@@ -515,6 +574,7 @@ static void tdx_setup_supported_cpuid(void)
     tdx_supported_cpuid->nent = tdx_caps->cpuid.nent;
 
     tdx_add_supported_cpuid_by_fixed1_bits();
+    tdx_add_supported_cpuid_by_attrs();
 }
 
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
-- 
2.43.0


