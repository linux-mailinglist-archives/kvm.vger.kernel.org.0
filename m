Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9B96D1053
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 22:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjC3UzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 16:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjC3UzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 16:55:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F449AF19
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 13:55:17 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h8so81674942ede.8
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 13:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680209715;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zoygelJTY/opdM34De9Gr6EJqe4Hin8pGQNMKB0ESO8=;
        b=UHMCFgvi4ls3VETItz9xEUB5CMaXPppEj6UjuVwRCcEKQENZ1JAnm8gD1/5GLw/BFw
         t5b62Y3X++xzAya4uglorT+PXsE1uIyR7pGqpUqc4NWtrZKADmTyGXHwvDoky5jitF30
         I0DwjR3LwIoxgnRGR8ye6SigUDw9spg3o67mINwus6+TPUOCwUQeSQVKOWg54mCvkP5d
         3JKg01YSBQGTCzODNQabzoyF5SyXo+A5UHSIDBqgJWr25F04MGxFxwL/JP9nAH6AF+43
         F8XzoPQ7LN8E9dAyrz6pnS4F+tsKGntQMS+CoEqNCx1J/ddlaATIqO8xFzEAKDnE4un7
         VC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680209715;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zoygelJTY/opdM34De9Gr6EJqe4Hin8pGQNMKB0ESO8=;
        b=2h1ZQSx7EyUmYi/gA4/mSglTnAsw2bqG/HtFqm5fcblsfChnOHG8Bxg520lbXCg7Lh
         U6ZcsEIQK5Jnhg53236W60zkGpSQRMUzAeClXguDnYn7SXXonoiYgcSPvm6wOymblzv2
         1gLSkGe//Lw07UYHKci6kevMQnRa3fe+0VFp5DRZ/89l7nItYXjb5NIvDbZF3Ng7iqmG
         9MlCFQuarMm1dqZKSNj3Wvw4XvpYi+DP8Du2c3dUm4ZIxni/mL3H82wbFLHakLdQmWUd
         ORsxyb595Vt4404vSdTDCg/Ab9nr7ZNc72nMHj5ZEwrTyOZbEhirtBPEG7e05sx/h7XU
         DPZA==
X-Gm-Message-State: AAQBX9eMYIrT6j0jOlEq6G05+lEw/ITOU6dNKTm/m8WtSthtp0+t1g6r
        7WJekln/3CDYomeiykmB0einSw==
X-Google-Smtp-Source: AKy350Zwl4YTBpNH0yFdas494z/VEOygBln01oyW2fBRRnX7rYE2oZ9H15YZfbah8pgntpGl7P04Eg==
X-Received: by 2002:a17:906:738a:b0:933:4ca3:9678 with SMTP id f10-20020a170906738a00b009334ca39678mr22836204ejl.24.1680209715456;
        Thu, 30 Mar 2023 13:55:15 -0700 (PDT)
Received: from ?IPV6:2003:f6:af13:8b00:c684:f698:a009:dbf2? (p200300f6af138b00c684f698a009dbf2.dip0.t-ipconnect.de. [2003:f6:af13:8b00:c684:f698:a009:dbf2])
        by smtp.gmail.com with ESMTPSA id b10-20020a1709065e4a00b0093dbb008281sm202117eju.130.2023.03.30.13.55.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 13:55:15 -0700 (PDT)
Message-ID: <9a51bd67-13cf-909a-8740-2a2f08fb42b8@grsecurity.net>
Date:   Thu, 30 Mar 2023 22:55:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 6/6] KVM: VMX: Make CR0.WP a guest owned bit
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-7-minipli@grsecurity.net>
 <677169b4-051f-fcae-756b-9a3e1bb9f8fe@grsecurity.net>
 <ZCXDAiUOnsL3fRBj@google.com> <ZCXyAcTd8NX4Lteq@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZCXyAcTd8NX4Lteq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.03.23 22:33, Sean Christopherson wrote:
> Duh, this is likely a KVM bug.  I expect the issue will go away if you revert
> 
>   fb509f76acc8 ("KVM: VMX: Make CR0.WP a guest owned bit")
> 
> KVM doesn't consume CR0.WP for _its_ MMU, but it does consume CR0.WP for the
> guest walker.  By passing through CR0.WP, toggling only CR0.WP will not trap
> (obviously) and thus won't run through kvm_post_set_cr0(), thus resulting in stle
> information due to not invoking kvm_init_mmu().

That reasoning sounds familiar ;)

> 
> I'm preetty sure I even called that we needed to refresh the permissions, but then
> obviously forgot to actually make that happen.

:(

> 
> I believe this will remedy the issue.  If it does, I'll post a proper patch
> (likely won't be until next week).  Compile tested only.
> 
> ---
>  arch/x86/kvm/mmu.h     |  8 +++++++-
>  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++++
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 89f532516a45..4a303aa735dd 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -113,6 +113,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
>  int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  				u64 fault_address, char *insn, int insn_len);
> +void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu);
>  
>  int kvm_mmu_load(struct kvm_vcpu *vcpu);
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu);
> @@ -184,8 +185,13 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	u64 implicit_access = access & PFERR_IMPLICIT_ACCESS;
>  	bool not_smap = ((rflags & X86_EFLAGS_AC) | implicit_access) == X86_EFLAGS_AC;
>  	int index = (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;
> -	bool fault = (mmu->permissions[index] >> pte_access) & 1;
>  	u32 errcode = PFERR_PRESENT_MASK;
> +	bool fault;
> +
> +	if (tdp_enabled)
> +		kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
> +
> +	fault = (mmu->permissions[index] >> pte_access) & 1;
>  
>  	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
>  	if (unlikely(mmu->pkru_mask)) {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4c874d4ec68f..2a63b5725f36 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5186,6 +5186,20 @@ static union kvm_cpu_role kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
>  	return role;
>  }
>  
> +void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> +{
> +	const bool cr0_wp = kvm_is_cr0_bit_set(vcpu, X86_CR0_WP);
> +
> +	BUILD_BUG_ON((KVM_MMU_CR0_ROLE_BITS & KVM_POSSIBLE_CR0_GUEST_BITS) != X86_CR0_WP);
> +	BUILD_BUG_ON((KVM_MMU_CR4_ROLE_BITS & KVM_POSSIBLE_CR4_GUEST_BITS));
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

I tested a backported version of this patch on v6.1 as that's what I was
testing with and it worked fine. :)

I'll do more thorough tests tomorrow and actually on kvm-x86/next's HEAD.

Thanks a lot, Sean!

Mathias
