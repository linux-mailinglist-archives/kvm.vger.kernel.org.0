Return-Path: <kvm+bounces-26903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87127978EA8
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B95F41C25474
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C689C1CF7CF;
	Sat, 14 Sep 2024 07:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bwu8X1TI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6905D1CF7A6;
	Sat, 14 Sep 2024 07:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297291; cv=none; b=iRx4+6Ca8Zgnp6LawCZXYe2zK+/fQkqgK1/kHfdHYbWZS8tbFdlX0Yio1YfAorUD31sq4VdGLkadgMPDfTTIu0fhHn2zZwVM4Bv8Dq9NPt8MB1Ut8FjHbnmDD35Gvt2eRqw57zAI8PXCHdYtZ29/hjL6Ou16rCtKgvHh0mAQ6tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297291; c=relaxed/simple;
	bh=osRoBW8hU9dewFz/BqZu2Ja6vvUVZ4VOz3YRrGapuqU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lpIkLGPAY9AmgEg5qB47tszd8wJD+xym9Ow46Onf3ATxoURKAi9QOrWyHqlNwOMu4M5JikOAbq8rBPHx6QyF7pEMq3Kh7981ZBAMmr+s/lA5Qq40YTcwBuGZf/aB7oaM7j0vdMpQf0CdGgKCnCNRvdy3xT7zyXE07OPZHnFecF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bwu8X1TI; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297290; x=1757833290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=osRoBW8hU9dewFz/BqZu2Ja6vvUVZ4VOz3YRrGapuqU=;
  b=bwu8X1TIr8J4WiY1biA72CJ/v+MhbHC3KROwYl/SbQTM/AEkhAMeNKLf
   FVdPIowGdGeohSDO+7UfxdmdY12H7z+CO3A+bZv/6bg3YhXPUo3J/Jmwn
   dcmbveEbHwfVkBT2HF1ZeJMaEdeiY6VfNs4Ag/SaBZ5MdFAKTn3lSlXoe
   l6jJGVPBP6PxOTMZam//qtgOhisMLgPCbcq5XsOvQ4VZdoCUUHNj8uG8A
   JYrtK7CGlMSSSx8910nTvL8raIufsi8wa/Ai1WKmUgFkwM9RDQFuCyECF
   fYkV6T0OWvTUWcekPNpqRDhpA2wFkB41k2bt3nGqXXZfdpwfwCxdTwdPc
   A==;
X-CSE-ConnectionGUID: 8AYhZsIwQiKtw2bpM3IVKA==
X-CSE-MsgGUID: gU2+lnhUT/eGHERpm3X9lw==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778792"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778792"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:30 -0700
X-CSE-ConnectionGUID: T0D4+R23TIa5FqYMhAEalg==
X-CSE-MsgGUID: R1wqdMwLTEeVioJ5BuKzdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950932"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:27 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v6 08/18] x86: pmu: Fix cycles event validation failure
Date: Sat, 14 Sep 2024 10:17:18 +0000
Message-Id: <20240914101728.33148-9-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running pmu test on SPR, sometimes the following failure is
reported.

PMU version:         2
GP counters:         8
GP counter width:    48
Mask length:         8
Fixed counters:      3
Fixed counter width: 48
1000000 <= 55109398 <= 50000000
FAIL: Intel: core cycles-0
1000000 <= 18279571 <= 50000000
PASS: Intel: core cycles-1
1000000 <= 12238092 <= 50000000
PASS: Intel: core cycles-2
1000000 <= 7981727 <= 50000000
PASS: Intel: core cycles-3
1000000 <= 6984711 <= 50000000
PASS: Intel: core cycles-4
1000000 <= 6773673 <= 50000000
PASS: Intel: core cycles-5
1000000 <= 6697842 <= 50000000
PASS: Intel: core cycles-6
1000000 <= 6747947 <= 50000000
PASS: Intel: core cycles-7

The count of the "core cycles" on first counter would exceed the upper
boundary and leads to a failure, and then the "core cycles" count would
drop gradually and reach a stable state.

That looks reasonable. The "core cycles" event is defined as the 1st
event in xxx_gp_events[] array and it is always verified at first.
when the program loop() is executed at the first time it needs to warm
up the pipeline and cache, such as it has to wait for cache is filled.
All these warm-up work leads to a quite large core cycles count which
may exceeds the verification range.

To avoid the false positive of cycles event caused by warm-up,
explicitly introduce a warm-up state before really starting
verification.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index cc940a61..e864ebc4 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -602,11 +602,27 @@ static void check_tsx_cycles(void)
 	report_prefix_pop();
 }
 
+static void warm_up(void)
+{
+	int i = 8;
+
+	/*
+	 * Since cycles event is always run as the first event, there would be
+	 * a warm-up state to warm up the cache, it leads to the measured cycles
+	 * value may exceed the pre-defined cycles upper boundary and cause
+	 * false positive. To avoid this, introduce an warm-up state before
+	 * the real verification.
+	 */
+	while (i--)
+		loop();
+}
+
 static void check_counters(void)
 {
 	if (is_fep_available())
 		check_emulated_instr();
 
+	warm_up();
 	check_gp_counters();
 	check_fixed_counters();
 	check_rdpmc();
-- 
2.40.1


