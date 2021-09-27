Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78D141988F
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 18:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhI0QMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 12:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbhI0QMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 12:12:31 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E65AC061575
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 09:10:53 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r23so27548501wra.6
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 09:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tzYLDWLzrX157HH12ds8As0JD+WbAz+wC4M9zHAPsb0=;
        b=n0w9qX8LHDnB4PmprGBttwqCfsRmgViG9pnT1tI3UB/RLI5V7pij8YoHVV1N96Csx3
         5Oc3pgzbN1YsZLtwHhz7lHqpzGmUb1rlPFGT6EIyKQlmv9gzFIZa8Ey4Yn+R2LqrJJTI
         M+dcjV+aVR6gcSrrQNMAoxHr0QZwy/7gtFK6Q6z+I5Aev7Dvzg1gZrtMBUJ9U8Rv8Yaf
         KXKtquvuyLYSRk610QxpffujK0GUfZKg3WEdjTkao6KXksFMF/wPxw6L6SOpkaag1XWb
         Dz9Wt8S/mNzE+ojf1Cjv+Hs5wEogMohRrUI4EW5xYi89Pe8I2NiGwOWvMVjyFs6oBoPT
         78UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tzYLDWLzrX157HH12ds8As0JD+WbAz+wC4M9zHAPsb0=;
        b=XBZudGv3c/U7V8NNKELyPc8CstnX8oqSVux8ixZA8DVxmCH+QkQ6INAX/DZQkvY+R2
         UWRsXWqnjBl1tcNDJEHSXzsyip7zi1q55IMJ1Jp9c/cV3GjEJVM9XaMKph4SWJbsiEnX
         NssxDyYwCOfvJQiB2cqCr53tkkdg8OGGJp9fDHUJd+E8TdCtJ4sZwkhSQ596uzpFZS9w
         J3Synp0/LZKJLJ4DziLoCaSE2/rGuStR9z8ay09TQu9er93ZP+T9C1N6vuVJ1rvUhI/O
         5T5XKCRL9J+9NAPJalw+aXJVehvSgcHDPOGC0eeRNR53AAhX8TylzteAMy3qqWjSQxhk
         +G7A==
X-Gm-Message-State: AOAM532h1rCopnD5Ddd+Z+nHreBbAdjEnr1KUIOFEPbjPhr41bjn6nyF
        u5tt7RoNMK4v9gFHaIqX2cU0zQ==
X-Google-Smtp-Source: ABdhPJzK6sQGveEJG3lj86y73aLzjzcH6Iuz+0g1A3pJ41wIOKXBBXYwNJkzpO76TGfOUgstN+/AYw==
X-Received: by 2002:adf:dd42:: with SMTP id u2mr750952wrm.39.1632759051410;
        Mon, 27 Sep 2021 09:10:51 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:fa68:b369:184:c5a])
        by smtp.gmail.com with ESMTPSA id n14sm15314452wmc.38.2021.09.27.09.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 09:10:51 -0700 (PDT)
Date:   Mon, 27 Sep 2021 17:10:48 +0100
From:   Quentin Perret <qperret@google.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, drjones@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [RFC PATCH v1 10/30] KVM: arm64: Add accessors for hypervisor
 state in kvm_vcpu_arch
Message-ID: <YVHtCK22VYx4HVZM@google.com>
References: <20210924125359.2587041-1-tabba@google.com>
 <20210924125359.2587041-11-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924125359.2587041-11-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday 24 Sep 2021 at 13:53:39 (+0100), Fuad Tabba wrote:
> Some of the members of vcpu_arch represent state that belongs to
> the hypervisor. Future patches will factor these out into their
> own structure. To simplify the refactoring and make it easier to
> read, add accessors for the members of kvm_vcpu_arch that
> represent the hypervisor state.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 182 ++++++++++++++++++++++-----
>  arch/arm64/include/asm/kvm_host.h    |  38 ++++--
>  2 files changed, 181 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 7d09a9356d89..e095afeecd10 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -41,9 +41,14 @@ void kvm_inject_vabt(struct kvm_vcpu *vcpu);
>  void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
>  void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
>  
> +static __always_inline bool hyp_state_el1_is_32bit(struct vcpu_hyp_state *vcpu_hyps)
> +{
> +	return !(hyp_state_hcr_el2(vcpu_hyps) & HCR_RW);
> +}
> +
>  static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>  {
> -	return !(vcpu_hcr_el2(vcpu) & HCR_RW);
> +	return hyp_state_el1_is_32bit(&hyp_state(vcpu));
>  }
>  
>  static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> @@ -252,14 +257,19 @@ static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
>  	return mode != PSR_MODE_EL0t;
>  }
>  
> +static __always_inline u32 kvm_hyp_state_get_esr(const struct vcpu_hyp_state *vcpu_hyps)
> +{
> +	return hyp_state_fault(vcpu_hyps).esr_el2;
> +}
> +
>  static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
>  {
> -	return vcpu_fault(vcpu).esr_el2;
> +	return kvm_hyp_state_get_esr(&hyp_state(vcpu));
>  }
>  
> -static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
> +static __always_inline u32 kvm_hyp_state_get_condition(const struct vcpu_hyp_state *vcpu_hyps)
>  {
> -	u32 esr = kvm_vcpu_get_esr(vcpu);
> +	u32 esr = kvm_hyp_state_get_esr(vcpu_hyps);
>  
>  	if (esr & ESR_ELx_CV)
>  		return (esr & ESR_ELx_COND_MASK) >> ESR_ELx_COND_SHIFT;
> @@ -267,111 +277,216 @@ static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
>  	return -1;
>  }
>  
> +static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
> +{
> +	return kvm_hyp_state_get_condition(&hyp_state(vcpu));
> +}
> +
> +static __always_inline phys_addr_t kvm_hyp_state_get_hfar(const struct vcpu_hyp_state *vcpu_hyps)
> +{
> +	return hyp_state_fault(vcpu_hyps).far_el2;
> +}
> +
>  static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vcpu)
>  {
> -	return vcpu_fault(vcpu).far_el2;
> +	return kvm_hyp_state_get_hfar(&hyp_state(vcpu));
> +}
> +
> +static __always_inline phys_addr_t kvm_hyp_state_get_fault_ipa(const struct vcpu_hyp_state *vcpu_hyps)
> +{
> +	return ((phys_addr_t) hyp_state_fault(vcpu_hyps).hpfar_el2 & HPFAR_MASK) << 8;
>  }
>  
>  static __always_inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
>  {
> -	return ((phys_addr_t) vcpu_fault(vcpu).hpfar_el2 & HPFAR_MASK) << 8;
> +	return kvm_hyp_state_get_fault_ipa(&hyp_state(vcpu));
> +}
> +
> +static __always_inline u32 kvm_hyp_state_get_disr(const struct vcpu_hyp_state *vcpu_hyps)
> +{
> +	return hyp_state_fault(vcpu_hyps).disr_el1;
>  }

Looks like kvm_hyp_state_get_disr() (as well as most of the
kvm_hyp_state_*() helpers below) are never used outside of their
kvm_vcpu_*() counterparts, so maybe let's merge them for now? This series
is really quite large, so I'm just hoping we can trim a bit the bits
that aren't strictly necessary :)

Cheers,
Quentin
