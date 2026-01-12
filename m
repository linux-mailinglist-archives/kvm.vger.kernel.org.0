Return-Path: <kvm+bounces-67869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 757B9D15F6F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 630DF3042682
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3504B285061;
	Tue, 13 Jan 2026 00:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T8aMSpjK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298212820A4;
	Tue, 13 Jan 2026 00:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263532; cv=none; b=ukC2PkrkmAKDah6sW0B49bQZipdnpp/meIdkVI5FPQQ/hLm9olEAm+7q++xAuTLhh7OxwAVfK1x5o6lM5vX4UhIIeEPxJZR+iVGEEFSy0ZYCvXc+d39ceT3IFsQzqdToOQQc8cmyKmuvfCcxkhPiYLGM12DuMr9iRX9M3eS2PSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263532; c=relaxed/simple;
	bh=glWO4Z8UhpJ/AH4HU6aO6QGGcEpfBBcGO8VC92sBFuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+K2EggxpUhYYVooaJGd7SGyPaI1xElUZ9l7yqI1dGHZNx/d/z+U3f1rSZkepzOcfq/WLCal9c0C46Kb36JCx4+JB/lDNPZbiMKH3FjPomO2amOvQfEXBGDsbVCbCmLxzcMoWVmuEeRHbXS5Spabadoha/y4zP0aOzhoZdDu5q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T8aMSpjK; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263531; x=1799799531;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=glWO4Z8UhpJ/AH4HU6aO6QGGcEpfBBcGO8VC92sBFuY=;
  b=T8aMSpjKh0fCzy0HnV1b7ahKJojZF1pXE55LC9NqQtfR1fhtFZuypQGb
   uiGGsdG088FO19+BVgu+PPICcLcBycukPbslrcAT0kdSIcRpJS65rfT8l
   Xx3/ecc1cY9QWF4m4qCcsFLmiRJYDIGq0sfiEtaEqERXWvKmlT2Z0YWlK
   9cUF0Zn96hqODIFrLOjA+z1dj9TnEaVOviwW7V0pNsIy12oPZ0u2gnek9
   /mv3tzcizJ66KXjrnDbgwfCUQyKCRQCnFHP58tCB6TsreHHuDmGbufMQH
   KgwQ3jVtsW/ctdHK6F9frVir/QA5XwRuOCr2tAEgi+q59G0NJAFgUGDRM
   Q==;
X-CSE-ConnectionGUID: D6c8BrGySpu0Vy35/BtlUg==
X-CSE-MsgGUID: DYCXNNscTnGcbnsosFSa/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264297"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264297"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:51 -0800
X-CSE-ConnectionGUID: OA0hqec9RZChdO+rZkuABA==
X-CSE-MsgGUID: f6MsPvVEQXiICZUzNUNHhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042322"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:51 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 16/16] KVM: x86: selftests: Add APX state handling and XCR0 sanity checks
Date: Mon, 12 Jan 2026 23:54:08 +0000
Message-ID: <20260112235408.168200-17-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112235408.168200-1-chang.seok.bae@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
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


