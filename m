Return-Path: <kvm+bounces-1442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8147E777E
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7481D2814E4
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A89D4A3B;
	Fri, 10 Nov 2023 02:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aGTsrWI6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8144B23C9
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:29:13 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A2A4687
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:29:12 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da0c6d62ec8so1930496276.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699583351; x=1700188151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5SlrZj36n0KChIF9h7ClFhiP6zYdMuLYWl1Pm7fXb0o=;
        b=aGTsrWI6rNx2REpLaZfKFSLSD/hcmTzs1814Pp82zEYuYvL3JggSLNVzAob/txjcJs
         ldcP57jwqy9gnJNPzwVvM4qC/WOsXZ7+/5UblA3iyFsP5QK53pXs37YBELaYwv9NNLKi
         9MMo2fBt40/WVfbubfj/RfJ0EscJyX9nTCODarsHSbV0xcYg7K56LU43PEoCWP5HgMSD
         /QetNZmWomGIDPb1Cr7GObxq32cUg3hNIWqnoawoWGgckqVd9EijwzaM8IqocF3TeE65
         MEJWuV4srT4g31h1NomwG3MmDAKyNMS/KNL/8cz/YvK5a19yS5e3zMLcosAI8G/qF2zu
         Hs4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699583351; x=1700188151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5SlrZj36n0KChIF9h7ClFhiP6zYdMuLYWl1Pm7fXb0o=;
        b=qvIgNAvz/gwK3Bt4MnV5CbMEfTnmHLcWpp0QA0O5xrlwbwl5hvIdEEfviyrs9ME6xV
         TiahYRFWE5n2TIMAfPBa2UezX4o5JhoLqc8nAXZ+7rcbI+0WvUlcqWpEJe+K9G6PHO3T
         wghaPILDsGPUzW4CcOG74KmV42kpHBonNjioSepr1LZkcZv89jzDB97jZW/PB1RtlpDx
         kbW9tIwHOTkCZselFvjz/pftVXPjm673wwh+I5KgYvYmNAx3+JV4DLKEVGChKHFzJKkr
         XOf7PGJWxFZ7yeUONCZL1xQESx+G134dfbm4ygIpOLWkNVZoBNEBw2qw2cGcyi3RKwjh
         9kIA==
X-Gm-Message-State: AOJu0YwepI25RMrl/z7i1UuUgXc4N2kBfmU/n3+uCoERHnKgd5KyG4lX
	U9Fw9ZtZHDNKIiUpp7Sc7UwGMQFQHxc=
X-Google-Smtp-Source: AGHT+IGFCa9KkZ81i+JJNjZhR4CIbz66m6zI5H/yCZMjmXJL+cscV1zQxhDZNMxmnsOJUKFv8SOM0ug181w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:f12:0:b0:da1:513d:8a3c with SMTP id
 x18-20020a5b0f12000000b00da1513d8a3cmr161843ybr.11.1699583351272; Thu, 09 Nov
 2023 18:29:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:28:52 -0800
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110022857.1273836-6-seanjc@google.com>
Subject: [PATCH 05/10] KVM: x86/pmu: Add macros to iterate over all PMCs given
 a bitmap
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Add and use kvm_for_each_pmc() to dedup a variety of open coded for-loops
that iterate over valid PMCs given a bitmap (and because seeing checkpatch
whine about bad macro style is always amusing).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c           | 26 +++++++-------------------
 arch/x86/kvm/pmu.h           |  6 ++++++
 arch/x86/kvm/vmx/pmu_intel.c |  7 ++-----
 3 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index ee921b24d9e4..0e2175170038 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -493,6 +493,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
 	int bit;
 
 	bitmap_copy(bitmap, pmu->reprogram_pmi, X86_PMC_IDX_MAX);
@@ -505,12 +506,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(sizeof(bitmap) != sizeof(atomic64_t));
 	atomic64_andnot(*(s64 *)bitmap, &pmu->__reprogram_pmi);
 
-	for_each_set_bit(bit, bitmap, X86_PMC_IDX_MAX) {
-		struct kvm_pmc *pmc = kvm_pmc_idx_to_pmc(pmu, bit);
-
-		if (unlikely(!pmc))
-			continue;
-
+	kvm_for_each_pmc(pmu, pmc, bit, bitmap) {
 		/*
 		 * If reprogramming fails, e.g. due to contention, re-set the
 		 * regprogram bit set, i.e. opportunistically try again on the
@@ -720,11 +716,7 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 
 	bitmap_zero(pmu->reprogram_pmi, X86_PMC_IDX_MAX);
 
-	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
-		pmc = kvm_pmc_idx_to_pmc(pmu, i);
-		if (!pmc)
-			continue;
-
+	kvm_for_each_pmc(pmu, pmc, i, pmu->all_valid_pmc_idx) {
 		pmc_stop_counter(pmc);
 		pmc->counter = 0;
 		pmc->emulated_counter = 0;
@@ -796,10 +788,8 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 	bitmap_andnot(bitmask, pmu->all_valid_pmc_idx,
 		      pmu->pmc_in_use, X86_PMC_IDX_MAX);
 
-	for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
-		pmc = kvm_pmc_idx_to_pmc(pmu, i);
-
-		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
+	kvm_for_each_pmc(pmu, pmc, i, bitmask) {
+		if (pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
 	}
 
@@ -851,10 +841,8 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	struct kvm_pmc *pmc;
 	int i;
 
-	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
-		pmc = kvm_pmc_idx_to_pmc(pmu, i);
-
-		if (!pmc || !pmc_event_is_allowed(pmc))
+	kvm_for_each_pmc(pmu, pmc, i, pmu->all_valid_pmc_idx) {
+		if (!pmc_event_is_allowed(pmc))
 			continue;
 
 		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 2235772a495b..cb62a4e44849 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -83,6 +83,12 @@ static inline struct kvm_pmc *kvm_pmc_idx_to_pmc(struct kvm_pmu *pmu, int idx)
 	return NULL;
 }
 
+#define kvm_for_each_pmc(pmu, pmc, i, bitmap)			\
+	for_each_set_bit(i, bitmap, X86_PMC_IDX_MAX)		\
+		if (!(pmc = kvm_pmc_idx_to_pmc(pmu, i)))	\
+			continue;				\
+		else						\
+
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4254411be467..ee3e122d3617 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -696,11 +696,8 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 	struct kvm_pmc *pmc = NULL;
 	int bit, hw_idx;
 
-	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
-			 X86_PMC_IDX_MAX) {
-		pmc = kvm_pmc_idx_to_pmc(pmu, bit);
-
-		if (!pmc || !pmc_speculative_in_use(pmc) ||
+	kvm_for_each_pmc(pmu, pmc, bit, (unsigned long *)&pmu->global_ctrl) {
+		if (!pmc_speculative_in_use(pmc) ||
 		    !pmc_is_globally_enabled(pmc) || !pmc->perf_event)
 			continue;
 
-- 
2.42.0.869.gea05f2083d-goog


