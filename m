Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED1A53039F
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347438AbiEVOyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 10:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiEVOyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 10:54:03 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D0D17A9B;
        Sun, 22 May 2022 07:54:00 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id m25so15234080oih.2;
        Sun, 22 May 2022 07:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5LAbxrhQvqJ0rVfTPKOc9msHJuHfL3/0vpviQnQBTYc=;
        b=dOtQFWNI1v40juuCcEn6eX/Y3w480xRXQjpjzy8XpyCy9Rm9YG0ckRhKwymMFFGirT
         CZjFjBfF51RmbI1OZh+5wyzKWBWGlAKt7iumNqSa1lz3Pnc8rYzkFG9fmwh4t73vE47b
         WmHTK8KO11FfJlvE/slPMPHLg6ljiuIE8xBbnuZVGvPTEkZ5BRqVXIpsH4FNVnB3qFaV
         3CgPtVRQJkwNZ6l4M2nwVSE+qQxZ1/xCSLOozUDvqrfY48Ty2roAI1uxlIFOC2Qezhej
         bGp8IM29EZfr7fRhbDbiAx44GAgCzJ75ZdLvTMYF2IdZckXJ6mVPCDJ2Ci6IxKRUZjzq
         Vz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5LAbxrhQvqJ0rVfTPKOc9msHJuHfL3/0vpviQnQBTYc=;
        b=KygNY0mPzSa+fHDYreyq6JmjCDYlvDOYRbanip3ZIzKmkmtU2cDQTRxXwdrUT5nw2t
         s586P1DJ3212pejlcqz/Ygey3IsddqIiXpi9BnymzkdAdnkl8fzOgXF5s9N09LjXFw/a
         o7tcssQrZky+XPq15kiwcY7+sEkMz9GSHMVm3ICqzr+HFOVVwQl5jPA61y1OEjz9YQgg
         hY0vuFFg/UFeYpHXaFRi2fwIXpHvXwP6pQUpJjkzzG8haqHFFWG03Q+nT/qahXtb1hof
         HoqtEhKC4akehVy+C04Uz9NGoIC9rCs5+YCbWA0g3Ct3CTOOAz96cSXejHhwGXmrDLk9
         uJ4Q==
X-Gm-Message-State: AOAM530cFejO56bnts9HgaBqAvs3HH05ldMWWL8P7JQLykuVgEI0S9BH
        OVAcoqbUCRc0Z1b6F37REQA=
X-Google-Smtp-Source: ABdhPJwKF59QPrNBVWllhBArNbXrS0RC9c7vVQQ9CXmuSl0IUuGaYikoD6KlKTyFqi7MK616GxHrWw==
X-Received: by 2002:aca:4b87:0:b0:326:b2bf:b10a with SMTP id y129-20020aca4b87000000b00326b2bfb10amr10296097oia.213.1653231239958;
        Sun, 22 May 2022 07:53:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i23-20020a4addd7000000b0035eb4e5a6bdsm3367006oov.19.2022.05.22.07.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 May 2022 07:53:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 22 May 2022 07:53:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Matti Vaittinen <Matti.Vaittinen@fi.rohmeurope.com>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 11/22] KVM: x86: hyper-v: replace bitmap_weight() with
 hweight64()
Message-ID: <20220522145357.GA244394@roeck-us.net>
References: <20220510154750.212913-1-yury.norov@gmail.com>
 <20220510154750.212913-12-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510154750.212913-12-yury.norov@gmail.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 08:47:39AM -0700, Yury Norov wrote:
> kvm_hv_flush_tlb() applies bitmap API to a u64 variable valid_bank_mask.
> Since valid_bank_mask has a fixed size, we can use hweight64() and avoid
> excessive bloating.

In kvm_hv_send_ipi(), valid_bank_mask is unsigned long, not u64.

This results in:

arch/x86/kvm/hyperv.c: In function 'kvm_hv_send_ipi':
include/asm-generic/bitops/const_hweight.h:21:76: error: right shift count >= width of type

on all 32-bit builds.

Guenter

> 
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Jim Mattson <jmattson@google.com>
> CC: Joerg Roedel <joro@8bytes.org>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Sean Christopherson <seanjc@google.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Vitaly Kuznetsov <vkuznets@redhat.com>
> CC: Wanpeng Li <wanpengli@tencent.com>
> CC: kvm@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: x86@kernel.org
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 41585f0edf1e..b652b856df2b 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1855,7 +1855,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		all_cpus = flush_ex.hv_vp_set.format !=
>  			HV_GENERIC_SET_SPARSE_4K;
>  
> -		if (hc->var_cnt != bitmap_weight((unsigned long *)&valid_bank_mask, 64))
> +		if (hc->var_cnt != hweight64(valid_bank_mask))
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
>  		if (all_cpus)
> @@ -1956,7 +1956,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
>  		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
>  
> -		if (hc->var_cnt != bitmap_weight(&valid_bank_mask, 64))
> +		if (hc->var_cnt != hweight64(valid_bank_mask))
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
>  		if (all_cpus)
> -- 
> 2.32.0
> 
