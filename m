Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6771E3CFCDF
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 17:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbhGTOVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 10:21:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234968AbhGTOMt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Jul 2021 10:12:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626792785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AJ3a+l7HYygfc5k+wq8ZfjE4bAmzGHq+jXXRV2Bhjoc=;
        b=IqcB5mjK2Ad+qObCfNaYy4Ooz7RJE1Nq00AOF3QzIj/5dPKUIycXxdAnsPNnB67KX8OiCt
        iB9kT0t/YlCOibDxPZiUsZAN2xCEg3qxKHTgozyJU5+q3Dc95QOy38i/sM0Tj5AOqpGrib
        bz8RnXMl2CS4G62hXEIylL9xFWCBepU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-K66-J-woOpKzyaqMFu1_AQ-1; Tue, 20 Jul 2021 10:53:01 -0400
X-MC-Unique: K66-J-woOpKzyaqMFu1_AQ-1
Received: by mail-il1-f199.google.com with SMTP id c7-20020a92b7470000b0290205c6edd752so13250287ilm.14
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 07:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AJ3a+l7HYygfc5k+wq8ZfjE4bAmzGHq+jXXRV2Bhjoc=;
        b=d+wJSn7YKpKIG3gzmVFnVmNmQvgMkZa2+8OhpzaMFPxH3wr0Kz4rw32PYg9RajKROo
         Nsjt0Tfk/CAekaTNnyZebA2cEI70XHNZcFZL+N5M4Q7PMmM97/21kfyuWTssT8kS0R7D
         XKwJOntyp3FVKxu534APUsV6/z2Gtxs3HWF1bcFFhFTTfK/RXfxcJd2O6ZDqAGVzvo4Z
         RmWF+2cEbPfLveT8OaVxY5dSX9cvBy+b0xIuUmyawSOgEFtvLEJVnX58t0GbXebJ+r1q
         9jac5DLFKqXJ6wtyNUOPI0NSI9plyjPrWpg8FLxBM5K7h0UQM2QBP3bUyM7LvdtkQ+Fz
         O/9w==
X-Gm-Message-State: AOAM531vAsY24BWT0djUjqz/Q0SXyzNlWnSd/0HEMXF031Wr51we6Bzo
        A/7i9h3mHmcNvMNk5xhquo9snD2bQNbTrcEd8ZNz4i6rc9zwR9y84rrd7BfehRNDdxCRQRRNvxd
        AhR8yJn47vCX9
X-Received: by 2002:a92:ab0a:: with SMTP id v10mr6070833ilh.17.1626792781052;
        Tue, 20 Jul 2021 07:53:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytAJej/L/uU7XclEttOrrPj1uCh7eLW+Gj07JbLiTweYRkQoA4op5Sy4dx4Bzh1ky2IX4HwQ==
X-Received: by 2002:a92:ab0a:: with SMTP id v10mr6070822ilh.17.1626792780811;
        Tue, 20 Jul 2021 07:53:00 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id g26sm10093279ioh.48.2021.07.20.07.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 07:53:00 -0700 (PDT)
Date:   Tue, 20 Jul 2021 16:52:58 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
Message-ID: <20210720145258.axhqog3abdvtpqhw@gator>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-7-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-7-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:37PM +0100, Fuad Tabba wrote:
> On deactivating traps, restore the value of mdcr_el2 from the
> newly created and preserved host value vcpu context, rather than
> directly reading the hardware register.
> 
> Up until and including this patch the two values are the same,
> i.e., the hardware register and the vcpu one. A future patch will
> be changing the value of mdcr_el2 on activating traps, and this
> ensures that its value will be restored.
> 
> No functional change intended.

I'm probably missing something, but I can't convince myself that the host
will end up with the same mdcr_el2 value after deactivating traps after
this patch as before. We clearly now restore whatever we had when
activating traps (presumably whatever we configured at init_el2_state
time), but is that equivalent to what we had before with the masking and
ORing that this patch drops?

Thanks,
drew

> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  5 ++++-
>  arch/arm64/include/asm/kvm_hyp.h        |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  6 +++++-
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 11 ++---------
>  arch/arm64/kvm/hyp/vhe/switch.c         | 12 ++----------
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |  2 +-
>  6 files changed, 15 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4d2d974c1522..76462c6a91ee 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -287,10 +287,13 @@ struct kvm_vcpu_arch {
>  	/* Stage 2 paging state used by the hardware on next switch */
>  	struct kvm_s2_mmu *hw_mmu;
>  
> -	/* HYP configuration */
> +	/* Values of trap registers for the guest. */
>  	u64 hcr_el2;
>  	u64 mdcr_el2;
>  
> +	/* Values of trap registers for the host before guest entry. */
> +	u64 mdcr_el2_host;
> +
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
>  
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 9d60b3006efc..657d0c94cf82 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -95,7 +95,7 @@ void __sve_restore_state(void *sve_pffr, u32 *fpsr);
>  
>  #ifndef __KVM_NVHE_HYPERVISOR__
>  void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
> -void deactivate_traps_vhe_put(void);
> +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
>  #endif
>  
>  u64 __guest_enter(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e4a2f295a394..a0e78a6027be 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -92,11 +92,15 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  		write_sysreg(0, pmselr_el0);
>  		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
>  	}
> +
> +	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  }
>  
> -static inline void __deactivate_traps_common(void)
> +static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
>  {
> +	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
> +
>  	write_sysreg(0, hstr_el2);
>  	if (kvm_arm_support_pmu_v3())
>  		write_sysreg(0, pmuserenr_el0);
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index f7af9688c1f7..1778593a08a9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -69,12 +69,10 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  {
>  	extern char __kvm_hyp_host_vector[];
> -	u64 mdcr_el2, cptr;
> +	u64 cptr;
>  
>  	___deactivate_traps(vcpu);
>  
> -	mdcr_el2 = read_sysreg(mdcr_el2);
> -
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
>  		u64 val;
>  
> @@ -92,13 +90,8 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  		isb();
>  	}
>  
> -	__deactivate_traps_common();
> -
> -	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
> -	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
> -	mdcr_el2 |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
> +	__deactivate_traps_common(vcpu);
>  
> -	write_sysreg(mdcr_el2, mdcr_el2);
>  	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
>  
>  	cptr = CPTR_EL2_DEFAULT;
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index b3229924d243..0d0c9550fb08 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -91,17 +91,9 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
>  	__activate_traps_common(vcpu);
>  }
>  
> -void deactivate_traps_vhe_put(void)
> +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
>  {
> -	u64 mdcr_el2 = read_sysreg(mdcr_el2);
> -
> -	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
> -		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
> -		    MDCR_EL2_TPMS;
> -
> -	write_sysreg(mdcr_el2, mdcr_el2);
> -
> -	__deactivate_traps_common();
> +	__deactivate_traps_common(vcpu);
>  }
>  
>  /* Switch to the guest for VHE systems running in EL2 */
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> index 2a0b8c88d74f..007a12dd4351 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -101,7 +101,7 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
>  	struct kvm_cpu_context *host_ctxt;
>  
>  	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> -	deactivate_traps_vhe_put();
> +	deactivate_traps_vhe_put(vcpu);
>  
>  	__sysreg_save_el1_state(guest_ctxt);
>  	__sysreg_save_user_state(guest_ctxt);
> -- 
> 2.32.0.402.g57bb445576-goog
> 

