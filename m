Return-Path: <kvm+bounces-60976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A13F5C0484B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F17861A06789
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4522798F3;
	Fri, 24 Oct 2025 06:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mNKtYg6N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D030A279346
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287739; cv=none; b=XeMGMfSrhIXlW3qS/o4GInahbavUrgf4SkxjvogDwNAlS4c86WYhhCwsplW3cb/+C3w6AQp+EnRr2bdEcdw4xqfJ7KLbxMBn6NO6I1DbSlikrnXMepkr1CQjoB5WTZJfl7C0YhMOvailuf2Ryczi72N10xU3k0nGa847tcLStIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287739; c=relaxed/simple;
	bh=8+D0ZyMJP774a0QzTHB9HaDDjW9x92tncQIYwGtlWcM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BTpxz0dunJ0YwkfVWrDHXq1b3D8chbCFqaBl5n5rXx6dBSKlmr6M+hqPDFE1LciWZoHvm7wh6+s7nE2nwGXEQv5K1LPy1GRKgGYgh2MDJvF1r1XrCAVQ9seulzKDjxVEaljfem9FPMqGExgDh5RP2lsqSu/sA2CZ7+rSdGc8Fdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mNKtYg6N; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287738; x=1792823738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8+D0ZyMJP774a0QzTHB9HaDDjW9x92tncQIYwGtlWcM=;
  b=mNKtYg6NV9mwGfOkhgDn2sAWC+qgXFctfObQR6vUU+T2lozAQapx+ykx
   4Tokw0As1vTwVoe5E9IktPH5ePrHMz8+HtbvIieC6fqGtLsyJrLAWUjxj
   myuTYZaDmxou6/K4dNMrjMTPQ1hiFfCXZqwg3Bklo1yakIYTMMk/RFxKW
   NrAlL3e3iCA2RiNkRjT+Zqd9rxESbl8UtA04aaEsl3QgG6xZov4rPF5+e
   XjVP61IX7LUfoyf3PnYQjtdY7SQet5Y9vXP2CV0PfI9M2R/mxvo9lapbx
   1M8DyM0qlxbhoX8ifkfgj9lpUBbHU/abtJHBn0jWJQsaS+hJWlT+mmoWS
   w==;
X-CSE-ConnectionGUID: IZEH5RVgQRS2u/sbQK/44g==
X-CSE-MsgGUID: ZJofgfujR22NIXYFsIl+4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62675697"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="62675697"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:37 -0700
X-CSE-ConnectionGUID: WloA9umMSkm/n6Cz1qupVg==
X-CSE-MsgGUID: LIouHQykSIytxUQS4lRFKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184276114"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:35:33 -0700
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
	Zhao Liu <zhao1.liu@intel.com>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 15/20] i386/machine: Add vmstate for cet-ss and cet-ibt
Date: Fri, 24 Oct 2025 14:56:27 +0800
Message-Id: <20251024065632.1448606-16-zhao1.liu@intel.com>
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

From: Yang Weijiang <weijiang.yang@intel.com>

Add vmstates for cet-ss and cet-ibt

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v2:
 - Split a subsection "vmstate_ss" since shstk is user-configurable.
---
 target/i386/machine.c | 53 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 45b7cea80aa7..3ad07ec82428 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1668,6 +1668,58 @@ static const VMStateDescription vmstate_triple_fault = {
     }
 };
 
+static bool shstk_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return !!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK);
+}
+
+static const VMStateDescription vmstate_ss = {
+    .name = "cpu/cet_ss",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = shstk_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.pl0_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl1_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl2_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl3_ssp, X86CPU),
+#ifdef TARGET_X86_64
+        /* This MSR is only present on Intel 64 architecture. */
+        VMSTATE_UINT64(env.int_ssp_table, X86CPU),
+#endif
+        VMSTATE_UINT64(env.guest_ssp, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static bool cet_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return !!((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) ||
+              (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT));
+}
+
+static const VMStateDescription vmstate_cet = {
+    .name = "cpu/cet",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = cet_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.u_cet, X86CPU),
+        VMSTATE_UINT64(env.s_cet, X86CPU),
+        VMSTATE_END_OF_LIST()
+    },
+    .subsections = (const VMStateDescription * const []) {
+        &vmstate_ss,
+        NULL,
+    },
+};
+
 const VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1817,6 +1869,7 @@ const VMStateDescription vmstate_x86_cpu = {
 #endif
         &vmstate_arch_lbr,
         &vmstate_triple_fault,
+        &vmstate_cet,
         NULL
     }
 };
-- 
2.34.1


