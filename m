Return-Path: <kvm+bounces-40356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6051AA56E19
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:42:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93DC23B9F6D
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F9A241C99;
	Fri,  7 Mar 2025 16:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gdg1Xoda"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7442417D2;
	Fri,  7 Mar 2025 16:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365555; cv=none; b=T9PHbTOZndwx370iKeuQZqtbWqAtgEEM+A2PUIJRbnZzAsFXQkE/uUAe9bn6/MJFmq79j7msiPGTJJp6OiTg0U/HobWaBUiza0PJ4Hbl8ug6s8Y4PrLP2CEYISUYrFIS3t4B0+YsIkRgONHgGfyU1Qhyl/BabU7myDHBPGAOdiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365555; c=relaxed/simple;
	bh=iditFzUC6gL9JXzaOkHqegaevIOWoBD7y+I1dZJrC64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPdnWdlu5K2X3jpFHo0MoWQCD+k3Jn1jcD6SNS2agmASw6/LFZ9dqFCrW+Prj3bI0sNEpqawf6VQ0URUDemdseGM5Cy2oURlmun0GVcS3yx4f0KAJwivD0MlIRd4UUtY9yiMJncx5YMjGj/88E0cXioX1MjFPv/LuRFTQJe5k0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gdg1Xoda; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741365554; x=1772901554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iditFzUC6gL9JXzaOkHqegaevIOWoBD7y+I1dZJrC64=;
  b=gdg1XodaQ38LQWdxG8aXDVhgU3V//Ji9ZRyB/LN4LnIEJx59ksbDKlte
   yXFCIzrD26efmH4Rj9O7YUuqythTF+VlUWvaO2Q0kC2IY33VN54cQDxtI
   HrC2bxqAK3sfpiDL4GTywXTaNwbJcAvxazM7YK2gogB0TlxYg0MxjxHuV
   bPvOimqPmVrL1jvLA99/oubxKD14YS5yxOpbZByiunq5uiRdfbTD60DtU
   Je76dzdhSsU54SVIduEMtB2pAHLE7v1e3YDIyTn1Z+aITuUgGxiBgen0R
   R/f+VPoIPi7G/UjLsBRoO7ffctEZLRdxH16Afgg8aIaNisjkYpRLzaXnF
   g==;
X-CSE-ConnectionGUID: aDaPdInyQMyyjFjfo0Oeeg==
X-CSE-MsgGUID: b2tpcNVZRly7om7vQvSh7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46344434"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46344434"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:13 -0800
X-CSE-ConnectionGUID: 7mRywES9RzO0a0fC6dQIWA==
X-CSE-MsgGUID: KMZxUO4pR02cbJak2aW5dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124397979"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:10 -0800
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
Subject: [PATCH v3 06/10] x86/fpu/xstate: Initialize guest perm with fpu_guest_cfg
Date: Sat,  8 Mar 2025 00:41:19 +0800
Message-ID: <20250307164123.1613414-7-chao.gao@intel.com>
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

Use the new fpu_guest_cfg to initialize guest permissions.

Note fpu_guest_cfg and fpu_kernel_cfg remain the same for now. So there
is no functional change.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
[Gao Chao: Extrace this from the previous patch ]
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kernel/fpu/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index b0c1ef40d105..d7ae684adbad 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -534,8 +534,15 @@ void fpstate_reset(struct fpu *fpu)
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
 	fpu->perm.__state_size		= fpu_kernel_cfg.default_size;
 	fpu->perm.__user_state_size	= fpu_user_cfg.default_size;
-	/* Same defaults for guests */
-	fpu->guest_perm = fpu->perm;
+
+	/* Guest permission settings */
+	fpu->guest_perm.__state_perm	= fpu_guest_cfg.default_features;
+	fpu->guest_perm.__state_size	= fpu_guest_cfg.default_size;
+	/*
+	 * Set guest's __user_state_size to fpu_user_cfg.default_size so that
+	 * existing uAPIs can still work.
+	 */
+	fpu->guest_perm.__user_state_size = fpu_user_cfg.default_size;
 }
 
 static inline void fpu_inherit_perms(struct fpu *dst_fpu)
-- 
2.46.1


