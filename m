Return-Path: <kvm+bounces-52126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05BE0B01920
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 108291C22263
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB1A1283FD8;
	Fri, 11 Jul 2025 10:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J8BPkdYK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3D727EFF7
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228062; cv=none; b=twvNWnnBXFFNj/B5TlS15mencd4aFCkVVUSlIGbOaqAxc1AmGrkoE1ZxzwU1wwgVCeA77cqhu82Q3QzFBgADiUckO59lgNszW8FFkZJ2q7NiSk1A1v2cU1m7m8cs55vyD+TOUZobydIEHcNoie7PTV7Wvzaqh2d3HOoc67e19j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228062; c=relaxed/simple;
	bh=wKjEW9bps5EkjAhmB9EjInZbONVf26jZWeVxusx0w0s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FzXmzpGRuOgtT9wIbqGz+E+t0acDQwH/0tbZ8jtoLxoaNcfds3qOVo/2/N1C6n5L/NCj8fH/g9PKYV1LkNDaRF8/xDgX+ZMKRUTIGLAMTy/Zmv81o3+N496sdtm0+iKvNB8Vde9sNpuw+nWomR5kjgOLziCEzWyjjXIOInrLjiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J8BPkdYK; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228061; x=1783764061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wKjEW9bps5EkjAhmB9EjInZbONVf26jZWeVxusx0w0s=;
  b=J8BPkdYKiivdcPZRJv2BVynJfEi0Pr759FhwpbHJxNb3B10NWzlLtHvO
   7MZreiLA/4OxYvFdf13VZ4dCW4bvP88VTBda12xIvSMDkj9R6QbJprrHh
   0C1xdkrU5IuknYUu+jQ1vl49O61076C2wB4b6B4fEZAlMtKndQB2lT9ZU
   UzdlFxZv3lXefwoK0vK9ecrucpvB0ZrQi9E/Kj0Kb0I45wTDX7+drfQg9
   EjU1vud758zFbUN371GXE6p8UkUiR/w/13zQ46U+kzwGtiow44BM1LwWL
   HiC1Ve4ixypMg5834s90Jq54K+lTrGgWTYkUloufyDgyAoEUCHz2vrWNf
   Q==;
X-CSE-ConnectionGUID: zf5A7PV5QBy9Sgi79PRp+w==
X-CSE-MsgGUID: QnbHBa+8RSOF5i3x93YKWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496299"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496299"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:01:01 -0700
X-CSE-ConnectionGUID: I17h21xoSkiwkPVFNCJnTg==
X-CSE-MsgGUID: Nztrt/okTAyj0GRuPPC/uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662064"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:00:56 -0700
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
Subject: [PATCH v2 08/18] i386/cpu: Mark CPUID[0x80000005] as reserved for Intel
Date: Fri, 11 Jul 2025 18:21:33 +0800
Message-Id: <20250711102143.1622339-9-zhao1.liu@intel.com>
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

Per SDM, 0x80000005 leaf is reserved for Intel CPU, and its current
"assert" check blocks adding new cache model for non-AMD CPUs.

And please note, although Zhaoxin mostly follows Intel behavior,
this leaf is an exception [1].

So, with the compat property "x-vendor-cpuid-only-v2", for the machine
since v10.1, check the vendor and encode this leaf as all-0 only for
Intel CPU. In addition, drop lines_per_tag assertion in
encode_cache_cpuid80000005(), since Zhaoxin will use legacy Intel cache
model in this leaf - which doesn't have this field.

This fix also resolves 2 FIXMEs of legacy_l1d_cache_amd and
legacy_l1i_cache_amd:

/*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */

In addition, per AMD's APM, update the comment of CPUID[0x80000005].

[1]: https://lore.kernel.org/qemu-devel/fa16f7a8-4917-4731-9d9f-7d4c10977168@zhaoxin.com/

Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v1:
 * Drop lines_per_tag assertion in encode_cache_cpuid80000005().

Changes Since RFC:
 * Only set all-0 for Intel CPU.
 * Add x-vendor-cpuid-only-v2.
---
 target/i386/cpu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b6d41aa110a2..6ab199c9a112 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -497,7 +497,6 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
 static uint32_t encode_cache_cpuid80000005(CPUCacheInfo *cache)
 {
     assert(cache->size % 1024 == 0);
-    assert(cache->lines_per_tag > 0);
     assert(cache->associativity > 0);
     assert(cache->line_size > 0);
     return ((cache->size / 1024) << 24) | (cache->associativity << 16) |
@@ -655,7 +654,6 @@ static CPUCacheInfo legacy_l1d_cache = {
     .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
-/*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
 static CPUCacheInfo legacy_l1d_cache_amd = {
     .type = DATA_CACHE,
     .level = 1,
@@ -684,7 +682,6 @@ static CPUCacheInfo legacy_l1i_cache = {
     .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
-/*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
 static CPUCacheInfo legacy_l1i_cache_amd = {
     .type = INSTRUCTION_CACHE,
     .level = 1,
@@ -7886,11 +7883,17 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *edx = env->cpuid_model[(index - 0x80000002) * 4 + 3];
         break;
     case 0x80000005:
-        /* cache info (L1 cache) */
+        /* cache info (L1 cache/TLB Associativity Field) */
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
             break;
         }
+
+        if (cpu->vendor_cpuid_only_v2 && IS_INTEL_CPU(env)) {
+            *eax = *ebx = *ecx = *edx = 0;
+            break;
+        }
+
         *eax = (L1_DTLB_2M_ASSOC << 24) | (L1_DTLB_2M_ENTRIES << 16) |
                (L1_ITLB_2M_ASSOC <<  8) | (L1_ITLB_2M_ENTRIES);
         *ebx = (L1_DTLB_4K_ASSOC << 24) | (L1_DTLB_4K_ENTRIES << 16) |
@@ -9478,6 +9481,7 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
     DEFINE_PROP_BOOL("cpuid-0xb", X86CPU, enable_cpuid_0xb, true),
     DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
+    DEFINE_PROP_BOOL("x-vendor-cpuid-only-v2", X86CPU, vendor_cpuid_only_v2, true),
     DEFINE_PROP_BOOL("x-amd-topoext-features-only", X86CPU, amd_topoext_features_only, true),
     DEFINE_PROP_BOOL("lmce", X86CPU, enable_lmce, false),
     DEFINE_PROP_BOOL("l3-cache", X86CPU, enable_l3_cache, true),
-- 
2.34.1


