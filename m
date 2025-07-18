Return-Path: <kvm+bounces-52826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5527AB09953
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FBF85A28B8
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D2419E971;
	Fri, 18 Jul 2025 01:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IAkbbBOL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D131E32A3;
	Fri, 18 Jul 2025 01:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802817; cv=none; b=tgrJTXsJ346WuVUuBkpdroJDRhatm2Le/96CHFssWUIPwVSJwNve+wn1q16TNyyutfuk8VjM3YSFVmeJF1I28pC6DE8dnd8qV+e08INlZrrEbX6pmTLxwMThJYF93yqmtGoePs2NTgZ7+csCfd82T3rJa+yvNKkCHUW2bxTWkwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802817; c=relaxed/simple;
	bh=IM6ZpntWH9mILQir1heZmjp9QGGWbJ+kZ3cIa25NE84=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sm7c696lsdGyaDOKfQStIiipQByh+PjfhCzVmStQojkBDqv5xSrNFIwU5m7x8aWtpSzTS3QZb46ZosRg1gRLsJO7zrzDRpODgWE9vvpxvHOz38zqu+ayInMtKBGCFcuw+Lc/YwPzcgOKqPIBqjRZ+9bE7kjOe4tM/8vy3X2dhLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IAkbbBOL; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752802816; x=1784338816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IM6ZpntWH9mILQir1heZmjp9QGGWbJ+kZ3cIa25NE84=;
  b=IAkbbBOLmI9OdukVW9vt1U8Lv0qdBbmjlNdJPYcm6vtx+cpoHrlXhu6C
   iNOjRZvkOnlbmR3XguTgUL8nBjidT02ouKal6mesVT3bLNNilsfzixrZz
   qkkpThlmwFdkyUcvbvjpEiauU8Fb/4Ko4axaJFpgkcGkU0B0IJJdpVqc4
   RKyaS8bpAt9uEV3cMD5kYgBUnFGwCZVIREpLsBOua3huzTr6h2eJ+KVD0
   j66xHukdUBQtu+MAsd6RTwXsJsTYEc8Glwk0SyxOEI3JJZoPhB+hveOaJ
   kaYPqK8sj6ldpxjmPAdwoPwj5AzmrXAoGrs0MYUqAX66HZQnIf5R+MGBq
   w==;
X-CSE-ConnectionGUID: 77yensJcTuWYwwxJxZQWog==
X-CSE-MsgGUID: bPUBkxt8SMucTYk5sVQliQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54951521"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54951521"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 18:40:16 -0700
X-CSE-ConnectionGUID: 5538bF8cQuK0PyjURZVbzw==
X-CSE-MsgGUID: ULCma+pASkq8u6PQTKbfmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="188918422"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa001.fm.intel.com with ESMTP; 17 Jul 2025 18:40:12 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Yi Lai <yi1.lai@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v2 6/7] x86: pmu_pebs: Remove abundant data_cfg_match calculation
Date: Fri, 18 Jul 2025 09:39:14 +0800
Message-Id: <20250718013915.227452-7-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
References: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove abundant data_cfg_match calculation.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 x86/pmu_pebs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 6e73fc34..2848cc1e 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -296,7 +296,6 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 		pebs_record_size = pebs_rec->format_size >> RECORD_SIZE_OFFSET;
 		pebs_idx_match = pebs_rec->applicable_counters & bitmask;
 		pebs_size_match = pebs_record_size == get_pebs_record_size(pebs_data_cfg, use_adaptive);
-		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
 		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) ==
 				 (use_adaptive ? pebs_data_cfg : 0);
 		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
-- 
2.34.1


