Return-Path: <kvm+bounces-65698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9195CCB4CA7
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0A193014DA0
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECBC4274FDB;
	Thu, 11 Dec 2025 05:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M9Kw+2+y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2675E28C2A1
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431822; cv=none; b=IEZjJjwnqmBkQg1BOkl+Nx1BoITffiiXqlPqhaA04NsTVKGhIDG+8B7NxXgk1SDpGyI1h4KpguZitOYZ9fjQolxm7TiCeYS0PrRbRjy5YF18f3h6z6nInIS1M40t67RvDe6xlROIpPmU1gusUt7k2z8gKqUfbHyh/W4Sart1Xu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431822; c=relaxed/simple;
	bh=c/VS1/2chdkAwU46yWRjXngVNYQ5YwGggg1BKVSm57Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rTabT3AKyIdbh03AfDRSm92UDLBydmjYJ6e/88OxlIZ0L0WTpxLOGTRzN2RkZv6ElSSkIZwrxi4jicaz18xW/2wqbxXJhRV64y7txymCqVrTIeclodFUP/YwxjyvmSp+Co2KlrVYPTG/PAg5tx4el0o75/fu6LDdH5rVM9wwK6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M9Kw+2+y; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431821; x=1796967821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c/VS1/2chdkAwU46yWRjXngVNYQ5YwGggg1BKVSm57Q=;
  b=M9Kw+2+yl6Se+cPHoYt+pTOwrfROG90ldIg/mMXj9yRM50zF3u7Ej6tv
   3o7jrSrQQxwILA/zBQiY/leNa2JCwRyYymsS/OUeav1MHV76Fi5eal51J
   TrAZCmN/YpAfzfDYEH8Tcjl0aj3FzlLTdjX2RCJNGDfwxyAOVS5gT5bwr
   MHaxP3Doo/8mBi3ICMXoCOqpKtMYbR5R0vgsIarwF0sm9d8+FS7Gu3zi/
   r4TiUVZ8ijJJFuV9QOoXx1mg2ex60+wcdOIzb3ZlSHVfSRuOId0vSopag
   epzrDWZdn+f1wvRYAtolDzDPJ5VmMkk/bxnypNvIPl53j5zLDjy+jO5Dj
   w==;
X-CSE-ConnectionGUID: giGuiRtGTAywtlbvvLkrHw==
X-CSE-MsgGUID: g1NrOrWZTPSIPT+8dMojkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409850"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409850"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:43:41 -0800
X-CSE-ConnectionGUID: LL4fL7cESH+fVaf4NISmLQ==
X-CSE-MsgGUID: 5+6778LAS42EFOp529m5Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366032"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:37 -0800
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
Subject: [PATCH v5 05/22] i386/cpu: Add avx10 dependency for Opmask/ZMM_Hi256/Hi16_ZMM
Date: Thu, 11 Dec 2025 14:07:44 +0800
Message-Id: <20251211060801.3600039-6-zhao1.liu@intel.com>
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

With feature array in ExtSaveArea, add avx10 as the second dependency
for Opmask/ZMM_Hi256/Hi16_ZMM xsave components, and drop the special
check in cpuid_has_xsave_feature().

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e495e6d9b21c..70a282668f72 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2054,18 +2054,21 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
         .size = sizeof(XSaveOpmask),
         .features = {
             { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
         },
     },
     [XSTATE_ZMM_Hi256_BIT] = {
         .size = sizeof(XSaveZMM_Hi256),
         .features = {
             { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
         },
     },
     [XSTATE_Hi16_ZMM_BIT] = {
         .size = sizeof(XSaveHi16_ZMM),
         .features = {
             { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
+            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
         },
     },
     [XSTATE_PKRU_BIT] = {
@@ -8648,12 +8651,6 @@ static bool cpuid_has_xsave_feature(CPUX86State *env, const ExtSaveArea *esa)
         }
     }
 
-    if (esa->features[0].index == FEAT_7_0_EBX &&
-        esa->features[0].mask == CPUID_7_0_EBX_AVX512F &&
-        (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10)) {
-        return true;
-    }
-
     return false;
 }
 
-- 
2.34.1


