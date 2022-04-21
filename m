Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFFA50A96C
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 21:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392046AbiDUTqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 15:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiDUTqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 15:46:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07C174BB8B
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650570196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HY/Y/H/17IRgZ8TLehrQxHtPGAMYrsVKwrowN9rRTBY=;
        b=EG8j3C8vYTi7PWsC9vAlKNvGwTAWTnDMVQxl+tWpUxtKgyjjyn53iiPs71Smh8uK34Uxul
        wcx1gIsWJW3OKcH2KIG0sDKFNM9N1fp7o3Vviezu2GLqOeB/FnK5yE4xkztATB/ZPTULfi
        Cpt37jlOTxvP3i5RLfjOZzQ4ceyQDrk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-7glSUISAP5Wi7HuliYqx5Q-1; Thu, 21 Apr 2022 15:43:14 -0400
X-MC-Unique: 7glSUISAP5Wi7HuliYqx5Q-1
Received: by mail-wm1-f70.google.com with SMTP id m125-20020a1c2683000000b00391893a2febso2739602wmm.4
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HY/Y/H/17IRgZ8TLehrQxHtPGAMYrsVKwrowN9rRTBY=;
        b=5ANnXnq1Vi1D4/InxjG8u4/e+Fwbwm/wii4I2dbD9PBbj4xqRRX2/zfCWasgfpP6pJ
         JmWn/wGKvMoY08KhPU03H7x9dtddJXXmSbhRKMtrzI/OtZZPn8WE6654lJz5RTnv7hxB
         UyHAYOkqz6qVvLXfzyZYNdePipzp7gNXOE7GuZru6OCRq1Xbczaq9Ucjuu84S1m+J6dD
         9pd0pdRwhTDiQBZxzbqgnBYjSxGaXfMRAtQV1aSkkClf32gzUROE/Lt8AEVXm5xqvNQy
         zJjRs1TBTlbfAKYsLHPsybMHf6p8ButrLabGTz9/vbS2goClrFG+IMVz4O7k3LQWqi53
         QslA==
X-Gm-Message-State: AOAM532biTTTtP7jdpl3nJB+9z2Z5335vZ8DxHOXf7Xpb8gqPGv3VHc7
        bPjEq16K9UErWon8RbHF0fp6VsOHQM3c+c6z10c/d7hjIC7cYgRHlA+MTH1H7tc6XIoLIdhg+Fy
        YF0jAI6t3RNcj
X-Received: by 2002:a05:600c:500c:b0:392:b12f:40a with SMTP id n12-20020a05600c500c00b00392b12f040amr839644wmr.122.1650570193545;
        Thu, 21 Apr 2022 12:43:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWKuSC3D47oP0rl1UOs4/4L+Z6e+SmEavaAc79ryCsyW6sduv4quDsOldf6ZZAcgbNeVs8ow==
X-Received: by 2002:a05:600c:500c:b0:392:b12f:40a with SMTP id n12-20020a05600c500c00b00392b12f040amr839629wmr.122.1650570193283;
        Thu, 21 Apr 2022 12:43:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id l8-20020a5d5608000000b00207ab405d15sm2860622wrv.42.2022.04.21.12.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 12:43:12 -0700 (PDT)
Message-ID: <1581f3b5-f965-5289-da15-fc1802cdbf68@redhat.com>
Date:   Thu, 21 Apr 2022 21:43:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: Fix build error on s390 due to
 kvm_flush_shadow_all() being hidden
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
References: <20220421192645.3762857-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220421192645.3762857-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/22 21:26, Sean Christopherson wrote:
> Hoist kvm_flush_shadow_all() out of the #ifdef block that depends on the
> mmu_notifier being enabled and wanted by KVM.  KVM s390 doesn't utilize
> the mmu_notifier, and so the direct call to kvm_flush_shadow_all() in
> vm_destroy() rightly complains.
> 
> virt/kvm/kvm_main.c: In function ‘kvm_destroy_vm’:
> virt/kvm/kvm_main.c:1248:9: error: implicit declaration of function ‘kvm_flush_shadow_all’;
> did you mean ‘kvm_arch_flush_shadow_all’? [-Werror=implicit-function-declaration]
>   1248 |         kvm_flush_shadow_all(kvm);
>        |         ^~~~~~~~~~~~~~~~~~~~
>        |         kvm_arch_flush_shadow_all
> 
> Fixes: b56a4ff6bff3 ("KVM: SEV: add cache flush to solve SEV cache incoherency issues")
> Cc: stable@vger.kernel.org
> Cc: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a719e52f3eb7..f30bb8c16f26 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -361,6 +361,12 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>   EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
>   #endif
>   
> +static void kvm_flush_shadow_all(struct kvm *kvm)
> +{
> +	kvm_arch_flush_shadow_all(kvm);
> +	kvm_arch_guest_memory_reclaimed(kvm);
> +}
> +
>   #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>   static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>   					       gfp_t gfp_flags)
> @@ -820,12 +826,6 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
>   					     kvm_test_age_gfn);
>   }
>   
> -static void kvm_flush_shadow_all(struct kvm *kvm)
> -{
> -	kvm_arch_flush_shadow_all(kvm);
> -	kvm_arch_guest_memory_reclaimed(kvm);
> -}
> -
>   static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
>   				     struct mm_struct *mm)
>   {
> 
> base-commit: b56a4ff6bff38fc49d8e583a3fbb5e18d1a99963

Thanks, I'll squash this.

Paolo

