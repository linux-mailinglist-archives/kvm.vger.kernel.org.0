Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C7C6D7CC8
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 14:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbjDEMiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 08:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbjDEMiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 08:38:18 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50DB2736
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 05:38:16 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-4fa3c1a7a41so363204a12.2
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 05:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680698295;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oucJoA3lSCrdUjWumODrDlx48gsAfc37yEIVb8RrZF8=;
        b=q0IxO5s7OuFfEyZn2WZ1coD3k1/U9QhlbbZY+daBGxmxvTanKmfNbelzWna18Es7lS
         o6TJiqXw8I5NoYULfUk7t/OG8kNQKJld5dgdMRiu+Tuuexa2SLfwyiducy2b3ckxUIb2
         GAHd5aZSNxwYAKYnS+HH0jP9js18Xz3mi9Ylzpbdpf40qrR37uodiTyKxbK15rrV+P6r
         nq3a/hfqvJ6B1AXcEbehhHsdyAUMPzJbqKtqecB5V7uAb6UsXWACv7JOiIIj/Ln+nAld
         dUOP03BV0/LtOR6yPaYNuLsF8YexNNlQrJ9KGZY5FmnjKCjCkMVLeY8Eaf9j+qag2Xok
         eCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680698295;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oucJoA3lSCrdUjWumODrDlx48gsAfc37yEIVb8RrZF8=;
        b=RvN3SztfTw1SUDt1dH+P+Egixi3maMM9+cZMAsvugNPCY/+JtsMROJ0VMpw6n9+ecO
         GKTzb/QViL3TgySfpcHNEZ46Ywr/FDb6HcOz501z4xOA+xa9SitwYMgUm86/hp+CGlNb
         h5RqIzSE0QMEwCzRind3gzDZx+cNDQEVr19Z+A9VIXh5DwUXZTwIDWwaRXOszZUWMoqm
         UnlPNtka9kUzdSBLNylkZsaSIMu5CH7BplPWRPO3cxyufjFZhHfLSN8Nnz8TyYckm1h7
         In27vonsTM0eeFijA6A97QiUfhSPc5k4YVqxKhHF5PJnFwVh4LQXvUkCQ8FCeE4oB705
         wSig==
X-Gm-Message-State: AAQBX9fillBFUPSnzlG4ge2BsL1GGsoh1RuEzKBodTqusX0z9HHEVYCQ
        qpmp607kEEPZw7TsF84GAMddnA==
X-Google-Smtp-Source: AKy350Z9uJSgcxjQUJ+39fyMfUzYh79t8mdIzQlAtGLEN7Zs8ouxcnOa+MRMId/Baqwu5GL3zpePbQ==
X-Received: by 2002:a50:ed10:0:b0:4fa:7679:d44c with SMTP id j16-20020a50ed10000000b004fa7679d44cmr1685232eds.11.1680698295213;
        Wed, 05 Apr 2023 05:38:15 -0700 (PDT)
Received: from ?IPV6:2003:f6:af39:8900:5941:dee7:da1a:b514? (p200300f6af3989005941dee7da1ab514.dip0.t-ipconnect.de. [2003:f6:af39:8900:5941:dee7:da1a:b514])
        by smtp.gmail.com with ESMTPSA id r19-20020a50c013000000b004fd29e87535sm7195179edb.14.2023.04.05.05.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 05:38:14 -0700 (PDT)
Message-ID: <a1ed2308-b521-14c0-a118-19c1afffd1d6@grsecurity.net>
Date:   Wed, 5 Apr 2023 14:38:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] KVM: x86/mmu: Refresh CR0.WP prior to checking for
 emulated permission faults
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230405002608.418442-1-seanjc@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230405002608.418442-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.04.23 02:26, Sean Christopherson wrote:
> If CR0.WP may be guest-owned, i.e. TDP is enabled, refresh the MMU's
> snapshot of the guest's CR0.WP prior to checking for permission faults
> when emulating a guest memory access.  If the guest toggles only CR0.WP
> and triggers emulation of a supervisor write, e.g. when KVM is emulating
> UMIP, KVM may consume a stale CR0.WP, i.e. use stale protection bits
> metadata.

