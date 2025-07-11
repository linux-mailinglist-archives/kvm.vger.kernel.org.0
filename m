Return-Path: <kvm+bounces-52131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B8EB0192E
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CDF83BC259
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B5828134D;
	Fri, 11 Jul 2025 10:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XbaCGUHA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B888D27E1AC
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228087; cv=none; b=bQuN9rBd2kiZ6c8rzuzYXpGANYfGcGsWoo08m/i2MXSCcsxcAsex78LU1Z+Ztd2rrhA2ERO6ywtI66B8LvU+6qQ/syd/sUy9yvee2/5sPmhsrWJ4DV4O1l8DLpBlgtotSUzfXnHUgkIZLk0ZJrg2NqE4wnj0Yj95/hjZDhqZzlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228087; c=relaxed/simple;
	bh=UHCtpH2VK6WpA+WnzZ3YsdnTTvrM2MCq9aP8ih6Hyec=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O/wB1qMVhfmMWDdaRCOwEYt7vVb5y3uEh0so9V73qGvJWo5O1cHaNhcwGHY1ZBe842jBA5R/CbNAYEswY+vWGrENbFX/C+1Zu4dh4P61mrs3XsunFK9ZY8CtA9Rtu+THRYM75jJTuBbNye9lGEKC8fuJh35IbUO7z7gg6RETIQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XbaCGUHA; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228086; x=1783764086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UHCtpH2VK6WpA+WnzZ3YsdnTTvrM2MCq9aP8ih6Hyec=;
  b=XbaCGUHAyFCiw1HC4ReCtLEiRwPvKuFYwvVnWcfS/ZWLr+UEHCx0+thI
   zVHQuiXRnY9V7P+eLArrOk0apAAAFipx838UuAymLkXCL3Am3ngYlWTyA
   KskX2Zi0rAD5OqS+5hKH0i61tYmSOeen9560vW/t4w2790tcBfti07QUd
   dSDFT2g+ze7LCDNYDvFCSxF7Fb18e65nDA/w71Gt8OtPJudmDRyyzCAYY
   lIOyMh+g/U8yhJU0xMrcOs1oAdR6XMWnYEMJx9pTFgXOUyu8s1UAVtoHO
   We4U29EJsPak02+MSDXRIG6Z9FOzg7hyX3AH3Uj50Uplo3m3QKnG7CoGJ
   w==;
X-CSE-ConnectionGUID: oZDTMlirQXar0Zt1Rx6ypw==
X-CSE-MsgGUID: 9H/D7bmaSQShLZtkpSzmVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496399"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496399"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:01:25 -0700
X-CSE-ConnectionGUID: RmRFC3U/SGeM3n96YM6VUA==
X-CSE-MsgGUID: I1fEkMz5TPOpQQIxPwyAhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662129"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:01:20 -0700
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
Subject: [PATCH v2 13/18] i386/cpu: Select legacy cache model based on vendor in CPUID 0x2
Date: Fri, 11 Jul 2025 18:21:38 +0800
Message-Id: <20250711102143.1622339-14-zhao1.liu@intel.com>
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

As preparation for merging cache_info_cpuid4 and cache_info_amd in
X86CPUState, set legacy cache model based on vendor in the CPUID 0x2
leaf. For AMD CPU, select legacy AMD cache model (in cache_info_amd) as
the default cache model, otherwise, select legacy Intel cache model (in
cache_info_cpuid4) as before.

To ensure compatibility is not broken, add an enable_legacy_vendor_cache
flag based on x-vendor-only-v2 to indicate cases where the legacy cache
model should be used regardless of the vendor. For CPUID 0x2 leaf,
enable_legacy_vendor_cache flag indicates to pick legacy Intel cache
model, which is for compatibility with the behavior of PC machine v10.0
and older.

The following explains how current vendor-based default legacy cache
model ensures correctness without breaking compatibility.

* For the PC machine v6.0 and older, vendor_cpuid_only=false, and
  vendor_cpuid_only_v2=false.

  - If the named CPU model has its own cache model, and doesn't use
    legacy cache model (legacy_cache=false), then cache_info_cpuid4 and
    cache_info_amd are same, so 0x2 leaf uses its own cache model
    regardless of the vendor.

  - For max/host/named CPU (without its own cache model), then the flag
    enable_legacy_vendor_cache is true, they will use legacy Intel cache
    model just like their previous behavior.

* For the PC machine v10.0 and older (to v6.1), vendor_cpuid_only=true,
  and vendor_cpuid_only_v2=false.

  - If the named CPU model has its own cache model (legacy_cache=false),
    then cache_info_cpuid4 & cache_info_amd both equal to its own cache
    model, so it uses its own cache model in 0x2 leaf regardless of the
    vendor. Only AMD CPUs have all-0 leaf due to vendor_cpuid_only=true,
    and this is exactly the behavior of these old machines.

  - For max/host/named CPU (without its own cache model), then the flag
    enable_legacy_vendor_cache is true, they will use legacy Intel cache
    model. Similarly, only AMD CPUs have all-0 leaf, and this is exactly
    the behavior of these old machines.

