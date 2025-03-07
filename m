Return-Path: <kvm+bounces-40358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C67AA56E20
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:43:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A11843B3A03
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13D6B24502F;
	Fri,  7 Mar 2025 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KMKCWsuR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF5224397F;
	Fri,  7 Mar 2025 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365563; cv=none; b=QPNdgXVfcIKQvcUBnBTRAQkJ1Lq4AllZ0sJXO0lnLrNCaWvXd4OIFMpWVLjb1a4YtrgD9AJ+12UBZuuJJfcTvKwdlDRLkWw+Tth/EStEG3fqv4c60ohPfzy+srD0qJLRbkMb/lmBoctQBoLYNtzs67rLYsWBfviKhG15e+nBhbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365563; c=relaxed/simple;
	bh=2lNXb9//3K3UmeWMThfbiW/TPoU8C963Y+MDaVEOVjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGRtHeKzb3lXC9jkx6usOtD55qkaUnMmMJnfC0ELE6aeLHHpAp3Y7YO+W8eijOELUe9p2zhY4uOEBPgxudETTR4BZuSTpphThHNwFS3kCiquuRwNU3ds1ycEhAhBtLBEDv4ubVujj1VdMmuRHN5zfm+ifCkWrLa/mgAilyQtnso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KMKCWsuR; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741365561; x=1772901561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2lNXb9//3K3UmeWMThfbiW/TPoU8C963Y+MDaVEOVjc=;
  b=KMKCWsuREdFMJoQ4c8SlqoQjXa11cpcdq4WyC3PanTlhRrUY+XxoqFYK
   kpY8HnmqEwXcng3g/qBct/wHnkRM7jU8NANB2puLgJDHIWZ43faqH7rq1
   vAG6BRPzAIQ596DvhmY6ZAjuIZTGlIzx6ga4yh5vzBaL8jYwa0UXb/2oA
   aUoSVVLaL7SRFiBOa+3kC2yIdhGenWKn8tl9AYS28TqpfBNXF8/gck4Ig
   lJy2DevPvv0McnZZrmSIAIpJ1JlvtbQm7AXi2RbVSObEAkGfX4KIOzBFM
   ko4Z4zmRCNUrb1FJR5mV9O+5G9Imklw/RzAAIFXkkadA5eMJq7GPUmUC7
   w==;
X-CSE-ConnectionGUID: 4eOpIVwdTRyc31yzplb7dw==
X-CSE-MsgGUID: r4iG4hrhTA6lFjEMC1pthQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46344463"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46344463"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:21 -0800
X-CSE-ConnectionGUID: Fum/a9n2T3eziRDlgHkakQ==
X-CSE-MsgGUID: nn7+w3+vR1Kk1NM8A36dxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124397989"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:18 -0800
From: Chao Gao <chao.gao@intel.com>
To: chao.gao@intel.com,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 08/10] x86/fpu/xstate: Add CET supervisor xfeature support
Date: Sat,  8 Mar 2025 00:41:21 +0800
Message-ID: <20250307164123.1613414-9-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250307164123.1613414-1-chao.gao@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

To support CET virtualization, KVM needs the kernel to save/restore CET
supervisor xstate in guest FPUs when switching between guest and host
FPUs.

Add CET supervisor xstate (i.e., XFEATURE_CET_KERNEL) support. Both the
guest FPU and the kernel FPU will allocate memory for the new xstate.
For the guest FPU, the xstate remains unused until the upcoming CET
virtualization is added to KVM. For the kernel FPU, the xstate is unused
until CET_S is enabled within the kernel.

