Return-Path: <kvm+bounces-40353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 17846A56E01
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F16D37A5A80
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DAB82405F2;
	Fri,  7 Mar 2025 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hkEDKrHM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406E523F43C;
	Fri,  7 Mar 2025 16:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365544; cv=none; b=VS7TvMjoVbf9QwhIU9H26slMsMjYk9Nmqr6PormzmFATZ+1y9ZbhAozy5DLxZhJTc0PG5pm/fgXJdHSKoK5ksga64eCtObRiPdaypzeSNdQ9BkpR44Qr9jWvoOxTJocLzOjp/Ckaf0d6KQuGbVg2Uz5oQPT9gKeHbdsJdvsR99A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365544; c=relaxed/simple;
	bh=SpKdz7sTD5wKZqrlLNpQ/arSV7IvcPHU/I9mT3rphFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/d+JGc5HByJdc59rzNVOrqyQH8IA+4H53TgkG02qPRm5jZogTLVR2k1OHOmb+Lk2gENFVrXfvKiXb0F6PPBZXZpfWUUItk8Yn2qkJGK7Fft4C/UiHz6B54UhxrHg7s8piEP1uppWnVlx8MHUShtfFzqNfDjEKUagXfCYRLUEzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hkEDKrHM; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741365543; x=1772901543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SpKdz7sTD5wKZqrlLNpQ/arSV7IvcPHU/I9mT3rphFg=;
  b=hkEDKrHMaEvVDkLtuJsUgqGwk1tAIXCsy96s0oXABOwi4Ae4tQZGi+lF
   TacL0LE5oRtjCTmH1ekH/jD/1V/2eUE71rabd7LwZlsl8LHNfSwiredtl
   i5Pu7MgrJKycho2P5t4cbyoahm8B8zNkYBX70/u1qa7MU00c+xJ7+mWl/
   3EkGKHUw+ONE75WrGbm1VdMRPIf2JwEndqKKaZd77q4jPK1Hdv6pjF2Fz
   CY/23eI/fI955wErP9WKoFZ+sHdsg/Cb3LeVUjCnzPpSV6DzSJks/0gHm
   ralCnNP4hVGqZWgBcfQu37t7DssYIKidCQcIosSWqmXuUQGdiPEsPKUA6
   A==;
X-CSE-ConnectionGUID: oumnp+DtT0uGwm/V4VDgqw==
X-CSE-MsgGUID: mEQKZ0oPQCqrxOOthretJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46344391"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46344391"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:03 -0800
X-CSE-ConnectionGUID: byvLJZMQTK2U8c5YFpXBww==
X-CSE-MsgGUID: 3PhMpAt8RMuCH1N7Wc9E/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124397955"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:00 -0800
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
	bp@alien8.de
Subject: [PATCH v3 03/10] x86/fpu/xstate: Correct xfeatures cache in guest pseudo fpu container
Date: Sat,  8 Mar 2025 00:41:16 +0800
Message-ID: <20250307164123.1613414-4-chao.gao@intel.com>
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

The xfeatures field in struct fpu_guest is designed to track the enabled
xfeatures for guest FPUs. However, during allocation in
fpu_alloc_guest_fpstate(), gfpu->xfeatures is initialized to
fpu_user_cfg.default_features, while the corresponding
fpstate->xfeatures is set to fpu_kernel_cfg.default_features

Correct the mismatch to avoid confusion.

Note this mismatch does not cause any functional issues. The
gfpu->xfeatures is checked in fpu_enable_guest_xfd_features() to
verify if XFD features are already enabled:

	xfeatures &= ~guest_fpu->xfeatures;
	if (!xfeatures)
		return 0;

It gets updated in fpstate_realloc() after enabling some XFD features:

	guest_fpu->xfeatures |= xfeatures;

So, backport is not needed.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kernel/fpu/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index dc169f3d336d..6166a928d3f5 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -230,7 +230,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	fpstate->is_guest	= true;
 
 	gfpu->fpstate		= fpstate;
-	gfpu->xfeatures		= fpu_user_cfg.default_features;
+	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
-- 
2.46.1


