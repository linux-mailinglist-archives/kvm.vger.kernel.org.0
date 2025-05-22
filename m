Return-Path: <kvm+bounces-47385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A06AC0F8E
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:11:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D29C5A41FBE
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C75F290BCC;
	Thu, 22 May 2025 15:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cmzvo5Z4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABCA28FFF0;
	Thu, 22 May 2025 15:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926644; cv=none; b=LExZZTBdDyZ2Cc/DuQu9HM1n2nJv55lGHbgDyHd1v/lYVlmyoSJYuVA/TJ7EhrDOe45okzvIQkuZRxxBDLfjANwVPxVq/1qGnJrDGtay2DljFRZ5wh1wy0WQD026s9JEoXdUJ+PQXWVRxqD+II/ip365VAL6fvZz+P5BsEICD8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926644; c=relaxed/simple;
	bh=ZCWTG8k//Yf0VlgdUB1ffPihLYI2QfHtharumNInnA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjN0G5Qo1faIZ3WCpNuunDz/6iOGqV8eLu6ov06oUVOLrL46gEeR/vStibf4p3l2AHcNq34BCV9fngxeXLEdkH4n3WvoEDDHnW8YjGypmVFwyY3OHCiNVPIwXw6K/zR0EXxFXF+HArDkPiuU3NrLsDd4rMlFioY1uziwh+bY17c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cmzvo5Z4; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747926643; x=1779462643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZCWTG8k//Yf0VlgdUB1ffPihLYI2QfHtharumNInnA4=;
  b=Cmzvo5Z4V6ai0oPuzXqkgU+Cp0ZxB/Pyd0TRdL1IcGpAqHpsvWWIfnpL
   hIgpbPUVKyUI3/BfrQfwS44yOEt+7ybVfKPaZuBp6OgH0JuCHbldTtOQI
   sccVUp1TGN9RSFcah1EN+PAzQ+fQSSrbe3UhIelUtimuut7bRS4Qf+T57
   02fM4LPw01EqWhHoc52vn3FJcx4iYYTGBtimTYmTgmOxZkV2NaUcDtu7A
   l7NbAm4F9bSr11TNuz2U2BjiAPvXN/q8qIgEkHaaOuzRApsOc74zNEG/q
   AvMq7VukU/mknaDo35vpWUrEwrqYraY/ZygWFsVD3MH5WjvbaKq8QHBLk
   Q==;
X-CSE-ConnectionGUID: skPkOL8wS9q69n7i6maucA==
X-CSE-MsgGUID: 3/P/MK7lSTiC7nVrnue7QA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="61006684"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="61006684"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:42 -0700
X-CSE-ConnectionGUID: wRo1B/+4SgeJQSblCmpf9g==
X-CSE-MsgGUID: NV9UzX07St+XkuGHGba+7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="171627618"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:41 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Stanislav Spassov <stanspas@amazon.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH v8 3/6] x86/fpu: Initialize guest fpstate and FPU pseudo container from guest defaults
Date: Thu, 22 May 2025 08:10:06 -0700
Message-ID: <20250522151031.426788-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250522151031.426788-1-chao.gao@intel.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
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
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v8: tweak comment in __fpstate_reset() (Sean)
v7: tweak __fpstate_reset() instead of adding a guest-specific reset
    function (Sean/Dave)
v6: Drop vcpu_fpu_config.user_* (Rick)
v5: init is_valloc/is_guest in the guest-specific reset function
(Chang)
---
 arch/x86/kernel/fpu/core.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index c69432d0ee41..a5a9c55fcf83 100644
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
@@ -535,10 +538,22 @@ void fpstate_init_user(struct fpstate *fpstate)
 
 static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
 {
-	/* Initialize sizes and feature masks */
-	fpstate->size		= fpu_kernel_cfg.default_size;
+	/*
+	 * Supervisor features (and thus sizes) may diverge between guest
+	 * FPUs and host FPUs, as some supervisor features are supported
+	 * for guests despite not being utilized by the host. User
+	 * features and sizes are always identical, which allows for
+	 * common guest and userspace ABI.
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


