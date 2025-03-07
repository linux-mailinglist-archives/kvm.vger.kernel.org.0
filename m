Return-Path: <kvm+bounces-40360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C67A56E11
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 831C5164502
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DEF624889A;
	Fri,  7 Mar 2025 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BhHVYdTC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3434B2459FB;
	Fri,  7 Mar 2025 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365569; cv=none; b=P2h7zJIMDr4elQvPJjgSgNtLESoeKamhiAnarh8MA0bIfupU39vOvbZbjt2Pcy/lDqq21kVpi2rdECSDamY8QVv3hbfwcG1l6IMhAl9Do8j3B9jW7zbsrn3XS14I0CgdKCwsPXAJrYB4c7+E66WiIM4gTv5auuBMUEKVURJq/3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365569; c=relaxed/simple;
	bh=2hhYjWrJvAfBJ4AhFSf2YTZ4BTSlANboUlb41O46vuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSxlp0k/tSkRx3a3U1uvUlrY3R0y87nQiIyoy/U3z0R+lKNuP+H0WY214M8YxDXc9UxVhl+CfSWMyvYJBk5kvUQnFZC+d7IGHAystNdKzNVqEplnqz7okDkDLPHi7VBxokLeIeGBpx+zIB4MBiWrFh3o/tr4OQNqYOANdZ5Ekdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BhHVYdTC; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741365568; x=1772901568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2hhYjWrJvAfBJ4AhFSf2YTZ4BTSlANboUlb41O46vuY=;
  b=BhHVYdTCMCVQBSihV476A/FuQDfb7GgVTKEp1j/uNrWSlj7uSra6pWZj
   mgD8vxP8kEuOr51Z5LMMGL0XiFC40o3Fdajvprn/EKXBGZ+HVhjtbZmEJ
   9oit+bO0gI+DitSuEAD6QlwTa/R8Y2I3zL67EDOv8k1HDwYaJv7RgUbdJ
   v2tYvrvjLxl9veJLI+xmX5xXI9AMu5IsldJuTjZN5WmbgayRlgZCJlt3r
   h+qawRQx9mnCF6hJQ1fYc12vivDPiueGd9PRXUeBkctJJX7Q41cwtKkgR
   zriGjulIWuHny+1rB0ZBhpx6gPJ5koCFJjJk42M51PQ8yfBe9A4dMV+Zt
   Q==;
X-CSE-ConnectionGUID: KxzbGAzWRa2x5vNuigVi/Q==
X-CSE-MsgGUID: 32HUdmtBTxiMI0Uvr0FQBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46344499"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46344499"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:28 -0800
X-CSE-ConnectionGUID: DTY15gl7SC204CwW+A8v4w==
X-CSE-MsgGUID: CSlach8FTiStkdZCCd8UmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124397997"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:25 -0800
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
Subject: [PATCH v3 10/10] x86/fpu/xstate: Warn if CET supervisor state is detected in normal fpstate
Date: Sat,  8 Mar 2025 00:41:23 +0800
Message-ID: <20250307164123.1613414-11-chao.gao@intel.com>
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

CET supervisor state bit is __ONLY__ enabled for guest fpstate, i.e.,
never for normal kernel fpstate. The bit is set when guest FPU config
is initialized.

For normal fpstate, the bit should have been removed when initializes
kernel FPU config settings, WARN_ONCE() if kernel detects normal fpstate
xfeatures contains CET supervisor state bit before xsaves operation.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kernel/fpu/xstate.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index aa16f1a1bbcf..3df135a7d8bd 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -209,6 +209,8 @@ static inline void os_xsave(struct fpstate *fpstate)
 	WARN_ON_FPU(!alternatives_patched);
 	xfd_validate_state(fpstate, mask, false);
 
+	WARN_ON_FPU(!fpstate->is_guest && (mask & XFEATURE_MASK_CET_KERNEL));
+
 	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
 
 	/* We should never fault when copying to a kernel buffer: */
-- 
2.46.1


