Return-Path: <kvm+bounces-65727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4052FCB4E91
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:46:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 644B2302530F
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F1E429C351;
	Thu, 11 Dec 2025 06:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YPCaaEk9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFB31E9B37
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435540; cv=none; b=JbPD/Ox8M78EJFh5iM3pBZY0s6qBOU7flMoXAGRXvJWzfLvwlzI+lKKNCtOSsq1cMIIuwEMzv75JlYZXUupmKlAPYlIcFqKV87zhudEzqIN/qggnzES4ty6rBdZ3YTbwwS+CccMGrlTYCmNnMg77lMMc4c0zlLXP7dmu8Hp+/io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435540; c=relaxed/simple;
	bh=ray+Oqw/uM8jcX8Iet4O0MoIkdoAsGFxvsVvR05hagQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SVCuDEOfRTmEl3IcmY3uD/UHeHJxJ2PLyCnizd8ZOHy18pvdDtlNtipo+bcXKolmAYjsaWTM/pWJ/4gzEIbTXuE6hi5vNc0royaMFqC1A9Oj967NDs8m1kR1qCiUkLlCtA3mPfrtWbPpTzdG9h96pXxv89p3BJNRXibCSPsge7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YPCaaEk9; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765435539; x=1796971539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ray+Oqw/uM8jcX8Iet4O0MoIkdoAsGFxvsVvR05hagQ=;
  b=YPCaaEk9v5Q5QoMEP58BlfnWCb/KZajO+bGsW8MYs1kWE+Gqg/wGRM6R
   f/kle4MfddXr+RC/lLBAZp0AQ+2+S4L4eJ7f/SuuNxa630fzGQbYL5SIv
   4a79bMjjYd2u+9C9rRy9Dfeh8gvAjZ6LTx8EYQi8pdL9bL9gEVpOM+PWR
   qDtEVUJ0f50eXt1+OtVBKmRF4Q4c5RKfYs9vRjwgU6YSchW6emM89VADJ
   wwY7wON35IchYRma40XR9PMXZeImSYgKAeDWlbT7AhoMZKa6H1NGa0/3S
   bGo1tccnHNZWYUQ6N552iug9bOY9XT8YdD4rfMHKUMe1mJVDu9c162Uir
   A==;
X-CSE-ConnectionGUID: uHbNy0YVScqleHwoCGtsoQ==
X-CSE-MsgGUID: rzX9GJEiSfiWk2UOm11wpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67584508"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67584508"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 22:45:39 -0800
X-CSE-ConnectionGUID: Qr86eNZ8Q5aDJS9ERNWV1g==
X-CSE-MsgGUID: BD9pkxitRqSC7SDQztwDCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196495042"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 10 Dec 2025 22:45:35 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 9/9] i386/cpu: Mark APX xstate as migratable
Date: Thu, 11 Dec 2025 15:09:42 +0800
Message-Id: <20251211070942.3612547-10-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211070942.3612547-1-zhao1.liu@intel.com>
References: <20251211070942.3612547-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

APX xstate is user xstate. The related registers are cached in
X86CPUState. And there's a vmsd "vmstate_apx" to migrate these
registers.

Thus, it's safe to mark it as migratable.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9cc553a86442..f703b1478d71 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1544,7 +1544,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
             XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
             XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
-            XSTATE_PKRU_MASK | XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK,
+            XSTATE_PKRU_MASK | XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK |
+            XSTATE_APX_MASK,
     },
     [FEAT_XSAVE_XCR0_HI] = {
         .type = CPUID_FEATURE_WORD,
-- 
2.34.1


