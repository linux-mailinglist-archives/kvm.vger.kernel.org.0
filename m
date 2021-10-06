Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C677423CB5
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 13:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238583AbhJFLZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 07:25:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238589AbhJFLZZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 07:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nkO/A9ZUQ8MQ4JoxbSB4fLiKZCpws9VtkHaFKddArB8=;
        b=L+TApTFO2raTf+nMHJ0XawvQKKPKhbiD5uMIsdLCIUAvdq5I0cCBEpdZ9n6Qay9AYlX0In
        4U8cZ+mxRRxmXbieh9ucSPdrWABut2yS/zywJdwQrb54WJIbW3XkwlRba6QG8ZCWuJHs8e
        aL3xGnpcHGyGYKOVKPuvw67yT2LpwLQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-KwVqDHIPNXuF9pAk8DsZdQ-1; Wed, 06 Oct 2021 07:23:31 -0400
X-MC-Unique: KwVqDHIPNXuF9pAk8DsZdQ-1
Received: by mail-ed1-f71.google.com with SMTP id r11-20020aa7cfcb000000b003d4fbd652b9so291890edy.14
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 04:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nkO/A9ZUQ8MQ4JoxbSB4fLiKZCpws9VtkHaFKddArB8=;
        b=6cojLWQCbZzAfDgGM9yGaE23QS2OukJTnccyfqcbSQKTcrr84ldPZ4dm3cwHefWSeL
         NOJsQYP+s1XPwImRYvxNpAsCJja4h+KFkvsv1vn8QrtjjjQXBkK7aLrfsLp+JPM6GfZa
         xfKqmmbVVfZZzvYrXnYuu6HI9P/BDLMI9vODHmTiafiCqeFvtmP323gFhutjf+kRthc6
         5pudfjU0wVQIZJpaWLJBH+KffgePoYC70jjbxk+hQ15MNU8Ny37Ca8W9NE56gn0VDLki
         vL0MYaG4t0W9ucKakLES6AHOZZx1kOC5VwZuwGqINOQGMlZwwZIKAqpH408Ex1dA7bd9
         RT3g==
X-Gm-Message-State: AOAM530GaIMMTYNCI4TeAOhUBivw3QYQ4R4j42XePK8aPuTSkaTFMXGo
        qtxPB7jF7Nn9h2meBaGZUbGiYa8/kZ4WlYXMceEGTJf98qDY8PtWopsNxbDN6Z5j8Aum9uAKpqM
        ShVhm+wZaPAVi
X-Received: by 2002:a17:906:1945:: with SMTP id b5mr31716368eje.347.1633519410751;
        Wed, 06 Oct 2021 04:23:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7tHmOaUmNn1CVb3pmZD4PKvuD0rO5Yb3oEqPmXefppLA2OvReFmzRcEzevrfTf5l68OwiQg==
X-Received: by 2002:a17:906:1945:: with SMTP id b5mr31716349eje.347.1633519410534;
        Wed, 06 Oct 2021 04:23:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id s21sm7037429eji.3.2021.10.06.04.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:23:30 -0700 (PDT)
Message-ID: <4b7e8fde-83fd-0431-cadd-71f484508096@redhat.com>
Date:   Wed, 6 Oct 2021 13:23:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.4 1/4] KVM: x86: Handle SRCU initialization
 failure during page track init
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006111250.264294-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006111250.264294-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 13:12, Sasha Levin wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
> 
> [ Upstream commit eb7511bf9182292ef1df1082d23039e856d1ddfb ]
> 
> Check the return of init_srcu_struct(), which can fail due to OOM, when
> initializing the page track mechanism.  Lack of checking leads to a NULL
> pointer deref found by a modified syzkaller.
> 
> Reported-by: TCS Robot <tcs_robot@tencent.com>
> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
> Message-Id: <1630636626-12262-1-git-send-email-tcs_kernel@tencent.com>
> [Move the call towards the beginning of kvm_arch_init_vm. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/include/asm/kvm_page_track.h | 2 +-
>   arch/x86/kvm/page_track.c             | 4 ++--
>   arch/x86/kvm/x86.c                    | 7 ++++++-
>   3 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index 172f9749dbb2..5986bd4aacd6 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -46,7 +46,7 @@ struct kvm_page_track_notifier_node {
>   			    struct kvm_page_track_notifier_node *node);
>   };
>   
> -void kvm_page_track_init(struct kvm *kvm);
> +int kvm_page_track_init(struct kvm *kvm);
>   void kvm_page_track_cleanup(struct kvm *kvm);
>   
>   void kvm_page_track_free_memslot(struct kvm_memory_slot *free,
> diff --git a/arch/x86/kvm/page_track.c b/arch/x86/kvm/page_track.c
> index 3521e2d176f2..ef89a3ede425 100644
> --- a/arch/x86/kvm/page_track.c
> +++ b/arch/x86/kvm/page_track.c
> @@ -167,13 +167,13 @@ void kvm_page_track_cleanup(struct kvm *kvm)
>   	cleanup_srcu_struct(&head->track_srcu);
>   }
>   
> -void kvm_page_track_init(struct kvm *kvm)
> +int kvm_page_track_init(struct kvm *kvm)
>   {
>   	struct kvm_page_track_notifier_head *head;
>   
>   	head = &kvm->arch.track_notifier_head;
> -	init_srcu_struct(&head->track_srcu);
>   	INIT_HLIST_HEAD(&head->track_notifier_list);
> +	return init_srcu_struct(&head->track_srcu);
>   }
>   
>   /*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f1a0eebdcf64..69e286edb2c9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9585,9 +9585,15 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>   
>   int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   {
> +	int ret;
> +
>   	if (type)
>   		return -EINVAL;
>   
> +	ret = kvm_page_track_init(kvm);
> +	if (ret)
> +		return ret;
> +
>   	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
>   	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>   	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
> @@ -9614,7 +9620,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
>   
>   	kvm_hv_init_vm(kvm);
> -	kvm_page_track_init(kvm);
>   	kvm_mmu_init_vm(kvm);
>   
>   	return kvm_x86_ops->vm_init(kvm);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

