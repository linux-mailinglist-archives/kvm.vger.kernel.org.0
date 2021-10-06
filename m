Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C610423C9D
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 13:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238371AbhJFLYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 07:24:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238280AbhJFLYw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 07:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/Zgi1wsYZ/utXyyQF+xCXuqHO4iLDqak0bKLEB9Lv4=;
        b=XKm49InDVWfSHNa2QwE08s+LPSzZUaL9UVD6tOXS4LEzRRq9CsCvij+UjnHuzWtLvyr1U5
        QXFBU0Iidb7jkGj/BPUkHBLSmLSAlwbrTH1AVGr5XFM7IekWtg0CxOxos0sn2F5LWTacWL
        pSCcSGLqKrLT+yh9wChGLPM+9n/3//c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-OHGbkKMeMfKZDDCLa9uB8g-1; Wed, 06 Oct 2021 07:22:59 -0400
X-MC-Unique: OHGbkKMeMfKZDDCLa9uB8g-1
Received: by mail-ed1-f71.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso2357626edx.2
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 04:22:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C/Zgi1wsYZ/utXyyQF+xCXuqHO4iLDqak0bKLEB9Lv4=;
        b=pllticYiBHDWD55RKC+Our9Rs/+ioAUkrav7np3lZ9cG8tDae7zrS0L080uZDlkiJm
         Nuber2aO7EW8ZjcsK+cyeiVBWrAGuqeq53R19AWekpPeL/Z5AMMrmlAT14JMuF2j24yL
         K+0Gb3T7+NsmDh93Ghqurv0mVuKc3GQ2IHoJyp4wjYMX0ku/IekiL9/iBJqaU6BjNlf3
         YenI2wyZZ7ljoYBxbH/2Erxm9w4PsMT8rWbx0D+JlsMPh0rtpPCyQwPuNhnVjsdhIVHQ
         zxRgD9nSTOdOSXYdcB+PQ9kkQj32xPzHTUOgzNsK+v4Hv6ejUNM1G9Yxl36rJPnU00Nd
         1XVw==
X-Gm-Message-State: AOAM532sevOfeFsHF+kPwnzT3hYiFMPZrbN1yRFAG8c6RyaZXu0iMuNM
        d8odLLEDKFaRrKRpoMZyzP6L8PUouNceMPMpGiWV5ZXa9Zc90r0icucwWr4duru5Ry+crU62J+L
        C17XVwycgQKJh
X-Received: by 2002:a05:6402:1011:: with SMTP id c17mr33666224edu.144.1633519378097;
        Wed, 06 Oct 2021 04:22:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqN+hYPbfU4H4kC/Pj0UZUnKoayGEPwFgezwkfiCLimJ/jquxZ6sU+8+Thig10TBLynhNc+A==
X-Received: by 2002:a05:6402:1011:: with SMTP id c17mr33666198edu.144.1633519377902;
        Wed, 06 Oct 2021 04:22:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d6sm5211684ejd.116.2021.10.06.04.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:22:56 -0700 (PDT)
Message-ID: <3ca1cf75-63d9-942f-e9f0-66ac96357737@redhat.com>
Date:   Wed, 6 Oct 2021 13:22:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.10 2/7] KVM: x86: Handle SRCU initialization
 failure during page track init
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006111234.264020-1-sashal@kernel.org>
 <20211006111234.264020-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006111234.264020-2-sashal@kernel.org>
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
>   arch/x86/kvm/mmu/page_track.c         | 4 ++--
>   arch/x86/kvm/x86.c                    | 7 ++++++-
>   3 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index 87bd6025d91d..6a5f3acf2b33 100644
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
>   void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 8443a675715b..81cf4babbd0b 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -163,13 +163,13 @@ void kvm_page_track_cleanup(struct kvm *kvm)
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
> index 75c59ad27e9f..d65da3b5837b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10392,9 +10392,15 @@ void kvm_arch_free_vm(struct kvm *kvm)
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
> @@ -10421,7 +10427,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
>   
>   	kvm_hv_init_vm(kvm);
> -	kvm_page_track_init(kvm);
>   	kvm_mmu_init_vm(kvm);
>   
>   	return kvm_x86_ops.vm_init(kvm);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

