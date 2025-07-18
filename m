Return-Path: <kvm+bounces-52824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55359B0994F
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:41:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C4DB7B9332
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38B91DB13A;
	Fri, 18 Jul 2025 01:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fcyMC768"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3F61D5CD1;
	Fri, 18 Jul 2025 01:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802810; cv=none; b=YNv8qeXEiR/pb2zgv8CUkvba90r4xYY8nJ4WZJ8eBKYqrSIWYQ4jnUFxNk+xb8aAOcVPg2ppt/ECNDR1KWsxAhIdARbHB5kA/rfUz4mZzxCN6plPit3tiLV43+FzjPaJSrIa+sFXUvhnGYCZoDLHyOSHVkXjToEHHjM4hYPP0tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802810; c=relaxed/simple;
	bh=S7lk8W1qOqN6f2hlk12G1kiNj2WSIVk7J9ru7MHfT5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fZEDwvTk4n20ym5d20WDrv+4PaZstgJ3tRTPhdHzNn6qDk84JBCKm0TQEit5abkyrks+kGOtjiSFhocbz+1dZTZQQBHs5s31ZM31DdeNmLUfVZLY9tRWeYnFlmTPC/8OM4AKBdBswOMhNQpqNUrFaZUV+s/rk8mqKK3xUDvNgLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fcyMC768; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752802810; x=1784338810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S7lk8W1qOqN6f2hlk12G1kiNj2WSIVk7J9ru7MHfT5M=;
  b=fcyMC768P83qKhLgnYxVn+1dY5Vrd0SpVESE1lDP+PtnlW3XgFsr5l/d
   eeNUWphzmcJh6+bk2FcQbIyskY0d6uX7Q08cpoyPNVA52bATQh6zRr0Ke
   kr2DYtab2p2NiocoR8/TxonKAIlzBogx+bYWNjlROZHpjoqm6vuWoDlO8
   qfnWU8XpRWQ1nEmd+cV5rlqbSxiBaEGXko4uk7zqlwwWygh5Pjt97m5DC
   Bk/5/z1bfdrcyBr2BqKo2pkmBoaVj3v/whkvvSGTR/foot1d5eiNq1Ij3
   cDOK0/X80ZIH5S7cb9bLtxDC3FozKFOALNDEKifMMB5JmJmf3gj7PDiRW
   A==;
X-CSE-ConnectionGUID: u8QPAHcBS3OBrxLVZKiDvw==
X-CSE-MsgGUID: uzx/9HXwR3uGBEK9RHewqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54951502"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54951502"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 18:40:10 -0700
X-CSE-ConnectionGUID: e4kx+BFIRx6hZgsV9apqCw==
X-CSE-MsgGUID: S74PmfwxRxaA4KWjPvkOIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="188918402"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa001.fm.intel.com with ESMTP; 17 Jul 2025 18:40:06 -0700
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
Subject: [kvm-unit-tests patch v2 4/7] x86/pmu: Handle instruction overcount issue in overflow test
Date: Fri, 18 Jul 2025 09:39:12 +0800
Message-Id: <20250718013915.227452-5-dapeng1.mi@linux.intel.com>
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

During the execution of __measure(), VM exits (e.g., due to
WRMSR/EXTERNAL_INTERRUPT) may occur. On systems affected by the
instruction overcount issue, each VM-Exit/VM-Entry can erroneously
increment the instruction count by one, leading to false failures in
overflow tests.

To address this, the patch introduces a range-based validation in place
of precise instruction count checks. Additionally, overflow_preset is
now statically set to 1 - LOOP_INSNS, rather than being dynamically
determined via measure_for_overflow().

These changes ensure consistent and predictable behavior aligned with the
intended loop instruction count, while avoiding modifications to the
subsequent status and status-clear testing logic.

The chosen validation range is empirically derived to maintain test
reliability across hardware variations.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 x86/pmu.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 44c728a5..c54c0988 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -518,6 +518,21 @@ static void check_counters_many(void)
 
 static uint64_t measure_for_overflow(pmu_counter_t *cnt)
 {
+	/*
+	 * During the execution of __measure(), VM exits (e.g., due to
+	 * WRMSR/EXTERNAL_INTERRUPT) may occur. On systems affected by the
+	 * instruction overcount issue, each VM-Exit/VM-Entry can erroneously
+	 * increment the instruction count by one, leading to false failures
+	 * in overflow tests.
+	 *
+	 * To mitigate this, if the overcount issue is detected, we hardcode
+	 * the overflow preset to (1 - LOOP_INSNS) instead of calculating it
+	 * dynamically. This ensures that an overflow will reliably occur,
+	 * regardless of any overcounting caused by VM exits.
+	 */
+	if (intel_inst_overcount_flags & INST_RETIRED_OVERCOUNT)
+		return 1 - LOOP_INSNS;
+
 	__measure(cnt, 0);
 	/*
 	 * To generate overflow, i.e. roll over to '0', the initial count just
@@ -574,8 +589,12 @@ static void check_counter_overflow(void)
 			cnt.config &= ~EVNTSEL_INT;
 		idx = event_to_global_idx(&cnt);
 		__measure(&cnt, cnt.count);
-		if (pmu.is_intel)
-			report(cnt.count == 1, "cntr-%d", i);
+		if (pmu.is_intel) {
+			if (intel_inst_overcount_flags & INST_RETIRED_OVERCOUNT)
+				report(cnt.count < 14, "cntr-%d", i);
+			else
+				report(cnt.count == 1, "cntr-%d", i);
+		}
 		else
 			report(cnt.count == 0xffffffffffff || cnt.count < 7, "cntr-%d", i);
 
-- 
2.34.1


