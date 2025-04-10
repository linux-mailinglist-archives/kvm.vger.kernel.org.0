Return-Path: <kvm+bounces-43062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82388A83B15
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:28:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EA8A1B85038
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA75721516E;
	Thu, 10 Apr 2025 07:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d1uQPFkI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B4720B207;
	Thu, 10 Apr 2025 07:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269767; cv=none; b=lUItbo86QR78rqkJ6zC474znNlbhcz+sMYURQX0xAxBXcwQyqU3S9gDowUfrFjVtzJgX/EaO5sQtMyLjlnIKEctc4Sj3avLlZeIObXTx1NyvdyZFFe+pqsYE3bC+XeZPozshnbUeg1+4S6cw9inZ2GX/Hb7/lqnuqSgXoXf/EaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269767; c=relaxed/simple;
	bh=WzJewkkVkSDXS36MObVi8a3bojWpuwsnQhRppAK9x8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjEWdM2EmqvxZrwYRxLxZgKH2xNweZQScY8io0JzBgLrZcU2Fh4/tQ60dpnJEbBus8+ln2d1eNX8G3xhfLuVFIMaAnQbTxePAxTUKa2sWpwg6iv9A8cZlme4toEtpQ0xX4OxkK9KwQyBIZiCKpw6uhk/ctpzUNMPZNEWTU4rIl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d1uQPFkI; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744269765; x=1775805765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WzJewkkVkSDXS36MObVi8a3bojWpuwsnQhRppAK9x8I=;
  b=d1uQPFkI7M/adcVUNOdxxOSukXmlGYDQvecYrbHCvpwEK/F1aO44AwJ3
   tpp5G1phesqsjhxb2JUwofonm89ttbZ/TAgYlMUyfDQvEC64f8wPYSCSl
   HuuM4ezPO+L+AdEXP8who/oqfEMJVyQ2NGOEHG9TK1/kXm5NGWw9feVSH
   p/F0OyO9D5mCQmmqoB5fg5D8C2omdVjH7O0tY8vUM1+fxsUusu2UCO/Gv
   /02i/siYYycGYRGbanI0IZhiIbe88JtaCb8oq0svrQmqvqvJnSnVx0RqG
   +sgGtk4Lzt33xRXIDM6Odt/HB+Lv+sW/6z5Mxd3MjscuxJ7ZYJBNxXQYR
   g==;
X-CSE-ConnectionGUID: DC1AzXmISUWcthi0THR/sw==
X-CSE-MsgGUID: 7VTELozkTdSKcNHzcOHy+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56439352"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56439352"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:45 -0700
X-CSE-ConnectionGUID: sd9XQcdYRYmcgfRavt9KiA==
X-CSE-MsgGUID: rM0qPWpNRHiFmF9WPdxDkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128778162"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:40 -0700
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
	Eric Biggers <ebiggers@google.com>,
	Stanislav Spassov <stanspas@amazon.de>
Subject: [PATCH v5 4/7] x86/fpu: Initialize guest FPU permissions from guest defaults
Date: Thu, 10 Apr 2025 15:24:44 +0800
Message-ID: <20250410072605.2358393-5-chao.gao@intel.com>
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
---
 arch/x86/kernel/fpu/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 25f13cc8ad92..e23e435b85c4 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -543,8 +543,10 @@ void fpstate_reset(struct fpu *fpu)
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
 	fpu->perm.__state_size		= fpu_kernel_cfg.default_size;
 	fpu->perm.__user_state_size	= fpu_user_cfg.default_size;
-	/* Same defaults for guests */
-	fpu->guest_perm = fpu->perm;
+
+	fpu->guest_perm.__state_perm	= guest_default_cfg.features;
+	fpu->guest_perm.__state_size	= guest_default_cfg.size;
+	fpu->guest_perm.__user_state_size = guest_default_cfg.user_size;
 }
 
 static inline void fpu_inherit_perms(struct fpu *dst_fpu)
-- 
2.46.1


