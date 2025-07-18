Return-Path: <kvm+bounces-52818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28A8BB098E6
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:21:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C9CB1C47160
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 00:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8623C19067C;
	Fri, 18 Jul 2025 00:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJhm9vwZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEAB1EB5B;
	Fri, 18 Jul 2025 00:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752798009; cv=none; b=ByGbS97DEWHJDO7XIXI3i7VvF+wFrnCj78gPu4Kva/ZdRu4HJiV6x6zmHpRrH4gSs83fb8HIKMZPinEPxJ3EwqC5bIb7XtAUmqCFhHx0gyVgCmtpqSr7sNYMXnhdw9+us66j5bRUBZhdLvLM8kFx7z528s+Y/X0G5WRUnjHk4oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752798009; c=relaxed/simple;
	bh=kYxBkpRHh5m69Dy/oFgmMqwgCH/c/EHcGUEBtjmuKsc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GYiCK4yDVEVrSNXi1geLgLYqKvBwE4Fcc4MSsW1Mm+4Lf55AcVnAwX8LPL6LwJ+lGUVUzBJpdrRUa2apN0IBI0yDs68j7idBsbeSPkHCGdEZJ4rzeROB26rTBeUTyxfs5WsOD562mUswdzkiSFbnO5EJktm0tFGGo5bqjvjE1Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJhm9vwZ; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752798008; x=1784334008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kYxBkpRHh5m69Dy/oFgmMqwgCH/c/EHcGUEBtjmuKsc=;
  b=HJhm9vwZ9EwuR7bfLRuLoMo2rHAV8eBjs3grX43+HBbdvmwMoj6psmwa
   myljLMP8j6IGAlTAed/GTw3qVgfd4fdg6+Sg6eoo7Zfk6etcycZGFF+oZ
   Q+42CPOtLLN6FPh2W/eiNuokta4T8WKyeWoEvDxSC3s79kuLNM8yxRwqw
   Mq4zHweUnd0XmPh0vNi+zEndFqG3+kiGSbRr/9xpOLqqv4YHuNUY2FnrI
   LV/V3xlMo+U/dUtgefnSbxPUfXORXH3luXYRJJdR4wDagNXoxMnvElfIR
   b5Qsf9h0baUy8F4zMGSydH6QSbVyMQLh7/IkICMyKiqHLDgVT2/whVxih
   A==;
X-CSE-ConnectionGUID: 2Hum73l/SaybgRBEkSlueA==
X-CSE-MsgGUID: baLi+lYURcSGpQkWljQlqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="65780126"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="65780126"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 17:20:08 -0700
X-CSE-ConnectionGUID: U4X4ubMHSV+cFuuguzwXXA==
X-CSE-MsgGUID: 67aMWxwmQ5ORnf2GHq++Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="157322892"
Received: from spr.sh.intel.com ([10.112.229.196])
  by orviesa010.jf.intel.com with ESMTP; 17 Jul 2025 17:20:03 -0700
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
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH v2 4/5] KVM: selftests: Relax precise event count validation as overcount issue
Date: Fri, 18 Jul 2025 08:19:04 +0800
Message-Id: <20250718001905.196989-5-dapeng1.mi@linux.intel.com>
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

From: dongsheng <dongsheng.x.zhang@intel.com>

For Intel Atom CPUs, the PMU events "Instruction Retired" or
"Branch Instruction Retired" may be overcounted for some certain
instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
and complex SGX/SMX/CSTATE instructions/flows.

The detailed information can be found in the errata (section SRF7):
https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/

For the Atom platforms before Sierra Forest (including Sierra Forest),
Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
be overcounted on these certain instructions, but for Clearwater Forest
only "Instruction Retired" event is overcounted on these instructions.

