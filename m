Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2858D6C23BB
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 22:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjCTVcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 17:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjCTVci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 17:32:38 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F3A24729
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 14:31:57 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id p16so8420234wmq.5
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 14:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679347876;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2w8AZsIQ778O8xveKyJPnuLuJ7HaFhYNh2NqvdMrIb8=;
        b=BzdWQC3fUgXf0gAaG+aRRq+VgPAuSpske7q0KYmH3A4CvASxe45lHffhvVs9hICjQP
         huiOK4QpQHVMRa68MIGScplcau56ITbHJf0hkZKmTv2D1AXZhs+SkcgNh1oNLFVaRXHZ
         BRxKK47SclnR3P9yGxuEE1uzjH2rb/soatq2D+wuddKPJPIzgE2B8nILQ2zuiu26Iv53
         tsg2A0rSGbfoe3vm5kdksJ1SiLBrergQQDtOhQGiyOc4sOYJ0V3EJm3kVcweuK+usu+2
         WaRiexGbljD3H63HHBNoBXhUB1n2vZSw6BLsANpVu4sMi+qES3jARvRrp3SLH496zrsj
         oWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679347876;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2w8AZsIQ778O8xveKyJPnuLuJ7HaFhYNh2NqvdMrIb8=;
        b=t64ytA4mgZIExleDOTmNMM271pYygOflLZ4WNLaQPT6Ywzf6o978qR2qo7i7gDPitK
         mSCUChZiLpQFSrUiMj+hQaO7kLSHs+KbWjBE4j0vRh6VGOGz34+HkqJYeqAJ7CNVpRNg
         Dwn11izjVf4+70zECysiEdBoQSIfO6X9t89qM6CpSpX/s0nE+wGRXkMDjmbCq5pl7Igw
         e3OyVgVru9qvAVGZyPXrGi5vke5sMgRgmRYCwrXUhPoZv+PMHUhaRvdMgC6wDljk4UW+
         f+9TO7zK4zbdvHGn9mraOwed9RnNSYJfOeY25jJpb5wlz1fWYTYpFRdPACt5q0lyAA7z
         xbiw==
X-Gm-Message-State: AO0yUKVZiGJfmjRTiCG6XBbtAIMHRg0eBWTC+V/HRFUID6KyoehRlrAl
        lR5IryVTeN2PHwvaRpTBKg7BcbHkCmtQCiC2sKE=
X-Google-Smtp-Source: AK7set8H/ledaIIh5ke9wpDg2BDTATYYbrj2duTM+GNF5JiA9O5tI91b5Q9ZuN7QHuqKmCkBN3FlAw==
X-Received: by 2002:a7b:cd07:0:b0:3ed:d261:50a6 with SMTP id f7-20020a7bcd07000000b003edd26150a6mr712536wmj.9.1679347875661;
        Mon, 20 Mar 2023 14:31:15 -0700 (PDT)
Received: from ?IPV6:2003:f6:af11:1000:ea7:9b12:7b30:c669? (p200300f6af1110000ea79b127b30c669.dip0.t-ipconnect.de. [2003:f6:af11:1000:ea7:9b12:7b30:c669])
        by smtp.gmail.com with ESMTPSA id p9-20020a05600c358900b003edd2ae9acfsm6414587wmq.35.2023.03.20.14.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 14:31:15 -0700 (PDT)
Message-ID: <cf70127f-5e15-3f5e-08fc-884877b2421a@grsecurity.net>
Date:   Mon, 20 Mar 2023 22:31:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v3 6/6] KVM: VMX: Make CR0.WP a guest owned bit
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230201194604.11135-1-minipli@grsecurity.net>
 <20230201194604.11135-7-minipli@grsecurity.net> <ZBJG//wpKUf9I8lE@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZBJG//wpKUf9I8lE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.03.23 23:30, Sean Christopherson wrote:
