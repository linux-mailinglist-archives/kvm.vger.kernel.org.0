Return-Path: <kvm+bounces-56665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CEFFB41573
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 763CC5627C1
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08AB82DBF5B;
	Wed,  3 Sep 2025 06:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ACxWQse7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC50B2D9493;
	Wed,  3 Sep 2025 06:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756882052; cv=none; b=NobOZIeow8lCuvkXvm0SBpicj1XoekzScABsz3glwkab8HCO3uHdRbUV/uRPM+c5X5j+/zrWdw468n/qJyTaYxjA/AQU7IxHXdRrgj7jXnMmptZEE9mdV+u76QeeRlpQBJft3GnHi/hUxAfn6lkstxcqU4pDESB3rHmkNOvq/rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756882052; c=relaxed/simple;
	bh=xZaOT2faqwrZtdkqO+qLsZJ8quiYyhmYLU8cnJOdgsM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KtblZ3f54NrW6Jw6IKp3+ERz9lTJ4r78OhgXgZ/M1nR2HVjoAOKlKJ1ETKvGrPsMtshJmxFDh9BcbSWYEAZBMl9RcY35msRozMOTvkfDdnYpYIaOmei2E+aywPuFqgTKJPKBhIB2a0YGHsLM4wMU2rLNQRIk7cbqpp81FYtIr7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ACxWQse7; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756882051; x=1788418051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xZaOT2faqwrZtdkqO+qLsZJ8quiYyhmYLU8cnJOdgsM=;
  b=ACxWQse7dr2CrGqmj7YNUyf5Cz306OO53YrGH5dkf37gOf/DurMapfLn
   7cJk+ejW1M/U51SmTeWng0/i+t5s8VoK5NlDPKx27YtXKKfkl3QDGXEjt
   73FrbUc49ccOs49ezXqFD9a4FUBMP8REMnkctChXUHVm1iJjhWP8vrONm
   QBjryNgN0KHS63KHK6v1sewUmzwDV+bVS/NIr6Yx00w/G0m/eeu11NIpL
   jYC5ImDEMc84EjhqrbZ6EhNkqyJxgNa98Sx/Ff/o6jviQ1OxT1IWUUrfd
   q4DkuoQmjh8typXR5HHdY1w7S6ymdshFnYtAHbrNV+wWNAxxSpKmngRLS
   A==;
X-CSE-ConnectionGUID: AnYtYTDWSoqQHT9KuLTsjQ==
X-CSE-MsgGUID: YffnVTnqTPeA/sit+jtQWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="63003787"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="63003787"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:47:30 -0700
X-CSE-ConnectionGUID: l9t6ZK0nQde/Yzlo7gkvoQ==
X-CSE-MsgGUID: eWVUgLahS1GtyroimvSKaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171656563"
Received: from spr.sh.intel.com ([10.112.230.239])
  by orviesa008.jf.intel.com with ESMTP; 02 Sep 2025 23:47:27 -0700
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
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>
Subject: [kvm-unit-tests patch v3 3/8] x86/pmu: Fix incorrect masking of fixed counters
Date: Wed,  3 Sep 2025 14:45:56 +0800
Message-Id: <20250903064601.32131-4-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: dongsheng <dongsheng.x.zhang@intel.com>

The current implementation mistakenly limits the width of fixed counters
to the width of GP counters. Corrects the logic to ensure fixed counters
are properly masked according to their own width.

Opportunistically refine the GP counter bitwidth processing code.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 x86/pmu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 04946d10..44c728a5 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -556,18 +556,16 @@ static void check_counter_overflow(void)
 		int idx;
 
 		cnt.count = overflow_preset;
-		if (pmu_use_full_writes())
-			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
-
 		if (i == pmu.nr_gp_counters) {
 			if (!pmu.is_intel)
 				break;
 
 			cnt.ctr = fixed_events[0].unit_sel;
-			cnt.count = measure_for_overflow(&cnt);
-			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
+			cnt.count &= (1ull << pmu.fixed_counter_width) - 1;
 		} else {
 			cnt.ctr = MSR_GP_COUNTERx(i);
+			if (pmu_use_full_writes())
+				cnt.count &= (1ull << pmu.gp_counter_width) - 1;
 		}
 
 		if (i % 2)
-- 
2.34.1