As the overcount issue on VM-Exit/VM-Entry, it has no way to validate
the precise count for these 2 events on these affected Atom platforms,
so just relax the precise event count check for these 2 events on these
Atom platforms.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 tools/testing/selftests/kvm/include/x86/pmu.h |  9 +++++
 tools/testing/selftests/kvm/lib/x86/pmu.c     | 38 +++++++++++++++++++
 .../selftests/kvm/x86/pmu_counters_test.c     | 17 ++++++++-
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/pmu.h b/tools/testing/selftests/kvm/include/x86/pmu.h
index 2aabda2da002..db14c08abc59 100644
--- a/tools/testing/selftests/kvm/include/x86/pmu.h
+++ b/tools/testing/selftests/kvm/include/x86/pmu.h
@@ -104,4 +104,13 @@ enum amd_pmu_zen_events {
 extern const uint64_t intel_pmu_arch_events[];
 extern const uint64_t amd_pmu_zen_events[];
 
+/*
+ * Flags for "Instruction Retired" and "Branch Instruction Retired"
+ * overcount flaws.
+ */
+#define INST_RETIRED_OVERCOUNT BIT(0)
+#define BR_RETIRED_OVERCOUNT   BIT(1)
+
+extern uint32_t detect_inst_overcount_flags(void);
+
 #endif /* SELFTEST_KVM_PMU_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/pmu.c b/tools/testing/selftests/kvm/lib/x86/pmu.c
index 5ab44bf54773..fd4ed577c88f 100644
--- a/tools/testing/selftests/kvm/lib/x86/pmu.c
+++ b/tools/testing/selftests/kvm/lib/x86/pmu.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 
 #include "kvm_util.h"
+#include "processor.h"
 #include "pmu.h"
 
 const uint64_t intel_pmu_arch_events[] = {
@@ -34,3 +35,40 @@ const uint64_t amd_pmu_zen_events[] = {
 	AMD_ZEN_BRANCHES_MISPREDICTED,
 };
 kvm_static_assert(ARRAY_SIZE(amd_pmu_zen_events) == NR_AMD_ZEN_EVENTS);
+
+/*
+ * For Intel Atom CPUs, the PMU events "Instruction Retired" or
+ * "Branch Instruction Retired" may be overcounted for some certain
+ * instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
+ * and complex SGX/SMX/CSTATE instructions/flows.
+ *
+ * The detailed information can be found in the errata (section SRF7):
+ * https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
+ *
+ * For the Atom platforms before Sierra Forest (including Sierra Forest),
+ * Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
+ * be overcounted on these certain instructions, but for Clearwater Forest
+ * only "Instruction Retired" event is overcounted on these instructions.
+ */
+uint32_t detect_inst_overcount_flags(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	uint32_t flags = 0;
+
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+	if (x86_family(eax) == 0x6) {
+		switch (x86_model(eax)) {
+		case 0xDD: /* Clearwater Forest */
+			flags = INST_RETIRED_OVERCOUNT;
+			break;
+		case 0xAF: /* Sierra Forest */
+		case 0x4D: /* Avaton, Rangely */
+		case 0x5F: /* Denverton */
+		case 0x86: /* Jacobsville */
+			flags = INST_RETIRED_OVERCOUNT | BR_RETIRED_OVERCOUNT;
+			break;
+		}
+	}
+
+	return flags;
+}
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 342a72420177..074cdf323406 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -52,6 +52,9 @@ struct kvm_intel_pmu_event {
 	struct kvm_x86_pmu_feature fixed_event;
 };
 
+
+static uint8_t inst_overcount_flags;
+
 /*
  * Wrap the array to appease the compiler, as the macros used to construct each
  * kvm_x86_pmu_feature use syntax that's only valid in function scope, and the
@@ -163,10 +166,18 @@ static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr
 
 	switch (idx) {
 	case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
-		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
+		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
+		if (inst_overcount_flags & INST_RETIRED_OVERCOUNT)
+			GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
+		else
+			GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
 		break;
 	case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
-		GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
+		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
+		if (inst_overcount_flags & BR_RETIRED_OVERCOUNT)
+			GUEST_ASSERT(count >= NUM_BRANCH_INSNS_RETIRED);
+		else
+			GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
 		break;
 	case INTEL_ARCH_LLC_REFERENCES_INDEX:
 	case INTEL_ARCH_LLC_MISSES_INDEX:
@@ -335,6 +346,7 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
 				length);
 	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EVENTS_MASK,
 				unavailable_mask);
+	sync_global_to_guest(vm, inst_overcount_flags);
 
 	run_vcpu(vcpu);
 
@@ -673,6 +685,7 @@ int main(int argc, char *argv[])
 
 	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
 	kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
+	inst_overcount_flags = detect_inst_overcount_flags();
 
 	test_intel_counters();
 
-- 
2.34.1


