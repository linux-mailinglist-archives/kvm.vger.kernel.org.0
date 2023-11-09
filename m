Return-Path: <kvm+bounces-1367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 604107E72A5
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B0FD280F8D
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 20:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E06D374C9;
	Thu,  9 Nov 2023 20:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G2VWKaz/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CCC37154
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 20:09:07 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE1244AF
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 12:09:06 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5ae5b12227fso18794257b3.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 12:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699560546; x=1700165346; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EtcRg7AW9xp4cg3F/hEs7um4Nd4JNDBFD59T4t+kJNY=;
        b=G2VWKaz/D1atLJGZwuEZT0y3HTdMQbQWzwFzABG40v5aiCaUumVDwyjF4ogdSXAkQ4
         MdIrFp4ilg3hVDqKDzLqbDnnyx19oD4hGtCz0TCvVywPCVm2iHSjhgYmgsGjcfyK0zQA
         UPczOTanyftK+oZFdxXybHcqIQZ5QU7z1loxAyEAFBehryCKKEZwOr0HBFY4+wXjGGpg
         h5a5MQjvsykG0nzrqgrCCHFCc4O6n0V3QCMRoZnFWjtKQ+sTaGVVf32yfUGWYCmPzhKs
         4yiBaG6hfzC42TY7wGpiiBmwmoUAHLvYtW5IQorss3CHA3Q0q9RPOpIVIpxdZ+fwu8Jz
         Y6Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699560546; x=1700165346;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EtcRg7AW9xp4cg3F/hEs7um4Nd4JNDBFD59T4t+kJNY=;
        b=IV/6mUmuF/jNtKWfNhGK3Z3BqKEYuKNBcYyHT9oRSmx4+RvSsEYLOG0a5DuPAwgsGW
         CENp7teaUDPMemIuZZDHM4LN8R9+OJOasdaRAZKaIH/VduQ7e7gdWtnlUA+4HT9PGiil
         k+Wu+IWyPS3kee/InpgcrU1uzno1KgTgcproO19YtuxxRdMZq+e30+RgGsCRwOUaO/6f
         G5YQjLY5VYJdDUh5ZTJThLQ5PlNh2aOadR7qRAi7q3G8QOMZJe/02IAvs9wZYMWZ3mqC
         RyjGLB9VgoYzzQD/56XrJcXszE9pawXiUQEwRG+25qf8RVibKkB3x/vP4pXRzHK8AVUV
         gdjg==
X-Gm-Message-State: AOJu0YzjgwxALp/zx0NqTaJCxpx1VHu1oEOtX5+PU3hn8M8iAW3qUSjr
	LS1oDv1TBjYbCfhtpkX+L/XcOm/ZqK0=
X-Google-Smtp-Source: AGHT+IHwaZvXn/WMsPJwhP618TIvTE04+iVdHAziVCo1J1vpYcgdhwHVEIIpRfUvCmlAPUW4m7JuchUgZF0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:285:b0:d9a:f3dc:7d18 with SMTP id
 v5-20020a056902028500b00d9af3dc7d18mr179250ybh.13.1699560546067; Thu, 09 Nov
 2023 12:09:06 -0800 (PST)
Date: Thu, 9 Nov 2023 12:09:04 -0800
In-Reply-To: <20231109180646.2963718-2-khorenko@virtuozzo.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109180646.2963718-1-khorenko@virtuozzo.com> <20231109180646.2963718-2-khorenko@virtuozzo.com>
Message-ID: <ZU08YPZ33fweaxDu@google.com>
Subject: Re: [PATCH 1/1] KVM: x86/vPMU: Check PMU is enabled for vCPU before
 searching for PMC
From: Sean Christopherson <seanjc@google.com>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Denis V. Lunev" <den@virtuozzo.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 09, 2023, Konstantin Khorenko wrote:
> The following 2 mainstream patches have introduced extra
> events accounting:
> 
>   018d70ffcfec ("KVM: x86: Update vPMCs when retiring branch instructions")
>   9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> 
> kvm_pmu_trigger_event() iterates over all PMCs looking for enabled and
> this appeared to be fast on Intel CPUs and quite expensive for AMD CPUs.
> 
> kvm_pmu_trigger_event() can be optimized not to iterate over all PMCs in
> the following cases:

Heh, I'm just putting the finishing touches on a series to optimize this mess.

> ---
>  arch/x86/kvm/pmu.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 9ae07db6f0f6..290d407f339b 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -731,12 +731,38 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
>  	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
>  }
>  
> +static inline bool guest_pmu_is_enabled(struct kvm_pmu *pmu)
> +{
> +	/*
> +	 * Currently VMs do not have PMU settings in configs which defaults
> +	 * to "pmu=off".
> +	 *
> +	 * For Intel currently this means pmu->version will be 0.
> +	 * For AMD currently PMU cannot be disabled:
> +	 * pmu->version should be 2 for Zen 4 cpus and 1 otherwise.
> +	 */
> +	if (pmu->version == 0)
> +		return false;
> +
> +	/*
> +	 * Starting with PMU v2 IA32_PERF_GLOBAL_CTRL MSR is available and
> +	 * it can be used to check if none PMCs are enabled.
> +	 */
> +	if (pmu->version >= 2 && !(pmu->global_ctrl & ~pmu->global_ctrl_mask))
> +		return false;
> +
> +	return true;
> +}
> +
>  void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  	struct kvm_pmc *pmc;
>  	int i;
>  
> +	if (!guest_pmu_is_enabled(pmu))
> +		return;

This _should_ be unnecessary, because all_valid_pmc_idx _should_ be zero when the
PMU is disabled.  Architecturally, AMD doesn't provide a way to disable the PMU,
but KVM open that can of worms a long time ago, e.g. see the enable_pmu check in
get_gp_pmc_amd().  Kernels have long since learned to not panic if the PMU isn't
available, precisely because hypervisors have a long history of not virtualizing
a PMU.

The issue is that KVM stupidly doesn't zero out the metadata, i.e. configures
all_valid_pmc_idx as if the vCPU has a PMU even though KVM will deny access to
all assets in the end.

The below should resolve the issue.  Note, it won't apply on kvm-x86/next due to
multiple dependencies on other PMU changes I have in flight.  Give me a few hours
to test; with luck I'll get this posted by end-of-day.

--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 9 Nov 2023 11:03:48 -0800
Subject: [PATCH 1/4] KVM: x86/pmu: Zero out PMU metadata on AMD if PMU is
 disabled

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
 

base-commit: 45c6565ff59d0b254ca3755cb4e14776a2c0b324
-- 

