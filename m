Return-Path: <kvm+bounces-557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9153F7E0C7C
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:03:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A2D0281F72
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3868BF3;
	Sat,  4 Nov 2023 00:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lfqRBtUz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFA87497
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:03:03 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A59ED70
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:03:00 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc391ca417so20681045ad.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056179; x=1699660979; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BaRKhWNuL6Q5DVgkMO21yhpwYHq5ZPFM2fl/r0JXK2s=;
        b=lfqRBtUz6OF5om4FtchNEySX4esGMCxe/hpBP71Mz5RaGP2169QFEs8GjWiedu9VPa
         dVJP/SISyIpuSHzZZX8OOYxMkiAKd/N6Z18BX13Uc3VORnTvEhSvdtBeQRaFXviEykvA
         Vi6gNrpLN777UQMXFDUReRkQaxVA0vSe+KGeWLH1Za4uVNQI0YiCm9KP5EDzwGkt3d6B
         IJEdbwIVuoabFIAQlkU3q/YRzbUCV2WDdrtwudNyrqsjds6EUF03g2Ik1eQYxFlVagpX
         wmiuYnouxdtBbVxOPQ1gGMdEAZxNFs98v8vQj+HK+NzlYkswtOpDClRrpVST5xY87c8i
         f45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056179; x=1699660979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BaRKhWNuL6Q5DVgkMO21yhpwYHq5ZPFM2fl/r0JXK2s=;
        b=GPVpCbgwNK8+YdNqBLfA5VltcppHqVFfPCiReZLENyxop4qK/GnhyXoZtnOMjGt2hY
         gPO08U4tsBzy1zo5xmebByj9rBolYU8rS6p6FjNcx4N71eoRugQC29cNuSuRw/ZYdHiu
         AhP2mgzUtqV3M1JupsBD8n/LNkv/aMy9SrK2YdmfI+B0ZtxryEoQow6TrdIOtcITa0yQ
         qYkk8wqVBlvzmaLlDP5LtoSzVxKvFQWVq6yhJpEtWrhqJYegHjt8PvxmjBCHF5kXYBTb
         tqPnnCYIGSGGUw6TD7b/EZPFyZawPew5fH6FbTxbqSIkRHdJClPLWTiHK+CFRnnaPP/z
         YSJg==
X-Gm-Message-State: AOJu0Yz7FEJz5oE2qiFV5ReXCVYJYPb8vwgQ5C9YzmSZBv8C1D/oC0F8
	bfusZDAU8S7TCVWF9poYr9UwlDc+zWo=
X-Google-Smtp-Source: AGHT+IELAesa7K8ee6Mm+p8N2ZWXCDJrVaBRWzASkYuftq7/gyMpS4MOpw2JZk+utUCkAbFeGDF7SXTbRA4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fe0c:b0:1cc:20c8:323a with SMTP id
 g12-20020a170902fe0c00b001cc20c8323amr373211plj.1.1699056179698; Fri, 03 Nov
 2023 17:02:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:28 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-11-seanjc@google.com>
Subject: [PATCH v6 10/20] KVM: selftests: Test Intel PMU architectural events
 on gp counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Add test cases to verify that Intel's Architectural PMU events work as
expected when the are (un)available according to guest CPUID.  Iterate
over a range of sane PMU versions, with and without full-width writes
enabled, and over interesting combinations of lengths/masks for the bit
vector that enumerates unavailable events.

Test up to vPMU version 5, i.e. the current architectural max.  KVM only
officially supports up to version 2, but the behavior of the counters is
backwards compatible, i.e. KVM shouldn't do something completely different
for a higher, architecturally-defined vPMU version.  Verify KVM behavior
against the effective vPMU version, e.g. advertising vPMU 5 when KVM only
supports vPMU 2 shouldn't magically unlock vPMU 5 features.

According to Intel SDM, the number of architectural events is reported
through CPUID.0AH:EAX[31:24] and the architectural event x is supported
if EBX[x]=0 && EAX[31:24]>x.  Note, KVM's ABI is that unavailable events
do not count, even though strictly speaking that's not required by the
SDM (the behavior is effectively undefined).

Handcode the entirety of the measured section so that the test can
precisely assert on the number of instructions and branches retired.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 321 ++++++++++++++++++
 2 files changed, 322 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 44d8d022b023..09f5d6fe84de 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -91,6 +91,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
 TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/pmu_counters_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
