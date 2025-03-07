Return-Path: <kvm+bounces-40352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D827EA56DFD
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17A007AB669
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 348C923F28A;
	Fri,  7 Mar 2025 16:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U+KJWtKr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F2523F279;
	Fri,  7 Mar 2025 16:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365541; cv=none; b=WsTY+b7bhtqlmDl94Trus9HGhYTVy8uxkeMiGyX+OoIP+sECcvjgtptbx3Oz5/cuO3p9IO6L2rcCAPNIm+NDS6gWKQ+7oZ06ubAeIQSpv+hclfkXlCOomWdpYjTrxxuFPXySGWmVrqJKGXTuMy4f+mRB7zAzIeY8u2IViFOuOEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365541; c=relaxed/simple;
	bh=6/K99JjqVQqQ1FfXjvgoQw/Ei25G3FgwXjX9ioZHaQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7fyKYXVcpUWwxwZl6Zlh7lzU56UWJgfaZa0gRR96q3CAK4+57EEo4uC+Z3nrl5e8DGRaMnW134hgINHMQ58Oa0Cor+XNHalcZszl6ScMFedqSyINgNYsPAl3Z1mVEjCBZrzV0T0A4HDc71EZ+Q1iRM2mCjCADQ03WrfMxq1ets=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U+KJWtKr; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741365540; x=1772901540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6/K99JjqVQqQ1FfXjvgoQw/Ei25G3FgwXjX9ioZHaQ0=;
  b=U+KJWtKrs2u/lb7KbDKacImgyXEBguPvZYA11FMvewttyEZnvFfB+L05
   wkgH7AC8d00iUkmCCdp7uLi09LP+RHLEEEUbTueY9AEVeI8UubxAn8voX
   Wso98IQ1WUwZEe7QRDGOx/BIrmXQdCqmhkaFP27wPA+NMbUbb4JPLVPyv
   lCkyufxRJctCfRULWTDqoet8XbplTnS+TVCz8qmHAf4HrcE+J4DPJ5mcK
   y66NsAiN3eizh+9xmRplEwtTe40Bk6sz3IDrnIsFUNjdNHBn6a1Ls0kEM
   zy8u1w8sYO5NEwyBMyHiWrNw8Fc9h3It2PvaTi7HxuITcdPYjUMkVuWZ3
   g==;
X-CSE-ConnectionGUID: aqJco40RRqaD3K2xVBWJmw==
X-CSE-MsgGUID: 4EB637H0RyKA225tllggIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46344372"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46344372"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:00 -0800
X-CSE-ConnectionGUID: NDV2RXOVROmbvh+wbMcxaQ==
X-CSE-MsgGUID: OWfHVZJySWSmfIa8QQjetQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124397949"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:38:56 -0800
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
Subject: [PATCH v3 02/10] x86/fpu/xstate: Drop @perm from guest pseudo FPU container
Date: Sat,  8 Mar 2025 00:41:15 +0800
Message-ID: <20250307164123.1613414-3-chao.gao@intel.com>
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

Remove @perm from the guest pseudo FPU container. The field is
initialized during allocation and never used later.

Rename fpu_init_guest_permissions() to show that its sole purpose is to
lock down guest permissions.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
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
index 1209c7aebb21..dc169f3d336d 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -195,7 +195,7 @@ void fpu_reset_from_exception_fixup(void)
 #if IS_ENABLED(CONFIG_KVM)
 static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
 
-static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
+static void fpu_lock_guest_permissions(struct fpu_guest *gfpu)
 {
 	struct fpu_state_perm *fpuperm;
 	u64 perm;
@@ -211,8 +211,6 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 	WRITE_ONCE(fpuperm->__state_perm, perm | FPU_GUEST_PERM_LOCKED);
 
 	spin_unlock_irq(&current->sighand->siglock);
-
-	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
 }
 
 bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
@@ -233,7 +231,6 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 
 	gfpu->fpstate		= fpstate;
 	gfpu->xfeatures		= fpu_user_cfg.default_features;
-	gfpu->perm		= fpu_user_cfg.default_features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
@@ -248,7 +245,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
 		gfpu->uabi_size = fpu_user_cfg.default_size;
 
-	fpu_init_guest_permissions(gfpu);
+	fpu_lock_guest_permissions(gfpu);
 
 	return true;
 }
-- 
2.46.1


