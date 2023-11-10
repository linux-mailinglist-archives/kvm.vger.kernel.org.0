Return-Path: <kvm+bounces-1420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C905F7E772C
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:14:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5194E2813C8
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658F263C5;
	Fri, 10 Nov 2023 02:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zefFNpVl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714105693
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:35 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB31049E3
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:34 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7be940fe1so23043327b3.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582414; x=1700187214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M4yIuLWtUhd20HNDbIbdJZg/15m7GuOnQW/l0bWB/Yg=;
        b=zefFNpVlxuCkclztqH9JizuJHC/TPjA8/dPN/PIK+fJ4vDFtV0MISBGhLicZ5Rao4e
         rCixlIZsnfxGe+RBPWmQ1nJ8ytPtCNZt17JNWP+9mqYhGcIG3PxwBMr6vkBqmzHAg1xq
         NB70TO45IUYF8FubSvl0DlEoLRn2n4z+0mzMBUkZ52i85fZP3HCGw+PMG04jsS6OobR9
         nYJEw4XW/P2jHH6jJXRHQpY2Mo4eIfAEcw7SbMKAjxZ+YZlNxZ75rnMeX91YF/z4BWX2
         yKnt20AzeCDW604lm57WwBc124/3jrWu78sscZRsmb8ElP3CzSzXp5VeYx8NwisVzk4o
         mxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582414; x=1700187214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M4yIuLWtUhd20HNDbIbdJZg/15m7GuOnQW/l0bWB/Yg=;
        b=jDlcsTZE6EndeCSZZ362HQq4ZWPgbxObX5VOGceTphiYNuPiFtZe4E6Du8lUKLUrgv
         Xnn0F6s+S2l64ZXGjbXpwxQXD44cYycI6lqzE8KH9MhIaJbOKCLQeQ6ZRZTEzWtL5RS/
         6Ftk9NmOjK+igQdgAa/7C1t1h4NSTLHEHYeb8d5gkx6qGyUby3m3KTiXeI1odgbHUOgr
         S1Z3c4O7Lo+SxpXgIvvDV4su0ie8Q11qmkm3R0iorGRmYhZjleMe/aA4fQ4bLqetGo5s
         bg4xv/CXwkezbkrAwO/oECY0+j3lc7BWjGWGCU+BcHt1byOnK7o5VFTubIEoA70B+1GP
         3mSw==
X-Gm-Message-State: AOJu0Yy5vDgkDLjcUNXMRkWJGDXlbKbc4SjUPR77ISvBxJiiFeHMuUU8
	Sct4dA96spYggMLq0VjnxgMfU9XsyLY=
X-Google-Smtp-Source: AGHT+IEN+BEM0Oq7nFG3DrxdoKg8zIRBDYgi3uLzcS29GsKLOgkU1WZCTMakf6xOHXIkktNQipxI4x8HR6E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9ac9:0:b0:d90:e580:88e5 with SMTP id
 t9-20020a259ac9000000b00d90e58088e5mr185777ybo.10.1699582413990; Thu, 09 Nov
 2023 18:13:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:51 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-12-seanjc@google.com>
Subject: [PATCH v8 11/26] KVM: selftests: Extend {kvm,this}_pmu_has() to
 support fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
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

Opportunistically define macros for all of the known architectural events
and fixed counters.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 65 ++++++++++++++-----
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 2d9771151dd9..64aecb3dcf60 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -281,24 +281,41 @@ struct kvm_x86_cpu_property {
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
+#define X86_PMU_FEATURE_CPU_CYCLES			KVM_X86_PMU_FEATURE(EBX, 0)
+#define X86_PMU_FEATURE_INSNS_RETIRED			KVM_X86_PMU_FEATURE(EBX, 1)
+#define X86_PMU_FEATURE_REFERENCE_CYCLES		KVM_X86_PMU_FEATURE(EBX, 2)
+#define X86_PMU_FEATURE_LLC_REFERENCES			KVM_X86_PMU_FEATURE(EBX, 3)
+#define X86_PMU_FEATURE_LLC_MISSES			KVM_X86_PMU_FEATURE(EBX, 4)
+#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED		KVM_X86_PMU_FEATURE(EBX, 5)
+#define X86_PMU_FEATURE_BRANCHES_MISPREDICTED		KVM_X86_PMU_FEATURE(EBX, 6)
+#define X86_PMU_FEATURE_TOPDOWN_SLOTS			KVM_X86_PMU_FEATURE(EBX, 7)
+
+#define X86_PMU_FEATURE_INSNS_RETIRED_FIXED		KVM_X86_PMU_FEATURE(ECX, 0)
+#define X86_PMU_FEATURE_CPU_CYCLES_FIXED		KVM_X86_PMU_FEATURE(ECX, 1)
+#define X86_PMU_FEATURE_REFERENCE_TSC_CYCLES_FIXED	KVM_X86_PMU_FEATURE(ECX, 2)
+#define X86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED		KVM_X86_PMU_FEATURE(ECX, 3)
 
 static inline unsigned int x86_family(unsigned int eax)
 {
@@ -697,10 +714,16 @@ static __always_inline bool this_cpu_has_p(struct kvm_x86_cpu_property property)
 
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
@@ -916,10 +939,16 @@ static __always_inline bool kvm_cpu_has_p(struct kvm_x86_cpu_property property)
 
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


