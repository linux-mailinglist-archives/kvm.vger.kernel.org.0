Return-Path: <kvm+bounces-1105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC42E7E4E13
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:32:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9196B2814C1
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C030679E5;
	Wed,  8 Nov 2023 00:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TQNj32ib"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4322610C
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:31:54 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83B61710
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:31:53 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9a5a3f2d4fso7256005276.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403513; x=1700008313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M4yIuLWtUhd20HNDbIbdJZg/15m7GuOnQW/l0bWB/Yg=;
        b=TQNj32ibUGvqOlULKYklb2l45iGtZbUtdmt9uwG3qyh5cTxOQauZFKnbZRM8H3ar2H
         wbqfaArK/cWVYjPBX4QG7qtmtNBm+/XXpMZlo27i6L7OyyM/HgLnHX6fXR7z/jJ5tsOU
         dgueE06HAIivwAbnhePCuHW/M9TbS8JDjoWf2kyW6BFf/BZwdiL3+0NHc2I0hYSvyF0e
         IOmjY8NfBtCuSjJd/HtitMHlqEXZSItjaAma4Nr3cwXizkfT957c/lg2u+EmOaiWctRk
         eP+3RkhAe5D68QFXUpNjAER7RpIKHwoXx2cFasZxWznDy+3jswZVbc3XBxwvJWiUR8Az
         v3HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403513; x=1700008313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M4yIuLWtUhd20HNDbIbdJZg/15m7GuOnQW/l0bWB/Yg=;
        b=n1PmUTl2oiuvc5Jg/ClOYbUB9ZpNjubcFGaWTNbu2Ffv+VwmuNNoQaaouCakC9E8is
         GPcdTcz9hByiyqZivkGhhiY2eMIi85Kh5Qk/5wSdNhc12HhWXmzNVF5+n24DeYUI2Bmr
         Y7Fo64NUDxWTcmmQcX/oBW6C4bSCY0yPuRfMmDIzjQYAgluutPbRCyYdCznwt0C1qz0N
         5S4R2sI3jK7MA0RWI/C6b2z5Ju0L/NXcj4OxBhQOdiL0ULPC6MEnUNOfNelKqu9Fjivw
         nCQxsQoiwYUefF/PG4eeFRW29Wh7rFcO4rmEKK8ExlIuSZGk+CiIqU5d7VgP9I//sjP8
         /1tA==
X-Gm-Message-State: AOJu0Yy0ketFLgLnN/SpwwKIIOCugYquqg1IG7QCkudGBL8wd5RmU603
	F3etOLAp4QFqzzvRdaM7goKrV45alEs=
X-Google-Smtp-Source: AGHT+IHsCY6ukPLMgBIpgrZV4IP7VOUx73LJtwvx6GOvx1AOW9j3qL7P05yYFoSxtVF8CAuUJn46hapPNlQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e64a:0:b0:da0:29ba:668c with SMTP id
 d71-20020a25e64a000000b00da029ba668cmr5699ybh.10.1699403512902; Tue, 07 Nov
 2023 16:31:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:23 -0800
In-Reply-To: <20231108003135.546002-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-8-seanjc@google.com>
Subject: [PATCH v7 07/19] KVM: selftests: Extend {kvm,this}_pmu_has() to
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


