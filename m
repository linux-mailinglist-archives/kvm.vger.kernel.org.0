Return-Path: <kvm+bounces-52136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C40B01933
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E72175603C2
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A56B127FB2D;
	Fri, 11 Jul 2025 10:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LQpgz0UX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDBE27EFEA
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228111; cv=none; b=TfaSl2E88glOJpuPzdZibduUYCJY8tz6IhWmvd4Xy9+KtG24ggFDurvkriRWF/KsNinJRXVykkrcVqsGbU8W6fFLFmev3XtK2n9SWna6ABYHgzPUBtNd8PJNZ8MtWbm+oGSjJOuHhIGQMC8eD5S0wWJq3/f/loK94f4enC32o8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228111; c=relaxed/simple;
	bh=2otHjRjWFXMpNbrnGgfOTh3c1Qw0xqo7w+y00sXBUEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FIDU+eWAQxiGzdkgYDE+BiH7LYKFuarff49ijPIIcbtz8Gh3Wy1iAZpQ50exXL+Sasg4M/+gpO+LbMfwYiJtBM2SZfajXVBhoYDPyzFvicomaeTjjzIZk50v9K9dIm4GL9kZMYupEdt/POExs9lp3iqclUGA+P1dAiyFxWATTOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LQpgz0UX; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228110; x=1783764110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2otHjRjWFXMpNbrnGgfOTh3c1Qw0xqo7w+y00sXBUEI=;
  b=LQpgz0UXtSEfIWOAaWXrroagUL/hrroZ5rL5pgCmH9SpPB/LUzu07YQO
   RoxaSBzusu4JjCj+yxOwkRuav/DtWRYB/NyYlXkS/TP2wI2VR6Y/MvQ2o
   v/F0FHAzUEDGxCeZRWsCDhO3MbliUh3gmOf394EhsNIyqcrCuVf9cEUoe
   5LqUAgo0ws39Nz/bDgnDoU8rzUcsPLIP5cE0CdEPuQdH7DaWhOL+j+Gad
   7g98oUWob3h+c7dmU+kA1aZxEaGdgPbetF/R8+nk7+jEPHv0y30EcZ4FV
   bQoW+69EJp7c+fbbkRmwABtoh3D+lJSQnTL2gVuHHuoVzESuGALte/tz2
   A==;
X-CSE-ConnectionGUID: i6JqDv2rQgakJbO72yzVIw==
X-CSE-MsgGUID: ANebzpIgQ0CTllx1VtZkeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496462"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496462"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:01:50 -0700
X-CSE-ConnectionGUID: qYYYD/I+QluSm8oJY8FfVA==
X-CSE-MsgGUID: xxeM9sLLSjyWseOo+Fo72g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662165"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:01:45 -0700
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
	Zhao Liu <zhao1.liu@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH v2 18/18] i386/cpu: Use a unified cache_info in X86CPUState
Date: Fri, 11 Jul 2025 18:21:43 +0800
Message-Id: <20250711102143.1622339-19-zhao1.liu@intel.com>
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

At present, all cases using the cache model (CPUID 0x2, 0x4, 0x80000005,
0x80000006 and 0x8000001D leaves) have been verified to be able to
select either cache_info_intel or cache_info_amd based on the vendor.

