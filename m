Return-Path: <kvm+bounces-47384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD67FAC0F8A
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 811017AC7B4
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B2D2900A8;
	Thu, 22 May 2025 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fwM4dpOk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925FA28FFD4;
	Thu, 22 May 2025 15:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926643; cv=none; b=oYLC9v1HT8rXe6X1CAjLeiAac2Alc4Sd6s7xDMipLaRhwHXFeVTSPGRTG3h/0vKxje7NPMH011T0JMcH4tBJCcBg+/FJC0JnROLHG/uuKCTnJjTyzmqXLaQqRQwnyL9d4NiqplGxsR4PA0pkwOZvJIeXaA0rHq7QWoJBIlAH/d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926643; c=relaxed/simple;
	bh=Tw5s2+4AFizuL9b8fs+k907xXYNlPJ+h/LJF/+Hhq10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBxmqewQA259K9OV7Y8VNiAh8BfX62J6/QfOsh5V+wF5o/lzu2WETWKzqrBmBDTnUTIm9qfIA41l9RJ0gZzj19szgqXf4mX8aWyvG3kG8PL7u+IPNGrZm5OkUpi0DzCtKpb/uVbaMAJMCtg4jqqSd8Gxh/3zPm9EykuHCQRNlgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fwM4dpOk; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747926642; x=1779462642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tw5s2+4AFizuL9b8fs+k907xXYNlPJ+h/LJF/+Hhq10=;
  b=fwM4dpOkY3qS0xvNlNPGOueTUakyyXFMLmCquSgPw/GnoJaesy5P8j9y
   PgmCl75kVmvIfcBwi6Tt+asklu02xuIBxTo4YwhfGSLooXBabrClvFgI8
   ++m0dFQg3CTM78AjvvFH92WjeutJTQzY3skFgEnz7Sf+sP+IHrV/7OPkZ
   g+cGEGNyzECUn8g6cVP57ZRVpgtaOFNRccNmKpQJEqhMM/03mhvinhV7N
   05OIfQn6ReDVC7rTGfnpaHzPVf2HJOKdus54fjRTcrLfT6QQ96nK0+iqU
   TjsdTuYlXD976OYtkRrEm8+8RJWUWZQZxtvIEDDmK1Wrmoq/XxC6qYZFa
   g==;
X-CSE-ConnectionGUID: swtNxorwREqNBfYUQJPq3Q==
X-CSE-MsgGUID: YpuydH4mTZisFMmw+vzxPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="61006674"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="61006674"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:41 -0700
X-CSE-ConnectionGUID: 1xyfw2BKQAWavODZO3D9eg==
X-CSE-MsgGUID: 7MDlzroFQqCxIxWUc7LaGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="171627614"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:40 -0700
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
	Stanislav Spassov <stanspas@amazon.de>,
	Eric Biggers <ebiggers@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH v8 2/6] x86/fpu: Initialize guest FPU permissions from guest defaults
Date: Thu, 22 May 2025 08:10:05 -0700
Message-ID: <20250522151031.426788-3-chao.gao@intel.com>
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

Currently, fpu->guest_perm is copied from fpu->perm, which is derived from
fpu_kernel_cfg.default_features.

Guest defaults were introduced to differentiate the features and sizes of
host and guest FPUs. Copying guest FPU permissions from the host will lead
to inconsistencies between the guest default features and permissions.

Initialize guest FPU permissions from guest defaults instead of host
defaults. This ensures that any changes to guest default features are
automatically reflected in guest permissions, which in turn guarantees
that fpstate_realloc() allocates a correctly sized XSAVE buffer for guest
FPUs.

Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v8: Refine the comment above fpu->guest_perm.__user_state_size
v6: Drop vcpu_fpu_config.user_* and collect reviews (Rick)
---
 arch/x86/kernel/fpu/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 2cd5e1910ff8..c69432d0ee41 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -553,8 +553,14 @@ void fpstate_reset(struct fpu *fpu)
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
 	fpu->perm.__state_size		= fpu_kernel_cfg.default_size;
 	fpu->perm.__user_state_size	= fpu_user_cfg.default_size;
-	/* Same defaults for guests */
-	fpu->guest_perm = fpu->perm;
+
+	fpu->guest_perm.__state_perm	= guest_default_cfg.features;
+	fpu->guest_perm.__state_size	= guest_default_cfg.size;
+	/*
+	 * User features and sizes are always identical between host and
+	 * guest FPUs, which allows for common guest and userspace ABI.
+	 */
+	fpu->guest_perm.__user_state_size = fpu_user_cfg.default_size;
 }
 
 static inline void fpu_inherit_perms(struct fpu *dst_fpu)
-- 
2.47.1


