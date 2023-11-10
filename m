Return-Path: <kvm+bounces-1425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 407687E7736
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:14:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CC761F20C9A
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10561D53A;
	Fri, 10 Nov 2023 02:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wOMhZfNs"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1163DD27C
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:45 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEE24C25
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:44 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a8ee6a1801so21684927b3.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582424; x=1700187224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XsCEN3l3oF0ZDvkpcqpL7JaNvnVu4RYlqqAiIGk0Efw=;
        b=wOMhZfNs/OtQe2i1QJ0I4QydtAXFyC0SPta5Ienqk/f/wamLhcMht98RIKsJJYLfX1
         XgiZhP5ydRBXiRJeDgMV/g28jAyXxmzeIOI6Yslf5JC9H+w10c9j5zzYvSZZ5SerQF+4
         djp9RkJPXTC9jm+hGtx2NANEmrJS/LqxFLfNTmgV50eMBHp6q27YxtYTEBCCs79nO475
         YSCg/SNQkqTe0mjYG9k7vL85TLFoK5ZlE57iIlINiB1xkfcTwGMu0PuFHx3QqINnuQH6
         6pYJjEfDpR0q38OOfblC5bkCd48MWu9JUzT/JwNAVWQ2kU039EOVyqPiz+JFVWZ2Xc//
         RG1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582424; x=1700187224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XsCEN3l3oF0ZDvkpcqpL7JaNvnVu4RYlqqAiIGk0Efw=;
        b=CuGM2ztycwM7S9lw2J9CX5zvAeM/JpRxlLwtu2hvj6skSyweAEntUsYYv6FmBl427y
         FOrMwyx1v/KNveYnhCl6IAZzoCJ4yIa4BaRgGl8Vxki7RgDR5URuD4S6tnfIezunuC6A
         Qz0VM7Dj7URQiniNUTS0J/53uEPej77aNRAZmLdS59JnlhMKqWZ4dv6d1DUuOCFONQNN
         gH7bY8w7403I8ORygjNUkfZL0rGxAk7/AlZsea0VAAIor1lwROboQWMW5Jf56yzFGjgQ
         rdZJWT2fBT8g39aoDT1BvF/CeSt7hKT2gBAXJVjWRElCiJmb3J0EqVVmEweeyth6vakR
         NwjA==
X-Gm-Message-State: AOJu0Ywzb1dB7ebwabN7r317oov1gf7vZwQdcX4aumuwpjPQWSj24XcG
	CRoifwg3TJJbZm8lFOoz+8+IEHxWzD0=
X-Google-Smtp-Source: AGHT+IFWK+6sL9KwZ+nJl4p66fxFuqimLE8EqV84Q8ZM4czaUMtTCJSKHWDpDs5UxpFNiLyemNbwHQsRN/w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:f80e:0:b0:5bf:5720:4fdc with SMTP id
 z14-20020a81f80e000000b005bf57204fdcmr117185ywm.6.1699582423770; Thu, 09 Nov
 2023 18:13:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:56 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-17-seanjc@google.com>
Subject: [PATCH v8 16/26] KVM: selftests: Test consistency of CPUID with num
 of fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Extend the PMU counters test to verify KVM emulation of fixed counters in
addition to general purpose counters.  Fixed counters add an extra wrinkle
in the form of an extra supported bitmask.  Thus quoth the SDM:

  fixed-function performance counter 'i' is supported if ECX[i] || (EDX[4:0] > i)

Test that KVM handles a counter being available through either method.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 60 ++++++++++++++++++-
 1 file changed, 57 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 863418842ef8..b07294af71a3 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -290,7 +290,7 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 		       msr, expected_val, val);
 
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
-				 uint8_t nr_counters)
+				 uint8_t nr_counters, uint32_t or_mask)
 {
 	uint8_t i;
 
@@ -301,7 +301,13 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		 */
 		const uint64_t test_val = 0xffff;
 		const uint32_t msr = base_msr + i;
-		const bool expect_success = i < nr_counters;
+
+		/*
+		 * Fixed counters are supported if the counter is less than the
+		 * number of enumerated contiguous counters *or* the counter is
+		 * explicitly enumerated in the supported counters mask.
+		 */
+		const bool expect_success = i < nr_counters || (or_mask & BIT(i));
 
 		/*
 		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
@@ -343,7 +349,7 @@ static void guest_test_gp_counters(void)
 	else
 		base_msr = MSR_IA32_PERFCTR0;
 
-	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters);
+	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0);
 }
 
 static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
@@ -363,9 +369,50 @@ static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 	kvm_vm_free(vm);
 }
 
+static void guest_test_fixed_counters(void)
+{
+	uint64_t supported_bitmask = 0;
+	uint8_t nr_fixed_counters = 0;
+
+	/* Fixed counters require Architectural vPMU Version 2+. */
+	if (guest_get_pmu_version() >= 2)
+		nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+
+	/*
+	 * The supported bitmask for fixed counters was introduced in PMU
+	 * version 5.
+	 */
+	if (guest_get_pmu_version() >= 5)
+		supported_bitmask = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK);
+
+	guest_rd_wr_counters(MSR_CORE_PERF_FIXED_CTR0, MAX_NR_FIXED_COUNTERS,
+			     nr_fixed_counters, supported_bitmask);
+}
+
+static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
+				uint8_t nr_fixed_counters,
+				uint32_t supported_bitmask)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_fixed_counters,
+					 pmu_version, perf_capabilities);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
+				supported_bitmask);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_FIXED_COUNTERS,
+				nr_fixed_counters);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
 static void test_intel_counters(void)
 {
 	uint8_t nr_arch_events = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
 	unsigned int i;
@@ -435,6 +482,13 @@ static void test_intel_counters(void)
 				v, perf_caps[i]);
 			for (j = 0; j <= nr_gp_counters; j++)
 				test_gp_counters(v, perf_caps[i], j);
+
+			pr_info("Testing fixed counters, PMU version %u, perf_caps = %lx\n",
+				v, perf_caps[i]);
+			for (j = 0; j <= nr_fixed_counters; j++) {
+				for (k = 0; k <= (BIT(nr_fixed_counters) - 1); k++)
+					test_fixed_counters(v, perf_caps[i], j, k);
+			}
 		}
 	}
 }
-- 
2.42.0.869.gea05f2083d-goog


