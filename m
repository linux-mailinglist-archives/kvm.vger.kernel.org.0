Return-Path: <kvm+bounces-36529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9C5A1B721
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1365C3AEC46
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BC7613A250;
	Fri, 24 Jan 2025 13:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L+5UpxQD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0176C78F57
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725985; cv=none; b=XnakNtduE3zbsPeVt0u76lzQoZiXwW7wmS5Kq74voL41CQb7trMNZv4ZZgj0U4h/iCZk8FDaFwi/KXqEWZKVPOCpK2Uy5pxe9EzRg5/IBUpriv8siYFBzGJgtuPQBIwgMB4QXZggB1TJmIZIOt01ynp2BkMdzuDwkyqZs2BMB8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725985; c=relaxed/simple;
	bh=DiFlJ2bW4l04b5XDYk9TOAHCOXgmdgi5M+5gwbsLQjI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bj6aIN7xHlTRi/gTopDozKwagQ1Mv5HufWqz2OysFuNkNrqs74Rpq7GA1RPI3qSt1UwlnSdH4QJfk2whj+41RdD96CUx0NnzP2W3jY/5DpDnSrZPefaTgzxjcAKOdA7JMZ5rq6HHxMexmcvRcgyzhkFffcKpEDnlgKQ1f5RTots=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L+5UpxQD; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725984; x=1769261984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DiFlJ2bW4l04b5XDYk9TOAHCOXgmdgi5M+5gwbsLQjI=;
  b=L+5UpxQDPxKRjOXMk/o0ZZvNO32fnHfwdPavYHbMLms7XwTyR8y9o4+Y
   BfcV8xMRUxj7zPTebJcQwPK1Echh3OIErNblUf9pPe1F62e39DBomse7Q
   qMgPQCuqVFYdpLqQ5HHXOj+kg/vYe/7Eomzd5MDHiFr+SnL9oPhBL9Vjf
   lHBJON6NGHyyOloG6CM3d3VxjXY2gpYEUcvif7ky3PCtKl0CgcI4jsaIV
   S1zriwy1gbJ/AwiA1IVeDtr+qGBkzjGcaMLFNakAYfnqn3oplHn2S+2jO
   MHc6XZE6LqW+EPk89+4ML4eY1TBM+JpXwUefnreiVnV88bJHwL+O7Gihm
   w==;
X-CSE-ConnectionGUID: 3qntKiWuSZursKLiKBUNiQ==
X-CSE-MsgGUID: UYSUeHVnSvaKmcM8QHfM6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246579"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246579"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:44 -0800
X-CSE-ConnectionGUID: lmzWCOrORrm/jSDeiiD8Bw==
X-CSE-MsgGUID: P0tFgi7SR3a/PtpBq3Nojw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804457"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:40 -0800
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
Subject: [PATCH v7 43/52] i386/tdx: Mask off CPUID bits by unsupported TD Attributes
Date: Fri, 24 Jan 2025 08:20:39 -0500
Message-Id: <20250124132048.3229049-44-xiaoyao.li@intel.com>
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

For TDX, some CPUID feature bit is configured via TD attributes. Adjust
the supported CPUID to mask off the bit if its matched attribute is
unsupported.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.h     |  4 ++++
 target/i386/kvm/tdx.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 8b63685e64e1..4890424c3a9e 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -905,6 +905,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_0_ECX_LA57              (1U << 16)
 /* Read Processor ID */
 #define CPUID_7_0_ECX_RDPID             (1U << 22)
+/* KeyLocker */
+#define CPUID_7_0_ECX_KeyLocker         (1U << 23)
 /* Bus Lock Debug Exception */
 #define CPUID_7_0_ECX_BUS_LOCK_DETECT   (1U << 24)
 /* Cache Line Demote Instruction */
@@ -957,6 +959,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_1_EAX_AVX_VNNI          (1U << 4)
 /* AVX512 BFloat16 Instruction */
 #define CPUID_7_1_EAX_AVX512_BF16       (1U << 5)
+/* Linear address space separation */
+#define CPUID_7_1_EAX_LASS              (1U << 6)
 /* CMPCCXADD Instructions */
 #define CPUID_7_1_EAX_CMPCCXADD         (1U << 7)
 /* Fast Zero REP MOVS */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 2d493a0dc1c6..3997a439f054 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -527,6 +527,58 @@ KvmCpuidInfo tdx_fixed1_bits = {
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
+     .feat_mask = CPUID_7_1_EAX_LASS},
+    {.attr_index = 30,
+     .cpuid_leaf = 7,
+     .cpuid_subleaf = 0,
+     .cpuid_reg = R_ECX,
+     .feat_mask = CPUID_7_0_ECX_PKS,},
+    {.attr_index = 31,
+     .cpuid_leaf = 7,
+     .cpuid_subleaf = 0,
+     .cpuid_reg = R_ECX,
+     .feat_mask = CPUID_7_0_ECX_KeyLocker,
+    },
+};
+
+static void tdx_mask_cpuid_by_attrs(uint32_t feature, uint32_t index,
+                                    int reg, uint32_t *value)
+{
+    TdxAttrsMap *map;
+    uint64_t unavail = 0;
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(tdx_attrs_maps); i++) {
+        map = &tdx_attrs_maps[i];
+
+        if (feature != map->cpuid_leaf || index != map->cpuid_subleaf ||
+            reg != map->cpuid_reg) {
+            continue;
+        }
+
+        if (!((1ULL << map->attr_index) & tdx_caps->supported_attrs)) {
+            unavail |= map->feat_mask;
+        }
+    }
+
+    if (unavail) {
+        *value &= ~unavail;
+    }
+}
+
 static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
                                           uint32_t feature, uint32_t index,
                                           int reg, uint32_t value)
@@ -560,6 +612,8 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
         break;
     }
 
+    tdx_mask_cpuid_by_attrs(feature, index, reg, &value);
+
     e = cpuid_find_entry(&tdx_fixed0_bits.cpuid, feature, index);
     if (e) {
         fixed0 = cpuid_entry_get_reg(e, reg);
-- 
2.34.1


