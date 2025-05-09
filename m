Return-Path: <kvm+bounces-46024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE63AB0CE8
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E94681C07A5C
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DBC270547;
	Fri,  9 May 2025 08:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wza7iiNG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34309213227;
	Fri,  9 May 2025 08:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746778512; cv=none; b=Rmo9jT7S0I1yzJwkdEcOQqLyucYfad2sbpnkQJ8qexl3uJBN5t/vyu5f4wYV4b7U2+6EBtuFisFLca7TpT4KJdkzC81VRFlS42ZkWTdZRtuHwC9twU+xIFDrw5StFzJ6r63PYwUQ5zd6GZ0cVObhx09X+YjAWUjvUO2MmgGxWPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746778512; c=relaxed/simple;
	bh=tV9q/voi5DA2mugf5pvM2o54i1Yl4qptuRIVboquVV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDayQI3DkSL4mtMH2E8KzAdcgv7KhiSxCMKin60UmLUgTPiUys/2Kj0pzAk6ii3T2RYr88kkHrtJ9PEQ3sp6jIVjUg5hDB+1jAVgfR5lvf3j1drjbe9ogE9Aqs1ZBzh/eoGArMFpsyzAvMBmti+mtTObZvFXMng4q7HBriWUfls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wza7iiNG; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746778510; x=1778314510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tV9q/voi5DA2mugf5pvM2o54i1Yl4qptuRIVboquVV8=;
  b=Wza7iiNGVW6HiLcGjbDJE5GyJ7CXUcXFkVVwSqyg8kzMsbR4lZDznwuy
   C2NNAiMHxTD9SrSen+hBMn3LIfFz+2chRFt5UpEUPfD7Q3CKQHPiG7xuJ
   jLZRw2Ihh2gmm4yr8qBg/HyKdN2DIyLOZ81LVY2fvJxGcgnj+CowYfxq3
   8KrE3lGqF83BiNKtWARihLl+qOGaVLH6kYY7c1iMRFCgWrv6AVBVWDgee
   vCwOEhmUklYlBxOUe9plaqxyttHbyyShcldlZYQM8McYzHKPxKgrZkX82
   pGPq/oAAGlAGa/L0ywh7AyhiOKsLm1oKsGQQc55V2DVLq5ce6o85/KDJQ
   A==;
X-CSE-ConnectionGUID: YL7wcVEcQT+HI2SnfcZWbA==
X-CSE-MsgGUID: TKbQUiO1SbmEjh0z8dNlEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="59941890"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="59941890"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 01:15:09 -0700
X-CSE-ConnectionGUID: PpAKtjgMQEOPLOZysdjaJg==
X-CSE-MsgGUID: AvO+QaWPTUSDu+4CY+Xeuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141766944"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 01:15:09 -0700
From: Chao Gao <chao.gao@intel.com>
To: chao.gao@intel.com
Cc: bp@alien8.de,
	chang.seok.bae@intel.com,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ebiggers@google.com,
	hpa@zytor.com,
	john.allen@amd.com,
	kees@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	oleg@redhat.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	stanspas@amazon.de,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin3.li@intel.com
Subject: [PATCH v6a 5/8] x86/fpu: Initialize guest fpstate and FPU pseudo container from guest defaults
Date: Fri,  9 May 2025 01:14:58 -0700
Message-ID: <20250509081458.248875-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250506093740.2864458-6-chao.gao@intel.com>
References: <20250506093740.2864458-6-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fpu_alloc_guest_fpstate() currently uses host defaults to initialize guest
fpstate and pseudo containers. Guest defaults were introduced to
differentiate the features and sizes of host and guest FPUs. Switch to
using guest defaults instead.

Adjust __fpstate_reset() to handle different defaults for host and guest
FPUs. And to distinguish between the types of FPUs, move the initialization
of indicators (is_guest and is_valloc) before the reset.

Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v6a: tweak __fpstate_reset() instead of adding a guest-specific reset
     function (Sean/Dave)
v6: Drop vcpu_fpu_config.user_* (Rick)
v5: init is_valloc/is_guest in the guest-specific reset function
(Chang)

Note: this quick revision is just intended to ensure that the feedback
has been properly addressed.

 arch/x86/kernel/fpu/core.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 444e517a8648..0d501bd25d79 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -236,19 +236,22 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	struct fpstate *fpstate;
 	unsigned int size;
 
-	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	size = guest_default_cfg.size + ALIGN(offsetof(struct fpstate, regs), 64);
+
 	fpstate = vzalloc(size);
 	if (!fpstate)
 		return false;
 
+	/* Initialize indicators to reflect properties of the fpstate */
+	fpstate->is_valloc	= true;
+	fpstate->is_guest	= true;
+
 	/* Leave xfd to 0 (the reset value defined by spec) */
 	__fpstate_reset(fpstate, 0);
 	fpstate_init_user(fpstate);
-	fpstate->is_valloc	= true;
-	fpstate->is_guest	= true;
 
 	gfpu->fpstate		= fpstate;
-	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
+	gfpu->xfeatures		= guest_default_cfg.features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
@@ -535,10 +538,20 @@ void fpstate_init_user(struct fpstate *fpstate)
 
 static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
 {
-	/* Initialize sizes and feature masks */
-	fpstate->size		= fpu_kernel_cfg.default_size;
+	/*
+	 * Initialize sizes and feature masks. Supervisor features and
+	 * sizes may diverge between guest FPUs and host FPUs, whereas
+	 * user features and sizes are always identical the same.
+	 */
+	if (fpstate->is_guest) {
+		fpstate->size		= guest_default_cfg.size;
+		fpstate->xfeatures	= guest_default_cfg.features;
+	} else {
+		fpstate->size		= fpu_kernel_cfg.default_size;
+		fpstate->xfeatures	= fpu_kernel_cfg.default_features;
+	}
+
 	fpstate->user_size	= fpu_user_cfg.default_size;
-	fpstate->xfeatures	= fpu_kernel_cfg.default_features;
 	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
 	fpstate->xfd		= xfd;
 }
-- 
2.47.1


