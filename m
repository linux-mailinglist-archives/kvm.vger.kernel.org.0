Return-Path: <kvm+bounces-66458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCEBCD3BDC
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE17D3011400
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18182566F5;
	Sun, 21 Dec 2025 04:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YQ03DMPZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EF024DCEB;
	Sun, 21 Dec 2025 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291520; cv=none; b=IdcTjNoUbj/bc+2c2ZxTeIcPepmXT4MfmK5q6gHusfMYE75mC5ngAyoj9hQeED8ToPtq2IUFoIg/vEq49R8Uyg5Sj8G6BTJk8l9PHGDi4T+TjcfOkO0EXNqtaX5ViJvr9EssMmEkIPsU3s9Nngw4gzaTZwFyyIqeVhfRQPtk10g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291520; c=relaxed/simple;
	bh=/uNM4zNMn5icO82QU9552KoFxkN3gz0ZUeyiQnJC7zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZIC2Q9j+8aoKifEyzd1Z9Z1nSIWzp85yH+70WMT2rO7nYL2oO3Gr5jzj62oBjA9KouGb2notoLUUPBOL5g/SkicFZSMrzLhXG35n0YjVkx7MH4FeHf0GM0WkrT5ZCMMFSd4CS5LFrVvYsEJOa7IJ6VAn7dS+iSWPQn+2DBS9fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YQ03DMPZ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291519; x=1797827519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/uNM4zNMn5icO82QU9552KoFxkN3gz0ZUeyiQnJC7zg=;
  b=YQ03DMPZ5eLE70quFVQi0NMGWd2GeaAaU5ovH/OFT/ITknQ+k1z6Lgl6
   ehVzhJQ3D/M4t4z2JyR5nufb1Q3CTraWhclpOjbuETeQ2EoyxvaZ94Fg+
   jpOI+mJbUKn3NFirEhErIAbxaEuUKv+hAQoJtpou6M2s8aFg91rR+Kw1H
   CLmZ6FZ73/ztnf5N1+HUBTg8eUpoht8u4ROTkpG5HJAXmgzXiuQtTz2/8
   gHAyL/lme40up7Fd03kFMGzBE+YJkTkSVvd3PCSbEZqbQH7N5FOUYnJm2
   LH6epzmeJS07IfsxmBi7U1ZOF/KSlTh/BIrB4FChUL6ekc+McXnfRUGsS
   Q==;
X-CSE-ConnectionGUID: 65l9Hj1QSgmBoWq7w2AUTQ==
X-CSE-MsgGUID: KiMh0FUvSEi1UNe5aK31+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132448"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132448"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:58 -0800
X-CSE-ConnectionGUID: kF3pwhpzRAGSwyiYFZSw/g==
X-CSE-MsgGUID: JSB1ru6tRy+P3+q+o3YQxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229885093"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:58 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 16/16] KVM: x86: selftests: Add APX state handling and XCR0 sanity checks
Date: Sun, 21 Dec 2025 04:07:42 +0000
Message-ID: <20251221040742.29749-17-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that KVM exposes the APX feature to guests on APX-capable systems,
extend the selftests to validate XCR0 configuration and state management.

Since APX repurposes the XSAVE area previously used by MPX in the
non-compacted format, add a check to ensure that MPX states are not set
when APX is enabled.

Also, load non-init APX state data in the guest so that XSTATE_BV[APX] is
set, allowing validation of APX state testing.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
No change since last version
---
 .../selftests/kvm/include/x86/processor.h     |  1 +
 tools/testing/selftests/kvm/x86/state_test.c  |  6 ++++++
 .../selftests/kvm/x86/xcr0_cpuid_test.c       | 19 +++++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 57d62a425109..6a1da26780ea 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -88,6 +88,7 @@ struct xstate {
 #define XFEATURE_MASK_LBR		BIT_ULL(15)
 #define XFEATURE_MASK_XTILE_CFG		BIT_ULL(17)
 #define XFEATURE_MASK_XTILE_DATA	BIT_ULL(18)
+#define XFEATURE_MASK_APX		BIT_ULL(19)
 
 #define XFEATURE_MASK_AVX512		(XFEATURE_MASK_OPMASK | \
 					 XFEATURE_MASK_ZMM_Hi256 | \
diff --git a/tools/testing/selftests/kvm/x86/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
index f2c7a1c297e3..2b7aa4cca011 100644
--- a/tools/testing/selftests/kvm/x86/state_test.c
+++ b/tools/testing/selftests/kvm/x86/state_test.c
@@ -167,6 +167,12 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 			asm volatile ("vmovupd %0, %%zmm16" :: "m" (buffer));
 		}
 
+		if (supported_xcr0 & XFEATURE_MASK_APX) {
+			/* mov $0xcccccccc, %r16 */
+			asm volatile (".byte 0xd5, 0x18, 0xb8, 0xcc, 0xcc,"
+				      "0xcc, 0xcc, 0x00, 0x00, 0x00, 0x00");
+		}
+
 		if (this_cpu_has(X86_FEATURE_MPX)) {
 			uint64_t bounds[2] = { 10, 0xffffffffull };
 			uint64_t output[2] = { };
diff --git a/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
index d038c1571729..e3d3af5ab6f2 100644
--- a/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
@@ -46,6 +46,20 @@ do {									\
 		       __supported, (xfeatures));			\
 } while (0)
 
+/*
+ * Verify that mutually exclusive architectural features do not overlap.
+ * For example, APX and MPX must never be reported as supported together.
+ */
+#define ASSERT_XFEATURE_CONFLICT(supported_xcr0, xfeatures, conflicts)			\
+do {											\
+	uint64_t __supported = (supported_xcr0) & ((xfeatures) | (conflicts));		\
+											\
+	__GUEST_ASSERT((__supported & (xfeatures)) != (xfeatures) ||			\
+		       !(__supported & (conflicts)),					\
+		       "supported = 0x%lx, xfeatures = 0x%llx, conflicts = 0x%llx",	\
+		       __supported, (xfeatures), (conflicts));				\
+} while (0)
+
 static void guest_code(void)
 {
 	uint64_t initial_xcr0;
@@ -79,6 +93,11 @@ static void guest_code(void)
 	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
 				    XFEATURE_MASK_XTILE);
 
+	/* Check APX by ensuring MPX is not exposed concurrently */
+	ASSERT_XFEATURE_CONFLICT(supported_xcr0,
+				 XFEATURE_MASK_APX,
+				 XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+
 	vector = xsetbv_safe(0, XFEATURE_MASK_FP);
 	__GUEST_ASSERT(!vector,
 		       "Expected success on XSETBV(FP), got %s",
-- 
2.51.0