Note CET_S may or may not be enabled within the kernel, so always
allocating memory for XFEATURE_CET_KERNEL could potentially waste some
XSAVE buffer space. If necessary, this issue can be addressed by making
XFEATURE_CET_KERNEL a guest-only feature.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/fpu/types.h  | 14 ++++++++++++--
 arch/x86/include/asm/fpu/xstate.h |  6 +++---
 arch/x86/kernel/fpu/xstate.c      |  6 +++++-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index d9515d7f65e4..eb034b7ab8c0 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -118,7 +118,7 @@ enum xfeature {
 	XFEATURE_PKRU,
 	XFEATURE_PASID,
 	XFEATURE_CET_USER,
-	XFEATURE_CET_KERNEL_UNUSED,
+	XFEATURE_CET_KERNEL,
 	XFEATURE_RSRVD_COMP_13,
 	XFEATURE_RSRVD_COMP_14,
 	XFEATURE_LBR,
@@ -141,7 +141,7 @@ enum xfeature {
 #define XFEATURE_MASK_PKRU		(1 << XFEATURE_PKRU)
 #define XFEATURE_MASK_PASID		(1 << XFEATURE_PASID)
 #define XFEATURE_MASK_CET_USER		(1 << XFEATURE_CET_USER)
-#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL_UNUSED)
+#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL)
 #define XFEATURE_MASK_LBR		(1 << XFEATURE_LBR)
 #define XFEATURE_MASK_XTILE_CFG		(1 << XFEATURE_XTILE_CFG)
 #define XFEATURE_MASK_XTILE_DATA	(1 << XFEATURE_XTILE_DATA)
@@ -266,6 +266,16 @@ struct cet_user_state {
 	u64 user_ssp;
 };
 
+/*
+ * State component 12 is Control-flow Enforcement supervisor states
+ */
+struct cet_supervisor_state {
+	/* supervisor ssp pointers  */
+	u64 pl0_ssp;
+	u64 pl1_ssp;
+	u64 pl2_ssp;
+};
+
 /*
  * State component 15: Architectural LBR configuration state.
  * The size of Arch LBR state depends on the number of LBRs (lbr_depth).
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 7f39fe7980c5..8990cf381bef 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -47,7 +47,8 @@
 
 /* All currently supported supervisor features */
 #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
-					    XFEATURE_MASK_CET_USER)
+					    XFEATURE_MASK_CET_USER | \
+					    XFEATURE_MASK_CET_KERNEL)
 
 /*
  * A supervisor state component may not always contain valuable information,
@@ -74,8 +75,7 @@
  * Unsupported supervisor features. When a supervisor feature in this mask is
  * supported in the future, move it to the supported supervisor feature mask.
  */
-#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT | \
-					      XFEATURE_MASK_CET_KERNEL)
+#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT)
 
 /* All supervisor states including supported and unsupported states. */
 #define XFEATURE_MASK_SUPERVISOR_ALL (XFEATURE_MASK_SUPERVISOR_SUPPORTED | \
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 58325b3b8914..12613ebdbb5d 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -55,7 +55,7 @@ static const char *xfeature_names[] =
 	"Protection Keys User registers",
 	"PASID state",
 	"Control-flow User registers",
-	"Control-flow Kernel registers (unused)",
+	"Control-flow Kernel registers",
 	"unknown xstate feature",
 	"unknown xstate feature",
 	"unknown xstate feature",
@@ -78,6 +78,7 @@ static unsigned short xsave_cpuid_features[] __initdata = {
 	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
 	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
 	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
+	[XFEATURE_CET_KERNEL]			= X86_FEATURE_SHSTK,
 	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
 	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
 };
@@ -283,6 +284,7 @@ static void __init print_xstate_features(void)
 	print_xstate_feature(XFEATURE_MASK_PKRU);
 	print_xstate_feature(XFEATURE_MASK_PASID);
 	print_xstate_feature(XFEATURE_MASK_CET_USER);
+	print_xstate_feature(XFEATURE_MASK_CET_KERNEL);
 	print_xstate_feature(XFEATURE_MASK_XTILE_CFG);
 	print_xstate_feature(XFEATURE_MASK_XTILE_DATA);
 }
@@ -352,6 +354,7 @@ static __init void os_xrstor_booting(struct xregs_state *xstate)
 	 XFEATURE_MASK_BNDCSR |			\
 	 XFEATURE_MASK_PASID |			\
 	 XFEATURE_MASK_CET_USER |		\
+	 XFEATURE_MASK_CET_KERNEL |		\
 	 XFEATURE_MASK_XTILE)
 
 /*
@@ -552,6 +555,7 @@ static bool __init check_xstate_against_struct(int nr)
 	case XFEATURE_PASID:	  return XCHECK_SZ(sz, nr, struct ia32_pasid_state);
 	case XFEATURE_XTILE_CFG:  return XCHECK_SZ(sz, nr, struct xtile_cfg);
 	case XFEATURE_CET_USER:	  return XCHECK_SZ(sz, nr, struct cet_user_state);
+	case XFEATURE_CET_KERNEL: return XCHECK_SZ(sz, nr, struct cet_supervisor_state);
 	case XFEATURE_XTILE_DATA: check_xtile_data_against_struct(sz); return true;
 	default:
 		XSTATE_WARN_ON(1, "No structure for xstate: %d\n", nr);
-- 
2.46.1


