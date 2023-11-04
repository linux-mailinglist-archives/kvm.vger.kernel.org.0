Return-Path: <kvm+bounces-555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 340D67E0C7A
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CF4428200D
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C61D6ABC;
	Sat,  4 Nov 2023 00:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DccDeXfi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AE34C78
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:02:58 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A221D68
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:02:56 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc3ad55c75so20674855ad.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056176; x=1699660976; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=L3Ph1WGBEgHW7QvmfHelm4EacJM/EhO7PSNkxK0HmCo=;
        b=DccDeXfiDvfv1fBWEzY45WjEbiOWdrzZaTNQV4f0F7uJwEyYRbB+VVZf9wIn1IeCTE
         iUVhrrFl/42ZXS4ylZj3+rYQbFEFxo1SVJWWPyw6CfR3I1AzEgsH+SlCQqrCiYl6GZT3
         MYnHtkO1Fn1LmgGtqObBctRZ7WRfIotrQqHt7wIFyJ6lvVudHnoKz/0402GO07m1C12a
         sHT3RmqN+J7A0OQqLbzMuwW8AMKjv8b2iU4mDN4lZYLYNMqS72px5WI4hPFrDV50O/mF
         YQLqOd7nEQvgbLuV+RXSkqHYfMgwkEowuSi7XSedAqeNJUx291KThC4BoNpi5+JXYlXc
         jLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056176; x=1699660976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L3Ph1WGBEgHW7QvmfHelm4EacJM/EhO7PSNkxK0HmCo=;
        b=Q3PcqPqa2pK9QzJGkoQ7QB9zj08um3GP/FREH5Z9JMgHguRgpuprky6s7oBpOw/yPK
         kOddxLAUZN+hdMY23VDTrUJY/O2kDGvMF6hG/NNtpD8n/mPjK4hS9RSn7fW1mA1iexQ1
         JUdZ9GA4An1OTb+jdRBAeo83hwuScR48mXZImLBenEj1b9dx5gV4pX23hbfrdiJwDN6/
         5/ByAnDhdxjCF2zOSyX1pU4IbQVaQKPcqp1C1M2c7YWlR4smS5Aeab41bUmG1XNI4uqa
         MV1AiNxBq5PZfrlkfFXNHwTpWPdWwiMiZ1IyEOcSg+2EEWhUb/SLVbt8xPJM6IKKY5Tu
         4xBA==
X-Gm-Message-State: AOJu0Yzz/sfN6uvD5Q8LCvxL90A6Qkxw7QVFuifVqUIbh70xeWlxoOSc
	x7TYuWwRVhxiZed/y8YLJyebgnzHsvY=
X-Google-Smtp-Source: AGHT+IF+xtFGk+3kSZATAuvt1FOAxavnxlitpSZmorzLd17NCJnmNvLwfKoliM6+iK7h6vXq068eMlQgu0k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d301:b0:1cc:32c6:e5d4 with SMTP id
 b1-20020a170902d30100b001cc32c6e5d4mr312291plc.6.1699056176128; Fri, 03 Nov
 2023 17:02:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:26 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-9-seanjc@google.com>
Subject: [PATCH v6 08/20] KVM: selftests: Extend {kvm,this}_pmu_has() to
 support fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend the kvm_x86_pmu_feature framework to allow querying for fixed
counters via {kvm,this}_pmu_has().  Like architectural events, checking
for a fixed counter annoyingly requires checking multiple CPUID fields, as
a fixed counter exists if:

  FxCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i);

Note, KVM currently doesn't actually support exposing fixed counters via
the bitmask, but that will hopefully change sooner than later, and Intel's
SDM explicitly "recommends" checking both the number of counters and the
mask.

Rename the intermedate "anti_feature" field to simply 'f' since the fixed
counter bitmask (thankfully) doesn't have reversed polarity like the
architectural events bitmask.

Note, ideally the helpers would use BUILD_BUG_ON() to assert on the
incoming register, but the expected usage in PMU tests can't guarantee the
inputs are compile-time constants.

