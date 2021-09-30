Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38AA41D0F1
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 03:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346834AbhI3Bbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 21:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhI3Bbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 21:31:50 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6717C06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 18:30:08 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id s16so3552553pfk.0
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 18:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jRp6xx9JEM0TcCD5fdU5sFSdTI9Sw1rI0wNiuDGyCkE=;
        b=D/asLJ437DdwVd//8Jb4exUYZiu7RfVER8eq3tHqN6BIsow5YckYOdpMOYMyVL1s0k
         1sMyrqevYEalyd+EGbeXn/EzntPCfj596lGy5vhHkh9UofxCBlgbc/84yzXlY9fIhR20
         nMWXsRR1njUh52+GLRBdtslfZ4oDM2M+hRns7VJEIL8yFqFyHL7LilrKv6Xbw3irlKuG
         QI/LcSDuZUtiIYAki4RcznWJkaxLInSneqoJb9cSP2WDN9TIj1l5thGjbKlipCmVsS3+
         FvhOsaPOyy/Nlc5BAhfTmMo0EmQs0b8lavzZ9Oarz/BJ54PL6KMClKjQ1vnnU3xsbPdG
         LAwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jRp6xx9JEM0TcCD5fdU5sFSdTI9Sw1rI0wNiuDGyCkE=;
        b=cyfsNGsUDKCsDZFtj+iuD7n+ID6QYU5CZe+t32/yroCkbqqERKzTU+CNAbXovlywXB
         kuH48x66r0dJOZJsHDEmWTTqEyyz5W7pG59Icty4yiB9qgfzjeN5AvJMG8rE7EnIPL6Y
         f3Y+XlRBo8Liwghc/0MOOrcuPQRsi90q4tdUw58/ypRo09HNqRC03niugBx8vp3S2fSB
         yCEB8vwzfTYMzNMXxh1nMiRklMeeFu8MErbY2pk6+mag93neiTZfv7ZiU3FZjHbSzasE
         4iYVskPpDmfW4EvBhKs35nNbKAWVtuLQ9dmFJUf8Tm/58Jqw6lPtIn8/ZBh8qH9poDBA
         rSxA==
X-Gm-Message-State: AOAM532Esw/MNXbPDYV+F/3eP//4Qsvth8L5dvWgNHMxXgK1aPoaqNhx
        Q9Onfk4nt1hbfcze5AaOEl7wyt3yrU7rOA==
X-Google-Smtp-Source: ABdhPJwMaJm98HJGwXWOEOaz6M1r0dr2QebCZGMK8k3moiBmocs409viVzDoOEisUTcu2xrSiPMclw==
X-Received: by 2002:aa7:9a0e:0:b0:44a:3ae2:825c with SMTP id w14-20020aa79a0e000000b0044a3ae2825cmr1623655pfj.28.1632965407921;
        Wed, 29 Sep 2021 18:30:07 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id n185sm915121pfn.171.2021.09.29.18.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 18:30:07 -0700 (PDT)
Date:   Wed, 29 Sep 2021 18:30:03 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Fix nested SVM tests when built with
 clang
Message-ID: <YVUTG0n1i1n/RpL4@google.com>
References: <20210930003649.4026553-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930003649.4026553-1-jmattson@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 05:36:49PM -0700, Jim Mattson wrote:
> Though gcc conveniently compiles a simple memset to "rep stos," clang
> prefers to call the libc version of memset. If a test is dynamically
> linked, the libc memset isn't available in L1 (nor is the PLT or the
> GOT, for that matter). Even if the test is statically linked, the libc
> memset may choose to use some CPU features, like AVX, which may not be
> enabled in L1. Note that __builtin_memset doesn't solve the problem,
> because (a) the compiler is free to call memset anyway, and (b)
> __builtin_memset may also choose to use features like AVX, which may
> not be available in L1.
> 
> To avoid a myriad of problems, use an explicit "rep stos" to clear the
> VMCB in generic_svm_setup(), which is called both from L0 and L1.
> 
> Reported-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Fixes: 20ba262f8631a ("selftests: KVM: AMD Nested test infrastructure")
> ---
>  tools/testing/selftests/kvm/lib/x86_64/svm.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> index 2ac98d70d02b..161eba7cd128 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> @@ -54,6 +54,18 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
>  	seg->base = base;
>  }
>  
> +/*
> + * Avoid using memset to clear the vmcb, since libc may not be
> + * available in L1 (and, even if it is, features that libc memset may
> + * want to use, like AVX, may not be enabled).
> + */
> +static void clear_vmcb(struct vmcb *vmcb)
> +{
> +	int n = sizeof(*vmcb) / sizeof(u32);
> +
> +	asm volatile ("rep stosl" : "+c"(n), "+D"(vmcb) : "a"(0) : "memory");
> +}
> +
>  void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
>  {
>  	struct vmcb *vmcb = svm->vmcb;
> @@ -70,7 +82,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
>  	wrmsr(MSR_EFER, efer | EFER_SVME);
>  	wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
>  
> -	memset(vmcb, 0, sizeof(*vmcb));
> +	clear_vmcb(vmcb);
>  	asm volatile ("vmsave %0\n\t" : : "a" (vmcb_gpa) : "memory");
>  	vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg_attr);
>  	vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg_attr);
> -- 
> 2.33.0.685.g46640cef36-goog
> 

Reviewed-by: Ricardo Koller <ricarkol@google.com>
