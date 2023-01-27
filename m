Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB1067EF57
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 21:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbjA0ULZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 15:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbjA0ULC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 15:11:02 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1717E4C08
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 12:10:49 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id m11so5650796pji.0
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 12:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uVeXA+MV2KiRuoJWt2euHuiO6q0ls69NMV+B5RGOE1g=;
        b=UnHTto9iYs+wX9znqS/a19vQIBuu685jiveSd5U6TsEy2kUm4egnKX+d2Q8+uqgKpX
         nAP4VyHRJkb+du25uLUwTbWRHG4imvVZ6B9sDjbqJ0BQrKilkVK+cTjFTYgF1tAPQ1SP
         Yvh7hqPkSJSfLPuoYRBqJUd2uPPalH+W+6XO2HmidqekVUYHrA4vKHj+t3QvzigPj8lh
         lJ9R6xniqfNYGpvlBxzT6GW9JV+sx7LhhQWlcrX7xqxm14myaujtxCqTDMYPI2oUIv4s
         36L2Eapu+AKpE4LlxAN7Z/Fep1f+WWnY7bzspA9kqsC11kBBQqTcF/ExTH+hUyOvv7u+
         yiow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uVeXA+MV2KiRuoJWt2euHuiO6q0ls69NMV+B5RGOE1g=;
        b=uqj3uk/YJ/FUSFo4YkA+kIy4FsIaL+RaT0TMsUWm4+zvSZGaVrDNFyTCQ0+q9IEasy
         YOAOxRRFMHtUdQFzubVM51aWhAODWXSCTskh9fCpvfOu4S7d5dCIGhBInpujdoUv1jQK
         WnY6MBeya6PSyh7edgJv4Jikgi/Sna1FaPomcNsnX9UlUFipmC3IVX4h4MOqm/ES7iux
         ltG6/SaKJaFBaYfeV3zq4TCSbDSenzwUqsy7z2YhSRo31qRbtra7WdOzK0aBFLaIBC/y
         aQgh5PDFBDJy/o//CcknjGMo4ahowRbsau0vkwuf6+r/DrrbpcB6eFswMCHDcBMkGWeX
         w8HQ==
X-Gm-Message-State: AO0yUKUU8BPJVgPKR+yLxX43SWEzDMvwB7P1ePlCHxCumwfpVKVcalDF
        NH9WjvTBPRPUgaYKnZx80Yn/+g==
X-Google-Smtp-Source: AK7set+XmtiAzHziowdJYv4UlUisVIIgCtjFaVGFSMV2uzaTLcaE71V5YEPSlKrBprYinorG3plboQ==
X-Received: by 2002:a05:6a20:3d16:b0:bc:3523:13c5 with SMTP id y22-20020a056a203d1600b000bc352313c5mr107342pzi.3.1674850248437;
        Fri, 27 Jan 2023 12:10:48 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v6-20020aa78506000000b00591b0c847b5sm1717135pfn.218.2023.01.27.12.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 12:10:47 -0800 (PST)
Date:   Fri, 27 Jan 2023 20:10:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com
Subject: Re: [PATCH v2 04/15] KVM: PMU: disable LBR handling if architectural
 LBR is available
Message-ID: <Y9QvxJbITGaY6Yki@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-5-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125040604.5051-5-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022, Yang Weijiang wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> Traditional LBR is absent on CPU models that have architectural LBR, so
> disable all processing of traditional LBR MSRs if they are not there.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index e5cec07ca8d9..905673228932 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -170,19 +170,23 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
>  static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>  {
>  	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
> -	bool ret = false;
>  
>  	if (!intel_pmu_lbr_is_enabled(vcpu))
> -		return ret;
> +		return false;
>  
> -	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
> -		(index >= records->from && index < records->from + records->nr) ||
> -		(index >= records->to && index < records->to + records->nr);
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&

IIUC, the MSRs flat out don't exist _and_ KVM expects to passthrough MSRs to the
guest, i.e. KVM should check host support, not guest support.  Probably a moot
point from a functionality perspective since KVM shouldn't allow LBRs to shouldn't
be enabled for the guest, but from a performance perspective, checking guest CPUID
is slooow.

That brings me to point #2, which is that KVM needs to disallow enabling legacy
LBRs on CPUs that support arch LBRs.  Again, IIUC, because KVM doesn't have the
option to fallback to legacy LBRs, that restriction needs to be treated as a bug
fix.  I'll post a separate patch unless my understanding is wrong.

> +	    (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
> +		return true;
>  
> -	if (!ret && records->info)
> -		ret = (index >= records->info && index < records->info + records->nr);
> +	if ((index >= records->from && index < records->from + records->nr) ||
> +	    (index >= records->to && index < records->to + records->nr))
> +		return true;
>  
> -	return ret;
> +	if (records->info && index >= records->info &&
> +	    index < records->info + records->nr)
> +		return true;
> +
> +	return false;
>  }
>  
>  static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> @@ -702,6 +706,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
>  			vmx_set_intercept_for_msr(vcpu, lbr->info + i, MSR_TYPE_RW, set);
>  	}
>  
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))

Similar to above, I really don't want to query guest CPUID in the VM-Enter path.
If we establish the rule that LBRs can be enabled if and only if the correct type
is enabled (traditional/legacy vs. arch), then this can simply check host support.

> +		return;
> +
>  	vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
>  	vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
>  }
> @@ -742,10 +749,12 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +	bool lbr_enable = !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);

Unnecessary guest CPUID lookup and VMCS read, i.e. this can be deferred to the
!lbr_desc->event path.

>  
>  	if (!lbr_desc->event) {
>  		vmx_disable_lbr_msrs_passthrough(vcpu);
> -		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
> +		if (lbr_enable)
>  			goto warn;
>  		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
>  			goto warn;
> @@ -768,7 +777,10 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>  
>  static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>  {
> -	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
> +	bool lbr_enable = !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
> +
> +	if (!lbr_enable)
>  		intel_pmu_release_guest_lbr_event(vcpu);
>  }
>  
> -- 
> 2.27.0
> 
