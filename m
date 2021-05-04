Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17389373117
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 21:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhEDT4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 15:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbhEDT4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 15:56:18 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7D7C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 12:55:22 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id v191so72317pfc.8
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V9MXCUfkwjmTe3RnQ5lcnKM97SAruzdIHvAHJ/7SbBM=;
        b=gDxUZXMjj4gmp5w7OneOA+ybUb5VLB6rrAPPS0IlGoniTArDiPJtz+fjyJG5pgsAMk
         KVjvhbAGD2sm8co6/oxomB+WqEb34rpQzg9VqgC7Pxglu9zYWstkxG+O4KcWxYMINqEE
         Z+RuLPQiCNVqp5L26RB3hDzYZcckTcsvVLcM9ivk8Quwc1EvIaHqbPP51FfNUayEGBtl
         0o0RFgUZ0GWIP+D0EunIYE6tDOi/TzlAW8yQ3iu5z5Ff2RWfpZBNmalCU/lKEAlnVOFu
         zZzrNLFp0Ybndoegu82z6OGV4CV3nuSkGn55WMkjI2P16/OfYTpz8d+NxnQro74LTSW7
         Wq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V9MXCUfkwjmTe3RnQ5lcnKM97SAruzdIHvAHJ/7SbBM=;
        b=BDJ33x5ixZawJE/RrgPnN6kBSOBqlau/kBfX8o0AhH7FDmvEWIjqgtdc5CPnJwVDrm
         ax/stcMN3cb4b6VL18LUI20D+Y/A0clo5RpPy4YB9Lr05BKE8Leb6kwj1F7lZh9D01sQ
         MEWKnSyGGksfk8g0ESWtadShEvPNMiPKguhAvUi64+Jiv54fa14kmSYCG6u+6f0ae89Z
         kaTtliurFlURGshNPW43UT/0VGz81mfmhHDLQTDszmKgJGljkEdvF/+LOAQPnGJ0Y9cE
         LJuiVAg1s3RvDC1rXQNCCatqZg/PcxdyjPLHCWioT0zgQVrr+703q4FAO6HcXE33xwQC
         5TtQ==
X-Gm-Message-State: AOAM533ReglHFpHKA5zkxjbAC9jmPNm0w/mnUfyRxOFwxWt2wnDWO6bA
        RmXfnyrHVAetIkVrWhtvsnM8ew==
X-Google-Smtp-Source: ABdhPJxa4R2eqYOmzom07zcVSSH/UwYdjTwtJKrJZ4ws+px9kF2HWI7h/Tqs4dOTngLsuXaKVJoJNA==
X-Received: by 2002:a63:796:: with SMTP id 144mr24646749pgh.246.1620158121499;
        Tue, 04 May 2021 12:55:21 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id j10sm13484582pfn.207.2021.05.04.12.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 12:55:20 -0700 (PDT)
Date:   Tue, 4 May 2021 19:55:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 1/7] KVM: x86/mmu: Track if shadow MMU active
Message-ID: <YJGmpOzaFy9E0f5T@google.com>
References: <20210429211833.3361994-1-bgardon@google.com>
 <20210429211833.3361994-2-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429211833.3361994-2-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021, Ben Gardon wrote:
> Add a field to each VM to track if the shadow / legacy MMU is actually
> in use. If the shadow MMU is not in use, then that knowledge opens the
> door to other optimizations which will be added in future patches.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu/mmu.c          | 10 +++++++++-
>  arch/x86/kvm/mmu/mmu_internal.h |  2 ++
>  arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++++--
>  arch/x86/kvm/mmu/tdp_mmu.h      |  4 ++--
>  5 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ad22d4839bcc..3900dcf2439e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1122,6 +1122,8 @@ struct kvm_arch {
>  	 */
>  	spinlock_t tdp_mmu_pages_lock;
>  #endif /* CONFIG_X86_64 */
> +
> +	bool shadow_mmu_active;

I'm not a fan of the name, "shadow mmu" in KVM almost always means shadow paging
of some form, whereas this covers both shadow paging and legacy TDP support.

But, I think we we can avoid bikeshedding by simply eliminating this flag.  More
in later patches.

>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 930ac8a7e7c9..3975272321d0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3110,6 +3110,11 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	return ret;
>  }
>  
> +void activate_shadow_mmu(struct kvm *kvm)
> +{
> +	kvm->arch.shadow_mmu_active = true;
> +}
> +
>  static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  			       struct list_head *invalid_list)
>  {
> @@ -3280,6 +3285,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> +	activate_shadow_mmu(vcpu->kvm);
> +
>  	write_lock(&vcpu->kvm->mmu_lock);
>  	r = make_mmu_pages_available(vcpu);
>  	if (r < 0)
> @@ -5467,7 +5474,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>  {
>  	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
>  
> -	kvm_mmu_init_tdp_mmu(kvm);
> +	if (!kvm_mmu_init_tdp_mmu(kvm))
> +		activate_shadow_mmu(kvm);

Doesn't come into play yet, but I would strongly prefer to open code setting the
necessary flag instead of relying on the helper to never fail.
