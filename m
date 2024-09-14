Return-Path: <kvm+bounces-26898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F8C978E9B
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:02:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CC591C22514
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D2D1CEAC4;
	Sat, 14 Sep 2024 07:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GvQqVEmu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8501C1CE702;
	Sat, 14 Sep 2024 07:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297279; cv=none; b=k0hYtoN2N2ENCNcHVYcNU6GF1qinBtjuECubUt5O+kuzlxCJBZec94GU6wIrR2VcJZCWerfIUpW46gMZvyK5d9NvZ1qe56IbCF76RZJRs1XSHEA9NxTBDHbuEmXv0l1a2Rql/hJYY7Yiqj89xLxH1IfdyT9syTh3AWZ660RZ8A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297279; c=relaxed/simple;
	bh=KhG3sJ5luiiC8MFnE8cG6eZUNJPJ5V6DemW66c/WrE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p10cM5/h9vqkKyd8t2dbQqY942wkmNA9hH8K4ASGYFTynI1s4slqokLCAGJLOPGc8M0luR2U8UT67sa641H9nMZFkOJJdpMHOnNX3nS+kRetCEnlWOGpGhSXDGmlt509tqkov/Gom8jBQa2/KWMijAsv/+IxCtUJcqjmf21tuXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GvQqVEmu; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297278; x=1757833278;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KhG3sJ5luiiC8MFnE8cG6eZUNJPJ5V6DemW66c/WrE0=;
  b=GvQqVEmuzVbckijcjn7M/vj6cAADG4LvngjtmtTmrmSYZlGiyFzgC/n/
   lW6susY1uweD5FTVnm6GTgdE+lqz/xLUsyQpu8dHNRaRcmkn2pXLbjuKD
   XT5VWCva0eEJ5enNfp/6JshRpLdi+eJ1klp16pYr748Eipc7WGQnh7jzr
   nU1HPhOak8b3ZvuBP/yiIwEoWRVui+01P9TkXZlTyla5/dRUumyO5OcNC
   7nKoNgP79siFzYAswadQD7pQ6sEaf9SKrDWo2SJLK2B2PfKh07pN+1Ie3
   SRFErVLGOB1R4mTIdVDruShh1eTBqrkFH6AmaZCUiCIOWkEj2Ir6z9Gj8
   w==;
X-CSE-ConnectionGUID: SekO6tRPT8azT+HWOdRI5A==
X-CSE-MsgGUID: SiBN0E63RD6hrSgZLiffLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778758"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778758"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:17 -0700
X-CSE-ConnectionGUID: nIDCJz2lSRatkIx0e4MA8A==
X-CSE-MsgGUID: FAFrko+6S4yEoDM3IvqNHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950804"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:04 -0700
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
Subject: [kvm-unit-tests patch v6 03/18] x86: pmu: Refine fixed_events[] names
Date: Sat, 14 Sep 2024 10:17:13 +0000
Message-Id: <20240914101728.33148-4-dapeng1.mi@linux.intel.com>
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

In SDM the fixed counter is numbered from 0 but currently the
fixed_events names are numbered from 1. It would cause confusion for
users. So Change the fixed_events[] names to number from 0 as well and
keep identical with SDM.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 865dbe67..60db8bdf 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -45,9 +45,9 @@ struct pmu_event {
 	{"branches", 0x00c2, 1*N, 1.1*N},
 	{"branch misses", 0x00c3, 0, 0.1*N},
 }, fixed_events[] = {
-	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
-	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
-	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
+	{"fixed 0", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
+	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
+	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
 char *buf;
-- 
2.40.1


