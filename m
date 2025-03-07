Return-Path: <kvm+bounces-40355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0EDA56E16
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:42:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAE333B9D57
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D039E23E25D;
	Fri,  7 Mar 2025 16:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lokZoY8j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBF1241683;
	Fri,  7 Mar 2025 16:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365552; cv=none; b=mKDZbMHJ6D/XDSFYrMSeevIynl9jKhmANIPiDmjWnNGT48nDwhN+ZCww3U+2F7LTScGlrTKpxiA9xNMiX2E0UyiLpOl9so+B7FaW2b0JT/il+hGBr2Kq805iN/sliSwImhNlitThYn6phQn4UkT6SeUkAGlVDuZSADdLv9yOHQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365552; c=relaxed/simple;
	bh=8w57i76C3y8iVjitfnDz5uyKl82BBPaB775SZiY6bcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Brun9JbZe8ayM2/qwr1Fw7YJdgbalmM03jExu0vDbfkB+AoN6aKONt8kCF1oESHtFQKNIo1SWl873xCKNILFJdQnWbv8uENUKzDMk/6PbT1AV/6dAvZQztVYcSkvx2uJsfnibbmGTR83W0EVeaSyqRCwKJciSg7oeiMDr+u57Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lokZoY8j; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741365550; x=1772901550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8w57i76C3y8iVjitfnDz5uyKl82BBPaB775SZiY6bcA=;
  b=lokZoY8jljYwHzf5Kvnaz5JMgZg/OVCrGgx/s+3HEvUBPBhpfebKutTf
   SvMKnZ2UHoXNVBhjkgEf/HVrsNayf6UJrW3zg4CpVD7TEwhTZs1rgZ1lv
   NJeRDcCtxLXZxGcCRJmXTx4zII9UvsUby0cH8S8eDh5w/jlaX95pvJNSi
   Mc9YMvnip+rMRLp/7RQD01fkoT3EzTPI/2pvX3LsMzCmuFB/THdEJnjzj
   T9KCkhrP7oYBnoV0TH3juHe9300IiuRyrpoqtU29uKweW4hDiC73evayr
   lnNO9dL0R4PvrK1Ff5hzhLKkJjkMeXyPIB6Vd0aUZzO5Ux1g5foBJZ05b
   A==;
X-CSE-ConnectionGUID: y9WeHZrXRfKvTBU/lP0wBQ==
X-CSE-MsgGUID: E24ds88NSD+bPvaynrVrVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46344419"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46344419"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:10 -0800
X-CSE-ConnectionGUID: sR4boAYyQX6iOnncnGb06A==
X-CSE-MsgGUID: T4E7Ms8ATTiF+LceGlV3xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124397971"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:07 -0800
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
Subject: [PATCH v3 05/10] x86/fpu/xstate: Introduce guest FPU configuration
Date: Sat,  8 Mar 2025 00:41:18 +0800
Message-ID: <20250307164123.1613414-6-chao.gao@intel.com>
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

The guest fpstate is currently initialized using fpu_kernel_cfg. This lacks
flexibility because every feature added to the kernel FPU config is
automatically available for use in the guest FPU. And to make any feature
available for the guest FPU, the feature should be added to the kernel FPU
config.

Introduce fpu_guest_cfg to separate the guest FPU config from the kernel
FPU config. This enhances code readability by allowing the guest FPU to be
initialized with its own config and also improves extensibility by allowing
the guest FPU config and kernel FPU config to evolve independently.

Note fpu_guest_cfg and fpu_kernel_cfg remain the same for now.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/fpu/types.h |  2 +-
 arch/x86/kernel/fpu/core.c       |  3 ++-
 arch/x86/kernel/fpu/xstate.c     | 10 ++++++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 9f9ed406b179..d9515d7f65e4 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -596,6 +596,6 @@ struct fpu_state_config {
 };
 
 /* FPU state configuration information */
-extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
+extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg, fpu_guest_cfg;
 
 #endif /* _ASM_X86_FPU_TYPES_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index adc34914634e..b0c1ef40d105 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -33,9 +33,10 @@ DEFINE_STATIC_KEY_FALSE(__fpu_state_size_dynamic);
 DEFINE_PER_CPU(u64, xfd_state);
 #endif
 
-/* The FPU state configuration data for kernel and user space */
+/* The FPU state configuration data for kernel, user space and guest */
 struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
 struct fpu_state_config fpu_user_cfg __ro_after_init;
+struct fpu_state_config fpu_guest_cfg __ro_after_init;
 
 /*
  * Represents the initial FPU state. It's mostly (but not completely) zeroes,
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 7caafdb7f6b8..58325b3b8914 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -683,6 +683,7 @@ static int __init init_xstate_size(void)
 {
 	/* Recompute the context size for enabled features: */
 	unsigned int user_size, kernel_size, kernel_default_size;
+	unsigned int guest_default_size;
 	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
 
 	/* Uncompacted user space size */
@@ -704,13 +705,18 @@ static int __init init_xstate_size(void)
 	kernel_default_size =
 		xstate_calculate_size(fpu_kernel_cfg.default_features, compacted);
 
+	guest_default_size =
+		xstate_calculate_size(fpu_guest_cfg.default_features, compacted);
+
 	if (!paranoid_xstate_size_valid(kernel_size))
 		return -EINVAL;
 
 	fpu_kernel_cfg.max_size = kernel_size;
 	fpu_user_cfg.max_size = user_size;
+	fpu_guest_cfg.max_size = kernel_size;
 
 	fpu_kernel_cfg.default_size = kernel_default_size;
+	fpu_guest_cfg.default_size = guest_default_size;
 	fpu_user_cfg.default_size =
 		xstate_calculate_size(fpu_user_cfg.default_features, false);
 
@@ -820,6 +826,10 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
 	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
 
+	fpu_guest_cfg.max_features = fpu_kernel_cfg.max_features;
+	fpu_guest_cfg.default_features = fpu_guest_cfg.max_features;
+	fpu_guest_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+
 	/* Store it for paranoia check at the end */
 	xfeatures = fpu_kernel_cfg.max_features;
 
-- 
2.46.1


