Return-Path: <kvm+bounces-52815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8093FB098E1
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D56351C460E2
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 00:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F73A5695;
	Fri, 18 Jul 2025 00:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P0g1dfol"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D576D517;
	Fri, 18 Jul 2025 00:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752797999; cv=none; b=eaUhyip1Ioy5jghKT1bKtSC6yIeOnP+I7UbUp8IXNcHSgEqFaiJiclqPh7fvxi5YsQ382GgeTZKqy2IDVMDVG2kecRRFct9ziL7nFqhgCK/eL4mTa32cq4EqBXyPcBuW8/mHsUA4PhcIaEr2nlEYApNJcSjS9xlUI92dXFXSHvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752797999; c=relaxed/simple;
	bh=0JWpwbk6iPo/36WokS/MZjm06ctYIHkLbqOLqgjG0V4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cn6rx0nc8orLWO04tQEc57HzWKggaizQmaHfcR9GPLi/HOrIjT+9QmYNH+utE/w0J/HLe3ZUeUyVYN4I1VzDcPpgL6+Df6yO9X7PaSrHILYDls6SUT4ban6M4Qx5WEnlKP2R1+AqdANsvCrBv7PBIMBVrSG0zBbnlWBzWwoCsd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P0g1dfol; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752797998; x=1784333998;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0JWpwbk6iPo/36WokS/MZjm06ctYIHkLbqOLqgjG0V4=;
  b=P0g1dfolfRIHsSxtnfIg7c/ImAgwwaDGoHFlsuacZE0gyUP1pS6YpQ/w
   mmZuHplA+WtAs9NPE0nMfj9vH7u42cG8jGdAbzVLNseVHc4XVijmIbOd+
   qOunF9gmmEvWL3Y5a8jmPmFthdDIrM4KQn6HhclkBZbNlKFIRZ3QKkrLY
   yWaIyOOD3oCMhZTbH7Eh4TUpymDu4qsm8RD2JPLn1pv7qG0y8TnjZLP/n
   ACUrTBB6MXXIAEKN7sybFMMcvT4R7skoTSxK7dySbSMNtuDCnrutJebEY
   eem9m2AytrqlITkHbvmCnToobR3qAt4SujLh9Ai7evLydCWZ1Kh5+3PL+
   Q==;
X-CSE-ConnectionGUID: aLyrOix9TqSktNlxqXmyyw==
X-CSE-MsgGUID: YKThnbbtTuKyW9MU9uiOaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="65780096"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="65780096"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 17:19:58 -0700
X-CSE-ConnectionGUID: Nh2+QS2uSa2Zj85Wv8LHUQ==
X-CSE-MsgGUID: Q01DgBdLRRqJL6/EDYi8JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="157322787"
Received: from spr.sh.intel.com ([10.112.229.196])
  by orviesa010.jf.intel.com with ESMTP; 17 Jul 2025 17:19:54 -0700
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
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH v2 1/5] KVM: x86/pmu: Correct typo "_COUTNERS" to "_COUNTERS"
Date: Fri, 18 Jul 2025 08:19:01 +0800
Message-Id: <20250718001905.196989-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos. "_COUTNERS" -> "_COUNTERS".

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++----
 arch/x86/kvm/vmx/pmu_intel.c    | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 46ad65a4d524..0a8010e2859c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -545,10 +545,10 @@ struct kvm_pmc {
 #define KVM_MAX_NR_GP_COUNTERS		KVM_MAX(KVM_MAX_NR_INTEL_GP_COUNTERS, \
 						KVM_MAX_NR_AMD_GP_COUNTERS)
 
-#define KVM_MAX_NR_INTEL_FIXED_COUTNERS	3
-#define KVM_MAX_NR_AMD_FIXED_COUTNERS	0
-#define KVM_MAX_NR_FIXED_COUNTERS	KVM_MAX(KVM_MAX_NR_INTEL_FIXED_COUTNERS, \
-						KVM_MAX_NR_AMD_FIXED_COUTNERS)
+#define KVM_MAX_NR_INTEL_FIXED_COUNTERS	3
+#define KVM_MAX_NR_AMD_FIXED_COUNTERS	0
+#define KVM_MAX_NR_FIXED_COUNTERS	KVM_MAX(KVM_MAX_NR_INTEL_FIXED_COUNTERS, \
+						KVM_MAX_NR_AMD_FIXED_COUNTERS)
 
 struct kvm_pmu {
 	u8 version;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 0b173602821b..e8b37a38fbba 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -478,8 +478,8 @@ static __always_inline u64 intel_get_fixed_pmc_eventsel(unsigned int index)
 	};
 	u64 eventsel;
 
-	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_perf_ids) != KVM_MAX_NR_INTEL_FIXED_COUTNERS);
-	BUILD_BUG_ON(index >= KVM_MAX_NR_INTEL_FIXED_COUTNERS);
+	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_perf_ids) != KVM_MAX_NR_INTEL_FIXED_COUNTERS);
+	BUILD_BUG_ON(index >= KVM_MAX_NR_INTEL_FIXED_COUNTERS);
 
 	/*
 	 * Yell if perf reports support for a fixed counter but perf doesn't
@@ -625,7 +625,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].current_config = 0;
 	}
 
-	for (i = 0; i < KVM_MAX_NR_INTEL_FIXED_COUTNERS; i++) {
+	for (i = 0; i < KVM_MAX_NR_INTEL_FIXED_COUNTERS; i++) {
 		pmu->fixed_counters[i].type = KVM_PMC_FIXED;
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + KVM_FIXED_PMC_BASE_IDX;
-- 
2.34.1


