Return-Path: <kvm+bounces-65710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 050CCCB4D07
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B0B1430019DF
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67A32C0F7B;
	Thu, 11 Dec 2025 05:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cneyof7Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE9A2C033C
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431871; cv=none; b=eaEOalpDAFUExG8WReBa9AkrrCHfkNGb3HqkICuNU74ghfOfHbwVli/oUvuUIS61hoIQCDbfxmmT3kxu/+V+DANDakLCMIdxnKJkuRrmWIFte9Ge3fC9xbW4E61PVmipjMuXc4ktNfCuJ37r5636wS/Ot1xF5o7lmcHZRd+MTQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431871; c=relaxed/simple;
	bh=+ZmFX9Wa38QCyJDA999eLfSD8lk8eMMUymD4mrIN4hM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S7Su5dIOdP4un/so0g3hIsDU0l/hmhVU03r3yUw/F15qowPSgLx43/19Q7CXz6EMn9KuZ88wmHJCKNgfTWw3w0N7fJ1So+sELByHvJPm89eYDVzmPkwmnvUycq88LM15uYyZeo0ub3+zWHMyU6rWFp1RGxizuAzwQ+33CAjJMnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cneyof7Y; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431870; x=1796967870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+ZmFX9Wa38QCyJDA999eLfSD8lk8eMMUymD4mrIN4hM=;
  b=Cneyof7YFZtFTTdTWgkOZnm4YlrkITuxp4j76vaZn7S3bDjFbCQJXp4j
   C6AKOgELxEhGgxlf1oYVr7FpwFLoOwITRW/wPGyWHAaaYPC4Pz8vuk3E3
   E8tSYF/modQHewa+OUY5BPHJgxZMpMpSyITgaJey/eFnvnD+Uc89hImZX
   2Grbr9/7zjv1rATGKMjrN5GDZ/0Ca/BMfwy7Iw2aJzh+Eni6aKc6erwHZ
   uz1cthvx2iNNB/v7+dnoep2q5RarJ1dBXW3s2p84XvpCfqULga76SN80r
   oSORDaDWMuoApJagzPNNYqQSQmJn84h87Ojqm8dbBG3GTPgFcXOGEeqU8
   w==;
X-CSE-ConnectionGUID: oXQizk9CRouDSLy4XsmCtQ==
X-CSE-MsgGUID: TEKRyGXcSxqz+P0R0bKTHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409964"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409964"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:29 -0800
X-CSE-ConnectionGUID: TS62/0xTR5a67qTvb29dgA==
X-CSE-MsgGUID: MGBlX1B5Q6qEzhBLIXLPYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366216"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:44:25 -0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 17/22] i386/machine: Add vmstate for cet-shstk and cet-ibt
Date: Thu, 11 Dec 2025 14:07:56 +0800
Message-Id: <20251211060801.3600039-18-zhao1.liu@intel.com>
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

From: Yang Weijiang <weijiang.yang@intel.com>

Add vmstates for cet-shstk and cet-ibt

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Rename vmstate_ss to vmstate_shstk.
 - Split pl0_ssp into a seperate vmstate in another patch.

Changes Since v2:
 - Split a subsection "vmstate_ss" since shstk is user-configurable.
---
 target/i386/machine.c | 52 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index bf13f7f0f66e..57a968c30db3 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1690,6 +1690,57 @@ static const VMStateDescription vmstate_pl0_ssp = {
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
+static const VMStateDescription vmstate_shstk = {
+    .name = "cpu/cet_shstk",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = shstk_needed,
+    .fields = (VMStateField[]) {
+        /* pl0_ssp has been covered by vmstate_pl0_ssp. */
+        VMSTATE_UINT64(env.pl1_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl2_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl3_ssp, X86CPU),
+#ifdef TARGET_X86_64
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
+        &vmstate_shstk,
+        NULL,
+    },
+};
+
 const VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1840,6 +1891,7 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_arch_lbr,
         &vmstate_triple_fault,
         &vmstate_pl0_ssp,
+        &vmstate_cet,
         NULL
     }
 };
-- 
2.34.1


