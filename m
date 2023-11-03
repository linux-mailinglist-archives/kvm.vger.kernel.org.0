Return-Path: <kvm+bounces-536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC9C7E0BDB
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:06:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2356282004
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 23:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B868725105;
	Fri,  3 Nov 2023 23:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gEedp323"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B007D250E9
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 23:05:48 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434F9D78
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 16:05:46 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc3130ba31so20898025ad.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 16:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699052746; x=1699657546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Mc19fE38hKjtB2xqPWfZgcHXFnhJGoZQeSx7D0d7P/U=;
        b=gEedp323QlkpnvIlzeBZPutRLJla4H97ePb2/iz1SgH1rAOnPHByQl3kKKSDGBpLSh
         BX2U6Jlus/wgNPQqzjFOqGxweWa0WkzBbXb3+h3zBSrmA2abskaXMwFvqMyX+yNEktUx
         pg8L4tgS6nWzUqegGO3nDRe6qq7kffyBEvF5B7U1R6wWcKzx9OLT3SnY/X8SjYY5/N5p
         d4UB8SESJsvZvySzqcNwxoDE011whZiq0j5wQBJf+IRQWlgCxDAOfsz32aisM1kt8KOd
         EklSOKXp7EE5PqD2I6EH3bi6QbCI+mSImIIbUiuZCf9kUIkxVfiHlat9HezFeC6BTSme
         9SnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699052746; x=1699657546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mc19fE38hKjtB2xqPWfZgcHXFnhJGoZQeSx7D0d7P/U=;
        b=Y2o6OJy/3erXtRSQCjpXLz3i7GDfIKRRpQ8XlAjHaGzp7cg0sXCgw1e8kDfSIwBtBp
         sVVlytDusavRni9hefLV4IMfp3DSNrcZED1Eyar5mXayW6k0yw1vUM4GhFryA6bK6uJX
         THFT6lUiemdbCt3GyWFDyVs7N7X7EsDHqg18S24VbaY3d80VkI9wnesIBEK7H9tTt+OH
         MnaqZpr1sfmGTnW//5s2VnW1RTj8wWI5i03gR3E9CW4WEKZnYpgB46zp+WvTbDNA7qw5
         C7Mij1nHU5q2fVEmiruee1cIfKtg899gFs3N02NLm4tzEvNR/NlZg9rOe/BZ4XgxQ18G
         9z2A==
X-Gm-Message-State: AOJu0Yxae5XmlZSDE0NmQe5fr4M4BKylSgZEltIe375RbrgKV9IbVNMN
	4MKQISu39ZdcZCsEFd2tzwYU7gX9F98=
X-Google-Smtp-Source: AGHT+IFA9xsBLpCOmgMkPEYyVTSkKTdtGFGfixvQhbs1c0Q6ls39YFKsmliGFG9dz03IQO6uC7xEy/RQmJM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ef83:b0:1cc:454f:73dc with SMTP id
 iz3-20020a170902ef8300b001cc454f73dcmr289352plb.7.1699052745760; Fri, 03 Nov
 2023 16:05:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 16:05:36 -0700
In-Reply-To: <20231103230541.352265-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231103230541.352265-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231103230541.352265-2-seanjc@google.com>
Subject: [PATCH v2 1/6] KVM: x86/pmu: Move PMU reset logic to common x86 code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Roman Kagan <rkagan@amazon.de>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Move the common (or at least "ignored") aspects of resetting the vPMU to
common x86 code, along with the stop/release helpers that are no used only
by the common pmu.c.

There is no need to manually handle fixed counters as all_valid_pmc_idx
tracks both fixed and general purpose counters, and resetting the vPMU is
far from a hot path, i.e. the extra bit of overhead to the PMC from the
index is a non-issue.

Zero fixed_ctr_ctrl in common code even though it's Intel specific.
Ensuring it's zero doesn't harm AMD/SVM in any way, and stopping the fixed
counters via all_valid_pmc_idx, but not clearing the associated control
bits, would be odd/confusing.

Make the .reset() hook optional as SVM no longer needs vendor specific
handling.

