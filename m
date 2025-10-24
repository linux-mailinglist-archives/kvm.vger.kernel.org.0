Return-Path: <kvm+bounces-60980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0B5C04875
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5959A188597B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0979027E05F;
	Fri, 24 Oct 2025 06:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q5iDjGGV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DC627BF6C
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287753; cv=none; b=EQgLkNGUsLGySUmxfi6rShDsJeMBBtFDFoDtPxu6LqhRc57ve44J45L5YsXQmThz1TMHgoVYqt2khqgZ34hVUDc2s2G8EaMFW62kevLcXpe5C7Wf+pNoytkOmxQ6MUeG/P8dQun/rlGdlwAJwlMR3l9rRvqOPVj1eLJxj/jXJkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287753; c=relaxed/simple;
	bh=iT6pGek/T2hADwOEBibyNy2m4pKMn1dzTaK0Ge2+9QU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PzBl+LPLUMgltBi3o0HHm8fSea1rGOdD3mXgatWF5xqX3TWy58W7sDRoQOV3Zq1hy9vwZtAUHk3ErKvmaD4pBXKJjgum+wLsi7PjhevKGOtfv1i2couPOka3wrOnbHDPX1HNK03vzr/5qPuGOG5rBDUBJJsxZHvleklvvNCowZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q5iDjGGV; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287752; x=1792823752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iT6pGek/T2hADwOEBibyNy2m4pKMn1dzTaK0Ge2+9QU=;
  b=Q5iDjGGVXHx1N9QjQilTmcBht5iYAlCr1uzTd/URrWYGT21K1hcyFkIj
   mwUz8UwJrDcbXLt9BkrD6GVK1dwXDBWAl0lJ/Y89nra3yct9p4pOkUo4t
   QjthkI3tEzxCf6CXJJNFnVRf0NHliK8haf7ISDdvu8lVbo2nFZXd122Nq
   wD2n2O4Z+Y6oQrQBW0GLs3WsX84kpFqO6ZFDe/AlVchbk0jSx+Z2eZZFw
   /oe74qV+Mh8qPQzrtWob+clP4NfiiFxHW/hfB/QnF8UdK4M07r78L7aZQ
   ltPLKYLBSc4q4PlZuATNHQ29avDfD/Y+g2GHVPYObPHa7d8RG+NflQwdN
   A==;
X-CSE-ConnectionGUID: rMoLkObXQtiQ9TRlyhn+bw==
X-CSE-MsgGUID: tZ1fhZfrRbaIP2gaXPDJmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62675707"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="62675707"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:52 -0700
X-CSE-ConnectionGUID: 6/Du4PsrQKecWwQXOAn6HQ==
X-CSE-MsgGUID: 76V0wjcmSm6iWeeDdSD99g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184276158"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:35:48 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 19/20] i386/tdx: Fix missing spaces in tdx_xfam_deps[]
Date: Fri, 24 Oct 2025 14:56:31 +0800
Message-Id: <20251024065632.1448606-20-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024065632.1448606-1-zhao1.liu@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
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


