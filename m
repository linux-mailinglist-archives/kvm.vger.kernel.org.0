Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948DA392D67
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 14:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhE0MCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 08:02:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34419 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234538AbhE0MCR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 08:02:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622116843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8zToxNU3l5hisEVZ3JgWmZRpInQw8WEWqsnjTJ/d20E=;
        b=Z/HhrPdmal+BMK1f2R2dTdk/RthJjo8JWz0yQoC9ihfguKgxgFEMlJwOuEMbuxFlNXL43P
        p4pUeHobUHdmLCK+h3/bua2gbawaug2GpJr05k80voccjYRsO7Sm/jcTBXBX/PDKAu85KX
        rCfLxjFKMt1hE90VWvEIFKqwEbbTUOY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-5GwXhI0SNcSjpgLkEAS2gw-1; Thu, 27 May 2021 08:00:41 -0400
X-MC-Unique: 5GwXhI0SNcSjpgLkEAS2gw-1
Received: by mail-ej1-f69.google.com with SMTP id w13-20020a170906384db02903d9ad6b26d8so1577534ejc.0
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 05:00:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8zToxNU3l5hisEVZ3JgWmZRpInQw8WEWqsnjTJ/d20E=;
        b=hw14U+2DKkWm0MInQnqxgYuywla/YSEFssYZ2+CM6sQeqfVVX/dUQdGKgUH/Ocn9mD
         NswbXukryGGJKgh20T2nnM7nMCqBI4VTS0uch9deCsmKw241EhjeN1KKmqVlYvBXFb74
         B84r2K+hWzIRYWmaoIevZZ6fQlOgMheo2G8/rtICKP8Sl7QrwdjXF+Ji9Si4daL22AZL
         DBWQe4N+g93quIIuDDz3nhUVTiHU/+1wYy3glua7fi0hk1mslq4ipYmrxUTjpIq/WljN
         ets1bKGb7DkeOT5urcoNgLSD50ftsH3qL25OsP03GmGDlN7gUFe7N0ZX/ApOfizVihwM
         h8Qw==
X-Gm-Message-State: AOAM530ONDkJKVRHCtg4pBQit/mXkx9z8V8lUxXVE4Ri5d7w1M7hmrSP
        EyPlMBGd+jRY2SjScffgbZl12+2b5DOkVdX7YUXCeykPFm1lYifGTma7e3FY5IVZTb87nGATMLL
        1nwShQoilTmTB
X-Received: by 2002:a17:906:b7d6:: with SMTP id fy22mr3292735ejb.383.1622116840369;
        Thu, 27 May 2021 05:00:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb4c4gfj24FKeEiTkSgSGlSeuXB7Ob/cX9QtlIJUcGaTbxva8tUM0Tm2w8JmXDj3lWOGcLIg==
X-Received: by 2002:a17:906:b7d6:: with SMTP id fy22mr3292713ejb.383.1622116840201;
        Thu, 27 May 2021 05:00:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dk9sm885856ejb.91.2021.05.27.05.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 05:00:39 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86/mmu: Make is_nx_huge_page_enabled an inline
 function
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <1622102271-63107-1-git-send-email-zhangshaokun@hisilicon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eab1aff2-2afd-57cc-62e1-a9c3563247e6@redhat.com>
Date:   Thu, 27 May 2021 14:00:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1622102271-63107-1-git-send-email-zhangshaokun@hisilicon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/21 09:57, Shaokun Zhang wrote:
> Function 'is_nx_huge_page_enabled' is called only by kvm/mmu, so make
> it as inline fucntion and remove the unnecessary declaration.
> 
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
> ChangeLog:
> v1-->v2:
>      1. Address Sean's comment, make is_nx_huge_page_enabled it as
> static inline function and remove the unnecessary declaration.
> 
>   arch/x86/kvm/mmu/mmu.c          | 7 +------
>   arch/x86/kvm/mmu/mmu_internal.h | 9 ++++++---
>   2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0144c40d09c7..d1e89e7ded17 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -55,7 +55,7 @@
>   
>   extern bool itlb_multihit_kvm_mitigation;
>   
> -static int __read_mostly nx_huge_pages = -1;
> +int __read_mostly nx_huge_pages = -1;
>   #ifdef CONFIG_PREEMPT_RT
>   /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
>   static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
> @@ -208,11 +208,6 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
>   	kvm_flush_remote_tlbs_with_range(kvm, &range);
>   }
>   
> -bool is_nx_huge_page_enabled(void)
> -{
> -	return READ_ONCE(nx_huge_pages);
> -}
> -
>   static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
>   			   unsigned int access)
>   {
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index d64ccb417c60..ff4c6256f3f9 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -116,7 +116,12 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
>   	       kvm_x86_ops.cpu_dirty_log_size;
>   }
>   
> -bool is_nx_huge_page_enabled(void);
> +extern int nx_huge_pages;
> +static inline bool is_nx_huge_page_enabled(void)
> +{
> +	return READ_ONCE(nx_huge_pages);
> +}
> +
>   bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>   			    bool can_unsync);
>   
> @@ -158,8 +163,6 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
>   void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
>   				kvm_pfn_t *pfnp, int *goal_levelp);
>   
> -bool is_nx_huge_page_enabled(void);
> -
>   void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>   
>   void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> 

Queued, thanks.

Paolo

