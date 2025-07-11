Return-Path: <kvm+bounces-52121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC662B01912
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD8B9188ADDE
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5274327F19B;
	Fri, 11 Jul 2025 10:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VKDv8F89"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EB727F166
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228037; cv=none; b=lNQRLfWBMflfmpDOW3JOiuH/ouRKIbXW/raHDGPkEpfwU0jWzmfOqRKENosPOlvZL7U2GHVC1oKgEb7Uut6ucCeJtiBA7aSBA/W1um5wgYrszGMQIyt8NWuRjIOQFU+xJVDIEK9gag2w9ojmKAhgNuroXYASHeENBh8aGY+3CAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228037; c=relaxed/simple;
	bh=N4j+RvAXnffezaGqQKQKZV+fiLAWxKiP/f4514lxOVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WXQjwwEjk3U8CH7x74TBXwcB8/DwtX1orK5LsJHMda2qr63qCjddvvR6/jSCMeAeDTMc/UQSBU1LO0zGXbC9StuILEuW2f2NiSzi5LWnv/aKay/245ToCEmEXJvdD+LOUaxnJlgu9wdonv700b3IxJjLIW+DPDT++b7qhsDCoSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VKDv8F89; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228036; x=1783764036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N4j+RvAXnffezaGqQKQKZV+fiLAWxKiP/f4514lxOVU=;
  b=VKDv8F89HYZiwEgQxFINVzhAzhIUVWY1Q+I+Dss7sbqiWhguCrgI4EkP
   2qipJcpQtbcCGYbxpfsTR7fhChMQoaf/LsdYcUBmCo98Vup+O5giwqGZX
   5oe0r875g7tipHgpNoaRB9oOHCjycDS55qnUSwm4JmPx4VYPH62PDwAce
   Gf/v/1g11j4eMG/Uz7x1KIQzdFu2PAvTN4shd9ybqMli/zxxIx87v8u6l
   de8MsqiA3bpjNfzpba/rBVWwCft9FRLilgshSEyiCgqN8wYqTErRsMUMd
   moFy2rvp2RAzhTMcENimZr/7I7BSBAsLI2Ej4afCDTAKE7UVcW4q2bOO1
   Q==;
X-CSE-ConnectionGUID: yW4zRbOdSrWpNfW3HgAw7w==
X-CSE-MsgGUID: lXE5JKYaQ4aVGYOnuVCMDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496223"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496223"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:00:35 -0700
X-CSE-ConnectionGUID: CbqxAaMDQuaahZezcZBMig==
X-CSE-MsgGUID: F+mi/dcpRk2W+ezusK1MfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662038"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:00:31 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Pu Wen <puwen@hygon.cn>,
	Tao Su <tao1.su@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 03/18] i386/cpu: Add default cache model for Intel CPUs with level < 4
Date: Fri, 11 Jul 2025 18:21:28 +0800
Message-Id: <20250711102143.1622339-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250711102143.1622339-1-zhao1.liu@intel.com>
References: <20250711102143.1622339-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Old Intel CPUs with CPUID level < 4, use CPUID 0x2 leaf (if available)
to encode cache information.

Introduce a cache model "legacy_intel_cpuid2_cache_info" for the CPUs
with CPUID level < 4, based on legacy_l1d_cache, legacy_l1i_cache,
legacy_l2_cache_cpuid2 and legacy_l3_cache. But for L2 cache, this
cache model completes self_init, sets, partitions, no_invd_sharing and
share_level fields, referring legacy_l2_cache, to avoid someone
increases CPUID level manually and meets assert() error. But the cache
information present in CPUID 0x2 leaf doesn't change.

This new cache model makes it possible to remove legacy_l2_cache_cpuid2
in X86CPUState and help to clarify historical cache inconsistency issue.

Furthermore, apply this legacy cache model to all Intel CPUs with CPUID
level < 4. This includes not only "pentium2" and "pentium3" (which have
0x2 leaf), but also "486" and "pentium" (which only have 0x1 leaf, and
cache model won't be presented, just for simplicity).

A legacy_intel_cpuid2_cache_info cache model doesn't change the cache
information of the above CPUs, because they just depend on 0x2 leaf.

Only when someone adjusts the min-level to >=4 will the cache
information in CPUID leaf 4 differ from before: previously, the L2
cache information in CPUID leaf 0x2 and 0x4 was different, but now with
legacy_intel_cpuid2_cache_info, the information they present will be
consistent. This case almost never happens, emulating a CPUID that is
not supported by the "ancient" hardware is itself meaningless behavior.

Therefore, even though there's the above difference (for really rare
case) and considering these old CPUs ("486", "pentium", "pentium2" and
"pentium3") won't be used for migration, there's no need to add new
versioned CPU models

Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 75932579542a..f85e087bf7df 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -710,6 +710,67 @@ static CPUCacheInfo legacy_l3_cache = {
     .share_level = CPU_TOPOLOGY_LEVEL_DIE,
 };
 
+/*
+ * Only used for the CPU models with CPUID level < 4.
+ * These CPUs (CPUID level < 4) only use CPUID leaf 2 to present
+ * cache information.
+ *
+ * Note: This cache model is just a default one, and is not
+ *       guaranteed to match real hardwares.
+ */
+static const CPUCaches legacy_intel_cpuid2_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 8,
+        .sets = 64,
+        .partitions = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 8,
+        .sets = 64,
+        .partitions = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .size = 2 * MiB,
+        .self_init = 1,
+        .line_size = 64,
+        .associativity = 8,
+        .sets = 4096,
+        .partitions = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l3_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 3,
+        .size = 16 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .sets = 16384,
+        .partitions = 1,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
+    },
+};
+
 /* TLB definitions: */
 
 #define L1_DTLB_2M_ASSOC       1
@@ -3043,6 +3104,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             I486_FEATURES,
         .xlevel = 0,
         .model_id = "",
+        .cache_info = &legacy_intel_cpuid2_cache_info,
     },
     {
         .name = "pentium",
@@ -3055,6 +3117,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             PENTIUM_FEATURES,
         .xlevel = 0,
         .model_id = "",
+        .cache_info = &legacy_intel_cpuid2_cache_info,
     },
     {
         .name = "pentium2",
@@ -3067,6 +3130,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             PENTIUM2_FEATURES,
         .xlevel = 0,
         .model_id = "",
+        .cache_info = &legacy_intel_cpuid2_cache_info,
     },
     {
         .name = "pentium3",
@@ -3079,6 +3143,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             PENTIUM3_FEATURES,
         .xlevel = 0,
         .model_id = "",
+        .cache_info = &legacy_intel_cpuid2_cache_info,
     },
     {
         .name = "athlon",
-- 
2.34.1


