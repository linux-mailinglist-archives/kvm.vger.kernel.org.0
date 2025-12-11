Return-Path: <kvm+bounces-65714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B31B8CB4D19
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:52:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B96BC301DBAB
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFE32D5959;
	Thu, 11 Dec 2025 05:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dLUyqnyh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED5E2D47E8
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431886; cv=none; b=Om4LPlamPKlSUgWwdvT+b6sSMfOyFNTDhcRbvcSTch0E0Pqphuqc1s1E0PFDakVKuP+HqCj3MuOmn+C3Cuc2jdC9wiFocur7uzAiWWTqwkSdL6RdEMZKLeIIQ3nExnDuJ4hSqt4ZObSExa5yKr9poQCriIX3pt9ROgNvrR/Oc8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431886; c=relaxed/simple;
	bh=66V7PYFxiVOdYw2D3BJVJJrWu9A0DxDp2SevYe43bMs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=npnIP6fJ6Y49zoQpEIp2DBzuvuPK8RFG/7mYX9iNnSjJUC2NmFCg1CMRq86fNYKaVL9FhNrgMwcVYT9SFiaOWPTnNgl9MOrkHxsVZId9LNmzascRmHKmeFNlcUdAeJLKE+Gh5474gLgy+ZRCg5rPI+N+hHWbPE4sTC+XSxishTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dLUyqnyh; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431884; x=1796967884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=66V7PYFxiVOdYw2D3BJVJJrWu9A0DxDp2SevYe43bMs=;
  b=dLUyqnyhOhlUxOn/o6hJ8p6JPZN41WNIc76Vd6QfauKFhLBtgvkvr/TX
   np39oMZVKSePK/hroalqCwhto+ySYkQQ6e02QbgjF5Mn1R5EUnonRAgEG
   OFM4izKtFeQmd9x91LpH9eaV9HI1AgVSkuOjOwo07IIDjk6VMX8OnFl8A
   OcKhnH/V/r1RnQBskGRpHNj8S/UVieKdQ3Gs0igFPZwk5HaHu2QPJ2siB
   J6VfCWB7cWrInHEp6YvpPBc81lMH9k+53YMf3igTzv8mz0pZjg8K9zwvk
   bRQYDt355BD1D5X9evUUkQUnwpg2ENh3WNDjGrboeqzu1qEXqnjNkEjwk
   w==;
X-CSE-ConnectionGUID: ugCuBcnVStC7BL+zsgcyIg==
X-CSE-MsgGUID: odBzxceCTdyudrJNsQ9/nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66410011"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66410011"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:44 -0800
X-CSE-ConnectionGUID: nIgW2W65SVa9JIbke47dJw==
X-CSE-MsgGUID: C7AtQXv+TOe0QXht/vYLUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366244"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:44:40 -0800
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
Subject: [PATCH v5 21/22] i386/tdx: Fix missing spaces in tdx_xfam_deps[]
Date: Thu, 11 Dec 2025 14:08:00 +0800
Message-Id: <20251211060801.3600039-22-zhao1.liu@intel.com>
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

The checkpatch.pl always complains: "ERROR: space required after that
close brace '}'".

Fix this issue.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index dbf0fa2c9180..a3444623657f 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -520,15 +520,15 @@ typedef struct TdxXFAMDep {
  * supported.
  */
 TdxXFAMDep tdx_xfam_deps[] = {
-    { XSTATE_YMM_BIT,       { FEAT_1_ECX, CPUID_EXT_FMA }},
-    { XSTATE_YMM_BIT,       { FEAT_7_0_EBX, CPUID_7_0_EBX_AVX2 }},
-    { XSTATE_OPMASK_BIT,    { FEAT_7_0_ECX, CPUID_7_0_ECX_AVX512_VBMI}},
-    { XSTATE_OPMASK_BIT,    { FEAT_7_0_EDX, CPUID_7_0_EDX_AVX512_FP16}},
-    { XSTATE_PT_BIT,        { FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT}},
-    { XSTATE_PKRU_BIT,      { FEAT_7_0_ECX, CPUID_7_0_ECX_PKU}},
-    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_BF16 }},
-    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_TILE }},
-    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_INT8 }},
+    { XSTATE_YMM_BIT,       { FEAT_1_ECX, CPUID_EXT_FMA } },
+    { XSTATE_YMM_BIT,       { FEAT_7_0_EBX, CPUID_7_0_EBX_AVX2 } },
+    { XSTATE_OPMASK_BIT,    { FEAT_7_0_ECX, CPUID_7_0_ECX_AVX512_VBMI } },
+    { XSTATE_OPMASK_BIT,    { FEAT_7_0_EDX, CPUID_7_0_EDX_AVX512_FP16 } },
+    { XSTATE_PT_BIT,        { FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT } },
+    { XSTATE_PKRU_BIT,      { FEAT_7_0_ECX, CPUID_7_0_ECX_PKU } },
+    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_BF16 } },
+    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_TILE } },
+    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_INT8 } },
 };
 
 static struct kvm_cpuid_entry2 *find_in_supported_entry(uint32_t function,
-- 
2.34.1


