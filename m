Return-Path: <kvm+bounces-60973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC0E3C04842
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A493BA546
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A54027E054;
	Fri, 24 Oct 2025 06:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lw+YGqq3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFFE271446
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287725; cv=none; b=U8KfUe/U/d+BT/RnJmn3+1T4SlFDB/3VUVAlv0udp9yph41xKlm6RHeX3BOBSncnd5u9l3amRrVftF0bm+eK6aak5ekexwkf0NtgAhLNZdmV1Skq6kqs2bmwYPf+hi1mFkAKriOe3KegKlmIKbio7Cbh3g2huGLd+oHTRL8H8QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287725; c=relaxed/simple;
	bh=sgS1MdtK61p+Dut1DBV3iMdRrcckU/yzr0CxPpWly1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F0EYlROR4pMHsIZNhTv6Awuf2hZxV2bxBO0AFC3zaMsI13MVN+Akjr2svDhsosN/c9Bi5SbXnww0EIXeD7CWZjz/+jFHHuMx3flC5BCX0T8caGOQLuUrWdM/1ACQ9u2vost8xTX0WPW0Vd328uyTNeBSuB6FIJmqbrGWc0UlFTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lw+YGqq3; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287725; x=1792823725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sgS1MdtK61p+Dut1DBV3iMdRrcckU/yzr0CxPpWly1Y=;
  b=Lw+YGqq3Xb+V+gk/Vj9wPXZeXDj/Gl+frqCoYjwZvyaWdLyK8xs9lOQi
   WAxHfTxFqvPAQ9rLuWqIZ8H28xRDj5Hed5aIUwnwq0hF3mvOnjCRk6W+J
   HcPHLkjirl0J42IufdtBHMe3JOG2l+lxZdo9mdb4CHCU839/+CMjGoolg
   GIe39SPDGmymazGF+j4hnYgSk0waxHGl4PUEVJ22KKoW9WU8cRUQCiayg
   QmoQzgQNY6JZGYYFgI3Tpn9PjB+8VSkEB80oWCLqyHdqKy0SbWSCnL0yP
   KvcQN2jbnKzQ7nwuzE7ziR4txNJfcLR9KaCTJkYDgH5+V84bAJu9Cp2n0
   g==;
X-CSE-ConnectionGUID: T48eGkBgROeJTk6kJFuSpQ==
X-CSE-MsgGUID: UKxXUeEaSjykTWMGF/qUug==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="86095595"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="86095595"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:24 -0700
X-CSE-ConnectionGUID: FR6f51c/RXCeG3lha77VCQ==
X-CSE-MsgGUID: qvEL48l6TRaSQqlowAbrIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184276091"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:35:21 -0700
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
Subject: [PATCH v3 12/20] i386/cpu: Add CET support in CR4
Date: Fri, 24 Oct 2025 14:56:24 +0800
Message-Id: <20251024065632.1448606-13-zhao1.liu@intel.com>
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

CR4.CET bit (bit 23) is as master enable for CET.
Check and adjust CR4.CET bit based on CET CPUIDs.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.h    |  7 ++++++-
 target/i386/helper.c | 12 ++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 7584cddb5917..86fbfd5e4023 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -257,6 +257,7 @@ typedef enum X86Seg {
 #define CR4_SMEP_MASK   (1U << 20)
 #define CR4_SMAP_MASK   (1U << 21)
 #define CR4_PKE_MASK   (1U << 22)
+#define CR4_CET_MASK   (1U << 23)
 #define CR4_PKS_MASK   (1U << 24)
 #define CR4_LAM_SUP_MASK (1U << 28)
 
@@ -274,7 +275,7 @@ typedef enum X86Seg {
                 | CR4_LA57_MASK \
                 | CR4_FSGSBASE_MASK | CR4_PCIDE_MASK | CR4_OSXSAVE_MASK \
                 | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
-                | CR4_LAM_SUP_MASK | CR4_FRED_MASK))
+                | CR4_LAM_SUP_MASK | CR4_FRED_MASK | CR4_CET_MASK))
 
 #define DR6_BD          (1 << 13)
 #define DR6_BS          (1 << 14)
@@ -2945,6 +2946,10 @@ static inline uint64_t cr4_reserved_bits(CPUX86State *env)
     if (!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED)) {
         reserved_bits |= CR4_FRED_MASK;
     }
+    if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) &&
+        !(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT)) {
+        reserved_bits |= CR4_CET_MASK;
+    }
     return reserved_bits;
 }
 
diff --git a/target/i386/helper.c b/target/i386/helper.c
index 72b2e195a31e..3f179c6c11f8 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -232,6 +232,18 @@ void cpu_x86_update_cr4(CPUX86State *env, uint32_t new_cr4)
         new_cr4 &= ~CR4_LAM_SUP_MASK;
     }
 
+    /*
+     * In fact, "CR4.CET can be set only if CR0.WP is set, and it must be
+     * clear before CR0.WP can be cleared". However, here we only check
+     * CR4.CET based on the supported CPUID CET bit, without checking the
+     * dependency on CR4.WP - the latter need to be determined by the
+     * underlying accelerators.
+     */
+    if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) &&
+        !(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT)) {
+        new_cr4 &= ~CR4_CET_MASK;
+    }
+
     env->cr[4] = new_cr4;
     env->hflags = hflags;
 
-- 
2.34.1


