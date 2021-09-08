Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97294039F1
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 14:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351853AbhIHMed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 08:34:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24218 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351780AbhIHMeT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 08:34:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631104391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aWw53LNgJz3aDc43XCZOPsV9FvfAENW+YZYZivjZJN4=;
        b=cKLVltDOE1OiFTOPcX1TSsRFtoz7lD7ZXx8JUq2rA/ABgHbTVI1iWyHLrmDyhtGunFEBl1
        YLMWL75qGyUHASWRUzCsYRcw7ExT0AGotvXk1Oy4mohEKq3AuMbMPTK/ZgCkIcSajQB2tZ
        1rrukpXSu/gKF7RD02TkqiC/FCTtn3U=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-4kHgK6ahMn-YWfXA5rZDuA-1; Wed, 08 Sep 2021 08:33:10 -0400
X-MC-Unique: 4kHgK6ahMn-YWfXA5rZDuA-1
Received: by mail-ej1-f72.google.com with SMTP id gw26-20020a170906f15a00b005c48318c60eso923726ejb.7
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 05:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aWw53LNgJz3aDc43XCZOPsV9FvfAENW+YZYZivjZJN4=;
        b=mhii3rH+LqFo3/8qJ94Pbaj1//Fw7zXv6bHes3jBbOnt0wpGtfqlfVRa4tFhOsSfYP
         CtnTW1+DSOhat6QHgOvrgbAlpd3ZdbsvdxxPiC7P61xPlLI7/Pn4ZabndDvzZe7kSwMy
         zEBBIR1eApxf2KhTK04A0xMdS9iDJ/kkNTYgRJtQUDV5j8g4QbVIBfHzQc9SWCm8qfFc
         LHT2iIpvcjI1WJT9nYoWGomlhMX7lzgi0RijuxXBxcq0xp+f4rS5oZtV1XfvIy/10koJ
         oGdS4rqs9ljwcOX2jlQi5VrreykeOubmuonSRjiMereLJZ0Qm7e4J+1QbqbSr/NywZ/Q
         oRUg==
X-Gm-Message-State: AOAM533f2BP8a24vvlZGxlRqfwY3DcI94jq0/D1AEh6EDHx/iTpZ9H/z
        ekxH6sfZ9El7L0oK7v2UzSg3jHGuY54dhX0zu9FKacZus4KSIZtb2hL/GHuWnUWtNJU9yXA0M84
        RsHKZc0ut4b5k
X-Received: by 2002:a17:906:dc43:: with SMTP id yz3mr3872905ejb.467.1631104389136;
        Wed, 08 Sep 2021 05:33:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIuRzcv6t607G/tVLSQPrkOuXVPBvLzyNFDBGRHwQRCQr3jx8byLjmzZ6F+EPiIBVQ5zUG3w==
X-Received: by 2002:a17:906:dc43:: with SMTP id yz3mr3872889ejb.467.1631104388955;
        Wed, 08 Sep 2021 05:33:08 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id h2sm1156061edd.43.2021.09.08.05.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 05:33:08 -0700 (PDT)
Date:   Wed, 8 Sep 2021 14:33:06 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v5 1/8] KVM: arm64: Pass struct kvm to per-EC handlers
Message-ID: <20210908123306.7xthfbxz274ndxit@gator>
References: <20210827101609.2808181-1-tabba@google.com>
 <20210827101609.2808181-2-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827101609.2808181-2-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 11:16:02AM +0100, Fuad Tabba wrote:
> We need struct kvm to check for protected VMs to be able to pick
> the right handlers for them.
> 
> Mark the handler functions inline, since some handlers will be
> called in future code from the protected VM handlers.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 16 ++++++++--------
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 0397606c0951..7cbff0ee59a5 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -163,7 +163,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
>   * If FP/SIMD is not implemented, handle the trap and inject an undefined
>   * instruction exception to the guest. Similarly for trapped SVE accesses.
>   */
> -static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	bool sve_guest, sve_host;
>  	u8 esr_ec;
> @@ -318,7 +318,7 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
>  
>  DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  
> -static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	struct kvm_cpu_context *ctxt;
>  	u64 val;
> @@ -343,7 +343,7 @@ static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return true;
>  }
>  
> -static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
>  	    handle_tx2_tvm(vcpu))
> @@ -356,7 +356,7 @@ static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
>  
> -static bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
>  	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
> @@ -365,7 +365,7 @@ static bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
>  
> -static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	if (!__populate_fault_info(vcpu))
>  		return true;
> @@ -373,7 +373,7 @@ static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
>  
> -static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	if (!__populate_fault_info(vcpu))
>  		return true;
> @@ -403,7 +403,7 @@ static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
>  
>  typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
>  
> -static const exit_handler_fn *kvm_get_exit_handler_array(void);
> +const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm);
>  
>  /*
>   * Allow the hypervisor to handle the exit with an exit handler if it has one.
> @@ -413,7 +413,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(void);
>   */
>  static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> -	const exit_handler_fn *handlers = kvm_get_exit_handler_array();
> +	const exit_handler_fn *handlers = kvm_get_exit_handler_array(kern_hyp_va(vcpu->kvm));
>  	exit_handler_fn fn;
>  
>  	fn = handlers[kvm_vcpu_trap_get_class(vcpu)];
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index c52d580708e0..ebc0a5a4dd6a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -170,7 +170,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>  	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
>  };
>  
> -static const exit_handler_fn *kvm_get_exit_handler_array(void)
> +const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
>  {
>  	return hyp_exit_handlers;
>  }
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 0e0d342358f7..d823b089d3e9 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -108,7 +108,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>  	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
>  };
>  
> -static const exit_handler_fn *kvm_get_exit_handler_array(void)
> +const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
>  {
>  	return hyp_exit_handlers;
>  }
> -- 
> 2.33.0.259.gc128427fd7-goog
>

I have to admit my ignorance here. How do we link KVM? Are not
nvhe/switch.c and vhe/switch.c linked into the same kernel? If so,
then how does this compile after the static on
kvm_get_exit_handler_array() was removed?

Thanks,
drew

