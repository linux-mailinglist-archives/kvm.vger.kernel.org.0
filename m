Return-Path: <kvm+bounces-40354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B12AA56E12
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:42:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAB6A3B85E0
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4182A23E229;
	Fri,  7 Mar 2025 16:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZQUMVmyz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EFC24113C;
	Fri,  7 Mar 2025 16:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365548; cv=none; b=pHm7MCrwMERAJNgq18zOZd4AaFF97+7TNkHjvL6dJGblbNM/PyTW0chRZtpM2cQIJKCcVH9PiTBkUsKyAqC/VJuOyEBp+pNtkBu9FMzkDE1XW+xYzETakL7w4yij5iuFD9gZigW2+6UmSh0Ygfafpyl7xejNU6gwCYo5jPk5KLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365548; c=relaxed/simple;
	bh=NS7eb9HUDJ8OTv0tuEbJukrt65iNUAvQ4hYP0y6hXyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2tTwOQOgQFOfk37z7R+FY3/nqEc5F8pJ6/2XDbAsmNVk5MzzfWD0idgzZVJQugBTt7rFCepQwFKZuBLz0y2gY7hYS8keekp/1DDXD62iwHBc3EhDR5yLgS80io6qNojqID72APk9Yqvg8DV9KpyS4LAXUhGzSJs2GDCP6BLXPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZQUMVmyz; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741365547; x=1772901547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NS7eb9HUDJ8OTv0tuEbJukrt65iNUAvQ4hYP0y6hXyI=;
  b=ZQUMVmyzPL1MAdl72f9ZuNd7d+njnBF4SL12M7KaYwt4kxj4I5VUiqNI
   /fFmAoeEhP+K6I/KbtmloSw6gkfoANJopY3NL5iqkJj221u5Rpd4+EHVW
   EPKFwyZuhEsB7qQtBxTS5DCUrs8EBRVUj+zR221OOyG3utsTqVoC8btOz
   cD41H6dWPYcW5z1Kz/pjdYktdyw5AKELdAHj1swsfdRp1MbMOZYa10kn5
   Eq6RB3G+X+Fqx7FiI5SAjTfVTkaqyDBtKHVQgTyTzPq1N5pM6O6CcrDhE
   XE6SbHhKhgTCxcWLeXecFjsTZQlx1B9Ct6IMt+bt+MhFqyoH+UV3Kw9CB
   A==;
X-CSE-ConnectionGUID: zb2a3wz+QNCPzU+MaM/0IA==
X-CSE-MsgGUID: 4okTXNiNQD2Yrw9AnZzUEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46344407"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46344407"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:06 -0800
X-CSE-ConnectionGUID: 2eXecet2SbSKD6NfZSt5wg==
X-CSE-MsgGUID: fn2jnwivQxuOlfi9zGG2mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124397963"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:03 -0800
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
Subject: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size calculation
Date: Sat,  8 Mar 2025 00:41:17 +0800
Message-ID: <20250307164123.1613414-5-chao.gao@intel.com>
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

The guest fpstate size is calculated based on fpu_user_cfg, while
fpstate->xfeatures is set to fpu_kernel_cfg.default_features in
fpu_alloc_guest_fpstate(). In other words, the guest fpstate doesn't
allocate memory for all supervisor states, even though they are enabled.

Correct the calculation of the guest fpstate size.

Note that this issue does not cause any functional problems because the
guest fpstate is allocated using vmalloc(), which aligns the size to a
full page, providing enough space for all existing supervisor components.
On Emerald Rapids CPUs, the guest fpstate after this correction is ~2880
bytes.

Link: https://lore.kernel.org/kvm/20230914063325.85503-3-weijiang.yang@intel.com/
Fixes: 69f6ed1d14c6 ("x86/fpu: Provide infrastructure for KVM FPU cleanup")
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kernel/fpu/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 6166a928d3f5..adc34914634e 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -218,7 +218,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	struct fpstate *fpstate;
 	unsigned int size;
 
-	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
 	fpstate = vzalloc(size);
 	if (!fpstate)
 		return false;
-- 
2.46.1


