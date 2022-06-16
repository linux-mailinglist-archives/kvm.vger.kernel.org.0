Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C4554D5CF
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 02:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350313AbiFPAHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 20:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241580AbiFPAHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 20:07:01 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CD556430
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 17:07:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id bo5so35343pfb.4
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 17:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UzNSLtWYYJaJcz6ahq1sWmZ/zvDFFynW/a820aPRv1o=;
        b=ZhUtoDjid6CNNi0X7rhWHwGozinrVNBKvm+R/6ExzKzXrqGQDazA5fXhvaKV8aiHID
         XEa744izFoZCdS58upNpp+LWO/UQkzK6aIxweuDL11niMI8x/CBSaG5P4C9kKeLy8clc
         2Q7uOv8SzCc9ODY2ZUxcc2rF319j8fILxFqnXzP3nd1Jejqc7G2wx0XcxKf+TzjlHfRL
         oekWkfEolwC2qdlvmWXEZK/PYyRCE81/npf0ZY3ROpTpx5NnxFERzt9qDtN60sNzyxTC
         HXNfkqMrlyE9bkufhJABVYvqCm4Dty3iTvPUp4aFBkOLIYm9XoYHAGiGfYnsDSZZESge
         DA1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UzNSLtWYYJaJcz6ahq1sWmZ/zvDFFynW/a820aPRv1o=;
        b=qY4vByBodbnYFm7oka1HsAwZASDNfgu0Yefr0dr1gf06Xubf2RevU4Z2zyjmZB3Dvq
         DPYT1Kgg6M5ie7oR6FfzVZSOnoHKliynYvk7mCjSvd9DbA7GE+3wkCbBUoWDdRLxYMbh
         Cco7JfcX+tqpWiGkTRSENLmD7M8BXEOB19+wasJEOu/eVsJrFS1o/3/cIvDjgxhhgRqo
         0Vi12QhXXxfU23AAx0HgmtaNnQMaw56FNAvh9/Bdyat+U1WbGBMyHAlJzVH5AkZBB2QG
         6WOneG7OYDxJ3GI6QHaAoM0NDNK7JvL046s+gmPMHsqmXdWyw7M5JIajaNIkk1IMndCn
         UBtg==
X-Gm-Message-State: AJIora+S7HZBz+Z3XaG/ldcoxX/Xk54CaAgRLTFE9O3kUUhKNsXSAIFt
        UvIygiUFAxQxeRcuqmiIUVRQRA==
X-Google-Smtp-Source: AGRyM1vNfQvYoju6cR3jOaFoTNJaVmrU7hvSpDgLjMcQ3/STuylr0/1PCGysK+TTGytYCPSnPjOcQQ==
X-Received: by 2002:a62:ab17:0:b0:51b:bf44:a9aa with SMTP id p23-20020a62ab17000000b0051bbf44a9aamr2144704pff.50.1655338020309;
        Wed, 15 Jun 2022 17:07:00 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y21-20020a637d15000000b00408be5733e9sm189348pgc.14.2022.06.15.17.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 17:06:59 -0700 (PDT)
Date:   Thu, 16 Jun 2022 00:06:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 5/8] x86: nSVM: Build up the nested
 page table dynamically
Message-ID: <Yqp0IP+qnp9qFrDM@google.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <20220428070851.21985-6-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428070851.21985-6-manali.shukla@amd.com>
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

On Thu, Apr 28, 2022, Manali Shukla wrote:
> Current implementation of nested page table does the page table build
> up statistically with 2048 PTEs and one pml4 entry.
> That is why current implementation is not extensible.
> 
> New implementation does page table build up dynamically based on the
> RAM size of the VM which enables us to have separate memory range to
> test various npt test cases.

I'm guessing you know the drill :-)

> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  x86/svm.c     | 75 ++++++++++++++++-----------------------------------
>  x86/svm.h     |  4 ++-
>  x86/svm_npt.c |  5 ++--
>  3 files changed, 29 insertions(+), 55 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index ec825c7..e66c801 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -8,6 +8,7 @@
>  #include "desc.h"
>  #include "msr.h"
>  #include "vm.h"
> +#include "fwcfg.h"
>  #include "smp.h"
>  #include "types.h"
>  #include "alloc_page.h"
> @@ -16,43 +17,32 @@
>  #include "vmalloc.h"
>  
>  /* for the nested page table*/
> -u64 *pte[2048];
> -u64 *pde[4];
> -u64 *pdpe;
>  u64 *pml4e;
>  
>  struct vmcb *vmcb;
>  
>  u64 *npt_get_pte(u64 address)
>  {
> -	int i1, i2;
> -
> -	address >>= 12;
> -	i1 = (address >> 9) & 0x7ff;
> -	i2 = address & 0x1ff;
> -
> -	return &pte[i1][i2];
> +        return get_pte(npt_get_pml4e(), (void*)address);
>  }
>  
>  u64 *npt_get_pde(u64 address)
>  {
> -	int i1, i2;
> -
> -	address >>= 21;
> -	i1 = (address >> 9) & 0x3;
> -	i2 = address & 0x1ff;
> -
> -	return &pde[i1][i2];
> +    struct pte_search search;
> +    search = find_pte_level(npt_get_pml4e(), (void*)address, 2);
> +    return search.pte;
>  }
>  
> -u64 *npt_get_pdpe(void)
> +u64 *npt_get_pdpe(u64 address)
>  {
> -	return pdpe;
> +    struct pte_search search;
> +    search = find_pte_level(npt_get_pml4e(), (void*)address, 3);
> +    return search.pte;
>  }
>  
>  u64 *npt_get_pml4e(void)
>  {
> -	return pml4e;
> +    return pml4e;
>  }
>  
>  bool smp_supported(void)
> @@ -300,11 +290,21 @@ static void set_additional_vcpu_msr(void *msr_efer)
>  	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME);
>  }
>  
> +void setup_npt(void) {

Function braces go on a new line.

> +    u64 end_of_memory;
> +    pml4e = alloc_page();
> +

...

> diff --git a/x86/svm_npt.c b/x86/svm_npt.c
> index 53e8a90..ab4dcf4 100644
> --- a/x86/svm_npt.c
> +++ b/x86/svm_npt.c
> @@ -209,7 +209,8 @@ static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsvd_bits, u64 efer,
>  	       "Wanted #NPF on rsvd bits = 0x%lx, got exit = 0x%x", rsvd_bits,
>  	       exit_reason);
>  
> -	if (pxe == npt_get_pdpe() || pxe == npt_get_pml4e()) {
> +	if (pxe == npt_get_pdpe((u64) basic_guest_main)
> +	    || pxe == npt_get_pml4e()) {

The "||" should be on the previous line.

>  		/*
>  		 * The guest's page tables will blow up on a bad PDPE/PML4E,
>  		 * before starting the final walk of the guest page.
> @@ -338,7 +339,7 @@ skip_pte_test:
>  				get_random_bits(20, 13) | PT_PAGE_SIZE_MASK,
>  				host_efer, host_cr4, guest_efer, guest_cr4);
>  
> -	_svm_npt_rsvd_bits_test(npt_get_pdpe(),
> +	_svm_npt_rsvd_bits_test(npt_get_pdpe((u64) basic_guest_main),
>  				PT_PAGE_SIZE_MASK |
>  				(this_cpu_has(X86_FEATURE_GBPAGES) ?
>  				 get_random_bits(29, 13) : 0), host_efer,
> -- 
> 2.30.2
> 