Therefore, further merge cache_info_intel and cache_info_amd into a
unified cache_info in X86CPUState, and during its initialization, set
different legacy cache models based on the vendor.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 150 ++++++++--------------------------------------
 target/i386/cpu.h |   5 +-
 2 files changed, 27 insertions(+), 128 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index df13dbc63a3f..7f88fe0c8697 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7476,27 +7476,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         } else if (env->enable_legacy_vendor_cache) {
             caches = &legacy_intel_cache_info;
         } else {
-            /*
-             * FIXME: Temporarily select cache info model here based on
-             * vendor, and merge these 2 cache info models later.
-             *
-             * This condition covers the following cases (with
-             * enable_legacy_vendor_cache=false):
-             *  - When CPU model has its own cache model and doesn't use legacy
-             *    cache model (legacy_model=off). Then cache_info_amd and
-             *    cache_info_cpuid4 are the same.
-             *
-             *  - For v10.1 and newer machines, when CPU model uses legacy cache
-             *    model. Non-AMD CPUs use cache_info_cpuid4 like before and AMD
-             *    CPU will use cache_info_amd. But this doesn't matter for AMD
-             *    CPU, because this leaf encodes all-0 for AMD whatever its cache
-             *    model is.
-             */
-            if (IS_AMD_CPU(env)) {
-                caches = &env->cache_info_amd;
-            } else {
-                caches = &env->cache_info_cpuid4;
-            }
+            caches = &env->cache_info;
         }
 
         if (cpu->cache_info_passthrough) {
@@ -7515,27 +7495,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (env->enable_legacy_vendor_cache) {
             caches = &legacy_intel_cache_info;
         } else {
-            /*
-             * FIXME: Temporarily select cache info model here based on
-             * vendor, and merge these 2 cache info models later.
-             *
-             * This condition covers the following cases (with
-             * enable_legacy_vendor_cache=false):
-             *  - When CPU model has its own cache model and doesn't use legacy
-             *    cache model (legacy_model=off). Then cache_info_amd and
-             *    cache_info_cpuid4 are the same.
-             *
-             *  - For v10.1 and newer machines, when CPU model uses legacy cache
-             *    model. Non-AMD CPUs use cache_info_cpuid4 like before and AMD
-             *    CPU will use cache_info_amd. But this doesn't matter for AMD
-             *    CPU, because this leaf encodes all-0 for AMD whatever its cache
-             *    model is.
-             */
-            if (IS_AMD_CPU(env)) {
-                caches = &env->cache_info_amd;
-            } else {
-                caches = &env->cache_info_cpuid4;
-            }
+            caches = &env->cache_info;
         }
 
         /* cache info: needed for Core compatibility */
@@ -7944,27 +7904,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (env->enable_legacy_vendor_cache) {
             caches = &legacy_amd_cache_info;
         } else {
-            /*
-             * FIXME: Temporarily select cache info model here based on
-             * vendor, and merge these 2 cache info models later.
-             *
-             * This condition covers the following cases (with
-             * enable_legacy_vendor_cache=false):
-             *  - When CPU model has its own cache model and doesn't uses legacy
-             *    cache model (legacy_model=off). Then cache_info_amd and
-             *    cache_info_cpuid4 are the same.
-             *
-             *  - For v10.1 and newer machines, when CPU model uses legacy cache
-             *    model. AMD CPUs use cache_info_amd like before and non-AMD
-             *    CPU will use cache_info_cpuid4. But this doesn't matter,
-             *    because for Intel CPU, it will get all-0 leaf, and Zhaoxin CPU
-             *    will get correct cache info. Both are expected.
-             */
-            if (IS_AMD_CPU(env)) {
-                caches = &env->cache_info_amd;
-            } else {
-                caches = &env->cache_info_cpuid4;
-            }
+            caches = &env->cache_info;
         }
 
         if (cpu->cache_info_passthrough) {
@@ -7991,25 +7931,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (env->enable_legacy_vendor_cache) {
             caches = &legacy_amd_cache_info;
         } else {
-            /*
-             * FIXME: Temporarily select cache info model here based on
-             * vendor, and merge these 2 cache info models later.
-             *
-             * This condition covers the following cases (with
-             * enable_legacy_vendor_cache=false):
-             *  - When CPU model has its own cache model and doesn't uses legacy
-             *    cache model (legacy_model=off). Then cache_info_amd and
-             *    cache_info_cpuid4 are the same.
-             *
-             *  - For v10.1 and newer machines, when CPU model uses legacy cache
-             *    model. AMD CPUs use cache_info_amd like before and non-AMD
-             *    CPU (Intel & Zhaoxin) will use cache_info_cpuid4 as expected.
-             */
-            if (IS_AMD_CPU(env)) {
-                caches = &env->cache_info_amd;
-            } else {
-                caches = &env->cache_info_cpuid4;
-            }
+            caches = &env->cache_info;
         }
 
         if (cpu->cache_info_passthrough) {
@@ -8082,22 +8004,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *edx = 0;
         }
         break;
-    case 0x8000001D: {
-        const CPUCaches *caches;
-
-        /*
-         * FIXME: Temporarily select cache info model here based on
-         * vendor, and merge these 2 cache info models later.
-         *
-         * Intel doesn't support this leaf so that Intel Guests don't
-         * have this leaf. This change is harmless to Intel CPUs.
-         */
-        if (IS_AMD_CPU(env)) {
-            caches = &env->cache_info_amd;
-        } else {
-            caches = &env->cache_info_cpuid4;
-        }
-
+    case 0x8000001D:
         *eax = 0;
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, count, eax, ebx, ecx, edx);
@@ -8105,19 +8012,19 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
         switch (count) {
         case 0: /* L1 dcache info */
-            encode_cache_cpuid8000001d(caches->l1d_cache,
+            encode_cache_cpuid8000001d(env->cache_info.l1d_cache,
                                        topo_info, eax, ebx, ecx, edx);
             break;
         case 1: /* L1 icache info */
-            encode_cache_cpuid8000001d(caches->l1i_cache,
+            encode_cache_cpuid8000001d(env->cache_info.l1i_cache,
                                        topo_info, eax, ebx, ecx, edx);
             break;
         case 2: /* L2 cache info */
-            encode_cache_cpuid8000001d(caches->l2_cache,
+            encode_cache_cpuid8000001d(env->cache_info.l2_cache,
                                        topo_info, eax, ebx, ecx, edx);
             break;
         case 3: /* L3 cache info */
-            encode_cache_cpuid8000001d(caches->l3_cache,
+            encode_cache_cpuid8000001d(env->cache_info.l3_cache,
                                        topo_info, eax, ebx, ecx, edx);
             break;
         default: /* end of info */
@@ -8128,7 +8035,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *edx &= CACHE_NO_INVD_SHARING | CACHE_INCLUSIVE;
         }
         break;
-    }
     case 0x8000001E:
         if (cpu->core_id <= 255) {
             encode_topo_cpuid8000001e(cpu, topo_info, eax, ebx, ecx, edx);
@@ -8825,46 +8731,34 @@ static bool x86_cpu_update_smp_cache_topo(MachineState *ms, X86CPU *cpu,
 
     level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D);
     if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
-        env->cache_info_cpuid4.l1d_cache->share_level = level;
-        env->cache_info_amd.l1d_cache->share_level = level;
+        env->cache_info.l1d_cache->share_level = level;
     } else {
         machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D,
-            env->cache_info_cpuid4.l1d_cache->share_level);
-        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D,
-            env->cache_info_amd.l1d_cache->share_level);
+            env->cache_info.l1d_cache->share_level);
     }
 
     level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I);
     if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
-        env->cache_info_cpuid4.l1i_cache->share_level = level;
-        env->cache_info_amd.l1i_cache->share_level = level;
+        env->cache_info.l1i_cache->share_level = level;
     } else {
         machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I,
-            env->cache_info_cpuid4.l1i_cache->share_level);
-        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I,
-            env->cache_info_amd.l1i_cache->share_level);
+            env->cache_info.l1i_cache->share_level);
     }
 
     level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2);
     if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
