Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9974B6D365C
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 10:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjDBIu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 04:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDBIuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 04:50:25 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FE49754;
        Sun,  2 Apr 2023 01:50:23 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id g17so34303969lfv.4;
        Sun, 02 Apr 2023 01:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680425422; x=1683017422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enNIzosZHddLYmQcmTTvz+akSMjXc6UgzK0+vsr51Yw=;
        b=X6v8gW53wf7Z3bb+1rAwyhDCnA+PsqdKtp5WC4nrahTGUkX0lppe6XqVWI/wyBzEPL
         13VSMeGB2A3SbpyMPl7Xmz3R/ijME2heILbl0bvnu2dOBMU0+SBcJ5iHrAal6GARRzPC
         vzzlbeeKkejQpyQBzm0wil9vHG90OU9e9Fb0FdVaJ53tCX7Ao1qgb42Br/c7vRvVNvCI
         +giuJr9SJruD41p+cxT+4psp/Si4rBgJoZR3YdI/evAB8Y91VVoAUwaYmD1VmF+J6QMe
         vs3B9JXZWMWBOCw0jjrSB189yZPxa4Nn/YybO62oqkinpIkMZmqpTYQJrEO8yyBLQQ+c
         JM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680425422; x=1683017422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=enNIzosZHddLYmQcmTTvz+akSMjXc6UgzK0+vsr51Yw=;
        b=hDkWcDWSyKrH90GeYBJlI5W499j5qEItV6tKWbTvyljJK/FhANMmy8d4Rwy1u7Gm9w
         0aDpNvpXptUZV6GdiSgFL7Qnlv1mYOjeit+p0ggPCSPMcpmfDkJEoycpIgNNHk15lfCS
         o253w2c0uAMfMd09UwRM+L/bsJtyAZ6vx8Jocoen4waBeioNfbYQGNpFb95oUIMqQug1
         tl96fmAlzd11ZUJ0vVFzO6uCrQ9P77ohsV3ng4W4H+kkwwbQfeo53ei0xu4aN0Ka4I7S
         PcTkNfUsUhYh2zr43kEUPkral4U4aiGdbrN59QxXHyHsichbabqDWWou40lUpCKN23s6
         /WGQ==
X-Gm-Message-State: AAQBX9caWyMffgZv9xYyp2KIkyiV5AvWrKzczxsV6r70Wk9gXRvO1t2W
        9QVhQfKJngCZo1tETMtYENU=
X-Google-Smtp-Source: AKy350b8FzYTpKqVxPDq4DmtLSC3J3OI9T8RLKiklT5jxSBwjUqU68rnW2HABEC2oGZOTCwk06j8DA==
X-Received: by 2002:a19:ee08:0:b0:4eb:7d2:a568 with SMTP id g8-20020a19ee08000000b004eb07d2a568mr2402826lfb.3.1680425421741;
        Sun, 02 Apr 2023 01:50:21 -0700 (PDT)
Received: from localhost (88-113-32-99.elisa-laajakaista.fi. [88.113.32.99])
        by smtp.gmail.com with ESMTPSA id y22-20020ac24476000000b004db44f782aesm1190796lfl.4.2023.04.02.01.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 01:50:21 -0700 (PDT)
Date:   Sun, 2 Apr 2023 11:50:19 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, likexu@tencent.com
Subject: Re: [PATCH v13 021/113] KVM: TDX: Make pmu_intel.c ignore guest TD
 case
Message-ID: <20230402115019.000046fd@gmail.com>
In-Reply-To: <017a06174fa054ae264a2caba6f7f55e00f258e8.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <017a06174fa054ae264a2caba6f7f55e00f258e8.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like:

Would you mind to take a look on this patch? It would be nice to have
a r-b also from you. :)