Opportunistically define macros for all of the architectural events and
fixed counters that KVM currently supports.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 63 +++++++++++++------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 2d9771151dd9..b103c462701b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -281,24 +281,39 @@ struct kvm_x86_cpu_property {
  * that indicates the feature is _not_ supported, and a property that states
  * the length of the bit mask of unsupported features.  A feature is supported
  * if the size of the bit mask is larger than the "unavailable" bit, and said
- * bit is not set.
+ * bit is not set.  Fixed counters also bizarre enumeration, but inverted from
+ * arch events for general purpose counters.  Fixed counters are supported if a
+ * feature flag is set **OR** the total number of fixed counters is greater
+ * than index of the counter.
  *
- * Wrap the "unavailable" feature to simplify checking whether or not a given
- * architectural event is supported.
+ * Wrap the events for general purpose and fixed counters to simplify checking
+ * whether or not a given architectural event is supported.
  */
 struct kvm_x86_pmu_feature {
-	struct kvm_x86_cpu_feature anti_feature;
+	struct kvm_x86_cpu_feature f;
 };
-#define	KVM_X86_PMU_FEATURE(__bit)						\
-({										\
-	struct kvm_x86_pmu_feature feature = {					\
-		.anti_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),	\
-	};									\
-										\
-	feature;								\
+#define	KVM_X86_PMU_FEATURE(__reg, __bit)				\
+({									\
+	struct kvm_x86_pmu_feature feature = {				\
+		.f = KVM_X86_CPU_FEATURE(0xa, 0, __reg, __bit),		\
+	};								\
+									\
+	kvm_static_assert(KVM_CPUID_##__reg == KVM_CPUID_EBX ||		\
+			  KVM_CPUID_##__reg == KVM_CPUID_ECX);		\
+	feature;							\
 })
 
-#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(5)
+#define X86_PMU_FEATURE_CPU_CYCLES		KVM_X86_PMU_FEATURE(EBX, 0)
+#define X86_PMU_FEATURE_INSNS_RETIRED		KVM_X86_PMU_FEATURE(EBX, 1)
+#define X86_PMU_FEATURE_REFERENCE_CYCLES	KVM_X86_PMU_FEATURE(EBX, 2)
+#define X86_PMU_FEATURE_LLC_REFERENCES		KVM_X86_PMU_FEATURE(EBX, 3)
+#define X86_PMU_FEATURE_LLC_MISSES		KVM_X86_PMU_FEATURE(EBX, 4)
+#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(EBX, 5)
+#define X86_PMU_FEATURE_BRANCHES_MISPREDICTED	KVM_X86_PMU_FEATURE(EBX, 6)
+
+#define X86_PMU_FEATURE_INSNS_RETIRED_FIXED	KVM_X86_PMU_FEATURE(ECX, 0)
+#define X86_PMU_FEATURE_CPU_CYCLES_FIXED	KVM_X86_PMU_FEATURE(ECX, 1)
+#define X86_PMU_FEATURE_REFERENCE_CYCLES_FIXED	KVM_X86_PMU_FEATURE(ECX, 2)
 
 static inline unsigned int x86_family(unsigned int eax)
 {
@@ -697,10 +712,16 @@ static __always_inline bool this_cpu_has_p(struct kvm_x86_cpu_property property)
 
 static inline bool this_pmu_has(struct kvm_x86_pmu_feature feature)
 {
-	uint32_t nr_bits = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint32_t nr_bits;
 
-	return nr_bits > feature.anti_feature.bit &&
-	       !this_cpu_has(feature.anti_feature);
+	if (feature.f.reg == KVM_CPUID_EBX) {
+		nr_bits = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+		return nr_bits > feature.f.bit && !this_cpu_has(feature.f);
+	}
+
+	GUEST_ASSERT(feature.f.reg == KVM_CPUID_ECX);
+	nr_bits = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+	return nr_bits > feature.f.bit || this_cpu_has(feature.f);
 }
 
 static __always_inline uint64_t this_cpu_supported_xcr0(void)
@@ -916,10 +937,16 @@ static __always_inline bool kvm_cpu_has_p(struct kvm_x86_cpu_property property)
 
 static inline bool kvm_pmu_has(struct kvm_x86_pmu_feature feature)
 {
-	uint32_t nr_bits = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint32_t nr_bits;
 
-	return nr_bits > feature.anti_feature.bit &&
-	       !kvm_cpu_has(feature.anti_feature);
+	if (feature.f.reg == KVM_CPUID_EBX) {
+		nr_bits = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+		return nr_bits > feature.f.bit && !kvm_cpu_has(feature.f);
+	}
+
+	TEST_ASSERT_EQ(feature.f.reg, KVM_CPUID_ECX);
+	nr_bits = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+	return nr_bits > feature.f.bit || kvm_cpu_has(feature.f);
 }
 
 static __always_inline uint64_t kvm_cpu_supported_xcr0(void)
-- 
2.42.0.869.gea05f2083d-goog


