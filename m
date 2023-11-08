Return-Path: <kvm+bounces-1109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 529547E4E19
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07AF8281487
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8928DD517;
	Wed,  8 Nov 2023 00:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iMlPBMR9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599BFD270
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:32:03 +0000 (UTC)
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BD019AA
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:32:02 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5b83d8797f4so4143136a12.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403522; x=1700008322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fciy2uDvKGS0QuzQncpVsszUsz4UsN4JK2VW9jvddoA=;
        b=iMlPBMR9Z1f9Jqjw5qC4hVmNv+O2KtmDsKzTH4+ikfhU69VZCUMJtCd4aMc7hNtrMx
         ycqRLH2MCdjUBJMkcyUC8DSkasWrbt/rawjthKCpVkRY3I81g4oOUdUnteMJFwfC6RKi
         XOK4U7nK4ryseriWxa3U5sxe7inwa2O56gKtx/CpOaCr5bMu5I+HFmQvU1n3T9vcEtRg
         JVIvC02UQ4Jwb6WEUQMfFJ+r0Wu0W0rzGnvfkoFMKRV7BtMvyBeeCITDlkS4EbNZGYJC
         W5B9hfJXRSmKCRxxJsxOcb7DS0etwmraQt+uUSy/BcvrIn/1IMm+/OfMNRzwTJewNWQp
         PS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403522; x=1700008322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fciy2uDvKGS0QuzQncpVsszUsz4UsN4JK2VW9jvddoA=;
        b=Hli0GBXiI+d5d8e8dsPL+oqBXaUZZO0hGjAAJND16M+94BFgllHRGnRbtGvajcdM54
         ydwvT4RhwwXWkdqpYjXMuLDi/w8N/OwegkWVimIc7SJYzDARqaiEH7mk8swj5F5+Zqo+
         luMxrYa/1nOAvsCmPn2U/cY79aa3Rx9dXPTqxPZP+HZTIMum3l+YGriC8Bufdi9ZeDOR
         sJYm76wUJjd9Chyl4BbSWCd6mTNu88ldy0gA3vRdGXqp7yZPCquzmY1hdlzxc/xIy4Cp
         PcUus4kkgRT5gQVz0nGwYwXPTwwOTZirkjvvuETMYa8R+VqRzDt8EF1DS+HFPghUeTP4
         vvyQ==
X-Gm-Message-State: AOJu0Yw9fPPryz3SQyeQmUZC5+Y04k0rzth87W5ubgTyd/LRQBtPzLEw
	m7NTzZsggioG0mhZxj7sZD9YrryS4kY=
X-Google-Smtp-Source: AGHT+IHMuYF2+iZ2VvvDlMt1HkKtNauUZsTlq1nLCyu12iuTLGfh3fvFc6T9HnHRl5eL99ZwT64GS/jktzI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ef8f:b0:1cc:454f:73dc with SMTP id
 iz15-20020a170902ef8f00b001cc454f73dcmr8085plb.7.1699403521842; Tue, 07 Nov
 2023 16:32:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:27 -0800
In-Reply-To: <20231108003135.546002-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-12-seanjc@google.com>
Subject: [PATCH v7 11/19] KVM: selftests: Test consistency of CPUID with num
 of gp counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Add a test to verify that KVM correctly emulates MSR-based accesses to
general purpose counters based on guest CPUID, e.g. that accesses to
non-existent counters #GP and accesses to existent counters succeed.

Note, for compatibility reasons, KVM does not emulate #GP when
MSR_P6_PERFCTR[0|1] is not present (writes should be dropped).

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 9cd308417aeb..6f2d3a64a118 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -270,9 +270,95 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
 	kvm_vm_free(vm);
 }
 
+/*
+ * Limit testing to MSRs that are actually defined by Intel (in the SDM).  MSRs
+ * that aren't defined counter MSRs *probably* don't exist, but there's no
+ * guarantee that currently undefined MSR indices won't be used for something
+ * other than PMCs in the future.
+ */
+#define MAX_NR_GP_COUNTERS	8
+#define MAX_NR_FIXED_COUNTERS	3
+
+#define GUEST_ASSERT_PMC_MSR_ACCESS(insn, msr, expect_gp, vector)		\
+__GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
+	       "Expected %s on " #insn "(0x%x), got vector %u",			\
+	       expect_gp ? "#GP" : "no fault", msr, vector)			\
+
+static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
+				 uint8_t nr_counters)
+{
+	uint8_t i;
+
+	for (i = 0; i < nr_possible_counters; i++) {
+		const uint32_t msr = base_msr + i;
+		const bool expect_success = i < nr_counters;
+
+		/*
+		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
+		 * unsupported, i.e. doesn't #GP and reads back '0'.
+		 */
+		const uint64_t expected_val = expect_success ? 0xffff : 0;
+		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
+				       msr != MSR_P6_PERFCTR1;
+		uint8_t vector;
+		uint64_t val;
+
+		vector = wrmsr_safe(msr, 0xffff);
+		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
+
+		vector = rdmsr_safe(msr, &val);
+		GUEST_ASSERT_PMC_MSR_ACCESS(RDMSR, msr, expect_gp, vector);
+
+		/* On #GP, the result of RDMSR is undefined. */
+		if (!expect_gp)
+			__GUEST_ASSERT(val == expected_val,
+				       "Expected RDMSR(0x%x) to yield 0x%lx, got 0x%lx",
+				       msr, expected_val, val);
+
+		vector = wrmsr_safe(msr, 0);
+		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
+	}
+	GUEST_DONE();
+}
+
+static void guest_test_gp_counters(void)
+{
+	uint8_t nr_gp_counters = 0;
+	uint32_t base_msr;
+
+	if (guest_get_pmu_version())
+		nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+
+	if (this_cpu_has(X86_FEATURE_PDCM) &&
+	    rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
+		base_msr = MSR_IA32_PMC0;
+	else
+		base_msr = MSR_IA32_PERFCTR0;
+
+	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters);
+}
+
+static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
+			     uint8_t nr_gp_counters)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_gp_counters,
+					 pmu_version, perf_capabilities);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_GP_COUNTERS,
+				nr_gp_counters);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
 static void test_intel_counters(void)
 {
 	uint8_t nr_arch_events = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
 	unsigned int i;
 	uint8_t v, j;
@@ -336,6 +422,11 @@ static void test_intel_counters(void)
 				for (k = 0; k < nr_arch_events; k++)
 					test_arch_events(v, perf_caps[i], j, BIT(k));
 			}
+
+			pr_info("Testing GP counters, PMU version %u, perf_caps = %lx\n",
+				v, perf_caps[i]);
+			for (j = 0; j <= nr_gp_counters; j++)
+				test_gp_counters(v, perf_caps[i], j);
 		}
 	}
 }
-- 
2.42.0.869.gea05f2083d-goog


