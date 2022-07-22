Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0BE57DF18
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 12:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbiGVJva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 05:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235091AbiGVJvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 05:51:16 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C4F2229A;
        Fri, 22 Jul 2022 02:50:46 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l15so1714363wro.11;
        Fri, 22 Jul 2022 02:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x3rHZXyS3mZjahWq2r2e1QyMV4pOHR1Oeni8M2mo2vY=;
        b=HUEhfOHvLPn7hRd3U8I5fDAFin7ZTfSTbi6z1MVNTTcjogkiGdvdAR+LiuEvJ+oyip
         jnmL2c9Z/SKvHka+HJp3aKyn1jmiqMZwGqXjUrXtoQy6UQCIxycp6NPdgdYJuEQzz6nf
         /ycZ55Ir6v5/w4ZCuIHj0IswI4fiekcrSl7By/8fExogC9qSOu2paQ2F8oJcwFW6BbgH
         drfEM9ObMmjvex6/izI+PqfjV2d8dO4mFG0CzSzdxg6pSZiO/hcP8tNeCZ/RqDWE9zyV
         2c6KAra9Rpt0rIuitlJNKwZHXH8IXaQHyPWoejD1IX7SRX8o7xWdj6TrFvBmWhYX+l7w
         ZQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x3rHZXyS3mZjahWq2r2e1QyMV4pOHR1Oeni8M2mo2vY=;
        b=PajZ8oXGeXujGXqNDcnmUGhNZa94trmQutbdoQ4uTEym7yRmkz8Cx/gkzxJPBUb8hj
         53gjtvaqsU3WVzx8ZcwgaJeU8wT87pKEBkP6RPfE0Dn7peV6MOCLK8TL7Az3rn5XWJrE
         vTmD8CZ0JXwBr4kqKr5921gQuwTzqFJJz5CRXdq0p/FUtAHgCbMdFzudPLGfzp9NCzo0
         q0DUqPwL9PXgrPY85Jba1v7lklVogf+SDvzbQHZNBI6ijYP8YjpS4uWHNQD1ZYFuoqp4
         5o4V+5EYppve4txb6LvHmF4Kigfc2WCavoL2QUT8w549kGHzpMjat8E6YN6ihEXhVYk6
         aJrQ==
X-Gm-Message-State: AJIora8veOh+O0LkC7cFPh51xjyJZ/a2h3VzL/QKzL9aCl48HyvdVpin
        v2quHHlER5woC/YIwjxA/NY=
X-Google-Smtp-Source: AGRyM1v+vNv4HraIkJXd/nvNxoUhZOyEl+d7iBqqig+egZUA5IEwbuAvbKl8qlK8kG27ffrw0LXUnw==
X-Received: by 2002:a5d:5903:0:b0:21d:6dd5:d9c3 with SMTP id v3-20020a5d5903000000b0021d6dd5d9c3mr1858769wrd.85.1658483444226;
        Fri, 22 Jul 2022 02:50:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id q15-20020a5d658f000000b0021e48faed68sm3961911wru.97.2022.07.22.02.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 02:50:43 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <fae8900f-be92-c697-47d0-497363767b9c@redhat.com>
Date:   Fri, 22 Jul 2022 11:50:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 12/15] KVM: nVMX: Extend VMX MSRs quirk to CR0/4 fixed1
 bits
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-13-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220607213604.3346000-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/22 23:36, Sean Christopherson wrote:
> Extend the VMX MSRs quirk to the CR0/4_FIXED1 MSRs, i.e. when the quirk
> is disabled, allow userspace to set the MSRs and do not rewrite the MSRs
> during CPUID updates.  The bits that the guest (L2 in this case) is
> allowed to set are not directly tied to CPUID.  Enumerating to L1 that it
> can set reserved CR0/4 bits is nonsensical and will ultimately result in
> a failed nested VM-Entry (KVM enforces guest reserved CR4 bits on top of
> the VMX MSRs), but KVM typically doesn't police the vCPU model except
> when doing so is necessary to protect the host kernel.
> 
> Further restricting CR4 bits is however a reasonable thing to do, e.g. to
> work around a bug in nested virtualization, in which case exposing a
> feature to L1 is ok, but letting L2 use the feature is not.  Of course,
> whether or not the L1 hypervisor will actually _check_ the FIXED1 bits is
> another matter entirely, e.g. KVM currently assumes all bits that can be
> set in the host can also be set in the guest.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I'm leaving this patch out for separate discussion since the quirk is 
not needed anymore.  I'll post the two reverts after some testing.

