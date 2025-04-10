Return-Path: <kvm+bounces-43060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 244A4A83AF3
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:25:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1A454656B9
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3F8213E8E;
	Thu, 10 Apr 2025 07:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jOk1s93j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD71212FB3;
	Thu, 10 Apr 2025 07:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269750; cv=none; b=QR8FlAxvfzOi2p5i49e+nPg7lNp7eHim/7knu20LeT/6HED18853NEn5u2edNlb1DzMhHABsC3sDxj3Imvlco92OJWoyaHGpuDYZ/fOlU8Q8wy/D5JSF1qW8L4F6Jx6rNWF7mLwOjhm3mbMKf9Kbf3yvP3YUr4LzbgZdY2RYLGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269750; c=relaxed/simple;
	bh=bkwRITAvHYW1PQMKc66vh0RX7BrF/SUjCdF5VO+meFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmeOjs0JKjseyz9dokfTIsvwjMOK4gpXxw53bxzKLM2Vc20cG61d3IuGzUnbgeX6vdcSVrS58rTgdJTtgJNCUks31yGYs1jZDKTfE5+qSTLAO2V9wnaDOuQ3J8MVkS3NVpqs5kdlRLN8U7gizxtd3eEIzUqjfFeklCUM+B0/YiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jOk1s93j; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744269749; x=1775805749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bkwRITAvHYW1PQMKc66vh0RX7BrF/SUjCdF5VO+meFY=;
  b=jOk1s93jDr+3Hfz+76D+7/8d7sdNNITdxYotDNjzHIGgRKDj91YRyfuu
   zUZrd4bayKMJ+9ZvMfsJxTwvyFq7QeQaYcXM/N1vVOryXs1+IJkI2TRHv
   BzPl3l9JGEyqDJpf9r1Y9qtP0lQ/UgKVtnKifGu2dT6wu9tWy3AsSenqt
   tHEHp7nLPhbuTiAPv4wattnaji86v6SMoUYH7tjGf5wNLo4Gk9xg9Gcld
   TCpPDc1ujSTx9/SpW/IKjeIRF8W0S26yRXqzMoswNsI/axCQhu6yK88GG
   AysYFGtiM38moYq8qSqvpfjrVDelfRhyBiPjAnCjOkbqbA6fGuHTKajC0
   g==;
X-CSE-ConnectionGUID: GsDjSd5oSb2384MOmrXbbA==
X-CSE-MsgGUID: YBT4UTTvQSqQitMDiGRJAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56439305"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56439305"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:28 -0700
X-CSE-ConnectionGUID: o42DGBJGSBqE1nIA8f+LRQ==
X-CSE-MsgGUID: zA8eglnlTsGBXzdoZICEmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128778122"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:23 -0700
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
	Maxim Levitsky <mlevitsk@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH v5 2/7] x86/fpu: Drop @perm from guest pseudo FPU container
Date: Thu, 10 Apr 2025 15:24:42 +0800
Message-ID: <20250410072605.2358393-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250410072605.2358393-1-chao.gao@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove @perm from the guest pseudo FPU container. The field is
initialized during allocation and never used later.

Rename fpu_init_guest_permissions() to show that its sole purpose is to
lock down guest permissions.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v5: drop the useless fpu_guest argument (Chang)
---
 arch/x86/include/asm/fpu/types.h | 7 -------
 arch/x86/kernel/fpu/core.c       | 7 ++-----
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 46cc263f9f4f..9f9ed406b179 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -526,13 +526,6 @@ struct fpu_guest {
 	 */
 	u64				xfeatures;
 
-	/*
-	 * @perm:			xfeature bitmap of features which are
-	 *				permitted to be enabled for the guest
-	 *				vCPU.
-	 */
-	u64				perm;
-
 	/*
 	 * @xfd_err:			Save the guest value.
 	 */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 1b734a9ff088..28ad7ec56eaa 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -202,7 +202,7 @@ void fpu_reset_from_exception_fixup(void)
 #if IS_ENABLED(CONFIG_KVM)
 static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
 
-static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
+static void fpu_lock_guest_permissions(void)
 {
 	struct fpu_state_perm *fpuperm;
 	u64 perm;
@@ -218,8 +218,6 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 	WRITE_ONCE(fpuperm->__state_perm, perm | FPU_GUEST_PERM_LOCKED);
 
 	spin_unlock_irq(&current->sighand->siglock);
-
-	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
 }
 
 bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
@@ -240,7 +238,6 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 
 	gfpu->fpstate		= fpstate;
 	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
-	gfpu->perm		= fpu_kernel_cfg.default_features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
@@ -255,7 +252,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
 		gfpu->uabi_size = fpu_user_cfg.default_size;
 
-	fpu_init_guest_permissions(gfpu);
+	fpu_lock_guest_permissions();
 
 	return true;
 }
-- 
2.46.1