new file mode 100644
index 000000000000..dd9a7864410c
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -0,0 +1,321 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023, Tencent, Inc.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <x86intrin.h>
+
+#include "pmu.h"
+#include "processor.h"
+
+/* Number of LOOP instructions for the guest measurement payload. */
+#define NUM_BRANCHES		10
+/*
+ * Number of "extra" instructions that will be counted, i.e. the number of
+ * instructions that are needed to set up the loop and then disabled the
+ * counter.  2 MOV, 2 XOR, 1 WRMSR.
+ */
+#define NUM_EXTRA_INSNS		5
+#define NUM_INSNS_RETIRED	(NUM_BRANCHES + NUM_EXTRA_INSNS)
+
+static uint8_t kvm_pmu_version;
+static bool kvm_has_perf_caps;
+
+static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
+						  void *guest_code,
+						  uint8_t pmu_version,
+						  uint64_t perf_capabilities)
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(vcpu, guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(*vcpu);
+
+	sync_global_to_guest(vm, kvm_pmu_version);
+
+	/*
+	 * Set PERF_CAPABILITIES before PMU version as KVM disallows enabling
+	 * features via PERF_CAPABILITIES if the guest doesn't have a vPMU.
+	 */
+	if (kvm_has_perf_caps)
+		vcpu_set_msr(*vcpu, MSR_IA32_PERF_CAPABILITIES, perf_capabilities);
+
+	vcpu_set_cpuid_property(*vcpu, X86_PROPERTY_PMU_VERSION, pmu_version);
+	return vm;
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	do {
+		vcpu_run(vcpu);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_PRINTF:
+			pr_info("%s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			break;
+		default:
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+		}
+	} while (uc.cmd != UCALL_DONE);
+}
+
+static uint8_t guest_get_pmu_version(void)
+{
+	/*
+	 * Return the effective PMU version, i.e. the minimum between what KVM
+	 * supports and what is enumerated to the guest.  The host deliberately
+	 * advertises a PMU version to the guest beyond what is actually
+	 * supported by KVM to verify KVM doesn't freak out and do something
+	 * bizarre with an architecturally valid, but unsupported, version.
+	 */
+	return min_t(uint8_t, kvm_pmu_version, this_cpu_property(X86_PROPERTY_PMU_VERSION));
+}
+
+/*
+ * If an architectural event is supported and guaranteed to generate at least
+ * one "hit, assert that its count is non-zero.  If an event isn't supported or
+ * the test can't guarantee the associated action will occur, then all bets are
+ * off regarding the count, i.e. no checks can be done.
+ *
+ * Sanity check that in all cases, the event doesn't count when it's disabled,
+ * and that KVM correctly emulates the write of an arbitrary value.
+ */
+static void guest_assert_event_count(uint8_t idx,
+				     struct kvm_x86_pmu_feature event,
+				     uint32_t pmc, uint32_t pmc_msr)
+{
+	uint64_t count;
+
+	count = _rdpmc(pmc);
+	if (!this_pmu_has(event))
+		goto sanity_checks;
+
+	switch (idx) {
+	case INTEL_ARCH_INSTRUCTIONS_RETIRED:
+		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
+		break;
+	case INTEL_ARCH_BRANCHES_RETIRED:
+		GUEST_ASSERT_EQ(count, NUM_BRANCHES);
+		break;
+	case INTEL_ARCH_CPU_CYCLES:
+	case INTEL_ARCH_REFERENCE_CYCLES:
+		GUEST_ASSERT_NE(count, 0);
+		break;
+	default:
+		break;
+	}
+
+sanity_checks:
+	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+	GUEST_ASSERT_EQ(_rdpmc(pmc), count);
+
+	wrmsr(pmc_msr, 0xdead);
+	GUEST_ASSERT_EQ(_rdpmc(pmc), 0xdead);
+}
+
+static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature event,
+				    uint32_t pmc, uint32_t pmc_msr,
+				    uint32_t ctrl_msr, uint64_t ctrl_msr_value)
+{
+	wrmsr(pmc_msr, 0);
+
+	/*
+	 * Enable and disable the PMC in a monolithic asm blob to ensure that
+	 * the compiler can't insert _any_ code into the measured sequence.
+	 * Note, ECX doesn't need to be clobbered as the input value, @pmc_msr,
+	 * is restored before the end of the sequence.
+	 */
+	__asm__ __volatile__("wrmsr\n\t"
+			     "mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"
+			     "loop .\n\t"
+			     "mov %%edi, %%ecx\n\t"
+			     "xor %%eax, %%eax\n\t"
+			     "xor %%edx, %%edx\n\t"
+			     "wrmsr\n\t"
+			     :: "a"((uint32_t)ctrl_msr_value),
+				"d"(ctrl_msr_value >> 32),
+				"c"(ctrl_msr), "D"(ctrl_msr)
+			     );
+
+	guest_assert_event_count(idx, event, pmc, pmc_msr);
+}
+
+static void guest_test_arch_event(uint8_t idx)
+{
+	const struct {
+		struct kvm_x86_pmu_feature gp_event;
+	} intel_event_to_feature[] = {
+		[INTEL_ARCH_CPU_CYCLES]		   = { X86_PMU_FEATURE_CPU_CYCLES },
+		[INTEL_ARCH_INSTRUCTIONS_RETIRED]  = { X86_PMU_FEATURE_INSNS_RETIRED },
+		[INTEL_ARCH_REFERENCE_CYCLES]	   = { X86_PMU_FEATURE_REFERENCE_CYCLES },
+		[INTEL_ARCH_LLC_REFERENCES]	   = { X86_PMU_FEATURE_LLC_REFERENCES },
+		[INTEL_ARCH_LLC_MISSES]		   = { X86_PMU_FEATURE_LLC_MISSES },
+		[INTEL_ARCH_BRANCHES_RETIRED]	   = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED },
+		[INTEL_ARCH_BRANCHES_MISPREDICTED] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED },
+	};
+
+	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	uint32_t pmu_version = guest_get_pmu_version();
+	/* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+. */
+	bool guest_has_perf_global_ctrl = pmu_version >= 2;
+	struct kvm_x86_pmu_feature gp_event;
+	uint32_t base_pmc_msr;
+	unsigned int i;
+
+	/* The host side shouldn't invoke this without a guest PMU. */
+	GUEST_ASSERT(pmu_version);
+
+	if (this_cpu_has(X86_FEATURE_PDCM) &&
+	    rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
+		base_pmc_msr = MSR_IA32_PMC0;
+	else
+		base_pmc_msr = MSR_IA32_PERFCTR0;
+
+	gp_event = intel_event_to_feature[idx].gp_event;
+	GUEST_ASSERT_EQ(idx, gp_event.f.bit);
+
+	GUEST_ASSERT(nr_gp_counters);
+
+	for (i = 0; i < nr_gp_counters; i++) {
+		uint64_t eventsel = ARCH_PERFMON_EVENTSEL_OS |
+				    ARCH_PERFMON_EVENTSEL_ENABLE |
+				    intel_pmu_arch_events[idx];
+
+		wrmsr(MSR_P6_EVNTSEL0 + i, 0);
+		if (guest_has_perf_global_ctrl)
+			wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(i));
+
+		__guest_test_arch_event(idx, gp_event, i, base_pmc_msr + i,
+					MSR_P6_EVNTSEL0 + i, eventsel);
+	}
+}
+
+static void guest_test_arch_events(void)
+{
+	uint8_t i;
+
+	for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++)
+		guest_test_arch_event(i);
+
+	GUEST_DONE();
+}
+
+static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
+			     uint8_t length, uint32_t unavailable_mask)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Testing arch events requires a vPMU (there are no negative tests). */
+	if (!pmu_version)
+		return;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_arch_events,
+					 pmu_version, perf_capabilities);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH,
+				length);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EVENTS_MASK,
+				unavailable_mask);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+static void test_intel_counters(void)
+{
+	uint8_t nr_arch_events = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
+	unsigned int i;
+	uint8_t v, j;
+	uint32_t k;
+
+	const uint64_t perf_caps[] = {
+		0,
+		PMU_CAP_FW_WRITES,
+	};
+
+	/*
+	 * Test up to PMU v5, which is the current maximum version defined by
+	 * Intel, i.e. is the last version that is guaranteed to be backwards
+	 * compatible with KVM's existing behavior.
+	 */
+	uint8_t max_pmu_version = max_t(typeof(pmu_version), pmu_version, 5);
+
+	/*
+	 * Verify that KVM is sanitizing the architectural events, i.e. hiding
+	 * events that KVM doesn't support.  This will fail any time KVM adds
+	 * support for a new event, but it's worth paying that price to be able
+	 * to detect KVM bugs.
+	 */
+	TEST_ASSERT(nr_arch_events <= NR_INTEL_ARCH_EVENTS,
+		    "KVM is either buggy, or has learned new tricks (length = %u, mask = %x)",
+		    nr_arch_events, kvm_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
+
+	/*
+	 * Force iterating over known arch events regardless of whether or not
+	 * KVM/hardware supports a given event.
+	 */
+	nr_arch_events = max_t(typeof(nr_arch_events), nr_arch_events, NR_INTEL_ARCH_EVENTS);
+
+	for (v = 0; v <= max_pmu_version; v++) {
+		for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
+			if (!kvm_has_perf_caps && perf_caps[i])
+				continue;
+
+			pr_info("Testing arch events, PMU version %u, perf_caps = %lx\n",
+				v, perf_caps[i]);
+			/*
+			 * To keep the total runtime reasonable, test every
+			 * possible non-zero, non-reserved bitmap combination
+			 * only with the native PMU version and the full bit
+			 * vector length.
+			 */
+			if (v == pmu_version) {
+				for (k = 1; k < (BIT(nr_arch_events) - 1); k++)
+					test_arch_events(v, perf_caps[i], nr_arch_events, k);
+			}
+			/*
+			 * Test single bits for all PMU version and lengths up
+			 * the number of events +1 (to verify KVM doesn't do
+			 * weird things if the guest length is greater than the
+			 * host length).  Explicitly test a mask of '0' and all
+			 * ones i.e. all events being available and unavailable.
+			 */
+			for (j = 0; j <= nr_arch_events + 1; j++) {
+				test_arch_events(v, perf_caps[i], j, 0);
+				test_arch_events(v, perf_caps[i], j, -1u);
+
+				for (k = 0; k < nr_arch_events; k++)
+					test_arch_events(v, perf_caps[i], j, BIT(k));
+			}
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+
+	TEST_REQUIRE(host_cpu_is_intel);
+	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
+	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
+
+	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
+	kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
+
+	test_intel_counters();
+
+	return 0;
+}
-- 
2.42.0.869.gea05f2083d-goog


