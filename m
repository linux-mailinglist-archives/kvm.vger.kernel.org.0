Return-Path: <kvm+bounces-21469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA1AE92F550
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:07:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 280871F22EFE
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 06:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6419C13D509;
	Fri, 12 Jul 2024 06:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l/oIGFNN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B234B13CFB0;
	Fri, 12 Jul 2024 06:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720764460; cv=none; b=qtAy77lBUNOUe8NwncDwlNNJhuz18nDE6xqxYauHmNCEEmTXN+ucmTskfEhvcKrsE05B5ryMo93L3jlZ8P4TxkJY8vGRs1YdmLUpsKvqxdqnnGOeLLVfKJlEBexNeXP8fX7bJoziMi7XKNi6LRZTM6uB9jHw/dRU2WSGRl1JZHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720764460; c=relaxed/simple;
	bh=o5lvfeUUUoomFKAxIJKfOCvtb4tndh2fIBaR29n/aJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=riSEu6kd1MorlxuY0CAAMXjR8pRxZ75IFwM/oHWMCwZsUbA5KBbVnH7VlHPz/gt+SngYQQyHMWUc4MuZCZNJWH6PWMxZ8fGgMQvkrA6Hx7Fj+6C3I5Tb2/5wZyJyFipagwfD2JPFWyk4IrOxF/R5MMONvviu+IPnH6jdGOS8WDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l/oIGFNN; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720764459; x=1752300459;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o5lvfeUUUoomFKAxIJKfOCvtb4tndh2fIBaR29n/aJ0=;
  b=l/oIGFNNYDOIZz4eQp46DuQ/6XCx7iv7QOa18htTT+viSw8WZU/RLEYJ
   H8Sz8abvXZyn+XxpFup6lje9FS0SdqMcorOoKNAW8oaShl1Y6bR+EvF1G
   tMDtoyRZGsC/hPiq72gDWgJVXomXUjgoNOy88UOTC2BqcUlewLqEdhhaA
   5Vb/r8xr+Caag9+776+0cyGY0YfU8sln/GYeBre7bVgp/MA6u4wN7wp65
   5mz5Rb3GYonWyTkQhSh0j4M91vjMIwgbRQyMeEz2NZJYncxG31tfM8j9c
   jrFQadEhkies0KPfKkPNssgbImAx3Nob8ZyqHDIFw57L3hf70Ns4BlptV
   w==;
X-CSE-ConnectionGUID: LwVlmWuATWG0WzkJ9esOeg==
X-CSE-MsgGUID: GR/Sm1nqSP+NYHt4voYy/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="29597392"
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="29597392"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 23:07:26 -0700
X-CSE-ConnectionGUID: Bh92un7EQhSrbbkHsWaPRA==
X-CSE-MsgGUID: xPBQA+kiQAquipaFJnLmzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="49219323"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa006.jf.intel.com with ESMTP; 11 Jul 2024 23:07:23 -0700
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
Subject: [Patch v2] KVM: x86/pmu: Insert #GP for invalid architectural PMU MSRs access
Date: Fri, 12 Jul 2024 12:49:17 +0000
Message-Id: <20240712124917.68858-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Return KVM_MSR_RET_INVALID instead of 0 to inject #GP to guest for all
invalid architectural PMU MSRs access.

Currently KVM silently drops the access and doesn't inject #GP for some
invalid PMU MSRs like MSR_P6_PERFCTR0/MSR_P6_PERFCTR1,
MSR_P6_EVNTSEL0/MSR_P6_EVNTSEL1, but KVM still injects #GP for all other
invalid PMU MSRs.

This behavior is introduced by 'commit 5753785fa977 ("KVM: do not #GP
on perf MSR writes when vPMU is disabled")' in 2012. This looks more
like a quirk and just want to respect some guests odd behavior for the
legacy non-architectural PMUs.

But for platforms with architectural PMU nowadays, this quirk can be
dropped. Especially since Perfmon v6 starts, the GP counters could
become discontinuous on HW, It's possible that HW doesn't support GP
counters 0 and 1. #GP needs to be injected to guest to notify this case.

