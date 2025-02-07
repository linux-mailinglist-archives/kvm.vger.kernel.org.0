Return-Path: <kvm+bounces-37549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8852A2B96E
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 04:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B221F3A3DB4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 03:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A3B156236;
	Fri,  7 Feb 2025 03:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C7SSZFGR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAC22030A;
	Fri,  7 Feb 2025 03:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738897731; cv=none; b=Aalw9FRkoAS9fPTA0JIWmE8MrGgBTH+Vbp15VI/Kzb/vfiuE1fGwV7ZB5tmyixP6UtuVbNVM79n2AED4vc6b5MHxO12JpuG5OVqaRg/YZv1ditsh/O0uZxQ1yLWiZJJz4VdgnMdU189nKO5Gi8IDA6bv7QlLh2yHxq82mtoougo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738897731; c=relaxed/simple;
	bh=Ma0iUnI2I6xNU2wk15KlDXjmVcchazEHZ4Ci9uaRTeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PB/AkG3dwn7IjQt2O+gZPeW1VbmlJvDZ7y2wMXshdV9MAH51CHuWvqvMRlqUcnZuV+XpN9rVrrFtHm41jHK0nLbmdj8vZ/cQbB+u+6XbPxu2ZufzBIakB+S0OOHHl0A2TUgjmhETd1w+m10LNnyMSakoOAP8GlyllFvhAWISqsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C7SSZFGR; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738897729; x=1770433729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ma0iUnI2I6xNU2wk15KlDXjmVcchazEHZ4Ci9uaRTeA=;
  b=C7SSZFGRzMg37GZxF34w3xYQwQW0pzIhZWwKSBAboTvSAFsA4XDO1S9c
   4/BeenaFJf+7YOMRpNWycUzdZ7PncmrlcB/e4AihClu2/fxZrRr8wsskV
   x6+D+MyOnZF7Ol0+DEoeYccg5w5PT/xYiTR7KtwcgdbWJwzH47jfvbxOa
   f86O3kSiXCri5pTfZyywusYG0Yy4LMmyTBsypvqYoYjHwQU1+SI3Qd25H
   AmroBpX+p752XlkTuD0NuFZTyo/iIStmYmdjKE9oWju3QkTsPIIsp9U/M
   ImBEuAcQGYoHqffvpdPBpa1upCS3iRTwgRH/GRmwJo3qg/znXWyLdKFxi
   A==;
X-CSE-ConnectionGUID: Y2LETPkoTQG5Gzu98MtkPw==
X-CSE-MsgGUID: CWD3qi6EQUOr/Fd0T2uPcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39403733"
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="39403733"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 19:08:49 -0800
X-CSE-ConnectionGUID: 3xZpZYe6QF2HCn1nTXXlRA==
X-CSE-MsgGUID: SmmRfWEARLSuyRNP3DEEVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="111597378"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 19:08:46 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 1/4] KVM: x86/mmu: Further check old SPTE is leaf for spurious prefetch fault
Date: Fri,  7 Feb 2025 11:07:39 +0800
Message-ID: <20250207030739.1649-1-yan.y.zhao@intel.com>
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

Instead of simply treating a prefetch fault as spurious when there's a
shadow-present old SPTE, further check if the old SPTE is leaf to determine
if a prefetch fault is spurious.

It's not reasonable to treat a prefetch fault as spurious when there's a
shadow-present non-leaf SPTE while without a shadow-present leaf SPTE.
e.g., with below sequence, a prefetch fault should not be regarded as
spurious:
1. add a memslot with size 4K
2. prefault GPA A in the memslot
3. delete the memslot (zap all disabled)
4. re-add the memslot with size 2M
5. prefault GPA A again.
In step 5, the prefetch fault attempts to install a 2M huge entry.
Since step 3 zaps the leaf SPTE for GPA A while keeping the non-leaf SPTE,
the leaf entry will remain empty after step 5 if the prefetch fault is
regarded as spurious due to a shadow-present non-leaf SPTE found.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a45ae60e84ab..3d74e680006f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2846,7 +2846,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	if (is_shadow_present_pte(*sptep)) {
-		if (prefetch)
+		if (prefetch && is_last_spte(*sptep, level))
 			return RET_PF_SPURIOUS;
 
 		/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 046b6ba31197..ab65fd915ef2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1137,7 +1137,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (WARN_ON_ONCE(sp->role.level != fault->goal_level))
 		return RET_PF_RETRY;
 
-	if (fault->prefetch && is_shadow_present_pte(iter->old_spte))
+	if (fault->prefetch && is_shadow_present_pte(iter->old_spte) &&
+	    is_last_spte(iter->old_spte, iter->level))
 		return RET_PF_SPURIOUS;
 
 	if (is_shadow_present_pte(iter->old_spte) &&
-- 
2.43.2