-        env->cache_info_cpuid4.l2_cache->share_level = level;
-        env->cache_info_amd.l2_cache->share_level = level;
+        env->cache_info.l2_cache->share_level = level;
     } else {
         machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2,
-            env->cache_info_cpuid4.l2_cache->share_level);
-        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2,
-            env->cache_info_amd.l2_cache->share_level);
+            env->cache_info.l2_cache->share_level);
     }
 
     level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3);
     if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
-        env->cache_info_cpuid4.l3_cache->share_level = level;
-        env->cache_info_amd.l3_cache->share_level = level;
+        env->cache_info.l3_cache->share_level = level;
     } else {
         machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3,
-            env->cache_info_cpuid4.l3_cache->share_level);
-        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3,
-            env->cache_info_amd.l3_cache->share_level);
+            env->cache_info.l3_cache->share_level);
     }
 
     if (!machine_check_smp_cache(ms, errp)) {
@@ -9101,7 +8995,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
                        "CPU model '%s' doesn't support legacy-cache=off", name);
             return;
         }
-        env->cache_info_cpuid4 = env->cache_info_amd = *cache_info;
+        env->cache_info = *cache_info;
     } else {
         /* Build legacy cache information */
         if (!cpu->consistent_cache) {
@@ -9111,8 +9005,12 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
         if (!cpu->vendor_cpuid_only_v2) {
             env->enable_legacy_vendor_cache = true;
         }
-        env->cache_info_cpuid4 = legacy_intel_cache_info;
-        env->cache_info_amd = legacy_amd_cache_info;
+
+        if (IS_AMD_CPU(env)) {
+            env->cache_info = legacy_amd_cache_info;
+        } else {
+            env->cache_info = legacy_intel_cache_info;
+        }
     }
 
 #ifndef CONFIG_USER_ONLY
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index bb474e65c4f7..3eecee3721b8 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2072,11 +2072,12 @@ typedef struct CPUArchState {
     /* Features that were explicitly enabled/disabled */
     FeatureWordArray user_features;
     uint32_t cpuid_model[12];
-    /* Cache information for CPUID.  When legacy-cache=on, the cache data
+    /*
+     * Cache information for CPUID.  When legacy-cache=on, the cache data
      * on each CPUID leaf will be different, because we keep compatibility
      * with old QEMU versions.
      */
-    CPUCaches cache_info_cpuid4, cache_info_amd;
+    CPUCaches cache_info;
     bool enable_legacy_cpuid2_cache;
     bool enable_legacy_vendor_cache;
 
-- 
2.34.1


