Return-Path: <kvm+bounces-1416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A84497E7723
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E0B71F20C73
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B254C7D;
	Fri, 10 Nov 2023 02:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E7nU+OHb"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE75E3FFB
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:26 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF3246BB
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:26 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc2be064b8so15945965ad.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582406; x=1700187206; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bjFOFq9eCDs5yJ6CYs0wSivMTMFgOXCeKduCrIaUzLY=;
        b=E7nU+OHbQsup+qWupwz/ufAtMV0UBw60/mPzRLNjdn61F39EnP4KPgOG9QtqR8pN7+
         aDoiyEVXIhb2CAb4J4zRii2nCjIWdidr7qA1R1poMRrxms5Mu3ncOKIP36ztnSQTscci
         7xrYLTIjdht8Lh9cdw22a2lIGvMIhPKCx+Pa+AIA65bGPGY3AhjqG3oT2N3pFwUC3DsY
         e9WXf1kYqUAnm1EpGYHqxqDamXTY63pdE3ZMDkz70zOoa0kG3nlCQurTIHjKro9ANc5y
         FMGJHFh38Bz94Jhv44MMX/EXimjnFNJ/JeTr9TSqBx7SHwyhFMZpBpm27RgcApi6UXxx
         jIHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582406; x=1700187206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bjFOFq9eCDs5yJ6CYs0wSivMTMFgOXCeKduCrIaUzLY=;
        b=Q7N8hlJnsg3u7C9DZZskUCa8HMtgy8/p8wOEmam/e4HXHIuqrg0jJw6jLYM2PpkYhJ
         URUrB969EO1zBQiqyk7Da/gfDOMhLPa4Rg00wEbMVQoTPvYro0uyY67xkmMuK7DvwOd3
         G/2TX2FKLMb3pZ5DPW6Lux25CaLDRICSS2lNqRrmFlq/hG6gqrdSbyvDdHWwtgm3jrvP
         +HMUKlFPvZ516S6NHwuFJAff+JKfMnk463L1w8ogbD++4RHjLsp6e3IGBTvSaNA20+p+
         Mtcf8/43FcGv43EHgipJevthZrw+1ry3t174IyQiYG5iJmVZSMRFi4owt+X2XP6o5rfg
         rNIQ==
X-Gm-Message-State: AOJu0YzL7vzv2JdROBtxp3bZwwjeLbBB6gJbaMp63ADKrtb8vISElIuu
	/pMyyuoCkDy05pke9RcGPx1RNVEzOfs=
X-Google-Smtp-Source: AGHT+IGbzddV7v55il7Z9t2H4osvH/RGeut9WH4rrWiF+86iSC7iBPjj0p1mEJ3428sTR4aeEuCzSlD6ZI0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:70c8:b0:1c9:f267:1661 with SMTP id
 l8-20020a17090270c800b001c9f2671661mr296098plt.2.1699582406108; Thu, 09 Nov
 2023 18:13:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:47 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-8-seanjc@google.com>
Subject: [PATCH v8 07/26] KVM: x86/pmu: Apply "fast" RDPMC only to Intel PMUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Move the handling of "fast" RDPMC instructions, which drop bits 63:31 of
the count, to Intel.  The "fast" flag, and all flags for that matter, are
Intel-only and aren't supported by AMD.

Opportunistically replace open coded bit crud with proper #defines.

Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c           |  3 +--
 arch/x86/kvm/vmx/pmu_intel.c | 20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 99ed72966528..e3ba5e12c2e7 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -499,10 +499,9 @@ static int kvm_pmu_rdpmc_vmware(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 {
-	bool fast_mode = idx & (1u << 31);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
-	u64 mask = fast_mode ? ~0u : ~0ull;
+	u64 mask = ~0ull;
 
 	if (!pmu->version)
 		return 1;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3bac3b32b485..c6ea128ea7c8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -20,6 +20,10 @@
 #include "nested.h"
 #include "pmu.h"
 
+/* Perf's "BASE" is wildly misleading, this is a single-bit flag, not a base. */
+#define INTEL_RDPMC_FIXED	INTEL_PMC_FIXED_RDPMC_BASE
+#define INTEL_RDPMC_FAST	BIT(31)
+
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
@@ -55,12 +59,17 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
+static u32 intel_rdpmc_get_masked_idx(struct kvm_pmu *pmu, u32 idx)
+{
+	return idx & ~(INTEL_RDPMC_FIXED | INTEL_RDPMC_FAST);
+}
+
 static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	bool fixed = idx & (1u << 30);
+	bool fixed = idx & INTEL_RDPMC_FIXED;
 
-	idx &= ~(3u << 30);
+	idx = intel_rdpmc_get_masked_idx(pmu, idx);
 
 	return fixed ? idx < pmu->nr_arch_fixed_counters
 		     : idx < pmu->nr_arch_gp_counters;
@@ -70,11 +79,14 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 					    unsigned int idx, u64 *mask)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	bool fixed = idx & (1u << 30);
+	bool fixed = idx & INTEL_RDPMC_FIXED;
 	struct kvm_pmc *counters;
 	unsigned int num_counters;
 
-	idx &= ~(3u << 30);
+	if (idx & INTEL_RDPMC_FAST)
+		*mask &= GENMASK_ULL(31, 0);
+
+	idx = intel_rdpmc_get_masked_idx(pmu, idx);
 	if (fixed) {
 		counters = pmu->fixed_counters;
 		num_counters = pmu->nr_arch_fixed_counters;
-- 
2.42.0.869.gea05f2083d-goog