This reads a little awkward for a non-native speaker. Maybe something
like this:

    As CR0.WP may be guest-owned if TDP is enabled, refresh...
    [in between as is]
    ...consume a stale CR0.WP and use stale protection bits metadata.

> 
> Reported-by: Mathias Krause <minipli@grsecurity.net>
> Link: https://lkml.kernel.org/r/677169b4-051f-fcae-756b-9a3e1bb9f8fe%40grsecurity.net
> Fixes: fb509f76acc8 ("KVM: VMX: Make CR0.WP a guest owned bit")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu.h     | 26 +++++++++++++++++++++++++-
>  arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
>  2 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 89f532516a45..92d5a1924fc1 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -113,6 +113,8 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
>  int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  				u64 fault_address, char *insn, int insn_len);
> +void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> +					struct kvm_mmu *mmu);
>  
>  int kvm_mmu_load(struct kvm_vcpu *vcpu);
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu);
> @@ -153,6 +155,24 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  					  vcpu->arch.mmu->root_role.level);
>  }
>  
> +static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> +						    struct kvm_mmu *mmu)
> +{
> +	/*
> +	 * When EPT is enabled, KVM may passthrough CR0.WP to the guest, i.e.
> +	 * @mmu's snapshot of CR0.WP and thus all related paging metadata may
> +	 * be stale.  Refresh CR0.WP and the metadata on-demand when checking
> +	 * for permission faults.  Exempt nested MMUs, i.e. MMUs for shadowing
> +	 * nEPT and nNPT, as CR0.WP is ignored in both cases.  Note, KVM does
> +	 * need to refresh nested_mmu, a.k.a. the walker used to translate L2
> +	 * GVAs to GPAs, as that "MMU" needs to honor L2's CR0.WP.
> +	 */
> +	if (!tdp_enabled || mmu == &vcpu->arch.guest_mmu)
> +		return;
> +
> +	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
> +}
> +
>  /*
>   * Check if a given access (described through the I/D, W/R and U/S bits of a
>   * page fault error code pfec) causes a permission fault with the given PTE
> @@ -184,8 +204,12 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	u64 implicit_access = access & PFERR_IMPLICIT_ACCESS;
>  	bool not_smap = ((rflags & X86_EFLAGS_AC) | implicit_access) == X86_EFLAGS_AC;
>  	int index = (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;
> -	bool fault = (mmu->permissions[index] >> pte_access) & 1;
>  	u32 errcode = PFERR_PRESENT_MASK;
> +	bool fault;
> +
> +	kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
> +
> +	fault = (mmu->permissions[index] >> pte_access) & 1;
>  
>  	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
>  	if (unlikely(mmu->pkru_mask)) {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4c874d4ec68f..47269d50e98d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5186,6 +5186,21 @@ static union kvm_cpu_role kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
>  	return role;
>  }
>  
> +void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> +					struct kvm_mmu *mmu)
> +{
> +	const bool cr0_wp = kvm_is_cr0_bit_set(vcpu, X86_CR0_WP);
> +
> +	BUILD_BUG_ON((KVM_MMU_CR0_ROLE_BITS & KVM_POSSIBLE_CR0_GUEST_BITS) != X86_CR0_WP);

> +	BUILD_BUG_ON((KVM_MMU_CR4_ROLE_BITS & KVM_POSSIBLE_CR4_GUEST_BITS));

Just curious, this should assert that we don't run into similar issues
if we make more bits of CR4 guest owned?

> +
> +	if (is_cr0_wp(mmu) == cr0_wp)
> +		return;
> +
> +	mmu->cpu_role.base.cr0_wp = cr0_wp;
> +	reset_guest_paging_metadata(vcpu, mmu);
> +}
> +
>  static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>  {
>  	/* tdp_root_level is architecture forced level, use it if nonzero */
> 
> base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393

Tested-by: Mathias Krause <minipli@grsecurity.net>

Thanks again, Sean!
