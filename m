Return-Path: <kvm+bounces-65699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1508BCB4CAD
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD6943024E4B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD84288502;
	Thu, 11 Dec 2025 05:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GtbMjO2B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA91288C2D
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431826; cv=none; b=RecVIqlilO45CB1BqLR7YofRRGB3Jw6NJXQk4B5GDx0Y5qkC2eamxAweYI4FieJA9x6WJQox/jxotT18qAt6QVpg6NXXI8waaryy7gz3pfNsY0p+JxvxnIlwotv+j2fHPIKJzkJBtgdo0BPCEHCaaxLVdDm37hJ1NOc5cTz5yw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431826; c=relaxed/simple;
	bh=6oiSLxx2zin740/NCyRplOfAx3FyLNTrt2eo2NqNpGA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X1/0bYh9p38QrnlgN9HsS4wMCy1f7uvNOgvCeUy5Shs4tgQWvgA1JTcHf92zdd4JohQOr4v4q0cRwWZnAKyRj/iBjkS0huflbKnVmlrd1R0uJ5TMpZXLyq80N6KCyZ210nMFXy0fHPh+qDVix91DRXMravea0R8+0JLnk+dbgNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GtbMjO2B; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431825; x=1796967825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6oiSLxx2zin740/NCyRplOfAx3FyLNTrt2eo2NqNpGA=;
  b=GtbMjO2BzX3GvcqW+KxcykqZ8tmub/7rOla8axSe1NYhYnRIbdf6vzjR
   sWE/SijdRScw/U/l2URMaDjODLivnH/HyeHQjGJAoGJTKgFuDrw+g0elK
   9qes9GBMy3tnuoxJ78EgFNQCHHXhjQpjnvaWhNjw8qaxqlhMvvu1obE0C
   adsWCbVqMgBv8iHmU3XHwWeNOWs7ZT7IhADOXh2r/i2MWqQ7HQ8rGOQq6
   ll9vG0fKQKkcwLcAKJgDe2hGPkeMnRcBZjXkJl0/iNxY5ePceeIDOFU/p
   v576XLFxnSA3/gx2UTlWJNglNKhwdgO8Suf0mASlsyq5Uf0kN6NCVrkPx
   g==;
X-CSE-ConnectionGUID: OonjHLPtQ62qKg2NqKRdcw==
X-CSE-MsgGUID: WhydmdQLTZmIYNVhdAg9rA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409860"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409860"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:43:44 -0800
X-CSE-ConnectionGUID: QhiEBwHTRwuV3cmxtIgpeA==
X-CSE-MsgGUID: M4jIW4ehTxqoyGKyrI4PYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366043"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:41 -0800
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
Subject: [PATCH v5 06/22] i386/cpu: Use x86_ext_save_areas[] for CPUID.0XD subleaves
Date: Thu, 11 Dec 2025 14:07:45 +0800
Message-Id: <20251211060801.3600039-7-zhao1.liu@intel.com>
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

The x86_ext_save_areas[] is expected to be well initialized by
accelerators and its xstate detail information cannot be changed by
user. So use x86_ext_save_areas[] to encode CPUID.0XD subleaves directly
without other hardcoding & masking.

And for arch LBR, KVM fills its xstate in x86_ext_save_areas[] via
host_cpuid(). The info obtained this way matches what would be retrieved
from x86_cpu_get_supported_cpuid() (since KVM just fills CPUID with the
host xstate info directly anyway). So just use the initialized
x86_ext_save_areas[] instead of calling x86_cpu_get_supported_cpuid().

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v4:
 - Update commit meesage to explain x86_cpu_get_supported_cpuid() is not
   necessary.

Changes Since v3:
 - New commit.
---
 target/i386/cpu.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 70a282668f72..f3bf7f892214 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8188,20 +8188,17 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             }
         } else if (count == 0xf && cpu->enable_pmu
                    && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
-            x86_cpu_get_supported_cpuid(0xD, count, eax, ebx, ecx, edx);
+            const ExtSaveArea *esa = &x86_ext_save_areas[count];
+
+            *eax = esa->size;
+            *ebx = esa->offset;
+            *ecx = esa->ecx;
         } else if (count < ARRAY_SIZE(x86_ext_save_areas)) {
             const ExtSaveArea *esa = &x86_ext_save_areas[count];
 
-            if (x86_cpu_xsave_xcr0_components(cpu) & (1ULL << count)) {
-                *eax = esa->size;
-                *ebx = esa->offset;
-                *ecx = esa->ecx &
-                       (ESA_FEATURE_ALIGN64_MASK | ESA_FEATURE_XFD_MASK);
-            } else if (x86_cpu_xsave_xss_components(cpu) & (1ULL << count)) {
-                *eax = esa->size;
-                *ebx = 0;
-                *ecx = 1;
-            }
+            *eax = esa->size;
+            *ebx = esa->offset;
+            *ecx = esa->ecx;
         }
         break;
     }
-- 
2.34.1


