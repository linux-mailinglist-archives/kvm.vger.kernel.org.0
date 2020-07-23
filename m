Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA2622A568
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 04:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbgGWCvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 22:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbgGWCvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 22:51:46 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F5EC0619DC
        for <kvm@vger.kernel.org>; Wed, 22 Jul 2020 19:51:46 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id 6so3468727qtt.0
        for <kvm@vger.kernel.org>; Wed, 22 Jul 2020 19:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3FGTIJsMWiuqsdJoUqDQziqKZol4pbNpNal4MX+V3kg=;
        b=D4Tjc4MSqAmk0rC//KBKh1MiOvF64ETmR5erHLkBNz/8G+d73CGhYZI1//N88xp3ZB
         PvKfFZuUeECW1tLVijoi3JQv9Up/t+hwwQgH3c8cswSdN6b+/Up9tW7+AtjRsHCmSMCX
         r4n01aNGXw77bOe/qpolDszh83WgniXUkiV5FRZrDN+31aJwo7pQVXKpIKpw5aIEsGtc
         Aec8VcRO62DibdZaLmJbPEQHsaxCYOcSRLIzgJUrA1mrdcESDQmhishwfqeMnn4kmy0s
         /liNR1YE0Fl6tdMi+cbCOMBaisHdmnJ3esEqnEFXLgeP+Ir4bBfTpC1fKWXfgCvzYJdD
         Sxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3FGTIJsMWiuqsdJoUqDQziqKZol4pbNpNal4MX+V3kg=;
        b=MPQP4JxuueXyZ9FnozrRkIOXQ2eCS3gmowP6S0eQ++o2MS/5AaEeos+mb8tUVgYVwI
         ZzjRBpOMBar1wsJke95px9R0Qsfeeyf31KNDys14peAsszf6d2lFbIRDWfENBKIMEN6U
         YJ9DTmlIBcTh9SadG+pkpa677pfkv2oh8Eb2SRAIvBGsHo4/aZ+iBCm5zU4puKjzXaRS
         tze5K8/YyBJ0GYcywjbtuTMoqNnZN0dklwArN9Lijd+GcK6J9Mqu9XzhuR1U545dSNnu
         wAM1l3NRZ89OiFZrOPJ7JissFtSi7PX0OcPsQwoIN+pzJhlF9p7KiWr/of5g53F6V0Ua
         lTzw==
X-Gm-Message-State: AOAM530Oy8C4NANOCrYsb2LM8otDhozGMPiK7AGZLnNiybxFE4iahoeo
        aCDDA7s/PIM5E2U1MbukLOs=
X-Google-Smtp-Source: ABdhPJzB3i+6fJCaN7bK3FLHzxEfYv91xyQg7+WuzYFSVlcaYRmb6plJdBFlgj+XI2n9fahxWfbf8A==
X-Received: by 2002:ac8:464f:: with SMTP id f15mr2224175qto.211.1595472705344;
        Wed, 22 Jul 2020 19:51:45 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id x13sm1288730qts.57.2020.07.22.19.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 19:51:44 -0700 (PDT)
Date:   Wed, 22 Jul 2020 19:51:42 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL
 functions
Message-ID: <20200723025142.GA361584@ubuntu-n2-xlarge-x86>
References: <20200722162231.3689767-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722162231.3689767-1-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 05:22:31PM +0100, Marc Zyngier wrote:
> So far, vcpu_has_ptrauth() is implemented in terms of system_supports_*_auth()
> calls, which are declared "inline". In some specific conditions (clang
> and SCS), the "inline" very much turns into an "out of line", which
> leads to a fireworks when this predicate is evaluated on a non-VHE
> system (right at the beginning of __hyp_handle_ptrauth).
> 
> Instead, make sure vcpu_has_ptrauth gets expanded inline by directly
> using the cpus_have_final_cap() helpers, which are __always_inline,
> generate much better code, and are the only thing that make sense when
> running at EL2 on a nVHE system.
> 
> Fixes: 29eb5a3c57f7 ("KVM: arm64: Handle PtrAuth traps early")
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Thank you for the quick fix! I have booted a mainline kernel with this
patch with Shadow Call Stack enabled and verified that using KVM no
longer causes a panic.

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>

For the future, is there an easy way to tell which type of system I am
using (nVHE or VHE)? I am new to the arm64 KVM world but it is something
that I am going to continue to test with various clang technologies now
that I have actual hardware capable of it that can run a mainline
kernel.

Cheers,
Nathan

> ---
>  arch/arm64/include/asm/kvm_host.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 147064314abf..a8278f6873e6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -391,9 +391,14 @@ struct kvm_vcpu_arch {
>  #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
>  
> -#define vcpu_has_ptrauth(vcpu)	((system_supports_address_auth() || \
> -				  system_supports_generic_auth()) && \
> -				 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))
> +#ifdef CONFIG_ARM64_PTR_AUTH
> +#define vcpu_has_ptrauth(vcpu)						\
> +	((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||		\
> +	  cpus_have_final_cap(ARM64_HAS_GENERIC_AUTH)) &&		\
> +	 (vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
> +#else
> +#define vcpu_has_ptrauth(vcpu)		false
> +#endif
>  
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>  
> -- 
> 2.28.0.rc0.142.g3c755180ce-goog
> 
