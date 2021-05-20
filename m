Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA68838B250
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 16:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhETO6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 10:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhETO6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 10:58:08 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195D4C061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 07:56:46 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t30so12026968pgl.8
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 07:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z0WDcMY3HhbvH2Ar5MtCT4eSRv/e0aZ4Q4UTkH2xM5U=;
        b=Ib4DIyuYFjMnKjce8BEbIEfHkXH+QmuGkXxpNxlRdXzq2Xz2OEDKGdFo7dM8bqAHWO
         +8EmzAYed7HK8O0eP0xW9Mr6YRNPC/6Sn8VOzEOfqTAySESoq+x+7I0g7mcD+hNjrG7o
         JetdpfwH6nU4zOYg081UQEkv3pRwO6g48V+5tZmzuwmRvfl+c9ce1Q40gqM7vPv1PS8N
         9VxIjfBFuBeMhBCypDcwXjToC4Ked2ZwYAgK6w0XpS3Lgs2pZx9+MWXGelmy0yqtt4K/
         o2FnMq8hHh4dzxV9sgRKmSlAjzHo4ebHxMynyVo88fbjPQy5609VnRG6Z3dpGnAMLUds
         HLuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z0WDcMY3HhbvH2Ar5MtCT4eSRv/e0aZ4Q4UTkH2xM5U=;
        b=tHXLFXcGu6ElGJJFPlUMQXfWmOfHvBBAXmdPEH5299KCmVaHuqmY2Qe0sHZ0D+Hw2x
         aEBuLH1LmGVc/9qoIOXgyfnp1UtM9Nd5a4h+v93dBPgsuvi/ri48d0CDGjlXCIFepaGT
         MSP5KDeW5ECvqrs+IGDesXIbPRb/SElDV8wWYTW8zMP7MeDzizsTGiO64Cc67Vdq1kvl
         gou+ERH+TW0pe9q04+XusClXnJaNQuEl5CFB44gRhNWxQBN5rOrTOkzGxli8BN5jNKJX
         1eYV/RNpJ1Q+jfNSHvXBBHrp4WjuIFWFfHKRH04CeR2dboq6TwLk2mCr1+xO5GE6226+
         LQcg==
X-Gm-Message-State: AOAM532QeC/BbsC6ruP4FM7vN/oashuXVxhKJ0qFg2Cs574SK2kDcm9u
        q+pmDHtWKqcy7LRcL85Ml83V9g==
X-Google-Smtp-Source: ABdhPJxu+nYjoMFJN/hxT53//uBbrR3gPxGF5uOsfvxp8eYwgGAYkqf1K6VHx5qDXgSQ4oNSmCCKLA==
X-Received: by 2002:a63:164a:: with SMTP id 10mr5031481pgw.186.1621522605462;
        Thu, 20 May 2021 07:56:45 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v18sm2321069pff.90.2021.05.20.07.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 07:56:44 -0700 (PDT)
Date:   Thu, 20 May 2021 14:56:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 3/4 v2] KVM: nVMX: nSVM: Add a new debugfs statistic to
 show how many VCPUs have run nested guests
Message-ID: <YKZ4qTp2OIS6LYy2@google.com>
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
 <20210520005012.68377-4-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520005012.68377-4-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021, Krish Sadhukhan wrote:
> Add a new debugfs statistic to show how many VCPUs have run nested guests.
> This statistic considers only the first time a given VCPU successfully runs
> a nested guest.
> 
> Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
> Suggested-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/svm.c          | 5 ++++-
>  arch/x86/kvm/vmx/vmx.c          | 5 ++++-
>  arch/x86/kvm/x86.c              | 1 +
>  4 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cf8557b2b90f..a19fe2cfaa93 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1138,6 +1138,7 @@ struct kvm_vm_stat {
>  	ulong lpages;
>  	ulong nx_lpage_splits;
>  	ulong max_mmu_page_hash_collisions;
> +	ulong vcpus_ran_nested;
>  };
>  
>  struct kvm_vcpu_stat {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 57c351640355..d1871c51411f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3876,8 +3876,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  		/* Track VMRUNs that have made past consistency checking */
>  		if (svm->nested.nested_run_pending &&
>  		    svm->vmcb->control.exit_code != SVM_EXIT_ERR &&
> -		    svm->vmcb->control.exit_code != SVM_EXIT_NPF)
> +		    svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
> +			if (!vcpu->stat.nested_runs)
> +				++vcpu->kvm->stat.vcpus_ran_nested;

Using a separate counter seems unnecessary, userspace can aggregate
vcpu->stat.nested_run itself to see how many vCPUs have done nested VM-Enter.

Jim, were you thinking of something else?  Am I missing something?
