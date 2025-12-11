Return-Path: <kvm+bounces-65694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BE2CB4C8C
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D1FD7300E455
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9746428C854;
	Thu, 11 Dec 2025 05:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E7VWG+13"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514B2288C0E
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431807; cv=none; b=PgB6PK+YIGeZfoLB1rD+QVKe6NZO2hA6QVwKKDKx0v7+8k0ym6h9HPasM3HnEm15CtuSassixE0PefZqBN/NShppclfTN92wDWMlce1JGR5e5dujr8Fe70QGIGW8xTkXmVgZzODVdyhq3dQx23/3WcFqkw05gOAs6882zwBvHhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431807; c=relaxed/simple;
	bh=i0sp4wj5rSSd6tZSRimjqOo45WUYte6rhpv/w5HY6HQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H6RUA6SOhMDqmBghOX6Uuy0wsKpSnsvLqDriYPLG6Zk70vFKkNXZ09IEU14mz2BZ+Y7aH0Oq4QYoiovcH/xIG2MKH6CxrKOsWGHBojVbiJaF4IPeS9BRzc2j1Ey8+2Y/vxEHUs6+EQaaqItamsztcBaGd3eN6E7Yblup+Mdc5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E7VWG+13; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431806; x=1796967806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i0sp4wj5rSSd6tZSRimjqOo45WUYte6rhpv/w5HY6HQ=;
  b=E7VWG+13bCL9FCztfGqHVOHEWfNFgSgXni8xCkn+VKSffB58BvoW757h
   RbZyT3f/ruS4ofwldOmxY/O3+dx9zp2sQr+x9IU3zBTNhTSiihxGX2JAJ
   dp5AlQDxPcz5jxvsToZhskenkemu6FjgFiMgudEspeqY2iOycry1drfF8
   +x5U6mwEbBJrd8rQvt5K6wAqOz/3Mm+Vz0bc8Upl9KztBIPbOSvR0Zb3f
   saUA/mkR+cZVXOw2JpHc5/Ps87IXW46kg5gkPvb7HEKK9RvwXXzMI/EYY
   XOvlN+ZaBfo2gjZnxqDUU5VQVwPzAnuIGfcAjZBaoP6O+OPVW9XYZF3YU
   g==;
X-CSE-ConnectionGUID: 9rPW/+6zT0GDexvQVGAUSA==
X-CSE-MsgGUID: 7VAetB0oTeeokkMWVn82Gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409804"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409804"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:43:26 -0800
X-CSE-ConnectionGUID: XTydjJdvQC+i0WPNLn9j+Q==
X-CSE-MsgGUID: OcA4TglsQvmUMI9O4GLkuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227365989"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:22 -0800
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
Subject: [PATCH v5 01/22] i386/cpu: Clean up indent style of x86_ext_save_areas[]
Date: Thu, 11 Dec 2025 14:07:40 +0800
Message-Id: <20251211060801.3600039-2-zhao1.liu@intel.com>
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

The indentation style in `x86_ext_save_areas[]` is extremely
inconsistent. Clean it up to ensure a uniform style.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 58 +++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 641777578637..c598f09f3d50 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2028,38 +2028,46 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
         .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
         .size = sizeof(X86LegacyXSaveArea) + sizeof(X86XSaveHeader),
     },
-    [XSTATE_YMM_BIT] =
-          { .feature = FEAT_1_ECX, .bits = CPUID_EXT_AVX,
-            .size = sizeof(XSaveAVX) },
-    [XSTATE_BNDREGS_BIT] =
-          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
-            .size = sizeof(XSaveBNDREG)  },
-    [XSTATE_BNDCSR_BIT] =
-          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
-            .size = sizeof(XSaveBNDCSR)  },
-    [XSTATE_OPMASK_BIT] =
-          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .size = sizeof(XSaveOpmask) },
-    [XSTATE_ZMM_Hi256_BIT] =
-          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .size = sizeof(XSaveZMM_Hi256) },
-    [XSTATE_Hi16_ZMM_BIT] =
-          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .size = sizeof(XSaveHi16_ZMM) },
-    [XSTATE_PKRU_BIT] =
-          { .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
-            .size = sizeof(XSavePKRU) },
+    [XSTATE_YMM_BIT] = {
+        .feature = FEAT_1_ECX, .bits = CPUID_EXT_AVX,
+        .size = sizeof(XSaveAVX),
+    },
+    [XSTATE_BNDREGS_BIT] = {
+        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
+        .size = sizeof(XSaveBNDREG),
+    },
+    [XSTATE_BNDCSR_BIT] = {
+        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
+        .size = sizeof(XSaveBNDCSR),
+    },
+    [XSTATE_OPMASK_BIT] = {
+        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
+        .size = sizeof(XSaveOpmask),
+    },
+    [XSTATE_ZMM_Hi256_BIT] = {
+        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
+        .size = sizeof(XSaveZMM_Hi256),
+    },
+    [XSTATE_Hi16_ZMM_BIT] = {
+        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
+        .size = sizeof(XSaveHi16_ZMM),
+    },
+    [XSTATE_PKRU_BIT] = {
+        .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
+        .size = sizeof(XSavePKRU),
+    },
     [XSTATE_ARCH_LBR_BIT] = {
-            .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
-            .offset = 0 /*supervisor mode component, offset = 0 */,
-            .size = sizeof(XSavesArchLBR) },
+        .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
+        .offset = 0 /*supervisor mode component, offset = 0 */,
+        .size = sizeof(XSavesArchLBR),
+    },
     [XSTATE_XTILE_CFG_BIT] = {
         .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
         .size = sizeof(XSaveXTILECFG),
     },
     [XSTATE_XTILE_DATA_BIT] = {
         .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
-        .size = sizeof(XSaveXTILEDATA)
+        .size = sizeof(XSaveXTILEDATA),
     },
 };
 
-- 
2.34.1


