Return-Path: <kvm+bounces-65701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C94CB4C95
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:43:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9481E30019FF
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40E720F08D;
	Thu, 11 Dec 2025 05:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iQ2RwsF5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CE428BA95
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431834; cv=none; b=XDJoqGkm55v1XB1FX8d7+DfQRf2bLVpmuE6hE8hj7DzEMZHDPaLAxD/04d7ffHVkqr4n/Dd0tsdV5MBmapjsgd0I/qMAEyOoAubs2HdNrwGCLAR+Z0piNSA6558T+JgkDXRBKveN3wFOh/tle9ZfcyYQ7XMn2lOXZHzsGsEGvBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431834; c=relaxed/simple;
	bh=fJBFcQVoKmgeoUmwsBmvZdBtcnTJvhtd89N47vMSmQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YK4NRSj0CaiKoR/zOcOI0LOqJ0BfJp+Tpfv7DjpaXatEbNqBkBVdcvNTqNtVqLRMDhYmnFmhk9tuA3dFAmI/ezbWebIB+3hViwzX18dlVA0IaLvmQhE+5MIiZX70VJS2/8bc2Byjswes9sX5yT3bZa2aAwKUdqVu+g4kTZ5rSeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iQ2RwsF5; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431832; x=1796967832;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fJBFcQVoKmgeoUmwsBmvZdBtcnTJvhtd89N47vMSmQc=;
  b=iQ2RwsF5uEg2GDWUmATiJzUpUKTEoWAc7QGL/YgyxFVWwJSC1LosE4B4
   b/TCRn/NoDZHu5O0ul0OVgKUb0QjfzIZ2dCH/cfdA5z84y13L44mJVjEx
   xEHIEqI3wCZ2vVDoHnjSPEDKL6gT3rTx9witaMxVw1UQO9gtpUHAeKW/X
   7Ek5LCdBmYfRAFrf8kdlO4YG3Wkprb+pLyHKZdbkkQex9TsxtT2BmNjE0
   TjG5Q5wbe4/TbFA6dwlIk8W7YkFuFA0nh0Sd2kSLfJZpNw8oggBaGi7tV
   PZfGU8HooKjGKxzJfR3QljFcUreEMSAuNrZmKZM/x4SWalQbVq5L8Trin
   w==;
X-CSE-ConnectionGUID: H1vCdyEWRwGrzPSd94pCSQ==
X-CSE-MsgGUID: xucYfFxpTOWveqMdCMKHUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409876"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409876"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:43:52 -0800
X-CSE-ConnectionGUID: BS+knNYIRRygEl7jo6PxpQ==
X-CSE-MsgGUID: ZnWECnVlTcGvVPdkV8+UkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366063"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:48 -0800
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
Subject: [PATCH v5 08/22] i386/cpu: Drop pmu check in CPUID 0x1C encoding
Date: Thu, 11 Dec 2025 14:07:47 +0800
Message-Id: <20251211060801.3600039-9-zhao1.liu@intel.com>
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

Since CPUID_7_0_EDX_ARCH_LBR will be masked off if pmu is disabled,
there's no need to check CPUID_7_0_EDX_ARCH_LBR feature with pmu.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 56b4c57969c1..62769db3ebb7 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8273,11 +8273,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
         break;
     }
-    case 0x1C:
-        if (cpu->enable_pmu && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
-            x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
-            *edx = 0;
+    case 0x1C: /* Last Branch Records Information Leaf */
+        *eax = 0;
+        *ebx = 0;
+        *ecx = 0;
+        *edx = 0;
+        if (!(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
+            break;
         }
+        x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
+        *edx = 0; /* EDX is reserved. */
         break;
     case 0x1D: {
         /* AMX TILE, for now hardcoded for Sapphire Rapids*/
-- 
2.34.1