Paolo

> ---
>   Documentation/virt/kvm/api.rst |  8 ++++++++
>   arch/x86/kvm/vmx/nested.c      | 33 ++++++++++++++++++++++++++++++---
>   arch/x86/kvm/vmx/vmx.c         |  6 +++---
>   3 files changed, 41 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1095692ddab7..88d1bbae031e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7391,6 +7391,14 @@ The valid bits in cap.args[0] are:
>                                         IA32_VMX_TRUE_EXIT_CTLS[bit 44]
>                                         ('load IA32_PERF_GLOBAL_CTRL'). Otherwise,
>                                         these corresponding MSR bits are cleared.
> +                                    - MSR_IA32_VMX_CR0_FIXED1 is unconditionally
> +                                      set to 0xffffffff
> +                                    - CR4.PCE is unconditionally set in
> +                                      MSR_IA32_VMX_CR4_FIXED1.
> +                                    - All CR4 bits with an associated CPUID
> +                                      feature flag are set in
> +                                      MSR_IA32_VMX_CR4_FIXED1 if the feature is
> +                                      reported as supported in guest CPUID.
>   
>                                       When this quirk is disabled, KVM will not
>                                       change the values of the aformentioned VMX
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 5533c2474128..abce74cfefc9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1385,6 +1385,30 @@ static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
>   	return 0;
>   }
>   
> +static u64 *vmx_get_fixed1_msr(struct nested_vmx_msrs *msrs, u32 msr_index)
> +{
> +	switch (msr_index) {
> +	case MSR_IA32_VMX_CR0_FIXED1:
> +		return &msrs->cr0_fixed1;
> +	case MSR_IA32_VMX_CR4_FIXED1:
> +		return &msrs->cr4_fixed1;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static int vmx_restore_fixed1_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
> +{
> +	const u64 *msr = vmx_get_fixed1_msr(&vmcs_config.nested, msr_index);
> +
> +	/* Bits that "must-be-0" must not be set in the restored value. */
> +	if (!is_bitwise_subset(*msr, data, -1ULL))
> +		return -EINVAL;
> +
> +	*vmx_get_fixed1_msr(&vmx->nested.msrs, msr_index) = data;
> +	return 0;
> +}
> +
>   /*
>    * Called when userspace is restoring VMX MSRs.
>    *
> @@ -1432,10 +1456,13 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
>   	case MSR_IA32_VMX_CR0_FIXED1:
>   	case MSR_IA32_VMX_CR4_FIXED1:
>   		/*
> -		 * These MSRs are generated based on the vCPU's CPUID, so we
> -		 * do not support restoring them directly.
> +		 * These MSRs are generated based on the vCPU's CPUID when KVM
> +		 * "owns" the VMX MSRs, do not allow restoring them directly.
>   		 */
> -		return -EINVAL;
> +		if (kvm_check_has_quirk(vmx->vcpu.kvm, KVM_X86_QUIRK_TWEAK_VMX_MSRS))
> +			return -EINVAL;
> +
> +		return vmx_restore_fixed1_msr(vmx, msr_index, data);
>   	case MSR_IA32_VMX_EPT_VPID_CAP:
>   		return vmx_restore_vmx_ept_vpid_cap(vmx, data);
>   	case MSR_IA32_VMX_VMCS_ENUM:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4c31c8f24329..139f365ca6bb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7520,10 +7520,10 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
>   			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
>   
> -	if (nested_vmx_allowed(vcpu)) {
> +	if (nested_vmx_allowed(vcpu) &&
> +	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_MSRS)) {
>   		nested_vmx_cr_fixed1_bits_update(vcpu);
> -		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_MSRS))
> -			nested_vmx_entry_exit_ctls_update(vcpu);
> +		nested_vmx_entry_exit_ctls_update(vcpu);
>   	}
>   
>   	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&

