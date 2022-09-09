Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4CF5B3B01
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 16:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiIIOq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 10:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiIIOqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 10:46:54 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EDCA7A92
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 07:46:53 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 202so1769872pgc.8
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 07:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=aeqcyjlRiIXcpcrwXwZh2ZdaG5blqERrWAC3psmQb1s=;
        b=mpAf3lqFV0vqYRF+Ziw7QpTF1QkgGeDYzVFCcwX2aXURg9iMkptuJC+tVzuX18ffHE
         8lSjGw3zWTst/OkfYDu213446yGt9hZm7IJreBYO/kCrJjeGcup2HgKlskGm71YK9jur
         wHhqFAiwI4Pexu4ELT0vMn4HQ/LGVb3hnttzJDLpZUEeCtfQ8fu27bgkkJqtQGS/x7wR
         3LXNtcNUW8X2+xIFHWur0kRt+igZ52XV6yFe32c9KkbFUDLaxI0WGaFDbwi4yVKf44+V
         NkNfBHVGN74vPJLUWpmq3JNVaaMubYbmXJkWs/kDISEPCn+GllhcUeNUQ8baGWnjpNhi
         RQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=aeqcyjlRiIXcpcrwXwZh2ZdaG5blqERrWAC3psmQb1s=;
        b=qqn1t0vkOzS6KvVs1PtrU8zOEhqO1ymDKmYnf5iyJmPAg1mDPjrYRYWXRmCnmne+y5
         XKLLtKzOnRfFoI6y8SxOEYjfoca8hhs88yfkciwFMVQetHHC3Bnvb6A8CzIHF63a11lv
         vc/DgMrX1hc4JQRlV4yV/V1+biTpJLq/bdzkZB+MjIPbYOGnFM1qtVWOplLCGdRplmh1
         +fSQIsl5o/8YsU6R4RwEv/AS6tt8liNRpgwnHowoEtVEByUHQgmOLsS7eeJATBHyW9kt
         rM8nXZIHGVtXChb2r3GmJbkdFZKYTGiy6Yt+BfuSoxZMDFj8rqTNVx/Kqj+jJuNJsH1J
         Zj6g==
X-Gm-Message-State: ACgBeo1prgOmAs6uANKKqphB5uTroVZF7kceGO3+MVRhSTPaMwkDpDlG
        W/m4/wY8eO9VfU59tnNW8kmN4A==
X-Google-Smtp-Source: AA6agR5ExI+5K3A7i6xFj5RwfI/4TAEa9km1rXWtOM/65/KkiOtwax2q08TPjxCFLCqN2EwdiTOZGw==
X-Received: by 2002:aa7:888d:0:b0:538:328b:2ffb with SMTP id z13-20020aa7888d000000b00538328b2ffbmr14584320pfe.82.1662734812439;
        Fri, 09 Sep 2022 07:46:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t4-20020a17090340c400b00172973d3cd9sm606043pld.55.2022.09.09.07.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 07:46:52 -0700 (PDT)
Date:   Fri, 9 Sep 2022 14:46:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Metin Kaya <metikaya@amazon.co.uk>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, x86@kernel.org,
        bp@alien8.de, dwmw@amazon.co.uk, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        joao.m.martins@oracle.com
Subject: Re: [PATCH 2/2] KVM: x86: Introduce kvm_gfn_to_hva_cache_valid()
Message-ID: <YxtR2J7CmTElfQNS@google.com>
References: <20220909095006.65440-1-metikaya@amazon.co.uk>
 <20220909095006.65440-2-metikaya@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909095006.65440-2-metikaya@amazon.co.uk>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022, Metin Kaya wrote:
> It simplifies validation of gfn_to_hva_cache to make it less error prone

Avoid pronouns as they're ambiguous, e.g. does "it" mean the helper or the patch?
Obviously not a big deal in this case, but avoid pronouns is a good habit to get
into.

> per the discussion at
> https://lore.kernel.org/all/4e29402770a7a254a1ea8ca8165af641ed0832ed.camel@infradead.org.

Please write a proper changelog.  Providing a link to the discussion is wonderful,
but it's a supplement to a good changelog, not a substitution.

> Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>
> ---
>  arch/x86/kvm/x86.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43a6a7efc6ec..07d368dc69ad 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3425,11 +3425,22 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
>  
> +static inline bool kvm_gfn_to_hva_cache_valid(struct kvm *kvm,

Don't add inline to local static functions, let the compiler make those decisions.

> +					      struct gfn_to_hva_cache *ghc,
> +					      gpa_t gpa)
> +{
> +	struct kvm_memslots *slots = kvm_memslots(kvm);
> +
> +	return !unlikely(slots->generation != ghc->generation ||

I don't I don't think the unlikely should be here, it's the context in which the
helper is used that determines whether or not the outcome is unlikely.

> +			 gpa != ghc->gpa ||
> +			 kvm_is_error_hva(ghc->hva) ||
> +			 !ghc->memslot);

Might be worth opportunistically reordering the checks to avoid grabbing memslots
when something else is invalid, e.g.

	return gpa != ghc->gpa || kvm_is_error_hva(ghc->hva) || !ghc->memslot ||
	       kvm_memslots(kvm)->generation != ghc->generation);

> +}
> +
