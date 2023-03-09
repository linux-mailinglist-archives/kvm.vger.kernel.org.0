Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31C96B2A92
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 17:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCIQLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 11:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCIQJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 11:09:02 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72516FD2B5;
        Thu,  9 Mar 2023 08:04:10 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id s22so2906545lfi.9;
        Thu, 09 Mar 2023 08:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678377833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wa4DJnUNex0Q5SmMM7G6Bl7IfXMX2NMMstgM+nrmnc4=;
        b=NbK46nUCwuSRR1zcr7DjNON0u8fAsqYo4AVrIrsK6XnXURpAXrmTZVbX4Q70oQOX2u
         MLWvfRPlOI9gST6crznfb55uEzC/JhhxOU9tFWpLVpXEbwBMB3IhuAMbQ5nX9lT6Q3v7
         HfHHcYNut4ZzjXb7dTp5JZKC+wWmG1SLtsQxkpvXRV85fBzco5redHt9Jl3trXT3zku4
         ZRmDzqEZK4sO2uUPm4nu1ycctgMOVAydp8mlbEGjlfASRMGa0VXDUDTMs2FidL3lL8za
         vL+0tUOQ5J1520hsc7/bVoYtxt+KMoqkD7yasDA5X+JFCoCeJICXtlMRK+lU4OXjg2io
         9Qcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678377833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wa4DJnUNex0Q5SmMM7G6Bl7IfXMX2NMMstgM+nrmnc4=;
        b=3HS+vSXhmn2x3ytRKhIKdex9zoMtTFRT9iuNCVUaXM0LwLgbG3KZboLC9O894gCHLu
         73gxTQWzNidq04rGugUe+2RiBF/LstnbetsUE1k1X2JrReIlfqCBu4oUWOV1Ws3IJIwv
         +ZZQZVQuvzX0aM4VcwMcXqDQzIUlDZypPKc9yE80CUMAfE0aA+kVRxOBbuTvJwz4VNGV
         sEW2AUN0vuIN6av0tILRYcLBBCCUzCfaWq3r8/VJVoX5vPoU7TWEQzypqkU29IbzCWu6
         GNTkP4ZEXUX1SovlFS5MTx1u85Gve+vhpCBjEf8YDEOug4Ac68Xvk19va2u28TFrdghW
         E9ng==
X-Gm-Message-State: AO0yUKX4KznsF97B2u1xJsFlUctIVNvKQSKNEnP/5CZpcbLIvHzmQRYv
        3+kYYWSRPZqU2I8F6h+jtJVKt5MUMwJ0NQ==
X-Google-Smtp-Source: AK7set9366TmnRPWcZQLG84bc43lQ1B94tSttnWxUTCUfB5NDRoBwfiqzWiUsiTByUL0iIdS5RjuAg==
X-Received: by 2002:ac2:44a3:0:b0:4db:1e4a:74aa with SMTP id c3-20020ac244a3000000b004db1e4a74aamr6423168lfm.1.1678377832593;
        Thu, 09 Mar 2023 08:03:52 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id a15-20020a056512020f00b004db3900da02sm2676005lfo.73.2023.03.09.08.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 08:03:52 -0800 (PST)
Date:   Thu, 9 Mar 2023 18:03:51 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com, jmattson@google.com, mizhang@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 07/18] KVM: x86/mmu: Unconditionally count
 allocations from MMU page caches
Message-ID: <20230309180351.000059bd@gmail.com>
In-Reply-To: <20230306224127.1689967-8-vipinsh@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
        <20230306224127.1689967-8-vipinsh@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  6 Mar 2023 14:41:16 -0800
Vipin Sharma <vipinsh@google.com> wrote:

Ah, it is removed here. :)

> Remove count_shadow_page_allocations from struct shadow_page_caches{}.
> Remove count_allocation boolean condition check from
> mmu_sp_memory_cache_alloc().
> 
> Both split_shadow_page_cache and mmu_shadow_page_cache are counted in
> global count of unused cache pages. count_shadow_page_allocations
> boolean is obsolete and can be removed.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 11 +++--------
>  arch/x86/kvm/mmu/mmu_internal.h |  3 +--
>  arch/x86/kvm/mmu/tdp_mmu.c      |  3 +--
>  3 files changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 73a0ac9c11ce..0a0962d8108b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2184,7 +2184,6 @@ struct shadow_page_caches {
>  	struct kvm_mmu_memory_cache *page_header_cache;
>  	struct kvm_mmu_memory_cache *shadow_page_cache;
>  	struct kvm_mmu_memory_cache *shadowed_info_cache;
> -	bool count_shadow_page_allocation;
>  };
>  
>  static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
> @@ -2196,8 +2195,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
>  	struct kvm_mmu_page *sp;
>  
>  	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
> -	sp->spt = mmu_sp_memory_cache_alloc(caches->shadow_page_cache,
> -					    caches->count_shadow_page_allocation);
> +	sp->spt = mmu_sp_memory_cache_alloc(caches->shadow_page_cache);
>  	if (!role.direct)
>  		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
>  
> @@ -2254,7 +2252,6 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
>  		.page_header_cache = &vcpu->arch.mmu_page_header_cache,
>  		.shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache,
>  		.shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache,
> -		.count_shadow_page_allocation = true,
>  	};
>  
>  	return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
> @@ -6330,7 +6327,6 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
>  	/* Direct SPs do not require a shadowed_info_cache. */
>  	caches.page_header_cache = &kvm->arch.split_page_header_cache;
>  	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
> -	caches.count_shadow_page_allocation = true;
>  
>  	/* Safe to pass NULL for vCPU since requesting a direct SP. */
>  	return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);
> @@ -7101,10 +7097,9 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>  		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
>  }
>  
> -void *mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *shadow_page_cache,
> -				bool count_allocation)
> +void *mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *shadow_page_cache)
>  {
> -	if (count_allocation && shadow_page_cache->nobjs)
> +	if (shadow_page_cache->nobjs)
>  		percpu_counter_dec(&kvm_total_unused_cached_pages);
>  	return kvm_mmu_memory_cache_alloc(shadow_page_cache);
>  }
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 798cfbf0a36b..a607314348e3 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -338,7 +338,6 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  
>  void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> -void *mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *cache,
> -				bool count_allocation);
> +void *mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *cache);
>  
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index fa6eb1e9101e..d1e85012a008 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -265,8 +265,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
>  	struct kvm_mmu_page *sp;
>  
>  	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -	sp->spt = mmu_sp_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache,
> -					    true);
> +	sp->spt = mmu_sp_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
>  
>  	return sp;
>  }

