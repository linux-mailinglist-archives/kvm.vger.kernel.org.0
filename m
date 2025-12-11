Return-Path: <kvm+bounces-65703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DD9CB4D25
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:52:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 130213022AA7
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C82292936;
	Thu, 11 Dec 2025 05:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NoU0M0NX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01DE288C20
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431845; cv=none; b=AT8uPSQVIKkQhTnAXYaprnJBxyrmd6yVlqDi9vjFw5VIjpGO/5uU6ktRrK2Sny0dD4MTw+Wjbit2BZlE+mrqaOeCRIzrkjvEr3hXnTDs9IXdcrOqoghHgZ9196FxXxEJOre0zNHFadIZDs/qt0q+63BvdZK97xnw7C21alcNsJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431845; c=relaxed/simple;
	bh=DZ3sfvrb+qc8GsNdFeIp7NVIUjHrM1Kf/7Vu9/XqA3o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DBOIy6rdQk/t8T58YL5tiqBn9xewJcWbXEXgGRsPgpjKlDOpMJZY7DeftAxM5bRJFMkkhraSqY+ykqc/9yptZSwdWGoOtaqU7svc1KiYETFzG4PWpwgzcs/SlTMAv2Mvr+OE2Zu7efhG0cz306xIXfccIlcqGdfyGIKl3ztFOL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NoU0M0NX; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431844; x=1796967844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DZ3sfvrb+qc8GsNdFeIp7NVIUjHrM1Kf/7Vu9/XqA3o=;
  b=NoU0M0NXQt112mno62ojSJwj6qLi+/RQGhzZsZcW1d1I6GK7r12NHzIM
   fvzWAO5XkiZRwseP8OGX5QmTENxcFdPX1VaQXrkaUhmDm+otsZ0EITSW4
   XpJFIO4VM/uJhNlVSSZoKseYdALt6YWaYfCBvgxSNOlv8i+YTVv4ZC6LH
   Cpx8DUToEuYqb1BqaBjRG6U/rxfJWKhpo0R31zuVEqK/sBqWsdVnyijFV
   z1UuQNstWhB/8HpTf/v2ogoqkkjfYFQa+HclHw1KfZ1lmRySZH/Ud8BpY
   mpMdEkbeMuGdCZfT/qKI93KqtZtbNHSnZ9ByiUQ4GXTzG9AtzlcuvpeBK
   Q==;
X-CSE-ConnectionGUID: cEmTfxiFTae07vQ6WEHDpA==
X-CSE-MsgGUID: scYzwicrRkyIex78DyTouA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409902"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409902"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:03 -0800
X-CSE-ConnectionGUID: QoC2Q5C0S7m/fEn5mdfr1g==
X-CSE-MsgGUID: FcG2oCBHSzGtD+rfLRUnwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366094"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:55 -0800
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
Subject: [PATCH v5 10/22] i386/cpu: Add missing migratable xsave features
Date: Thu, 11 Dec 2025 14:07:49 +0800
Message-Id: <20251211060801.3600039-11-zhao1.liu@intel.com>
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

Xtile-cfg & xtile-data are both user xstates. Their xstates are cached
in X86CPUState, and there's a related vmsd "vmstate_amx_xtile", so that
it's safe to mark them as migratable.

Arch lbr xstate is a supervisor xstate, and it is save & load by saving
& loading related arch lbr MSRs, which are cached in X86CPUState, and
there's a related vmsd "vmstate_arch_lbr". So it should be migratable.

PT is still unmigratable since KVM disabled it and there's no vmsd and
no other emulation/simulation support.

Note, though the migratable_flags get fixed,
x86_cpu_enable_xsave_components() still overrides supported xstates
bitmaps regardless the masking of migratable_flags. This is another
issue, and would be fixed in follow-up refactoring.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Mark XSTATE_ARCH_LBR_MASK as migratable in FEAT_XSAVE_XSS_LO.
 - Add TODO comment.
---
 target/i386/cpu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 859cb889a37c..d2a89c03caec 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1484,6 +1484,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             .ecx = 1,
             .reg = R_ECX,
         },
+        .migratable_flags = XSTATE_ARCH_LBR_MASK,
     },
     [FEAT_XSAVE_XSS_HI] = {
         .type = CPUID_FEATURE_WORD,
@@ -1522,7 +1523,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
             XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
             XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
-            XSTATE_PKRU_MASK,
+            XSTATE_PKRU_MASK | XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK,
     },
     [FEAT_XSAVE_XCR0_HI] = {
         .type = CPUID_FEATURE_WORD,
@@ -2154,8 +2155,13 @@ static uint64_t x86_cpu_get_migratable_flags(X86CPU *cpu, FeatureWord w)
     for (i = 0; i < 64; i++) {
         uint64_t f = 1ULL << i;
 
-        /* If the feature name is known, it is implicitly considered migratable,
-         * unless it is explicitly set in unmigratable_flags */
+        /*
+         * If the feature name is known, it is implicitly considered migratable,
+         * unless it is explicitly set in unmigratable_flags.
+         *
+         * TODO: Make the behavior of x86_cpu_enable_xsave_components() align
+         * with migratable_flags masking.
+         */
         if ((wi->migratable_flags & f) ||
             (wi->feat_names[i] && !(wi->unmigratable_flags & f))) {
             r |= f;
-- 
2.34.1


