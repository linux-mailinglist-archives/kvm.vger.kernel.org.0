Return-Path: <kvm+bounces-37550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94082A2B970
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 04:09:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32C99163237
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 03:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53B615E5B8;
	Fri,  7 Feb 2025 03:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fJcrYHNa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0020E1531F0;
	Fri,  7 Feb 2025 03:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738897760; cv=none; b=jf8zl7Qj+s9yJa5u1RjDVMYsDeFaZP8a9eF7mkgSdFyTYzEAqdcsNodCsBDaDTH5PegAMU7rT1BK+hyM6mvcztpbryt/+wo9cpE6E3+Q1KvaUOg3o9W1awmOnOMDeCFRsoHhbXiiR3ER1i4DdYPUNA4nPc3lxsw6o56Y3GNv98I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738897760; c=relaxed/simple;
	bh=eBRGEhcdw/cf/u9D7E5Qd78kS3bvzu14Dn7vtFCO7B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UA4pXgJ+usMoLuJ+HcG97oQX7kzIoN8rXun8X3y9Y2MRxKPmJ19jfHUvFg+ePLVw8jFwga/4hdlHPhlZ6N29eIm3vHBHW6EYozhRMgQEzKEre/oY8w7iTZOpAS8u8bD+uhAjkBC4j7hshGOpI0Ev6AkYd8/+o0Cxh+iZWgKumEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fJcrYHNa; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738897759; x=1770433759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eBRGEhcdw/cf/u9D7E5Qd78kS3bvzu14Dn7vtFCO7B8=;
  b=fJcrYHNazwX/NtJ6Qd1sHvmGM7aHVjYpYCmudHIBmN4QZrvo3eKcT1yr
   Y1+91vWnaSvExhXMnAgu84e9ynSOZx6yJiXUR87u3tjFrAT4hn+MZtiDJ
   aA2nkzR9+erG72n2V2jy14T0XmVLka9Wt7S4qTFomyHamD0tq+ZBvpSM8
   4uf9DATWopiwkXVe7nv3W0hdVd5ctO7F8w512Az5bpsckEhoo2ZQUpGY2
   VOv31eS3sDjDtR+tEVH7ajiVI/SmISmgxZzHIuxMw1mNKialIynpaZ/HB
   HzDex77Cy2VQGl6ULCmxX+K+O4/ZXDreKSwNGAeXUb4tsDU76hs+Eg60T
   g==;
X-CSE-ConnectionGUID: T6LSMwmMRkidlq1TzNVtrw==
X-CSE-MsgGUID: qeCAllo5RxKDvm5Xhfj6OQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39661950"
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="39661950"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 19:09:17 -0800
X-CSE-ConnectionGUID: bnxXoa18SyClkM7XdNtKMg==
X-CSE-MsgGUID: GAyigAiXSuyzI4DurW6PyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="111237608"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 19:09:15 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 2/4] KVM: x86/tdp_mmu: Merge the prefetch into the is_access_allowed() check
Date: Fri,  7 Feb 2025 11:08:10 +0800
Message-ID: <20250207030810.1701-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250207030640.1585-1-yan.y.zhao@intel.com>
References: <20250207030640.1585-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Merge the prefetch check into the is_access_allowed() check to determine a
spurious fault.

In the TDP MMU, a spurious prefetch fault should also pass the
is_access_allowed() check. Combining these checks to avoid redundancy.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ab65fd915ef2..5f9e7374220e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1137,10 +1137,6 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (WARN_ON_ONCE(sp->role.level != fault->goal_level))
 		return RET_PF_RETRY;
 
-	if (fault->prefetch && is_shadow_present_pte(iter->old_spte) &&
-	    is_last_spte(iter->old_spte, iter->level))
-		return RET_PF_SPURIOUS;
-
 	if (is_shadow_present_pte(iter->old_spte) &&
 	    is_access_allowed(fault, iter->old_spte) &&
 	    is_last_spte(iter->old_spte, iter->level))
-- 
2.43.2