* For the PC machine v10.1 and newer, vendor_cpuid_only=true, and
  vendor_cpuid_only_v2=true.

  - If the named CPU model has its own cache model (legacy_cache=false),
    then cache_info_cpuid4 & cache_info_amd both equal to its own cache
    model, so it uses its own cache model in 0x2 leaf regardless of the
    vendor. And AMD CPUs have all-0 leaf. Nothing will change.

  - For max/host/named CPU (without its own cache model), then the flag
    enable_legacy_vendor_cache is false, the legacy cache model is
    selected based on vendor.

    For AMD CPU, it will use legacy AMD cache but still get all-0 leaf
    due to vendor_cpuid_only=true.

    For non-AMD (Intel/Zhaoxin) CPU, it will use legacy Intel cache as
    expected.

    Here, selecting the legacy cache model based on the vendor does not
    change the previous (before the change)  behavior.

Therefore, the above analysis proves that, with the help of the flag
enable_legacy_vendor_cache, it is acceptable to select the default
legacy cache model based on the vendor.

For the CPUID 0x2 leaf, in X86CPUState, a unified cache_info is enough.
It only needs to be initialized and configured with the corresponding
legacy cache model based on the vendor.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 47 +++++++++++++++++++++++++++++++++++++----------
 target/i386/cpu.h |  1 +
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4a0505004bfb..34a82a378ccb 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -248,23 +248,17 @@ static const CPUCaches legacy_intel_cpuid2_cache_info;
 
 /* Encode cache info for CPUID[2] */
 static void encode_cache_cpuid2(X86CPU *cpu,
+                                const CPUCaches *caches,
                                 uint32_t *eax, uint32_t *ebx,
                                 uint32_t *ecx, uint32_t *edx)
 {
     CPUX86State *env = &cpu->env;
-    const CPUCaches *caches;
     int l1d, l1i, l2, l3;
     bool unmatched = false;
 
     *eax = 1; /* Number of CPUID[EAX=2] calls required */
     *ebx = *ecx = *edx = 0;
 
-    if (env->enable_legacy_cpuid2_cache) {
-        caches = &legacy_intel_cpuid2_cache_info;
-    } else {
-        caches = &env->cache_info_cpuid4;
-    }
-
     l1d = cpuid2_cache_descriptor(caches->l1d_cache, &unmatched);
     l1i = cpuid2_cache_descriptor(caches->l1i_cache, &unmatched);
     l2 = cpuid2_cache_descriptor(caches->l2_cache, &unmatched);
@@ -7474,8 +7468,37 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *ebx |= threads_per_pkg << 16;
         }
         break;
-    case 2:
-        /* cache info: needed for Pentium Pro compatibility */
+    case 2: { /* cache info: needed for Pentium Pro compatibility */
+        const CPUCaches *caches;
+
+        if (env->enable_legacy_cpuid2_cache) {
+            caches = &legacy_intel_cpuid2_cache_info;
+        } else if (env->enable_legacy_vendor_cache) {
+            caches = &legacy_intel_cache_info;
+        } else {
+            /*
+             * FIXME: Temporarily select cache info model here based on
+             * vendor, and merge these 2 cache info models later.
+             *
+             * This condition covers the following cases (with
+             * enable_legacy_vendor_cache=false):
+             *  - When CPU model has its own cache model and doesn't use legacy
+             *    cache model (legacy_model=off). Then cache_info_amd and
+             *    cache_info_cpuid4 are the same.
+             *
+             *  - For v10.1 and newer machines, when CPU model uses legacy cache
+             *    model. Non-AMD CPUs use cache_info_cpuid4 like before and AMD
+             *    CPU will use cache_info_amd. But this doesn't matter for AMD
+             *    CPU, because this leaf encodes all-0 for AMD whatever its cache
+             *    model is.
+             */
+            if (IS_AMD_CPU(env)) {
+                caches = &env->cache_info_amd;
+            } else {
+                caches = &env->cache_info_cpuid4;
+            }
+        }
+
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
             break;
@@ -7483,8 +7506,9 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *eax = *ebx = *ecx = *edx = 0;
             break;
         }
-        encode_cache_cpuid2(cpu, eax, ebx, ecx, edx);
+        encode_cache_cpuid2(cpu, caches, eax, ebx, ecx, edx);
         break;
+    }
     case 4:
         /* cache info: needed for Core compatibility */
         if (cpu->cache_info_passthrough) {
@@ -8988,6 +9012,9 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
             env->enable_legacy_cpuid2_cache = true;
         }
 
+        if (!cpu->vendor_cpuid_only_v2) {
+            env->enable_legacy_vendor_cache = true;
+        }
         env->cache_info_cpuid4 = legacy_intel_cache_info;
         env->cache_info_amd = legacy_amd_cache_info;
     }
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 03a7b735d090..bb474e65c4f7 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2078,6 +2078,7 @@ typedef struct CPUArchState {
      */
     CPUCaches cache_info_cpuid4, cache_info_amd;
     bool enable_legacy_cpuid2_cache;
+    bool enable_legacy_vendor_cache;
 
     /* MTRRs */
     uint64_t mtrr_fixed[11];
-- 
2.34.1


