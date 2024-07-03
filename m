Return-Path: <kvm+bounces-20861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CE62924D85
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:12:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECF71282E07
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2518C4C6C;
	Wed,  3 Jul 2024 02:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fQfq+fd/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF957945A;
	Wed,  3 Jul 2024 02:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972751; cv=none; b=NCps/F1p/TDPYcdYKJmj0PG5uq8oS/f2+VXzEcXcwzVrmx2x99hUrVaZCAufqjoevnKKx2SJCt3TaJp+347QbtI/MZkcdfFSEDp8Wtpk/Yc5Q5GPodpUoSYfJVGYRQcrFU65i5mbmMQhMa3zKgXXQp6HnR35FcrfaX3/z5RwP9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972751; c=relaxed/simple;
	bh=LTohYiMBP5iJF+QbwlLQmGYpTkoiDfecodLSJghM2KU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YPOQHBELfcLC26RtkfTq2JFeRoy2a46L9PpmC2af3oji5h/HzBUpd/d2mVsNUV3uOtcyCrpRHL7uL8IbxR44KyKWpfcqMM204QZ9cAiOAj6aupjbaFEGSnIN9seLruA3zpequ6saas7FGqmPNM+LHxAeq8ZH/2GFiqp81NHmNKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fQfq+fd/; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972750; x=1751508750;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LTohYiMBP5iJF+QbwlLQmGYpTkoiDfecodLSJghM2KU=;
  b=fQfq+fd/55fhT2/716X73bRoZB6MS4zfyTm9zg6Wh+W2/7sd8BOoRg7u
   jWtD4Ifka3konbS849hqVppHhFVKwhSxHODvsfQQnbUaX5PbhpFUXNf/I
   YSeVJs8kFk9E+yii5cUWF+zKr8qtkt6PJKymqfIaz5xz4YhO4jAfz7soX
   zmeiBoA4Ss+gf/N4jOfKV/gCdUiEcm6E5gYPxa5fwh5AYb4luQHCeZS4k
   fGdjcXKAakdtBhPs7pG9Ij09eE9kmvrslSx43HGzrDw7gSe73jQdcBojV
   vfO43JbX/0POjxj4ETOMETZwX94psNP4bRKbW8OTyLm0oeKzWIZSam3no
   w==;
X-CSE-ConnectionGUID: /QZA28qqThOiYjTPfdOqRA==
X-CSE-MsgGUID: Z8OGrD6YQSKpY2JsmSzXgA==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17310933"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17310933"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:29 -0700
X-CSE-ConnectionGUID: mUX2nWezTBG+bbySqyfYzA==
X-CSE-MsgGUID: fbsEOSVeSGSmB+MPk0AD6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148496"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:26 -0700
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
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v5 00/18] pmu test bugs fix and improvements
Date: Wed,  3 Jul 2024 09:56:54 +0000
Message-Id: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes:
v4 -> v5:
  * Fix the building errors with configuration options "--arch=i386" or
    "--enable-efi' introduced by v4 patch "Add IBPB indirect jump asm 
    blob" (Patch 15/18)
  * Add patch 18/18 to print count details if test case fails


All changes pass validation on Intel Sapphire Rapids and Emerald Rapids
platforms against latest kvm-x86/next code (0ce958282e66). No tests on
AMD platforms since no AMD platform on hand. Any tests on AMD platform
are appreciated.

History:
  v4: https://lore.kernel.org/all/20240419035233.3837621-1-dapeng1.mi@linux.intel.com/
  v3: https://lore.kernel.org/lkml/20240103031409.2504051-1-dapeng1.mi@linux.intel.com/ 
  v2: https://lore.kernel.org/lkml/20231031092921.2885109-1-dapeng1.mi@linux.intel.com/
  v1: https://lore.kernel.org/lkml/20231024075748.1675382-1-dapeng1.mi@linux.intel.com/

Dapeng Mi (17):
  x86: pmu: Remove blank line and redundant space
  x86: pmu: Refine fixed_events[] names
  x86: pmu: Fix the issue that pmu_counter_t.config crosses cache line
  x86: pmu: Enlarge cnt[] length to 48 in check_counters_many()
  x86: pmu: Add asserts to warn inconsistent fixed events and counters
  x86: pmu: Fix cycles event validation failure
  x86: pmu: Use macro to replace hard-coded branches event index
  x86: pmu: Use macro to replace hard-coded ref-cycles event index
  x86: pmu: Use macro to replace hard-coded instructions event index
  x86: pmu: Enable and disable PMCs in loop() asm blob
  x86: pmu: Improve instruction and branches events verification
  x86: pmu: Improve LLC misses event verification
  x86: pmu: Adjust lower boundary of llc-misses event to 0 for legacy
    CPUs
  x86: pmu: Add IBPB indirect jump asm blob
  x86: pmu: Adjust lower boundary of branch-misses event
  x86: pmu: Optimize emulated instruction validation
  x86: pmu: Print measured event count if test fails

Xiong Zhang (1):
  x86: pmu: Remove duplicate code in pmu_init()

 lib/x86/pmu.c |   5 -
 x86/pmu.c     | 406 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 328 insertions(+), 83 deletions(-)


base-commit: d301d0187f5db09531a1c2c7608997cc3b0a5c7d
-- 
2.40.1