Cc: stable@vger.kernel.org
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  2 +-
 arch/x86/kvm/pmu.c                     | 40 +++++++++++++++++++++++++-
 arch/x86/kvm/pmu.h                     | 18 ------------
 arch/x86/kvm/svm/pmu.c                 | 16 -----------
 arch/x86/kvm/vmx/pmu_intel.c           | 20 -------------
 5 files changed, 40 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index 6c98f4bb4228..058bc636356a 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -22,7 +22,7 @@ KVM_X86_PMU_OP(get_msr)
 KVM_X86_PMU_OP(set_msr)
 KVM_X86_PMU_OP(refresh)
 KVM_X86_PMU_OP(init)
-KVM_X86_PMU_OP(reset)
+KVM_X86_PMU_OP_OPTIONAL(reset)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 9ae07db6f0f6..027e9c3c2b93 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -250,6 +250,24 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	return true;
 }
 
+static void pmc_release_perf_event(struct kvm_pmc *pmc)
+{
+	if (pmc->perf_event) {
+		perf_event_release_kernel(pmc->perf_event);
+		pmc->perf_event = NULL;
+		pmc->current_config = 0;
+		pmc_to_pmu(pmc)->event_count--;
+	}
+}
+
+static void pmc_stop_counter(struct kvm_pmc *pmc)
+{
+	if (pmc->perf_event) {
+		pmc->counter = pmc_read_counter(pmc);
+		pmc_release_perf_event(pmc);
+	}
+}
+
 static int filter_cmp(const void *pa, const void *pb, u64 mask)
 {
 	u64 a = *(u64 *)pa & mask;
@@ -654,7 +672,27 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 {
-	static_call(kvm_x86_pmu_reset)(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	int i;
+
+	bitmap_zero(pmu->reprogram_pmi, X86_PMC_IDX_MAX);
+
+	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
+		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
+		if (!pmc)
+			continue;
+
+		pmc_stop_counter(pmc);
+		pmc->counter = 0;
+
+		if (pmc_is_gp(pmc))
+			pmc->eventsel = 0;
+	}
+
+	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
+
+	static_call_cond(kvm_x86_pmu_reset)(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 1d64113de488..a46aa9b25150 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -80,24 +80,6 @@ static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
 	pmc->counter &= pmc_bitmask(pmc);
 }
 
-static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
-{
-	if (pmc->perf_event) {
-		perf_event_release_kernel(pmc->perf_event);
-		pmc->perf_event = NULL;
-		pmc->current_config = 0;
-		pmc_to_pmu(pmc)->event_count--;
-	}
-}
-
-static inline void pmc_stop_counter(struct kvm_pmc *pmc)
-{
-	if (pmc->perf_event) {
-		pmc->counter = pmc_read_counter(pmc);
-		pmc_release_perf_event(pmc);
-	}
-}
-
 static inline bool pmc_is_gp(struct kvm_pmc *pmc)
 {
 	return pmc->type == KVM_PMC_GP;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 373ff6a6687b..3fd47de14b38 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -233,21 +233,6 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void amd_pmu_reset(struct kvm_vcpu *vcpu)
-{
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	int i;
-
-	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC; i++) {
-		struct kvm_pmc *pmc = &pmu->gp_counters[i];
-
-		pmc_stop_counter(pmc);
-		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
-	}
-
-	pmu->global_ctrl = pmu->global_status = 0;
-}
-
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.hw_event_available = amd_hw_event_available,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
@@ -259,7 +244,6 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.set_msr = amd_pmu_set_msr,
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
-	.reset = amd_pmu_reset,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 820d3e1f6b4f..90c1f7f07e53 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -632,26 +632,6 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 {
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = NULL;
-	int i;
-
-	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
-		pmc = &pmu->gp_counters[i];
-
-		pmc_stop_counter(pmc);
-		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
-	}
-
-	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
-		pmc = &pmu->fixed_counters[i];
-
-		pmc_stop_counter(pmc);
-		pmc->counter = pmc->prev_counter = 0;
-	}
-
-	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
-
 	intel_pmu_release_guest_lbr_event(vcpu);
 }
 
-- 
2.42.0.869.gea05f2083d-goog