All PMU related kselftests
(pmu_counters_test/pmu_event_filter_test/vmx_pmu_caps_test) and KUT PMU
tests (pmu/pmu_lbr/pmu_pebs) pass with this patch on Sapphire Rapids.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/x86.c                            | 53 ++++++++++++-------
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 12 +++--
 2 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 994743266480..800442db0f21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4051,16 +4051,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		return set_msr_mce(vcpu, msr_info);
 
-	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
-	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
-	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
-	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-		if (kvm_pmu_is_valid_msr(vcpu, msr))
-			return kvm_pmu_set_msr(vcpu, msr_info);
-
-		if (data)
-			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
-		break;
 	case MSR_K7_CLK_CTL:
 		/*
 		 * Ignore all writes to this no longer documented MSR.
@@ -4137,6 +4127,24 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.guest_fpu.xfd_err = data;
 		break;
 #endif
+	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
+	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
+	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
+	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
+		/*
+		 * Some legacy guests don't expect to get a #GP if these MSRs
+		 * are invalid on the old platforms with non-architectural PMUs.
+		 * Refer: commit 5753785fa977 ("KVM: do not #GP on perf MSR writes
+		 * when vPMU is disabled")
+		 */
+		if (!vcpu_to_pmu(vcpu)->version) {
+			if (kvm_pmu_is_valid_msr(vcpu, msr))
+				return kvm_pmu_set_msr(vcpu, msr_info);
+			if (data)
+				kvm_pr_unimpl_wrmsr(vcpu, msr, data);
+			break;
+		}
+		fallthrough;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -4239,14 +4247,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_DRAM_ENERGY_STATUS:	/* DRAM controller */
 		msr_info->data = 0;
 		break;
-	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
-	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
-	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
-	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info);
-		msr_info->data = 0;
-		break;
 	case MSR_IA32_UCODE_REV:
 		msr_info->data = vcpu->arch.microcode_version;
 		break;
@@ -4496,6 +4496,23 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
 		break;
 #endif
+	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
+	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
+	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
+	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
+		/*
+		 * Some legacy guests don't expect to get a #GP if these MSRs
+		 * are invalid on the old platforms with non-architectural PMUs.
+		 * Refer: commit 5753785fa977 ("KVM: do not #GP on perf MSR writes
+		 * when vPMU is disabled")
+		 */
+		if (!vcpu_to_pmu(vcpu)->version) {
+			if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
+				return kvm_pmu_get_msr(vcpu, msr_info);
+			msr_info->data = 0;
+			break;
+		}
+		fallthrough;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 698cb36989db..69fca57dedef 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -358,7 +358,8 @@ static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
 				 uint8_t nr_counters, uint32_t or_mask)
 {
-	const bool pmu_has_fast_mode = !guest_get_pmu_version();
+	uint8_t guest_pmu_version = guest_get_pmu_version();
+	const bool pmu_has_fast_mode = !guest_pmu_version;
 	uint8_t i;
 
 	for (i = 0; i < nr_possible_counters; i++) {
@@ -377,12 +378,13 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		const bool expect_success = i < nr_counters || (or_mask & BIT(i));
 
 		/*
-		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
-		 * unsupported, i.e. doesn't #GP and reads back '0'.
+		 * KVM drops writes to MSR_P6_PERFCTR[0|1] for non-architectural PMUs
+		 * if the counters are unsupported, i.e. doesn't #GP and reads back '0'.
 		 */
 		const uint64_t expected_val = expect_success ? test_val : 0;
-		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
-				       msr != MSR_P6_PERFCTR1;
+		const bool expect_gp = !expect_success &&
+				       (guest_pmu_version ||
+					(msr != MSR_P6_PERFCTR0 && msr != MSR_P6_PERFCTR1));
 		uint32_t rdpmc_idx;
 		uint8_t vector;
 		uint64_t val;

base-commit: 771df9ffadb8204e61d3e98f36c5067102aab78f
-- 
2.40.1


