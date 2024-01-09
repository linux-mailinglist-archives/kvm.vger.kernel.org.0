Return-Path: <kvm+bounces-5929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE2682907C
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22A821C24BE8
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79F54655E;
	Tue,  9 Jan 2024 23:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pIE3U+U/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76F445BFA
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbdb69bc114so4534281276.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841392; x=1705446192; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GbgLIH6rTnv7SO9FN+B/HV3gRuklhpSWLpN0FQT/Z7Q=;
        b=pIE3U+U/+O2YkfyluDy7TMg9Vbxdf/IuWMB/3iQZXxnPtHIt+J7q5lYqwdSoiYSTeb
         Y8Z+SSy5He0Moz+D5EIwuqCVE9QfCV8f4HJmVlhe15deWz30UM7FC211dnb0uVfiG2ox
         dvEQYPLEJoI+UblOA8I7tFYrRlUGGUsm7BSL79O6nl0FwbluSREIHmo1TeL1AgaIEfMA
         0rXcV6IiCzwqalIJncVvWfOGbRLjL7KEY8ddya2e0Q0JTr8owWs6Q5f1gOe6F1Ae+m9M
         /YzKtvPdznJpGvxl5aUKMnCdBfF1l06FejSBdmg+fYIpBDlfD1H64XgJgbAyyWiCIp1x
         b3Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841392; x=1705446192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GbgLIH6rTnv7SO9FN+B/HV3gRuklhpSWLpN0FQT/Z7Q=;
        b=ljVk0YRhEnJKJ7FOjcCJHVdDiF8VridN0vsQ2zRZTWYUWyRp68tkWJg4zUJy/dAB8g
         KEhceHcKQGtc2j/cSuln4GeaZtgsWXfqaM1gXS61Dg7HVW5cYrLug3slTVNj7QqPjCqz
         bhYzBU/KB0pUYyk9FvlZmRlEccX2zFoP/myfVOusxsktprtnSpC7Rjc4BkIl4cdpaCmM
         xMW1I3F6d/ntOX9Nm+vqg0YAKbraGsX35w08NZKZl7yy9OVj8gPQDvNm//Nu6N2v7uvr
         /uMqtAkgsyJsRqeQu76BCMr2TdsfaNt2TB/fFtSWdfp6OrSAYnbLKPVQ77oHYFaVCmLG
         Oy1w==
X-Gm-Message-State: AOJu0YyM+L8kR0PdkiV4h/R+bHLKRws4RBbBKx3te6rtbuYitNSkL1Ey
	1WcFurpw7Hy94kxWt0pdVxDxQAWAbGga3jZADg==
X-Google-Smtp-Source: AGHT+IFHc443KCf2oRp9tqj1KiGn6s2aEsUR6J7GWPA6zlL3cvuE9VayN2xL4wL0V9+OlokqdRYY8493mI8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1343:b0:dbe:a220:68f9 with SMTP id
 g3-20020a056902134300b00dbea22068f9mr47982ybu.0.1704841392693; Tue, 09 Jan
 2024 15:03:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:30 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-11-seanjc@google.com>
Subject: [PATCH v10 10/29] KVM: x86/pmu: Treat "fixed" PMU type in RDPMC as
 index as a value, not flag
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Refactor KVM's handling of ECX for RDPMC to treat the FIXED modifier as an
explicit value, not a flag (minus one wart).  While non-architectural PMUs
do use bit 31 as a flag (for "fast" reads), architectural PMUs use the
upper half of ECX to encode the type.  From the SDM:

  ECX[31:16] specifies type of PMC while ECX[15:0] specifies the index of
  the PMC to be read within that type

Note, that the known supported types are 4000H and 2000H, i.e. look a lot
like flags, doesn't contradict the above statement that ECX[31:16] holds
the type, at least not by any sane reading of the SDM.

Keep the explicitly clearing of the FIXED "flag", as KVM subtly relies on
that behavior to disallow unsupported types while allowing the correct
indices for fixed counters.  This wart will be cleaned up in short order.

Opportunistically grab the per-type bitmask in the if-else blocks to
eliminate the one-off usage of the local "fixed" bool.

Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5a5dfae6055c..c37dd3aa056b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -28,6 +28,9 @@
  */
 #define INTEL_RDPMC_FIXED	INTEL_PMC_FIXED_RDPMC_BASE
 
+#define INTEL_RDPMC_TYPE_MASK	GENMASK(31, 16)
+#define INTEL_RDPMC_INDEX_MASK	GENMASK(15, 0)
+
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
@@ -66,10 +69,11 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 					    unsigned int idx, u64 *mask)
 {
+	unsigned int type = idx & INTEL_RDPMC_TYPE_MASK;
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	bool fixed = idx & INTEL_RDPMC_FIXED;
 	struct kvm_pmc *counters;
 	unsigned int num_counters;
+	u64 bitmask;
 
 	/*
 	 * The encoding of ECX for RDPMC is different for architectural versus
@@ -90,16 +94,20 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	 * i.e. let RDPMC fail due to accessing a non-existent counter.
 	 */
 	idx &= ~INTEL_RDPMC_FIXED;
-	if (fixed) {
+	if (type == INTEL_RDPMC_FIXED) {
 		counters = pmu->fixed_counters;
 		num_counters = pmu->nr_arch_fixed_counters;
+		bitmask = pmu->counter_bitmask[KVM_PMC_FIXED];
 	} else {
 		counters = pmu->gp_counters;
 		num_counters = pmu->nr_arch_gp_counters;
+		bitmask = pmu->counter_bitmask[KVM_PMC_GP];
 	}
+
 	if (idx >= num_counters)
 		return NULL;
-	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
+
+	*mask &= bitmask;
 	return &counters[array_index_nospec(idx, num_counters)];
 }
 
-- 
2.43.0.472.g3155946c3a-goog