> On Wed, Feb 01, 2023, Mathias Krause wrote:
>> Guests like grsecurity that make heavy use of CR0.WP to implement kernel
>> level W^X will suffer from the implied VMEXITs.
>>
>> For a direct MMU role there is no need to intercept a guest change of
>> CR0.WP, so simply make it a guest owned bit if we can do so.
>>
>> This implies that a read of a guest's CR0.WP bit might need a VMREAD.
>> However, the only potentially affected user seems to be kvm_init_mmu()
>> which is a heavy operation to begin with. But also most callers already
>> cache the full value of CR0 anyway, so no additional VMREAD is needed.
>> The only exception is nested_vmx_load_cr3().
>>
>> Add a new module parameter 'lazycr0' to allow users to revert back to
>> the old behaviour by loading kvm-intel.ko with 'lazycr0=0'.
>>
>> This change is VMX-specific, as SVM has no such fine grained control
>> register intercept control.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
>>
>> Initially I wanted to implement the scheme Sean sketched[1]: having a
>> threshold where we would switch from eager to lazy CR0.WP tracking after
>> toggling the bit often enough, make the bit guest owned afterwards and
>> VMREAD CR0 when needed. However, when starting to look for users that
>> would be affected, I only found kvm_init_mmu() (via kvm_init_mmu() ->
>> vcpu_to_role_regs() -> kvm_read_cr0_bits(KVM_MMU_CR0_ROLE_BITS)). It has
>> only these three interesting callers:
>> 1/ kvm_mmu_reset_context(), which isn't all that interesting, as it's a
>>    heavy weight operation anyway and many of the control flows leading
>>    to it already cache the value of CR0, so no additional VMREAD is
>>    needed,
>> 2/ nested_vmx_load_cr3() and
>> 3/ kvm_post_set_cr0(), only when CR0.WP was toggled and the MMU is in
>>    direct mode (optimization introduced by patch 3).
>>
>> The last case's most interesting caller is likely kvm_set_cr0(), which
>> already caches the written CR0 value, thereby vanishes the need for
>> another VMREAD in vcpu_to_role_regs().
>>
>> That's why I went with the much simpler approach and always allow CR0.WP
>> to be guest owned if EPT is enabled as well.
> 
> Nice!
> 
>> There's nothing we can do for SVM, though :/
> 
> :/ indeed
> 
>> [1] https://lore.kernel.org/kvm/Y8cTMnyBzNdO5dY3@google.com/
>> ---
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index d3b49e0b6c32..1969360d2744 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -91,6 +91,9 @@ module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
>>  bool __read_mostly enable_ept = 1;
>>  module_param_named(ept, enable_ept, bool, S_IRUGO);
>>  
>> +bool __read_mostly enable_lazy_cr0 = 1;
>> +module_param_named(lazycr0, enable_lazy_cr0, bool, S_IRUGO);
> 
> Unless someone crawls out of the woodworks to object, let's omit the module param
> and make this unconditional.  We typically add module params for behavior where
> there are legitimate downsides even if KVM is bug free, or for features that are
> dependent on hardware.  E.g. testing shadow paging without a knob to disable EPT
> would require acces to really ancient CPUs.
> 
> The one exception that comes to mind is force_flush_and_sync_on_reuse, but TLB
> bugs tend to be subtle and hard to hit, whereas if we break something with CR0.WP
> emulation, the breakage should be immediate and obvious.
> 
>>  bool __read_mostly enable_unrestricted_guest = 1;
>>  module_param_named(unrestricted_guest,
>>  			enable_unrestricted_guest, bool, S_IRUGO);
>> @@ -4765,7 +4768,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>  	/* 22.2.1, 20.8.1 */
>>  	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
>>  
>> -	vmx->vcpu.arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
>> +	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_guest_owned_cr0_bits();
>>  	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
>>  
>>  	set_cr4_guest_host_mask(vmx);
>> @@ -8370,6 +8373,10 @@ static __init int hardware_setup(void)
>>  		return -EOPNOTSUPP;
>>  	}
>>  
>> +	/* Need EPT for lazy CR0.WP synchronization. */
>> +	if (!enable_ept)
>> +		enable_lazy_cr0 = 0;
> 
> Heh, just realized that this code would be broken if nested TDP wasn't exempt
> from including CR0.WP in the MMU role.  Better to be lucky than good :-)

=:)

> 
> And similar to similar to kvm_post_set_cr0(), the CR0.PG=0 case _could_ let
> CR0.WP be guest-owned, but I don't think that's worth doing as it introduces a
> subtle dependency on CR0 being up-to-date (or passed in).

And it has no real use case, IMHO. Aside from the academic exercise, why
would any sane operating system^W^W"system software" that runs non-paged
touch CR0.WP at all?

> 
> So this?
> 
> ---
>  arch/x86/kvm/kvm_cache_regs.h |  2 +-
>  arch/x86/kvm/vmx/nested.c     |  4 ++--
>  arch/x86/kvm/vmx/vmx.c        |  2 +-
>  arch/x86/kvm/vmx/vmx.h        | 18 ++++++++++++++++++
>  4 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 4c91f626c058..e50d353b5c1c 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -4,7 +4,7 @@
>  
>  #include <linux/kvm_host.h>
>  
> -#define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
> +#define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
>  #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
>  	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
>  	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 7c4f5ca405c7..a0c92a2b3f65 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4478,7 +4478,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  	 * CR0_GUEST_HOST_MASK is already set in the original vmcs01
>  	 * (KVM doesn't change it);
>  	 */
> -	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
>  	vmx_set_cr0(vcpu, vmcs12->host_cr0);
>  
>  	/* Same as above - no reason to call set_cr4_guest_host_mask().  */
> @@ -4629,7 +4629,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
>  	 */
>  	vmx_set_efer(vcpu, nested_vmx_get_vmcs01_guest_efer(vmx));
>  
> -	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
>  	vmx_set_cr0(vcpu, vmcs_readl(CR0_READ_SHADOW));
>  
>  	vcpu->arch.cr4_guest_owned_bits = ~vmcs_readl(CR4_GUEST_HOST_MASK);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index da65d90984ae..136adccffc4b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4773,7 +4773,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  	/* 22.2.1, 20.8.1 */
>  	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
>  
> -	vmx->vcpu.arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
>  	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
>  
>  	set_cr4_guest_host_mask(vmx);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 2acdc54bc34b..423e9d3c9c40 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -640,6 +640,24 @@ BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
>  				(1 << VCPU_EXREG_EXIT_INFO_1) | \
>  				(1 << VCPU_EXREG_EXIT_INFO_2))
>  
> +static inline unsigned long vmx_l1_guest_owned_cr0_bits(void)
> +{
> +	unsigned long bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +
> +	/*
> +	 * CR0.WP needs to be intercepted when KVM is shadowing legacy paging
> +	 * in order to construct shadow PTEs with the correct protections.
> +	 * Note!  CR0.WP technically can be passed through to the guest if
> +	 * paging is disabled, but checking CR0.PG would generate a cyclical
> +	 * dependency of sorts due to forcing the caller to ensure CR0 holds
> +	 * the correct value prior to determining which CR0 bits can be owned
> +	 * by L1.  Keep it simple and limit the optimization to EPT.
> +	 */
> +	if (!enable_ept)
> +		bits &= ~X86_CR0_WP;
> +	return bits;
> +}
> +
>  static __always_inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
>  {
>  	return container_of(kvm, struct kvm_vmx, kvm);
> 
> base-commit: 0b39948a802b5e76d65989b47ae36fe0dfbc10ad

LGTM!
