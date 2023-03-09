Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5549B6B294D
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 17:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjCIQCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 11:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjCIQBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 11:01:40 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA7BF63A3;
        Thu,  9 Mar 2023 08:01:38 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id m6so2919040lfq.5;
        Thu, 09 Mar 2023 08:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678377697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BnNEy1TvqDe9P58+euHpM+5zOn4gQhzVMn4KxunHiqk=;
        b=cMYNVqXckRANKLEY6kG0ZZjW/+JuKsU4ao96+IfSDke+SeOz8SAjADFWxdRye7mQO5
         8ugW46oeZpX4BjtoiaYn6t8DJ5D5kOJNhy00tmrRZIBochdXrpkgL81X+VChX7pip2E7
         dPsQUsE92jTT/OxojvTputJoszFZ1rVV+7XDYGHDkWKgdM9UsiQ91hxdvUfUGpdqr4Kx
         g+Onbh8XYYfpGbtyN9e3xJ++P83G3dzjmTjtcYEVlGPGhRmYD46FlWRAPc0YWnHDZD1S
         uGR85owChGdO5EEGkLaOBc8ud99OpNCBZZsTvI0F50EPzxQbAbRbDHq72iwc1fLKjMml
         bq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678377697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BnNEy1TvqDe9P58+euHpM+5zOn4gQhzVMn4KxunHiqk=;
        b=viM0Kfzk+mnQw3XS1cw0wy437tq7nrTVZMBJlderR8ct0x5RqudaJ3mY9Ez9YYKwa0
         jz8pwws0w9V2zbHXpYbr7fnDHE9VFNVix6WVnyA8vx6qzA+YKWgBg+toe1npJgIAwOk2
         ZJ3M1ZjRTKapYCUv2zUh7P4F8NtryZtJcrw4+kpjN4wamtFSUwiSFjUDh7WOcREXdtbA
         9OyKDUcovMnSTgkdPzFIs/VGAJ8ckqp2fjtffTN6I2T8ApINX/TEckANDeJHvL9B/9iz
         vmlKOzpcxhpKUp/qNfeLJv4w6COl3ZcElzWc1jjuw5zAxC1s8ML3zRt2tOgfI2MFjihO
         2jrw==
X-Gm-Message-State: AO0yUKWXWg/pScmN29emcJeh158CBZ4YYPedGRdnWHaFoyEYZfSE9dAJ
        UR7ArIMrhXQa7uymZth1SfE=
X-Google-Smtp-Source: AK7set9gosEliLWl+57Z/zLt4Vhe2WB5L5/FOfjiDr3B+0Q5HNNAl7EooR85XsvoPT/2Jo+gnfDw2Q==
X-Received: by 2002:a19:ad46:0:b0:4e7:fa9a:4d47 with SMTP id s6-20020a19ad46000000b004e7fa9a4d47mr969191lfd.2.1678377696531;
        Thu, 09 Mar 2023 08:01:36 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id x21-20020a19f615000000b004d545f1e0ccsm2679416lfe.187.2023.03.09.08.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 08:01:36 -0800 (PST)
Date:   Thu, 9 Mar 2023 18:01:35 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com, jmattson@google.com, mizhang@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 06/18] KVM: x86/mmu: Shrink split_shadow_page_cache
 via MMU shrinker
Message-ID: <20230309180135.000043fe@gmail.com>
In-Reply-To: <20230306224127.1689967-7-vipinsh@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
        <20230306224127.1689967-7-vipinsh@google.com>
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

On Mon,  6 Mar 2023 14:41:15 -0800
Vipin Sharma <vipinsh@google.com> wrote:

> Use MMU shrinker to free unused pages in split_shadow_page_cache.
> Refactor the code and make common function to try emptying the page cache.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 34 +++++++++++++++++++++-------------
>  1 file changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0ebb8a2eaf47..73a0ac9c11ce 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6696,13 +6696,24 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
>  	}
>  }
>  

After adding the lock in the kvm_mmu_memory_cache, the cache_lock doesn't need
to be passed here and in mmu_shrink_scan().

> +static int mmu_memory_cache_try_empty(struct kvm_mmu_memory_cache *cache,
> +				      struct mutex *cache_lock)
> +{
> +	int freed = 0;
> +
> +	if (mutex_trylock(cache_lock)) {
> +		freed = cache->nobjs;
> +		kvm_mmu_empty_memory_cache(cache);
> +		mutex_unlock(cache_lock);
> +	}
> +	return freed;
> +}
> +
>  static unsigned long mmu_shrink_scan(struct shrinker *shrink,
>  				     struct shrink_control *sc)
>  {
>  	struct kvm *kvm, *next_kvm, *first_kvm = NULL;
> -	struct kvm_mmu_memory_cache *cache;
>  	unsigned long i, freed = 0;
> -	struct mutex *cache_lock;
>  	struct kvm_vcpu *vcpu;
>  
>  	mutex_lock(&kvm_lock);
> @@ -6716,18 +6727,15 @@ static unsigned long mmu_shrink_scan(struct shrinker *shrink,
>  		list_move_tail(&kvm->vm_list, &vm_list);
>  
>  		kvm_for_each_vcpu(i, vcpu, kvm) {
> -			cache = &vcpu->arch.mmu_shadow_page_cache;
> -			cache_lock = &vcpu->arch.mmu_shadow_page_cache_lock;
> -			if (mutex_trylock(cache_lock)) {
> -				if (cache->nobjs) {
> -					freed += cache->nobjs;
> -					kvm_mmu_empty_memory_cache(cache);
> -				}
> -				mutex_unlock(cache_lock);
> -				if (freed >= sc->nr_to_scan)
> -					goto out;
> -			}
> +			freed += mmu_memory_cache_try_empty(&vcpu->arch.mmu_shadow_page_cache,
> +							    &vcpu->arch.mmu_shadow_page_cache_lock);
> +			if (freed >= sc->nr_to_scan)
> +				goto out;
>  		}
> +		freed += mmu_memory_cache_try_empty(&kvm->arch.split_shadow_page_cache,
> +						    &kvm->slots_lock);
> +		if (freed >= sc->nr_to_scan)
> +			goto out;
>  	}
>  out:
>  	mutex_unlock(&kvm_lock);

