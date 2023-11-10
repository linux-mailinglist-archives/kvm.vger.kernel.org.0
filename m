Return-Path: <kvm+bounces-1441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F37D7E777B
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:29:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B30D91C20D26
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC17E23DE;
	Fri, 10 Nov 2023 02:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bFn5J5mS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE5D1FBB
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:29:10 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A1444BF
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:29:10 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5bc3be6a91bso20124957b3.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699583349; x=1700188149; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/ewAJtcLDJCjiqPeU8Oy31szzWjWOzI4Ilaj+lyQ/Xs=;
        b=bFn5J5mSZ22wXwvlrgl0UN1xcmAvRiLLTCNYRfW8DB9SC9qNK5USE3A9heh63+PoYG
         IJH565kGwuM0TtiJvr+o+yFQHpBN7ZGgl/XViZy5GNPqJ3kU4ERAb8hU4TGh7XkHpZGX
         sxUYhFa84p5ino0OaMYUR66BhbEU/Gu91c6GvQUSa4QrbR2AMLPeRAukIi2lpKarqVDb
         iOsCk1uJ6a3HelkeU+rAH99VypbuuwHWB4ycH41SQjbZg5mw4HY+Lau6yy7l/Bq63YkE
         ryTzOTivWndXGblsjsj+a902INleON4kxqNfrtFk+2UaAP5O3Sh9QFHvxe/knQGom03e
         4atg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699583349; x=1700188149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ewAJtcLDJCjiqPeU8Oy31szzWjWOzI4Ilaj+lyQ/Xs=;
        b=hqWhPMNY5L2JKyDOERWQRyBfZsPKyd1eCunOr3/kYrExaRFpXiSQ9OWJYPTVdsfNtx
         gQa89jPX1W00fLHm8VOYyJaQxVqdpIKa0lAiyRVi9ag1enCHeV4BwEpZHTN4HKxBkddP
         xVhCfqCjmtmT9gzKzg4Ad4D0xZu99aZKOyio/gSns0lfGaMRGXLhaHzyIAFN6opTL9UY
         qWuWjqnGVbSfErNGTRC1MhtLtAal++MwH2eZBezCCkuaf/MBmyL2W3qQycl/HNYF1QUL
         Vwu/ACdgVbTdWHPdjUELMNx40R1Uc30bfvQRKIo34uQSA0XHv1BH0ihcvfPSeZoEo2WC
         TiCg==
X-Gm-Message-State: AOJu0YxPdak/o6tkgzweKtrAQ0XYDhU+PJ9U4rKuHC3Q4IX2RzHSYDaw
	AmvOorhiDd+dlrJ9p6wU/vt8wl4kyq0=
X-Google-Smtp-Source: AGHT+IHGMt2jktFG5bE27wELiNJLEDJKDs34DhbaMrjwulehu1Br5N+AE3S6fFh8oMDyRfcQwpBoDsQQEX4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d:b0:d89:42d7:e72d with SMTP id
 t13-20020a056902018d00b00d8942d7e72dmr45730ybh.3.1699583349370; Thu, 09 Nov
 2023 18:29:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:28:51 -0800
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110022857.1273836-5-seanjc@google.com>
Subject: [PATCH 04/10] KVM: x86/pmu: Snapshot and clear reprogramming bitmap
 before reprogramming
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Refactor the handling of the reprogramming bitmap to snapshot and clear
to-be-processed bits before doing the reprogramming, and then explicitly
set bits for PMCs that need to be reprogrammed (again).  This will allow
adding a macro to iterate over all valid PMCs without having to add
special handling for the reprogramming bit, which (a) can have bits set
for non-existent PMCs and (b) needs to clear such bits to avoid wasting
cycles in perpetuity.

Note, the existing behavior of clearing bits after reprogramming does NOT
have a race with kvm_vm_ioctl_set_pmu_event_filter().  Setting a new PMU
filter synchronizes SRCU _before_ setting the bitmap, i.e. guarantees that
the vCPU isn't in the middle of reprogramming with a stale filter prior to
setting the bitmap.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 52 ++++++++++++++++++---------------
 2 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d8bc9ba88cfc..22ba24d0fd4f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -535,6 +535,7 @@ struct kvm_pmc {
 #define KVM_PMC_MAX_FIXED	3
 #define MSR_ARCH_PERFMON_FIXED_CTR_MAX	(MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
 #define KVM_AMD_PMC_MAX_GENERIC	6
+
 struct kvm_pmu {
 	u8 version;
 	unsigned nr_arch_gp_counters;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 6ee05ad35f55..ee921b24d9e4 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -444,7 +444,7 @@ static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
 	       check_pmu_event_filter(pmc);
 }
 
-static void reprogram_counter(struct kvm_pmc *pmc)
+static int reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u64 eventsel = pmc->eventsel;
@@ -455,7 +455,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 	emulate_overflow = pmc_pause_counter(pmc);
 
 	if (!pmc_event_is_allowed(pmc))
-		goto reprogram_complete;
+		return 0;
 
 	if (emulate_overflow)
 		__kvm_perf_overflow(pmc, false);
@@ -476,43 +476,49 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 	}
 
 	if (pmc->current_config == new_config && pmc_resume_counter(pmc))
-		goto reprogram_complete;
+		return 0;
 
 	pmc_release_perf_event(pmc);
 
 	pmc->current_config = new_config;
 
-	/*
-	 * If reprogramming fails, e.g. due to contention, leave the counter's
-	 * regprogram bit set, i.e. opportunistically try again on the next PMU
-	 * refresh.  Don't make a new request as doing so can stall the guest
-	 * if reprogramming repeatedly fails.
-	 */
-	if (pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
-				  (eventsel & pmu->raw_event_mask),
-				  !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
-				  !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-				  eventsel & ARCH_PERFMON_EVENTSEL_INT))
-		return;
-
-reprogram_complete:
-	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
+	return pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
+				     (eventsel & pmu->raw_event_mask),
+				     !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
+				     !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
+				     eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
 
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
+	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	int bit;
 
-	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
+	bitmap_copy(bitmap, pmu->reprogram_pmi, X86_PMC_IDX_MAX);
+
+	/*
+	 * The reprogramming bitmap can be written asynchronously by something
+	 * other than the task that holds vcpu->mutex, take care to clear only
+	 * the bits that will actually processed.
+	 */
+	BUILD_BUG_ON(sizeof(bitmap) != sizeof(atomic64_t));
+	atomic64_andnot(*(s64 *)bitmap, &pmu->__reprogram_pmi);
+
+	for_each_set_bit(bit, bitmap, X86_PMC_IDX_MAX) {
 		struct kvm_pmc *pmc = kvm_pmc_idx_to_pmc(pmu, bit);
 
-		if (unlikely(!pmc)) {
-			clear_bit(bit, pmu->reprogram_pmi);
+		if (unlikely(!pmc))
 			continue;
-		}
 
-		reprogram_counter(pmc);
+		/*
+		 * If reprogramming fails, e.g. due to contention, re-set the
+		 * regprogram bit set, i.e. opportunistically try again on the
+		 * next PMU refresh.  Don't make a new request as doing so can
+		 * stall the guest if reprogramming repeatedly fails.
+		 */
+		if (reprogram_counter(pmc))
+			set_bit(pmc->idx, pmu->reprogram_pmi);
 	}
 
 	/*
-- 
2.42.0.869.gea05f2083d-goog