On Sun, 12 Mar 2023 10:55:45 -0700
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
> support as another patch series) and pmu_intel.c touches vmx specific
> structure in vcpu initialization, as workaround add dummy structure to
> struct vcpu_tdx and pmu_intel.c can ignore TDX case.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 46 +++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/pmu_intel.h | 28 ++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h       |  8 ++++++-
>  arch/x86/kvm/vmx/vmx.c       |  2 +-
>  arch/x86/kvm/vmx/vmx.h       | 32 +------------------------
>  5 files changed, 82 insertions(+), 34 deletions(-)
>  create mode 100644 arch/x86/kvm/vmx/pmu_intel.h
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index e8a3be0b9df9..df1f4ddfa72d 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -19,6 +19,7 @@
>  #include "lapic.h"
>  #include "nested.h"
>  #include "pmu.h"
> +#include "tdx.h"
>  
>  #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>  
> @@ -40,6 +41,26 @@ static struct {
>  /* mapping between fixed pmc index and intel_arch_events array */
>  static int fixed_pmc_events[] = {1, 0, 7};
>  
> +struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
> +{
> +#ifdef CONFIG_INTEL_TDX_HOST
> +	if (is_td_vcpu(vcpu))
> +		return &to_tdx(vcpu)->lbr_desc;
> +#endif
> +
> +	return &to_vmx(vcpu)->lbr_desc;
> +}
> +
> +struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
> +{
> +#ifdef CONFIG_INTEL_TDX_HOST
> +	if (is_td_vcpu(vcpu))
> +		return &to_tdx(vcpu)->lbr_desc.records;
> +#endif
> +
> +	return &to_vmx(vcpu)->lbr_desc.records;
> +}
> +
>  static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>  {
>  	struct kvm_pmc *pmc;
> @@ -172,6 +193,23 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
>  	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
>  }
>  
> +bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return false;
> +	return cpuid_model_is_consistent(vcpu);
> +}
> +
> +bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
> +
> +	if (is_td_vcpu(vcpu))
> +		return false;
> +
> +	return lbr->nr && (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_LBR_FMT);
> +}
> +
>  static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>  {
>  	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
> @@ -282,6 +320,9 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
>  					PERF_SAMPLE_BRANCH_USER,
>  	};
>  
> +	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
> +		return 0;
> +
>  	if (unlikely(lbr_desc->event)) {
>  		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
>  		return 0;
> @@ -591,7 +632,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
>  
>  	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
> -	if (cpuid_model_is_consistent(vcpu) &&
> +	if (intel_pmu_lbr_is_compatible(vcpu) &&
>  	    (perf_capabilities & PMU_CAP_LBR_FMT))
>  		x86_perf_get_lbr(&lbr_desc->records);
>  	else
> @@ -647,6 +688,9 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>  	struct kvm_pmc *pmc = NULL;
>  	int i;
>  
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
>  	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
>  		pmc = &pmu->gp_counters[i];
>  
> diff --git a/arch/x86/kvm/vmx/pmu_intel.h b/arch/x86/kvm/vmx/pmu_intel.h
> new file mode 100644
> index 000000000000..66bba47c1269
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/pmu_intel.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __KVM_X86_VMX_PMU_INTEL_H
> +#define  __KVM_X86_VMX_PMU_INTEL_H
> +
> +struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu);
> +struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu);
> +
> +bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
> +bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
> +int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
> +
> +struct lbr_desc {
> +	/* Basic info about guest LBR records. */
> +	struct x86_pmu_lbr records;
> +
> +	/*
> +	 * Emulate LBR feature via passthrough LBR registers when the
> +	 * per-vcpu guest LBR event is scheduled on the current pcpu.
> +	 *
> +	 * The records may be inaccurate if the host reclaims the LBR.
> +	 */
> +	struct perf_event *event;
> +
> +	/* True if LBRs are marked as not intercepted in the MSR bitmap */
> +	bool msr_passthrough;
> +};
> +
> +#endif /* __KVM_X86_VMX_PMU_INTEL_H */
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 1e00e75b1c5e..5728820fed5e 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -4,6 +4,7 @@
>  
>  #ifdef CONFIG_INTEL_TDX_HOST
>  
> +#include "pmu_intel.h"
>  #include "tdx_ops.h"
>  
>  struct kvm_tdx {
> @@ -21,7 +22,12 @@ struct kvm_tdx {
>  
>  struct vcpu_tdx {
>  	struct kvm_vcpu	vcpu;
> -	/* TDX specific members follow. */
> +
> +	/*
> +	 * Dummy to make pmu_intel not corrupt memory.
> +	 * TODO: Support PMU for TDX.  Future work.
> +	 */
> +	struct lbr_desc lbr_desc;
>  };
>  
>  static inline bool is_td(struct kvm *kvm)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d23830d92f61..f9e9fd7fde2c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2432,7 +2432,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			if ((data & PMU_CAP_LBR_FMT) !=
>  			    (kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT))
>  				return 1;
> -			if (!cpuid_model_is_consistent(vcpu))
> +			if (!intel_pmu_lbr_is_compatible(vcpu))
>  				return 1;
>  		}
>  		if (data & PERF_CAP_PEBS_FORMAT) {
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 2acdc54bc34b..1d15c3c2751b 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -11,6 +11,7 @@
>  #include "capabilities.h"
>  #include "../kvm_cache_regs.h"
>  #include "posted_intr.h"
> +#include "pmu_intel.h"
>  #include "vmcs.h"
>  #include "vmx_ops.h"
>  #include "../cpuid.h"
> @@ -105,22 +106,6 @@ static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
>  	return pmu->version > 1;
>  }
>  
> -struct lbr_desc {
> -	/* Basic info about guest LBR records. */
> -	struct x86_pmu_lbr records;
> -
> -	/*
> -	 * Emulate LBR feature via passthrough LBR registers when the
> -	 * per-vcpu guest LBR event is scheduled on the current pcpu.
> -	 *
> -	 * The records may be inaccurate if the host reclaims the LBR.
> -	 */
> -	struct perf_event *event;
> -
> -	/* True if LBRs are marked as not intercepted in the MSR bitmap */
> -	bool msr_passthrough;
> -};
> -
>  /*
>   * The nested_vmx structure is part of vcpu_vmx, and holds information we need
>   * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
> @@ -650,21 +635,6 @@ static __always_inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
>  	return container_of(vcpu, struct vcpu_vmx, vcpu);
>  }
>  
> -static inline struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
> -{
> -	return &to_vmx(vcpu)->lbr_desc;
> -}
> -
> -static inline struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
> -{
> -	return &vcpu_to_lbr_desc(vcpu)->records;
> -}
> -
> -static inline bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
> -{
> -	return !!vcpu_to_lbr_records(vcpu)->nr;
> -}
> -
>  void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
>  int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
>  void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);

