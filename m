Return-Path: <kvm+bounces-1438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F4F7E7774
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:29:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3AD22815D6
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B9EF1847;
	Fri, 10 Nov 2023 02:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rTt8sICL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8660E1390
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:29:04 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F1A420B
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:29:03 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da2b8af7e89so1986246276.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699583343; x=1700188143; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=z5ryUyEZOO+/tMRx5bR+5vxzqerjQqbnVQhlXKSl6+s=;
        b=rTt8sICLvmhzb66yf4Xg/orrbf5+mXq3xrlorMU8hAZRy+5Xy3GtXnMiKFrTxwvoq7
         xIlIew+1GwdH7VANSsY1nBxmLqI4pRX0O2+U9KZJE7BOIzFeYtAhcsrZsYQ4pxtX9JUy
         fZ8exvqcNitO75mteFqoliQsFOrvEmDZeMQpchAxnzrwi+b5v+OzZALB/CZzjxgCnK63
         HoBn7V1EDPTohPVe9UGUcXxgfmudnLwMU+58GBWcLOzMPcgGF4C62WaX++b+groccAah
         fEZ9/FtBS5ejYjaOLfxohyD0g6sdjyC8MpP3Tsm+PlSKDWf1Qg5lmDclTRCaHeBoywIZ
         w32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699583343; x=1700188143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z5ryUyEZOO+/tMRx5bR+5vxzqerjQqbnVQhlXKSl6+s=;
        b=P86fVqgUPMFszbTPNlcxwhntWqZgVvwjNiOsYghZqHfFFeZyfjiXAT+KMicwoBlZ30
         VYfde6xY9fXK0OQ3XE1TQHcNf6yitimm1ZR84c2km6wawE+QsRJUmwtliBV2UfKylxls
         fii/Mm2Ar64W8JDzv8j6TSj7mRREpeGASsDfZUojYZA9YCvM+cGEYwSJugIR1hZjZafD
         rvvOa4W6lgnpwAs+/whRDyiUgZju58I3Qzy0Jd8MYgf/9yAd1kw090A8c5DIXNeA4KsR
         vO5D9uESAtnjqY4i3SMrgwemvrWRzHquvj0ms26XkEvfBfimMdf5Nww/N+9759E6Kwzr
         yFKQ==
X-Gm-Message-State: AOJu0Yw3/BniJkHWOhoDnyQGBwWCQ/tRRrX08z6cyFk2ONqoT3Y/Jow0
	69aCIxDkcV5dd0v6OUC6fMTBpu1+GCs=
X-Google-Smtp-Source: AGHT+IEOoL78sfqQfuTgzbOo5Q96/UpjUTTutLExKXWogUjIC0qmLjdeWWb3VMacgMBVzqQmS2VhR9s9lw8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ba4a:0:b0:d9a:5e10:c34d with SMTP id
 z10-20020a25ba4a000000b00d9a5e10c34dmr162289ybj.11.1699583342989; Thu, 09 Nov
 2023 18:29:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:28:48 -0800
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110022857.1273836-2-seanjc@google.com>
Subject: [PATCH 01/10] KVM: x86/pmu: Zero out PMU metadata on AMD if PMU is disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the purging of common PMU metadata from intel_pmu_refresh() to
kvm_pmu_refresh(), and invoke the vendor refresh() hook if and only if
the VM is supposed to have a vPMU.

KVM already denies access to the PMU based on kvm->arch.enable_pmu, as
get_gp_pmc_amd() returns NULL for all PMCs in that case, i.e. KVM already
violates AMD's architecture by not virtualizing a PMU (kernels have long
since learned to not panic when the PMU is unavailable).  But configuring
the PMU as if it were enabled causes unwanted side effects, e.g. calls to
kvm_pmu_trigger_event() waste an absurd number of cycles due to the
all_valid_pmc_idx bitmap being non-zero.

Fixes: b1d66dad65dc ("KVM: x86/svm: Add module param to control PMU virtualization")
Reported-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Closes: https://lore.kernel.org/all/20231109180646.2963718-2-khorenko@virtuozzo.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c           | 20 ++++++++++++++++++--
 arch/x86/kvm/vmx/pmu_intel.c | 16 ++--------------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 1b74a29ed250..b52bab7dc422 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -739,6 +739,8 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
 	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
 		return;
 
@@ -748,8 +750,22 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	 */
 	kvm_pmu_reset(vcpu);
 
-	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
-	static_call(kvm_x86_pmu_refresh)(vcpu);
+	pmu->version = 0;
+	pmu->nr_arch_gp_counters = 0;
+	pmu->nr_arch_fixed_counters = 0;
+	pmu->counter_bitmask[KVM_PMC_GP] = 0;
+	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
+	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
+	pmu->global_ctrl_mask = ~0ull;
+	pmu->global_status_mask = ~0ull;
+	pmu->fixed_ctr_ctrl_mask = ~0ull;
+	pmu->pebs_enable_mask = ~0ull;
+	pmu->pebs_data_cfg_mask = ~0ull;
+	bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
+
+	if (vcpu->kvm->arch.enable_pmu)
+		static_call(kvm_x86_pmu_refresh)(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index c3a841d8df27..0d2fd9fdcf4b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -463,19 +463,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	u64 counter_mask;
 	int i;
 
-	pmu->nr_arch_gp_counters = 0;
-	pmu->nr_arch_fixed_counters = 0;
-	pmu->counter_bitmask[KVM_PMC_GP] = 0;
-	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
-	pmu->version = 0;
-	pmu->reserved_bits = 0xffffffff00200000ull;
-	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
-	pmu->global_ctrl_mask = ~0ull;
-	pmu->global_status_mask = ~0ull;
-	pmu->fixed_ctr_ctrl_mask = ~0ull;
-	pmu->pebs_enable_mask = ~0ull;
-	pmu->pebs_data_cfg_mask = ~0ull;
-
 	memset(&lbr_desc->records, 0, sizeof(lbr_desc->records));
 
 	/*
@@ -487,8 +474,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa);
-	if (!entry || !vcpu->kvm->arch.enable_pmu)
+	if (!entry)
 		return;
+
 	eax.full = entry->eax;
 	edx.full = entry->edx;
 
-- 
2.42.0.869.gea05f2083d-goog


