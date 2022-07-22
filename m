Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDBE57E47D
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 18:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbiGVQeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 12:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiGVQeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 12:34:18 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B97F93696
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 09:34:17 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c3so4856015pfb.13
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 09:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cuktg7do6AYKEIAo+TdIr91FV4JqL1g1w6zTqnC0jaY=;
        b=bBDlBH13JIXtLxG6Alxt3OynRcx4j90VZj4px70koq7WXtp9g6ruYqhKbRdJdgFH/V
         iYpLoETeFpzvLwsUiSeWHiLihHBqNUacJ4aeXbhoMaKgwv2K1YlUkXA7rIhDtzdu8SS1
         7LCKH+CxitJTSVa7SEdoRtg9obijkJZ86szTWPZ3cqRY2+51/pmV2G40npiciXwzTPew
         J32f6saUZsQ9b/4Nz/sgrL/L6t5QhggYT5j8362CN2P2BxnWu3K17J/QuUAp1uYwVn8J
         MXHJyGb7/7ywzVq/cXIlEhQ/AccmfLET8P5pbBIagSda82uOhEuWxHk96Z38UbhZGhSu
         KL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cuktg7do6AYKEIAo+TdIr91FV4JqL1g1w6zTqnC0jaY=;
        b=NOa4QxvftHbabz2S9YrZmvFdXEM15e2fhHzePvK1b3l+Ofecoup43PLCVFt8c/ymEG
         R6qzoOGxaLzsxQm0l76jp9r7aHhFsRoogdReuLuQxfQz02lYbKg9ckaKRkLbZG3dHM5n
         RFHgEziyJ30aA6EQL8KD1ekuqwhrREwJt/FUbJmRnV4646qFpwmZib54+S9CbF5HBG+e
         /LW9jwNxk4ZFW84TOjKEwnaVgy/wqBn5zeReyc7qFK1Ot9Afs5PqSYmXtj0PJMsIthfx
         sI1ImKCqGZFhxoyzJpzRT/QGOSjzdlF0I++wzjpsExlRiM1t4aBQQjDt71VbdO2BYiv4
         chMw==
X-Gm-Message-State: AJIora8Mb3aSzj4791WZFdWl2R3YWeQekH1iSqEckfLD5w8lLA9aQ8ha
        gslguCDcIgqX2FRYwAx2v1PTUg==
X-Google-Smtp-Source: AGRyM1sHTzpID1U1BXhZwQnXEV//9IjOyMD87/Wa6PBw/9FDkGOYzTEz7JPFoAUsZ6ITDWjqH+OSFQ==
X-Received: by 2002:a65:6b96:0:b0:41a:617f:e193 with SMTP id d22-20020a656b96000000b0041a617fe193mr507766pgw.85.1658507656093;
        Fri, 22 Jul 2022 09:34:16 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id a15-20020aa7970f000000b00525302fe9c4sm4138221pfg.190.2022.07.22.09.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 09:34:15 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:34:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        oliver.upton@linux.dev
Subject: Re: [PATCH] Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
 VM-{Entry,Exit} control"
Message-ID: <YtrRg03bsPVJLSBx@google.com>
References: <20220722104328.3265326-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722104328.3265326-1-pbonzini@redhat.com>
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

On Fri, Jul 22, 2022, Paolo Bonzini wrote:
> This reverts commit 03a8871add95213827e2bea84c12133ae5df952e.
> 
> Since commit 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
> VM-{Entry,Exit} control"), KVM has taken ownership of the "load
> IA32_PERF_GLOBAL_CTRL" VMX entry/exit control bits, trying to set these
> bits in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS MSRs if the guest's CPUID
> supports the architectural PMU (CPUID[EAX=0Ah].EAX[7:0]=1), and clear
> otherwise.
> 
> This was a misguided attempt at mimicking what commit 5f76f6f5ff96
> ("KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled",
> 2018-10-01) did for MPX.  However, that commit was a workaround for
> another KVM bug and not something that should be imitated.  Mucking with
> the VMX MSRs creates a subtle, difficult to maintain ABI as KVM must
> ensure that any internal changes, e.g. to how KVM handles _any_ guest
> CPUID changes, yield the same functional result.  Therefore, KVM's policy
> is to let userspace have full control of the guest vCPU model so long
> as the host kernel is not at risk.
> 
> And that's the snag: setting the bit must not cause any harm to the host,
> therefore we need to be sure that the kvm_set_msr will actually succeed.

() on functions please.

> Furthermore, it is plausible to have a hypervisor that sets the controls
> unconditionally and just leaves GUEST/HOST_IA32_PERF_GLOBAL_CTRL to 0, and
> we don't want to regress that case.  The simplest way to handle
> both issues is to skip the call to kvm_set_msr if the value of
> MSR_CORE_PERF_GLOBAL_CTRL is not changing.  This covers trivially the case
> where the PMU is not available and the only acceptable value of the MSR is
> zero, because nonzero values are filtered in nested_vmx_check_host_state

()

> and nested_vmx_check_guest_state.

Hmm, this is just trading one hack for another.  The real problem is that KVM
has a WARN that can be triggered by userspace sending a misconfigured vCPU model.

And calling kvm_set_msr() iff the value is changing is trivial to exploit, e.g.
userspace does KVM_SET_CPUID with a valid PMU and stuffs MSR_CORE_PERF_GLOBAL_CTRL
to a non-zero value then does a "bad" KVM_SET_CPUID and a nested VM-Enter.  An
even more devious attack would be to do back-to-back KVM_SET_CPUID to get a valid
pmu->global_ctrl_mask with pmu->version==0 (which is a bug in intel_pmu_refresh())
in order to bypass this check:

	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
	    CC(!kvm_valid_perf_global_ctrl(vcpu_to_pmu(vcpu),
					   vmcs12->guest_ia32_perf_global_ctrl)))
		return -EINVAL;

and then nested VM-Enter with a non-zero guest_ia32_perf_global_ctrl.

Blech, I was going to type up a suggested "flow", but untangling this requires
multiple patches (there are multiple bugs).  I'll just send a series with this as
a pure revert of 03a8871add95213827e2bea84c12133ae5df952e as the last patch.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c    | 26 +++-----------------------
>  arch/x86/kvm/vmx/nested.h    |  2 --
>  arch/x86/kvm/vmx/pmu_intel.c |  3 ---
>  3 files changed, 3 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c1c85fd75d42..6d25de9ebefa 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2623,6 +2623,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	}
>  
>  	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
> +	    vmcs12->guest_ia32_perf_global_ctrl != vcpu_to_pmu(vcpu)->global_ctrl &&
>  	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
>  				     vmcs12->guest_ia32_perf_global_ctrl))) {
>  		*entry_failure_code = ENTRY_FAIL_DEFAULT;
> @@ -4333,7 +4334,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
>  		vcpu->arch.pat = vmcs12->host_ia32_pat;
>  	}
> -	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> +	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> +	    && vmcs12->host_ia32_perf_global_ctrl != vcpu_to_pmu(vcpu)->global_ctrl)

Should be a moot point, but put the "&&" on the first line.

>  		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
>  					 vmcs12->host_ia32_perf_global_ctrl));
>  
