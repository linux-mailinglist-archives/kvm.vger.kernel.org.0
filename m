Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF224BBCFF
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 17:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiBRQFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 11:05:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiBRQFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 11:05:02 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BEB532FE
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:04:46 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id i21so2628484pfd.13
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WDCu5fW0jU66ysKsVUGrCitGNsiEZTA+NVb+oahcLwA=;
        b=LXDx8icFsWFPMdF/g01b4gSchKGaC2RcBtXtf4DrUEw3t5xt4m7ZPlXIYKBxC4e7Ub
         Qd7R+6JNu13TapP/gJmnVnpBwUs0I+fiPNRTy9aIzKEEJdLXmqwROwUL6hBCncRKywW9
         8AvV3xi6aYtB42zirKim6PrWOMPK7bB1j41JRV68B8HvQa95E+mwiiG1PgEEgOpmgWMF
         h33tPRQY2315I8lczu0a/qLAjNkMvRguMkRPLTGsdDGNajduA6X8/xfLnAyQbFuPyPkj
         9qeh8O2uxYR/MgnK/noxfEWh/4i8ORQzF6PfcJ04CAxA2jBWjFflZvonmOP9BxSG8Dgf
         MeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WDCu5fW0jU66ysKsVUGrCitGNsiEZTA+NVb+oahcLwA=;
        b=QV1+6exUkyENiiVEkhDhl7rRRdHxWZxvRAhNUt+2zrpKqlTRZbTJ/mQC7KgpPKmm8M
         s2TKlkEba1JIlOl7smJuN5fsiY8btblxbW1/ECPdVQVV1rpJYxbM83cW9vCjFtT2x59K
         IHeVWbPS2lkskcc21e9Yk+MAid7B+jhx2tDmocdrHZM6MGt9BGG7WeFlFXZplO5k76Tl
         qoCpAaaI84fF7SOw4uvBxtHo4ykoy81+M13nkgQHitks/6/QKJJ3Bq8eAZVIIAOVKtVq
         1fcABABGs7YqmwrR+rJ7UhcopuK2fFTUUr1Hf0BVgYl8ozm3X3qn7UEhHR6hWiYJXqxJ
         46Bg==
X-Gm-Message-State: AOAM530NTJQZgTYTkFEkKxrUC92vq5ZUoXGCv1TnqbOBzCmDwcNBlClQ
        P+Dw3z+JKNhQQ0vTXHGvSjaIxQ==
X-Google-Smtp-Source: ABdhPJyOXXnBv1yMQKgPoI/ywpg5jlp3cL5cedKhOmSghspyiza1zCJ9BlMluZ1SBcRYyVkJhYM2AQ==
X-Received: by 2002:a62:65c6:0:b0:4d1:6354:e8e6 with SMTP id z189-20020a6265c6000000b004d16354e8e6mr8190211pfb.64.1645200285419;
        Fri, 18 Feb 2022 08:04:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mg24sm5112105pjb.4.2022.02.18.08.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 08:04:44 -0800 (PST)
Date:   Fri, 18 Feb 2022 16:04:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peng Hao <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  kvm: correct comment description issue
Message-ID: <Yg/DmdjSqNLwWo2d@google.com>
References: <20220218110547.11249-1-flyingpeng@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218110547.11249-1-flyingpeng@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"KVM: VMX:" for the scope.  A more specific shortlog would also be helfpul, stating
that a comment is being modified doesn't provide any info about what comment.

On Fri, Feb 18, 2022, Peng Hao wrote:
> loaded_vmcs does not have this field 'vcpu', modify this comment.

It would be helpful to state that loaded_vmcs has 'cpu', not 'vcpu'.  It's hard to
identify what's being changed.


Something like this?

  KVM: VMX: Fix typos above smp_wmb() comment in __loaded_vmcs_clear()

  Fix a comment documenting the memory barrier related to clearing a
  loaded_vmcs; loaded_vmcs tracks the host CPU the VMCS is loaded on via
  the field 'cpu', it doesn't have a 'vcpu' field.

With a tweaked shortlog/changelog (doesn't have to be exactly the above),

Reviewed-by: Sean Christopherson <seanjc@google.com>

> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7dce746c175f..0ffcfe54eea5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -644,10 +644,10 @@ static void __loaded_vmcs_clear(void *arg)
>  
>  	/*
>  	 * Ensure all writes to loaded_vmcs, including deleting it from its
> -	 * current percpu list, complete before setting loaded_vmcs->vcpu to
> -	 * -1, otherwise a different cpu can see vcpu == -1 first and add
> -	 * loaded_vmcs to its percpu list before it's deleted from this cpu's
> -	 * list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
> +	 * current percpu list, complete before setting loaded_vmcs->cpu to
> +	 * -1, otherwise a different cpu can see loaded_vmcs->cpu == -1 first
> +	 * and add loaded_vmcs to its percpu list before it's deleted from this
> +	 * cpu's list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
>  	 */
>  	smp_wmb();
>  
> -- 
> 2.27.0
> 
