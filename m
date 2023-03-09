Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78C76B2940
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 16:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjCIP65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 10:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjCIP6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 10:58:54 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8587A90;
        Thu,  9 Mar 2023 07:58:52 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id f16so2318514ljq.10;
        Thu, 09 Mar 2023 07:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678377531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WT1eDLrYPweHOSvfYO2xevZujy3gdlIkd4hrI5NuO68=;
        b=M6HZJlcaOLYfhx8X00zRKtDJDCQ39kwVBPP3EdRYWxdZkVkVeTYFkarryLHkteejU7
         Bz+1VcwM3jkfNWBJV07ZGB4bzpbrSrfxfdh9O+5T8RozELBOQNP6AsENp2PvVUaFCCIJ
         EYh7lNQv6ZdwOpWmjQmXQZlt6NDLMVpjQmcXue3wRvGIxXRRKNO+ExpOkszIqMJVJvYt
         XHvGqBHkxUOQdW2FM2qoZzzNNXRX9WuB1Tkqgrp7vgvH8FSH/Xg2gQriM3mTgGPnenZc
         OTy7BN8YijbkCZU/RHM5DiDdXUuozsXt1XJAMqpEFKOBDISInCeBkX1HfgC+0rgZ2X+u
         Rplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678377531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WT1eDLrYPweHOSvfYO2xevZujy3gdlIkd4hrI5NuO68=;
        b=4e42k9HzOq/vtgR65auNLF3plZqWq8EzN1t5OOaqsiG+0pMER+T/dvdgbvf6n0l2V/
         SNMmNErOxc5AciKJ7SmjVPdpxECI7I7rHXdQpqy7NmSDJhEJsVnyUR4YNvMq5M26lQSd
         CkuLmv18GMqlaYnQN3nItKrUbSP7/l5q8C0tR+CAqPipoXrLg5rBYaJ7jZXfJzebzxlm
         9CDz/Hi6dAV6hProfSoA1mDDaeFiaLxhXG7xlLLEJM9LdD7/V6ZxsaBTKXZf17H7v6tS
         KhIwBNuBlYo/RZyQCAp1GpkOpQFyLBkAUbRp4Hz5ziDOuDH3wXknKB3YKVYt1jKX4y7p
         S4Sg==
X-Gm-Message-State: AO0yUKVNREOkePulc9/6LC9PP3JsRQOsnBlm8R+s0YX/OwtnWkhvxwuv
        kYjXmpWB/uyXktqgAYNvIeMNAEcfcsAL5g==
X-Google-Smtp-Source: AK7set8c7yjN90nXpNlY3N8l0RbdcrtAKnOXvRgtr28IJapZMi640zsmYzqg2oG3xwEn+7pTjOwcmA==
X-Received: by 2002:a2e:a803:0:b0:298:700c:c8d with SMTP id l3-20020a2ea803000000b00298700c0c8dmr2041273ljq.5.1678377530693;
        Thu, 09 Mar 2023 07:58:50 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id z10-20020a2e8e8a000000b002986d9bdecesm690461ljk.129.2023.03.09.07.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 07:58:50 -0800 (PST)
Date:   Thu, 9 Mar 2023 17:58:49 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com, jmattson@google.com, mizhang@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 05/18] KVM: x86/mmu: Add split_shadow_page_cache
 pages to global count of MMU cache pages
Message-ID: <20230309175849.0000565e@gmail.com>
In-Reply-To: <20230306224127.1689967-6-vipinsh@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
        <20230306224127.1689967-6-vipinsh@google.com>
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

On Mon,  6 Mar 2023 14:41:14 -0800
Vipin Sharma <vipinsh@google.com> wrote:

> Add pages in split_shadow_page_cache to the global counter
> kvm_total_unused_cached_pages. These pages will be freed by MMU shrinker
> in future commit.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index df8dcb7e5de7..0ebb8a2eaf47 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6149,7 +6149,9 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
>  {
>  	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
>  	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
> -	kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
> +	mutex_lock(&kvm->slots_lock);
> +	mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache);
> +	mutex_unlock(&kvm->slots_lock);

Taking the lock of the calling path in the layer of cache topping/free layer
seems off.

My vote goes to have a lock for each cache and take the lock of the cache when
topping/free the cache. It is more self-contained and architecturally nice.

>  }
>  
>  void kvm_mmu_uninit_vm(struct kvm *kvm)
> @@ -6303,7 +6305,7 @@ static int topup_split_caches(struct kvm *kvm)
>  	if (r)
>  		return r;
>  
> -	return kvm_mmu_topup_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
> +	return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
>  }
>  
>  static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep)
> @@ -6328,6 +6330,7 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
>  	/* Direct SPs do not require a shadowed_info_cache. */
>  	caches.page_header_cache = &kvm->arch.split_page_header_cache;
>  	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
> +	caches.count_shadow_page_allocation = true;
>  
>  	/* Safe to pass NULL for vCPU since requesting a direct SP. */
>  	return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);

