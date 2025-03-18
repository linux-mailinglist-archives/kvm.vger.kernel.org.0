Return-Path: <kvm+bounces-41339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D98D7A66526
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 02:34:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 101E57A90B4
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77370146D65;
	Tue, 18 Mar 2025 01:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k60ijP0P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B3F256D;
	Tue, 18 Mar 2025 01:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742261648; cv=none; b=hClhk/GBNX/4AkkdQ5WpfcwDQiaXwg1rb/nTzgkfzHPWuyyL168FCdq9B3MJAcIFhUaeO3O4q1RZ1+rBymM5ni1xL7LslJwNGQsiAjptM/8yegLQoqrfNf+wMnsAczVMuYhHBzGIbtc++rHkT03wh4zDmM4Z/fOiwFNv45lXt9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742261648; c=relaxed/simple;
	bh=3h/tBuBGetcnoP/gV+1yhxo0Nigtzof+XWtMFsLQMSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k58whTHOicDCTWG5f2bShwK0sbzasQ34fI2DSaXCcEaJWJwUnC0Ptiw98oKBqpGKA5IwTrsfjoD6yArcPxZJiLmUCJezv9lVQXSwInBB58d+8bW0wORkee2ZrSu8kX7wNqxvpMi+Ea6M5yvh5hl1ImcUBpQq0tdSJCTQLGL+4YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k60ijP0P; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742261647; x=1773797647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3h/tBuBGetcnoP/gV+1yhxo0Nigtzof+XWtMFsLQMSU=;
  b=k60ijP0Pl+OZbwM6M7bF+y8WPlsSus0fB3dedEZpCf6KyNDlwOk29aTD
   MJfnWu6brbdEJknaszkfFfBD0N6FS53xSIGMT84PTeHSR28q8A/4uOSsY
   Hje+/mL4PLcx4xpArkchZ4lxLmRWB/2pTlbOYKWadEAPBOV+Dy1r+Oimm
   wkjYG0TU2/SwiI+mZJf2eke6PyiuMmu0ATQ0J4aMRM1B4IlTO8U0YAMA4
   54VaLd/zot+dadQ6ZlFDzfUvIgrohClLzhz1WoSc5IfL07nSRQNHKXasg
   jpSedmzT7gHYY9q0CNaBHNd02q1SacN78XqB5QTsYdLv6oitKvtu1j11v
   A==;
X-CSE-ConnectionGUID: 1wiQHBadQrG5pdWhUyGiGg==
X-CSE-MsgGUID: kwft7VtvTq6hq0Whrk3TDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="54009451"
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="54009451"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:34:05 -0700
X-CSE-ConnectionGUID: 55Wb8WbjQXusR/PcHCAi0Q==
X-CSE-MsgGUID: m9oVNe38RomUnnrlFYFT0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="127283965"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:34:04 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 3/5] KVM: x86/tdp_mmu: WARN if PFN changes for spurious faults
Date: Tue, 18 Mar 2025 09:32:38 +0800
Message-ID: <20250318013238.5732-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250318013038.5628-1-yan.y.zhao@intel.com>
References: <20250318013038.5628-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a WARN() to assert that KVM does _not_ change the PFN of a
shadow-present SPTE during spurious fault handling.

KVM should _never_ change the PFN of a shadow-present SPTE and TDP MMU
already BUG()s on this. However, spurious faults just return early before
the existing BUG() could be hit.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6365eb6c1390..d219ecd4ac5b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1139,8 +1139,10 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (is_shadow_present_pte(iter->old_spte) &&
 	    (fault->prefetch || is_access_allowed(fault, iter->old_spte)) &&
-	    is_last_spte(iter->old_spte, iter->level))
+	    is_last_spte(iter->old_spte, iter->level)) {
+		WARN_ON_ONCE(fault->pfn != spte_to_pfn(iter->old_spte));
 		return RET_PF_SPURIOUS;
+	}
 
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-- 
2.43.2


