Return-Path: <kvm+bounces-52823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F777B0994E
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BEC057B9055
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246931CBA02;
	Fri, 18 Jul 2025 01:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c6ZuPuez"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2231C84C0;
	Fri, 18 Jul 2025 01:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802807; cv=none; b=ZhFBBP4qQVu/qpx2nE1abj6OBKAN2u1guUBy6jzo/F+C2qJnSaGGsr03zXbzE+CCL18LFd0inxiZsQwGMXxBBkvYjv61kdAlz9gKMM45WwKPbzjsOoGUVWRCSBpUBlCEvgUa+hSBfViQXchA6GkmhG1qJCkxIaMrpmWzM/6HaKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802807; c=relaxed/simple;
	bh=xZaOT2faqwrZtdkqO+qLsZJ8quiYyhmYLU8cnJOdgsM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G9ZezNXKH0PuxDsUYPL+TTNwfRtSaMnWYzBvZMnLdPOL8zPXBNT4IYNTzWL/SK7Ok2EjAbn5Ep7c+H6jHhaJJqJv9KJG5B8jp+Z4uglCVAvF3SygAio86Pcy8vFAGmDUmBlvQ+bByiXPu5t7eDL4mo8origyTq/Mp/2/LmbMQwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c6ZuPuez; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752802806; x=1784338806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xZaOT2faqwrZtdkqO+qLsZJ8quiYyhmYLU8cnJOdgsM=;
  b=c6ZuPuez8dFOhcmEenmEB/2R7V2tVFLHuIg2SLls1zKyeIHkh2U9rf+5
   dk7ZNbSqV7luRCIWuN92weJ4jKMay2lSS7kNsgP8Y9fmSKd9fJfjTo+Fu
   3dnVNESodvb2v3ERctcAF2jXUqDeDDonTXo1WPmpmaiOetV3qkcvJQ6NV
   HUsZpQixlXxAA1dNxXKbQpjhgP9gJIKnsBlCOdNvmYawy/8Hj1vO6s4Xw
   MZzKC99FAvdGY0daLcHw36GpbLVRYhAlhS+Yu+5PEAGokzbMFRDJoMAG9
   UVGjk6cAKThf1w0IWYC8TBkouqKrX5kfutoBiIWsx/bl7OMDuKo7vXmQV
   g==;
X-CSE-ConnectionGUID: fBdlW84bStqG95C8sZ9iLQ==
X-CSE-MsgGUID: 1zoOoAXjQJazc+nDcL0Xsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54951476"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54951476"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 18:40:06 -0700
X-CSE-ConnectionGUID: SGdC1Qa8Sm28DkmbzyI/rg==
X-CSE-MsgGUID: nUXgnuv/SWivkYYAVxGoOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="188918382"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa001.fm.intel.com with ESMTP; 17 Jul 2025 18:40:02 -0700
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
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v2 3/7] x86/pmu: Fix incorrect masking of fixed counters
Date: Fri, 18 Jul 2025 09:39:11 +0800
Message-Id: <20250718013915.227452-4-dapeng1.mi@linux.intel.com>
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


