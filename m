Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2953481D3
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 20:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbhCXTVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 15:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237914AbhCXTVF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 15:21:05 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4403C061763
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 12:21:04 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id m7so15349706pgj.8
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 12:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lCEZrk5ZMye12lNks/t4yh+GdaF+KuVyhhCCIQr8x50=;
        b=ID786m9irKWBTEFfhCGozQ8TXWsPJyETWPbudZKO+2M73hDMoTC1ZpoYgxW4eYrfCX
         FWDrtbV5e43UozLnKhdGy8iyWAwId9AOTl+sJl90+ZcfgSvLYX/Dffsyxte2XZ2fXzKu
         iC+3Vv+So0epNZ4UsWOahrWYIIXdxuq+4qeO6T31AfYKk46BgmDJO95fK99ltw7YaezY
         8UrxnC7wWuWLQ9PIy0lwVsmC3aYyu+6zpKqxT/+WooBj7nq9QCHCgcEbMkvfRewFC62S
         n1I0CuxeeBvL40Hfa0uIIV2h35xZlDU90ZPn5lgb+nFjqYHKce+VDgI2G6Igc3+lGqKT
         SHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lCEZrk5ZMye12lNks/t4yh+GdaF+KuVyhhCCIQr8x50=;
        b=l13EHdaKWMMrtqEP9hqvlMbPLoi21piuqF79C3LnbEUdXsdHbSP/HZUHUUhd4jRSw/
         DhVrSYgYIw74WEGvfFs4owZrGPyUkRKJzsOh5ca4xNk8XWfxMT20KgRw5q81f/6NT8Rx
         fvndqtjEeELATEnwkIvC6xAw+AhbLk9PbeS3LKLPTRaq3Kwb3taOG92GGHnT4mgIz86E
         cP26avx1CuyNRqyh3Aci9O1tQjArBtZZYXZP//HHpZSzjy8hp4IztZOJdK1ze8VgYNU+
         hZ2m7xwWVSkUc5KOik/pHWpklnZ0oZxjCnAZOh8CwxSskcG2/8FFdg4jUIWOOPHJUtAI
         rwNg==
X-Gm-Message-State: AOAM533DhQDVx6tvqxO5Bthp6z07HgJLgl6D76ebeBZ7HOKfANiyCAU2
        cOReIE8JOb94r/u9usDkB/oRvA==
X-Google-Smtp-Source: ABdhPJxoDcgjXySYXLlUflCeCP38yrPGbnWOILlxXKLytUDM00TzzjyCNRM3feL9ulQa0BB4Lcw6Lg==
X-Received: by 2002:a17:902:fe85:b029:e6:27a5:839e with SMTP id x5-20020a170902fe85b02900e627a5839emr5029303plm.79.1616613664212;
        Wed, 24 Mar 2021 12:21:04 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id a24sm3350673pff.18.2021.03.24.12.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 12:21:03 -0700 (PDT)
Date:   Wed, 24 Mar 2021 19:21:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 4/5 v4] nSVM: Test addresses of MSR and IO permissions
 maps
Message-ID: <YFuRHBVy1cp+R7FQ@google.com>
References: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
 <20210324175006.75054-5-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324175006.75054-5-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021, Krish Sadhukhan wrote:
> According to section "Canonicalization and Consistency Checks" in APM vol 2,
> the following guest state is illegal:
> 
>     "The MSR or IOIO intercept tables extend to a physical address that
>      is greater than or equal to the maximum supported physical address."
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  x86/svm_tests.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 29a0b59..70442d2 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2304,6 +2304,33 @@ static void test_dr(void)
>  	vmcb->save.dr7 = dr_saved;
>  }
>  
> +/*
> + * If the MSR or IOIO intercept table extends to a physical address that
> + * is greater than or equal to the maximum supported physical address, the
> + * guest state is illegal.
> + *
> + * [ APM vol 2]
> + */
> +static void test_msrpm_iopm_bitmap_addrs(void)
> +{
> +	u64 addr_spill_beyond_ram =

FWIW, it's not "beyond ram", it's beyond the legal physical address space.  E.g.
the address can point at stuff other than RAM and be perfectly legal from a
consistency check perspective.

> +	    (u64)(((u64)1 << cpuid_maxphyaddr()) - 4096);

It'd be nice to also check a straight legal address, and an address that
straddles the high address => 0.

> +
> +	/* MSR bitmap address */
> +	vmcb->control.intercept |= 1ULL << INTERCEPT_MSR_PROT;
> +	vmcb->control.msrpm_base_pa = addr_spill_beyond_ram;
> +	report(svm_vmrun() == SVM_EXIT_ERR, "Test MSRPM address: %lx",
> +	    addr_spill_beyond_ram);
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_MSR_PROT);
> +
> +	/* MSR bitmap address */
> +	vmcb->control.intercept |= 1ULL << INTERCEPT_IOIO_PROT;
> +	vmcb->control.msrpm_base_pa = addr_spill_beyond_ram;

Wrong bitmap.

> +	report(svm_vmrun() == SVM_EXIT_ERR, "Test IOPM address: %lx",
> +	    addr_spill_beyond_ram);
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_IOIO_PROT);

The control should be save/restored, assuming the intercepts were clear will
cause reproducibility issues for other tests.

> +}
> +
>  static void svm_guest_state_test(void)
>  {
>  	test_set_guest(basic_guest_main);
> @@ -2313,6 +2340,7 @@ static void svm_guest_state_test(void)
>  	test_cr3();
>  	test_cr4();
>  	test_dr();
> +	test_msrpm_iopm_bitmap_addrs();
>  }
>  
>  
> -- 
> 2.27.0
> 
